part of 'example.dart';

class GetClientHistoryOrdersPagedVariablesBuilder {
  int limit;
  int offset;
  Optional<List<OrderStatus>> _statuses = Optional.optional(listDeserializer((data) => OrderStatus.values.byName(data)), listSerializer(enumSerializer));

  final FirebaseDataConnect _dataConnect;  GetClientHistoryOrdersPagedVariablesBuilder statuses(List<OrderStatus>? t) {
   _statuses.value = t;
   return this;
  }

  GetClientHistoryOrdersPagedVariablesBuilder(this._dataConnect, {required  this.limit,required  this.offset,});
  Deserializer<GetClientHistoryOrdersPagedData> dataDeserializer = (dynamic json)  => GetClientHistoryOrdersPagedData.fromJson(jsonDecode(json));
  Serializer<GetClientHistoryOrdersPagedVariables> varsSerializer = (GetClientHistoryOrdersPagedVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetClientHistoryOrdersPagedData, GetClientHistoryOrdersPagedVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetClientHistoryOrdersPagedData, GetClientHistoryOrdersPagedVariables> ref() {
    GetClientHistoryOrdersPagedVariables vars= GetClientHistoryOrdersPagedVariables(limit: limit,offset: offset,statuses: _statuses,);
    return _dataConnect.query("GetClientHistoryOrdersPaged", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetClientHistoryOrdersPagedOrders {
  final String id;
  final double price;
  final double costo;
  final String? serviceName;
  final String? observations;
  final String? cancellationReason;
  final EnumValue<OrderType> type;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final String? invoiceUrl;
  final Timestamp? createdAt;
  final GetClientHistoryOrdersPagedOrdersBusiness business;
  final GetClientHistoryOrdersPagedOrdersEmployee? employee;
  final GetClientHistoryOrdersPagedOrdersReviewOnOrder? review_on_order;
  GetClientHistoryOrdersPagedOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  cancellationReason = json['cancellationReason'] == null ? null : nativeFromJson<String>(json['cancellationReason']),
  type = orderTypeDeserializer(json['type']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  invoiceUrl = json['invoiceUrl'] == null ? null : nativeFromJson<String>(json['invoiceUrl']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']),
  business = GetClientHistoryOrdersPagedOrdersBusiness.fromJson(json['business']),
  employee = json['employee'] == null ? null : GetClientHistoryOrdersPagedOrdersEmployee.fromJson(json['employee']),
  review_on_order = json['review_on_order'] == null ? null : GetClientHistoryOrdersPagedOrdersReviewOnOrder.fromJson(json['review_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientHistoryOrdersPagedOrders otherTyped = other as GetClientHistoryOrdersPagedOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    cancellationReason == otherTyped.cancellationReason && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    invoiceUrl == otherTyped.invoiceUrl && 
    createdAt == otherTyped.createdAt && 
    business == otherTyped.business && 
    employee == otherTyped.employee && 
    review_on_order == otherTyped.review_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, observations.hashCode, cancellationReason.hashCode, type.hashCode, paymentMethod.hashCode, status.hashCode, invoiceUrl.hashCode, createdAt.hashCode, business.hashCode, employee.hashCode, review_on_order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    json['costo'] = nativeToJson<double>(costo);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    if (cancellationReason != null) {
      json['cancellationReason'] = nativeToJson<String?>(cancellationReason);
    }
    json['type'] = 
    orderTypeSerializer(type)
    ;
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    json['status'] = 
    orderStatusSerializer(status)
    ;
    if (invoiceUrl != null) {
      json['invoiceUrl'] = nativeToJson<String?>(invoiceUrl);
    }
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    json['business'] = business.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    if (review_on_order != null) {
      json['review_on_order'] = review_on_order!.toJson();
    }
    return json;
  }

  GetClientHistoryOrdersPagedOrders({
    required this.id,
    required this.price,
    required this.costo,
    this.serviceName,
    this.observations,
    this.cancellationReason,
    required this.type,
    required this.paymentMethod,
    required this.status,
    this.invoiceUrl,
    this.createdAt,
    required this.business,
    this.employee,
    this.review_on_order,
  });
}

@immutable
class GetClientHistoryOrdersPagedOrdersBusiness {
  final String id;
  final String nombre;
  final double? latitud;
  final double? longitud;
  final String? telefono;
  GetClientHistoryOrdersPagedOrdersBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  latitud = json['latitud'] == null ? null : nativeFromJson<double>(json['latitud']),
  longitud = json['longitud'] == null ? null : nativeFromJson<double>(json['longitud']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientHistoryOrdersPagedOrdersBusiness otherTyped = other as GetClientHistoryOrdersPagedOrdersBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, latitud.hashCode, longitud.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    if (latitud != null) {
      json['latitud'] = nativeToJson<double?>(latitud);
    }
    if (longitud != null) {
      json['longitud'] = nativeToJson<double?>(longitud);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetClientHistoryOrdersPagedOrdersBusiness({
    required this.id,
    required this.nombre,
    this.latitud,
    this.longitud,
    this.telefono,
  });
}

@immutable
class GetClientHistoryOrdersPagedOrdersEmployee {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;
  GetClientHistoryOrdersPagedOrdersEmployee.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  fotoPerfil = json['fotoPerfil'] == null ? null : nativeFromJson<String>(json['fotoPerfil']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientHistoryOrdersPagedOrdersEmployee otherTyped = other as GetClientHistoryOrdersPagedOrdersEmployee;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    fotoPerfil == otherTyped.fotoPerfil && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, fotoPerfil.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (fotoPerfil != null) {
      json['fotoPerfil'] = nativeToJson<String?>(fotoPerfil);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetClientHistoryOrdersPagedOrdersEmployee({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

@immutable
class GetClientHistoryOrdersPagedOrdersReviewOnOrder {
  final String id;
  final int calificacion;
  final String? comentario;
  GetClientHistoryOrdersPagedOrdersReviewOnOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  calificacion = nativeFromJson<int>(json['calificacion']),
  comentario = json['comentario'] == null ? null : nativeFromJson<String>(json['comentario']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientHistoryOrdersPagedOrdersReviewOnOrder otherTyped = other as GetClientHistoryOrdersPagedOrdersReviewOnOrder;
    return id == otherTyped.id && 
    calificacion == otherTyped.calificacion && 
    comentario == otherTyped.comentario;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, calificacion.hashCode, comentario.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['calificacion'] = nativeToJson<int>(calificacion);
    if (comentario != null) {
      json['comentario'] = nativeToJson<String?>(comentario);
    }
    return json;
  }

  GetClientHistoryOrdersPagedOrdersReviewOnOrder({
    required this.id,
    required this.calificacion,
    this.comentario,
  });
}

@immutable
class GetClientHistoryOrdersPagedData {
  final List<GetClientHistoryOrdersPagedOrders> orders;
  GetClientHistoryOrdersPagedData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetClientHistoryOrdersPagedOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientHistoryOrdersPagedData otherTyped = other as GetClientHistoryOrdersPagedData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetClientHistoryOrdersPagedData({
    required this.orders,
  });
}

@immutable
class GetClientHistoryOrdersPagedVariables {
  final int limit;
  final int offset;
  late final Optional<List<OrderStatus>>statuses;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetClientHistoryOrdersPagedVariables.fromJson(Map<String, dynamic> json):
  
  limit = nativeFromJson<int>(json['limit']),
  offset = nativeFromJson<int>(json['offset']) {
  
  
  
  
    statuses = Optional.optional(listDeserializer((data) => OrderStatus.values.byName(data)), listSerializer(enumSerializer));
    statuses.value = json['statuses'] == null ? null : (json['statuses'] as List<dynamic>)
        .map((e) => OrderStatus.values.byName(e))
        .toList();
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientHistoryOrdersPagedVariables otherTyped = other as GetClientHistoryOrdersPagedVariables;
    return limit == otherTyped.limit && 
    offset == otherTyped.offset && 
    statuses == otherTyped.statuses;
    
  }
  @override
  int get hashCode => Object.hashAll([limit.hashCode, offset.hashCode, statuses.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['limit'] = nativeToJson<int>(limit);
    json['offset'] = nativeToJson<int>(offset);
    if(statuses.state == OptionalState.set) {
      json['statuses'] = statuses.toJson();
    }
    return json;
  }

  GetClientHistoryOrdersPagedVariables({
    required this.limit,
    required this.offset,
    required this.statuses,
  });
}

