// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/orders/models/client_order.dart';
import 'package:washgo/features/orders/models/washgo_order.dart';
import 'package:washgo/features/orders/models/order_audit_log.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/core/utils/prepaid_consumption_helper.dart';
import 'package:uuid/uuid.dart';
import 'order_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_reservation_metadata_repository.dart';

class FirebaseOrderRepository implements OrderRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  // Stream caches and subscriptions pooling
  final Map<String, StreamController<List<WashGoOrder>>> _businessStreamsCache = {};
  final Map<String, StreamSubscription> _businessSubsCache = {};
  final Map<String, Timer> _businessTimersCache = {};
  final Map<String, List<WashGoOrder>> _businessLastValueCache = {};

  StreamController<List<ClientOrder>>? _sharedClientController;
  StreamSubscription? _sharedClientSub;
  Timer? _sharedClientTimer;
  List<ClientOrder>? _clientLastValueCache;

  Future<void> _notifyClientControllers() async {
    final controller = _sharedClientController;
    if (controller != null && !controller.isClosed && controller.hasListener) {
      try {
        final orders = await getClientOrders();
        if (!controller.isClosed) {
          controller.add(orders);
        }
      } catch (_) {}
    }
  }

  Future<void> _notifyBusinessControllers(String businessId) async {
    final controller = _businessStreamsCache[businessId];
    if (controller != null && !controller.isClosed && controller.hasListener) {
      try {
        final orders = await getBusinessOrders(businessId);
        if (!controller.isClosed) {
          controller.add(orders);
        }
      } catch (_) {}
    }
  }

  @override
  Future<List<ClientOrder>> getClientOrders() async {
    final response = await _connector.getClientOrders().ref().execute(
      fetchPolicy: QueryFetchPolicy.serverOnly,
    );
    final mapped = response.data.orders.map((o) {
      final emp = o.employee;
      ClientEmployee? employee;
      if (emp != null) {
        employee = ClientEmployee(
          id: emp.id,
          nombreCompleto: emp.nombreCompleto,
          fotoPerfil: emp.fotoPerfil,
          telefono: emp.telefono,
        );
      }

      return ClientOrder(
        id: o.id,
        businessId: o.business.id,
        status: o.status.stringValue,
        observations: o.observations ?? '',
        cancellationReason: o.cancellationReason,
        businessName: o.business.nombre,
        businessPhone: o.business.telefono,
        serviceName: o.serviceName,
        price: o.price,
        employee: employee,
        paymentMethod: o.paymentMethod.stringValue,
        invoiceUrl: o.invoiceUrl,
        hasReview: o.review_on_order != null,
        createdAt: o.createdAt?.toDateTime(),
        type: o.type.stringValue,
        hasPaymentProof: o.paymentProof_on_order != null,
      );
    }).toList();
    final result = mapped.reversed.toList();
    unawaited(_checkAndExpireOrders(result));
    return result;
  }

  @override
  Future<String> createOrder({
    required String businessId,
    required double price,
    required double costo,
    required String serviceName,
    required OrderType type,
    required PaymentMethod paymentMethod,
    required String observations,
  }) async {
    final status = (paymentMethod == PaymentMethod.TRANSFERENCIA_BANCARIA ||
            paymentMethod == PaymentMethod.PAYPAL ||
            paymentMethod == PaymentMethod.PAYPHONE)
        ? OrderStatus.PENDIENTE_PAGO
        : OrderStatus.EN_COLA;

    final result = await _connector
        .createOrder(
          businessId: businessId,
          price: price,
          costo: costo,
          serviceName: serviceName,
          type: type,
          paymentMethod: paymentMethod,
        )
        .status(status)
        .observations(observations)
        .execute();

    final orderId = result.data.order_insert.id;
    final parsed = ParsedObservations.parse(observations);
    try {
      await _connector
          .createOrderLog(
            orderId: orderId,
            actionType: 'CREACION',
          )
          .newValue(parsed.dateTime)
          .execute();
    } catch (e) {
      debugPrint('Error creating order log for CREACION: $e');
    }

    _notifyClientControllers();
    _notifyBusinessControllers(businessId);

    return orderId;
  }

  @override
  Future<List<WashGoOrder>> getBusinessOrders(String businessId) async {
    final response = await _connector
        .getBusinessOrders(businessId: businessId)
        .ref()
        .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
    final mapped = response.data.orders.map((o) {
      final status = o.status is Known<OrderStatus>
          ? (o.status as Known<OrderStatus>).value
          : OrderStatus.EN_COLA;

      final type = o.type is Known<OrderType>
          ? (o.type as Known<OrderType>).value
          : OrderType.LOCAL;

      final paymentMethod = o.paymentMethod is Known<PaymentMethod>
          ? (o.paymentMethod as Known<PaymentMethod>).value
          : PaymentMethod.CASH;

      final client = OrderParty(
        id: o.client.id,
        nombreCompleto: o.client.nombreCompleto,
        fotoPerfil: o.client.fotoPerfil,
        telefono: o.client.telefono,
      );

      OrderParty? employee;
      final emp = o.employee;
      if (emp != null) {
        employee = OrderParty(
          id: emp.id,
          nombreCompleto: emp.nombreCompleto,
          fotoPerfil: emp.fotoPerfil,
          telefono: emp.telefono,
        );
      }

      PaymentProofStatus? paymentProofStatus;
      final proof = o.paymentProof_on_order;
      if (proof != null) {
        paymentProofStatus = proof.status is Known<PaymentProofStatus>
            ? (proof.status as Known<PaymentProofStatus>).value
            : null;
      }

      return WashGoOrder(
        id: o.id,
        status: status,
        observations: o.observations,
        businessId: businessId,
        businessName: '',
        serviceName: o.serviceName,
        price: o.price,
        type: type,
        paymentMethod: paymentMethod,
        client: client,
        employee: employee,
        paymentProofStatus: paymentProofStatus,
      );
    }).toList();
    unawaited(_checkAndExpireOrders(mapped));
    return mapped;
  }

  StreamController<List<WashGoOrder>> _getOrCreateBusinessStream(String businessId) {
    if (_businessStreamsCache.containsKey(businessId)) {
      return _businessStreamsCache[businessId]!;
    }

    late StreamController<List<WashGoOrder>> controller;
    DateTime lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);

    void emit(List<WashGoOrder> orders) {
      _businessLastValueCache[businessId] = orders;
      if (!controller.isClosed) {
        lastUpdate = DateTime.now();
        controller.add(orders);
      }
    }

    Future<void> fetchAndEmit() async {
      try {
        final orders = await getBusinessOrders(businessId);
        emit(orders);
      } catch (e) {
        // Suppress errors during background polling
      }
    }

    controller = StreamController<List<WashGoOrder>>.broadcast(
      onListen: () {
        fetchAndEmit();

        StreamSubscription? sub;
        try {
          sub = _connector
              .getBusinessOrders(businessId: businessId)
              .ref()
              .subscribe()
              .listen(
                (response) {
                  final data = response.data;
                  final mapped = data.orders.map((o) {
                    final status = o.status is Known<OrderStatus>
                        ? (o.status as Known<OrderStatus>).value
                        : OrderStatus.EN_COLA;

                    final type = o.type is Known<OrderType>
                        ? (o.type as Known<OrderType>).value
                        : OrderType.LOCAL;

                    final paymentMethod = o.paymentMethod is Known<PaymentMethod>
                        ? (o.paymentMethod as Known<PaymentMethod>).value
                        : PaymentMethod.CASH;

                    final client = OrderParty(
                      id: o.client.id,
                      nombreCompleto: o.client.nombreCompleto,
                      fotoPerfil: o.client.fotoPerfil,
                      telefono: o.client.telefono,
                    );

                    OrderParty? employee;
                    final emp = o.employee;
                    if (emp != null) {
                      employee = OrderParty(
                        id: emp.id,
                        nombreCompleto: emp.nombreCompleto,
                        fotoPerfil: emp.fotoPerfil,
                        telefono: emp.telefono,
                      );
                    }

                    PaymentProofStatus? paymentProofStatus;
                    final proof = o.paymentProof_on_order;
                    if (proof != null) {
                      paymentProofStatus = proof.status is Known<PaymentProofStatus>
                          ? (proof.status as Known<PaymentProofStatus>).value
                          : null;
                    }

                    return WashGoOrder(
                      id: o.id,
                      status: status,
                      observations: o.observations,
                      businessId: businessId,
                      businessName: '',
                      serviceName: o.serviceName,
                      price: o.price,
                      type: type,
                      paymentMethod: paymentMethod,
                      client: client,
                      employee: employee,
                      paymentProofStatus: paymentProofStatus,
                    );
                  }).toList();
                  emit(mapped);
                },
                onError: (err) {
                  // Suppress background subscription error
                },
              );
          _businessSubsCache[businessId] = sub;
        } catch (e) {
          // Suppress background subscription error
        }

        final timer = Timer.periodic(const Duration(seconds: 60), (t) {
          final elapsed = DateTime.now().difference(lastUpdate);
          if (elapsed >= const Duration(seconds: 60)) {
            fetchAndEmit();
          }
        });
        _businessTimersCache[businessId] = timer;
      },
      onCancel: () {
        _businessSubsCache[businessId]?.cancel();
        _businessSubsCache.remove(businessId);

        _businessTimersCache[businessId]?.cancel();
        _businessTimersCache.remove(businessId);

        _businessStreamsCache.remove(businessId);
        _businessLastValueCache.remove(businessId);
        controller.close();
      },
    );

    _businessStreamsCache[businessId] = controller;
    return controller;
  }

  @override
  Stream<List<WashGoOrder>> watchBusinessOrders(String businessId) {
    final controller = _getOrCreateBusinessStream(businessId);

    Stream<List<WashGoOrder>> getSubStream() async* {
      final cached = _businessLastValueCache[businessId];
      if (cached != null) {
        yield cached;
      }
      yield* controller.stream;
    }
    return getSubStream();
  }

  DateTime? _parseOrderDateTime(String dtStr) {
    try {
      final parts = dtStr.trim().split(' ');
      if (parts.length != 2) return null;
      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');
      if (dateParts.length != 3 || timeParts.length != 2) return null;

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  StreamController<List<ClientOrder>> _getOrCreateClientStream() {
    if (_sharedClientController != null) {
      return _sharedClientController!;
    }

    late StreamController<List<ClientOrder>> controller;
    DateTime lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
    List<ClientOrder> lastOrdersList = [];

    void emit(List<ClientOrder> orders) {
      _clientLastValueCache = orders;
      lastOrdersList = orders;
      if (!controller.isClosed) {
        lastUpdate = DateTime.now();
        controller.add(orders);
      }
    }

    Future<void> fetchAndEmit() async {
      try {
        final orders = await getClientOrders();
        emit(orders);
      } catch (e) {
        // Suppress errors during background polling
      }
    }

    controller = StreamController<List<ClientOrder>>.broadcast(
      onListen: () {
        fetchAndEmit();

        try {
          _sharedClientSub = _connector.getClientOrders().ref().subscribe().listen(
            (response) {
              final data = response.data;
              final mapped = data.orders.map((o) {
                final emp = o.employee;
                ClientEmployee? employee;
                if (emp != null) {
                  employee = ClientEmployee(
                    nombreCompleto: emp.nombreCompleto,
                    fotoPerfil: emp.fotoPerfil,
                    telefono: emp.telefono,
                  );
                }

                return ClientOrder(
                  id: o.id,
                  businessId: o.business.id,
                  status: o.status.stringValue,
                  observations: o.observations ?? '',
                  cancellationReason: o.cancellationReason,
                  businessName: o.business.nombre,
                  businessPhone: o.business.telefono,
                  serviceName: o.serviceName,
                  price: o.price,
                  employee: employee,
                  paymentMethod: o.paymentMethod.stringValue,
                  invoiceUrl: o.invoiceUrl,
                  hasReview: o.review_on_order != null,
                  createdAt: o.createdAt?.toDateTime(),
                  type: o.type.stringValue,
                  hasPaymentProof: o.paymentProof_on_order != null,
                );
              }).toList();

              final reversed = mapped.reversed.toList();
              emit(reversed);
            },
            onError: (err) {
              // Suppress background subscription error
            },
          );
        } catch (e) {
          // Suppress background subscription error
        }

        _sharedClientTimer = Timer.periodic(const Duration(seconds: 60), (t) {
          final elapsed = DateTime.now().difference(lastUpdate);
          if (elapsed >= const Duration(seconds: 60)) {
            final hasActive = lastOrdersList.any((o) {
              final s = o.status.toUpperCase();
              if (s == 'COMPLETADO' || s == 'CANCELADO') return false;

              final parsed = ParsedObservations.parse(o.observations);
              if (parsed.scheduleType == 'Ahora mismo') {
                return true; // Always poll for immediate/now orders
              }

              // It's a scheduled order, check if we need to poll
              final schedTime = _parseOrderDateTime(parsed.dateTime);
              if (schedTime == null) {
                return true; // Fallback to poll if parsing fails
              }

              // Poll if the scheduled time is within the next 30 minutes, or is in the past
              final diff = schedTime.difference(DateTime.now());
              return diff.inMinutes <= 30;
            });

            if (hasActive) {
              fetchAndEmit();
            }
          }
        });
      },
      onCancel: () {
        _sharedClientSub?.cancel();
        _sharedClientSub = null;

        _sharedClientTimer?.cancel();
        _sharedClientTimer = null;

        _sharedClientController = null;
        _clientLastValueCache = null;
        controller.close();
      },
    );

    _sharedClientController = controller;
    return controller;
  }

  @override
  Stream<List<ClientOrder>> watchClientOrders() {
    final controller = _getOrCreateClientStream();

    Stream<List<ClientOrder>> getSubStream() async* {
      final cached = _clientLastValueCache;
      if (cached != null) {
        yield cached;
      }
      yield* controller.stream;
    }
    return getSubStream();
  }

  @override
  Future<void> acceptOrder({
    required String orderId,
    required String employeeId,
  }) async {
    await _connector
        .acceptOrder(orderId: orderId, employeeId: employeeId)
        .execute();

    _notifyClientControllers();
    for (final businessId in _businessStreamsCache.keys) {
      _notifyBusinessControllers(businessId);
    }
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancellationReason,
  }) async {
    await _connector
        .updateOrderStatus(orderId: orderId, status: status)
        .cancellationReason(cancellationReason)
        .execute();

    if (status == OrderStatus.COMPLETADO) {
      await PrepaidConsumptionHelper.consumePrepaidBalanceForOrder(orderId);
    }

    if (status == OrderStatus.CANCELADO || status == OrderStatus.COMPLETADO) {
      try {
        final metadataRepo = FirebaseReservationMetadataRepository();
        await metadataRepo.deleteReservation(orderId);
      } catch (e) {
        print('Error deleting reservation: $e');
      }
    }

    _notifyClientControllers();
    for (final businessId in _businessStreamsCache.keys) {
      _notifyBusinessControllers(businessId);
    }
  }

  @override
  Future<void> updateOrderPaymentMethodAndStatus({
    required String orderId,
    required PaymentMethod paymentMethod,
    required OrderStatus status,
    String? cancellationReason,
  }) async {
    await _connector
        .updateOrderPaymentMethodAndStatus(
          orderId: orderId,
          paymentMethod: paymentMethod,
          status: status,
        )
        .cancellationReason(cancellationReason)
        .execute();

    if (status == OrderStatus.COMPLETADO) {
      await PrepaidConsumptionHelper.consumePrepaidBalanceForOrder(orderId);
    }

    if (status == OrderStatus.CANCELADO || status == OrderStatus.COMPLETADO) {
      try {
        final metadataRepo = FirebaseReservationMetadataRepository();
        await metadataRepo.deleteReservation(orderId);
      } catch (e) {
        print('Error deleting reservation: $e');
      }
    }

    _notifyClientControllers();
    for (final businessId in _businessStreamsCache.keys) {
      _notifyBusinessControllers(businessId);
    }
  }

  @override
  Future<void> rescheduleOrder({
    required String orderId,
    required String observations,
  }) async {
    String? previousValue;
    try {
      final orderRes = await _connector.getOrderById(id: orderId).ref().execute();
      if (orderRes.data.order != null) {
        final prevParsed = ParsedObservations.parse(orderRes.data.order!.observations);
        previousValue = prevParsed.dateTime;
      }
    } catch (e) {
      debugPrint('Error fetching previous order observations for log: $e');
    }

    final parsed = ParsedObservations.parse(observations);
    final newValue = parsed.dateTime;

    await _connector
        .rescheduleOrder(orderId: orderId, observations: observations)
        .execute();

    try {
      await _connector
          .createOrderLog(
            orderId: orderId,
            actionType: 'REPROGRAMACION',
          )
          .previousValue(previousValue)
          .newValue(newValue)
          .execute();
    } catch (e) {
      debugPrint('Error creating order log for REPROGRAMACION: $e');
    }

    _notifyClientControllers();
    for (final businessId in _businessStreamsCache.keys) {
      _notifyBusinessControllers(businessId);
    }
  }

  @override
  Future<QueuePosition> getQueuePosition({
    required String businessId,
    required String orderId,
  }) async {
    try {
      final response = await _connector
          .getActiveBusinessOrders(businessId: businessId)
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);

      final activeOrders = response.data.orders;
      final targetOrderIndex = activeOrders.indexWhere((o) => o.id == orderId);
      if (targetOrderIndex == -1) {
        return QueuePosition(position: -1, estimatedWaitTime: 0);
      }

      final targetOrder = activeOrders[targetOrderIndex];
      final waitingStatuses = [
        'PENDIENTE_PAGO',
        'EN_COLA',
        'ACEPTADO',
        'EN_CAMINO',
      ];
      final targetStatusStr = targetOrder.status.stringValue.toUpperCase();
      if (!waitingStatuses.contains(targetStatusStr)) {
        return QueuePosition(
          position: 0,
          estimatedWaitTime: 0,
        ); // Not waiting in queue (e.g. EN_SERVICIO or completed)
      }

      final list = activeOrders.map((o) {
        final parsed = ParsedObservations.parse(o.observations);
        final dt =
            _parseOrderDateTime(parsed.dateTime) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return _OrderQueueItem(
          id: o.id,
          status: o.status.stringValue,
          dateTime: dt,
          duration: (o.service?.duracionMinutos ?? 15).toInt(),
        );
      }).toList();

      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      final waitingList = list.where((item) {
        return waitingStatuses.contains(item.status.toUpperCase());
      }).toList();

      final index = waitingList.indexWhere((item) => item.id == orderId);
      if (index == -1) {
        return QueuePosition(position: -1, estimatedWaitTime: 0);
      }

      int estimatedWaitTime = 0;
      for (int i = 0; i < index; i++) {
        estimatedWaitTime += waitingList[i].duration;
      }

      return QueuePosition(
        position: index + 1,
        estimatedWaitTime: estimatedWaitTime,
      );
    } catch (_) {
      return QueuePosition(position: -1, estimatedWaitTime: 0);
    }
  }

  @override
  Future<List<WashGoOrder>> getEmployeeHistoryOrdersPaged({
    required String businessId,
    required String employeeId,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _connector
          .getEmployeeHistoryOrdersPaged(
            businessId: businessId,
            employeeId: employeeId,
            limit: limit,
            offset: offset,
          )
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);

      return response.data.orders.map((o) {
        final status = o.status is Known<OrderStatus>
            ? (o.status as Known<OrderStatus>).value
            : OrderStatus.EN_COLA;

        final type = o.type is Known<OrderType>
            ? (o.type as Known<OrderType>).value
            : OrderType.LOCAL;

        final paymentMethod = o.paymentMethod is Known<PaymentMethod>
            ? (o.paymentMethod as Known<PaymentMethod>).value
            : PaymentMethod.CASH;

        final client = OrderParty(
          id: o.client.id,
          nombreCompleto: o.client.nombreCompleto,
          fotoPerfil: o.client.fotoPerfil,
          telefono: o.client.telefono,
        );

        OrderParty? employee;
        final emp = o.employee;
        if (emp != null) {
          employee = OrderParty(
            id: emp.id,
            nombreCompleto: emp.nombreCompleto,
            fotoPerfil: emp.fotoPerfil,
            telefono: emp.telefono,
          );
        }

        return WashGoOrder(
          id: o.id,
          status: status,
          observations: o.observations,
          businessId: businessId,
          businessName: '',
          serviceName: o.serviceName,
          price: o.price,
          type: type,
          paymentMethod: paymentMethod,
          client: client,
          employee: employee,
        );
      }).toList();
    } catch (e) {
      print('Error en getEmployeeHistoryOrdersPaged: $e');
      return [];
    }
  }

  @override
  Future<List<ClientOrder>> getClientHistoryOrdersPaged({
    required List<OrderStatus> statuses,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _connector
          .getClientHistoryOrdersPaged(
            limit: limit,
            offset: offset,
          )
          .statuses(statuses)
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);

      return response.data.orders.map((o) {
        final emp = o.employee;
        ClientEmployee? employee;
        if (emp != null) {
          employee = ClientEmployee(
            nombreCompleto: emp.nombreCompleto,
            fotoPerfil: emp.fotoPerfil,
            telefono: emp.telefono,
          );
        }

        return ClientOrder(
          id: o.id,
          businessId: o.business.id,
          status: o.status.stringValue,
          observations: o.observations ?? '',
          cancellationReason: o.cancellationReason,
          businessName: o.business.nombre,
          businessPhone: o.business.telefono,
          serviceName: o.serviceName ?? '',
          price: o.price,
          employee: employee,
          paymentMethod: o.paymentMethod.stringValue,
          invoiceUrl: o.invoiceUrl,
          hasReview: o.review_on_order != null,
          createdAt: o.createdAt?.toDateTime(),
          type: o.type.stringValue,
          hasPaymentProof: false,
        );
      }).toList();
    } catch (e) {
      print('Error en getClientHistoryOrdersPaged: $e');
      return [];
    }
  }

  @override
  Future<WalkInClientInfo?> findUserByPhone(String phone) async {
    try {
      final response = await _connector
          .findUserByPhone(phone: phone)
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      if (response.data.users.isNotEmpty) {
        final u = response.data.users.first;
        return WalkInClientInfo(
          id: u.id,
          nombreCompleto: u.nombreCompleto,
          telefono: u.telefono ?? '',
          email: u.email,
        );
      }
      return null;
    } catch (e) {
      print('Error en findUserByPhone: $e');
      return null;
    }
  }

  @override
  Future<String> createWalkInUser({
    required String nombreCompleto,
    required String telefono,
    required String email,
  }) async {
    final newId = const Uuid().v4();
    await _connector
        .createWalkInUser(
          id: newId,
          nombreCompleto: nombreCompleto,
          telefono: telefono,
          email: email,
        )
        .execute();
    return newId;
  }

  @override
  Future<String> createWalkInOrder({
    required String businessId,
    required String clientId,
    required double price,
    required double costo,
    required String serviceName,
    required OrderType type,
    required PaymentMethod paymentMethod,
    required String observations,
  }) async {
    final response = await _connector
        .createWalkInOrder(
          businessId: businessId,
          clientId: clientId,
          price: price,
          costo: costo,
          serviceName: serviceName,
          type: type,
          paymentMethod: paymentMethod,
        )
        .observations(observations)
        .execute();

    final orderId = response.data.order_insert.id;
    final parsed = ParsedObservations.parse(observations);
    try {
      await _connector
          .createOrderLog(
            orderId: orderId,
            actionType: 'CREACION',
          )
          .newValue(parsed.dateTime)
          .execute();
    } catch (e) {
      debugPrint('Error creating order log for walk-in CREACION: $e');
    }

    _notifyClientControllers();
    _notifyBusinessControllers(businessId);

    return orderId;
  }

  @override
  Future<List<OrderAuditLog>> getOrderLogs(String orderId) async {
    try {
      final response = await _connector
          .getOrderLogs(orderId: orderId)
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      return response.data.orderLogs.map((log) {
        return OrderAuditLog(
          id: log.id,
          actionType: log.actionType,
          createdAt: log.createdAt.toDateTime(),
          previousValue: log.previousValue,
          newValue: log.newValue,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching order logs: $e');
      return [];
    }
  }

  Future<void> _checkAndExpireOrders(List<dynamic> orders) async {
    final now = DateTime.now();
    for (final order in orders) {
      final String orderId = order.id;
      final observations = order.observations ?? '';

      final bool isTerminal = order is ClientOrder
          ? (order.status.toUpperCase() == 'COMPLETADO' ||
              order.status.toUpperCase() == 'CANCELADO' ||
              order.status.toUpperCase() == 'EN_SERVICIO')
          : (order.status == OrderStatus.COMPLETADO ||
              order.status == OrderStatus.CANCELADO ||
              order.status == OrderStatus.EN_SERVICIO);

      if (isTerminal) continue;

      final String status = order is ClientOrder ? order.status.toUpperCase() : order.status.name.toUpperCase();
      if (status == 'PENDIENTE_PAGO') {
        final paymentMethod = order is ClientOrder ? order.paymentMethod.toUpperCase() : order.paymentMethod.name.toUpperCase();
        if (paymentMethod == 'PAYPHONE' || paymentMethod == 'PAYPAL' || paymentMethod == 'TRANSFERENCIA_BANCARIA') {
          final bool hasProof = order is ClientOrder
              ? order.hasPaymentProof
              : (order is WashGoOrder && order.paymentProofStatus != null);
          if (hasProof) continue;

          DateTime? orderCreatedAt;
          if (order is ClientOrder) {
            orderCreatedAt = order.createdAt;
          }
          if (orderCreatedAt != null) {
            final diff = now.difference(orderCreatedAt);
            if (diff.inMinutes >= 30) {
              try {
                await updateOrderStatus(
                  orderId: orderId,
                  status: OrderStatus.CANCELADO,
                  cancellationReason: 'No pagó',
                );
                final metadataRepo = FirebaseReservationMetadataRepository();
                await metadataRepo.deleteReservation(orderId);
                print('Lazy expired order $orderId due to stale payment (created at $orderCreatedAt)');
              } catch (e) {
                print('Error expiring order $orderId: $e');
              }
              continue;
            }
          }
        }
      }

      final parsed = ParsedObservations.parse(observations);
      if (parsed.scheduleType == 'Programado') {
        final schedTime = _parseOrderDateTime(parsed.dateTime);
        if (schedTime != null) {
          if (now.difference(schedTime).inMinutes > 15) {
            try {
              await updateOrderStatus(
                orderId: orderId,
                status: OrderStatus.CANCELADO,
                cancellationReason: 'No asistió',
              );
              final metadataRepo = FirebaseReservationMetadataRepository();
              await metadataRepo.deleteReservation(orderId);
              print('Lazy expired order $orderId due to no-show (scheduled at $schedTime)');
            } catch (e) {
              print('Error expiring order $orderId: $e');
            }
          }
        }
      }
    }
  }
}

class _OrderQueueItem {
  final String id;
  final String status;
  final DateTime dateTime;
  final int duration;

  _OrderQueueItem({
    required this.id,
    required this.status,
    required this.dateTime,
    required this.duration,
  });
}
