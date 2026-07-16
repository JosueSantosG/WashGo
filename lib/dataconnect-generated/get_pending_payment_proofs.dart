part of 'example.dart';

class GetPendingPaymentProofsVariablesBuilder {
  Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _offset = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  GetPendingPaymentProofsVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }
  GetPendingPaymentProofsVariablesBuilder offset(int? t) {
   _offset.value = t;
   return this;
  }

  GetPendingPaymentProofsVariablesBuilder(this._dataConnect, );
  Deserializer<GetPendingPaymentProofsData> dataDeserializer = (dynamic json)  => GetPendingPaymentProofsData.fromJson(jsonDecode(json));
  Serializer<GetPendingPaymentProofsVariables> varsSerializer = (GetPendingPaymentProofsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPendingPaymentProofsData, GetPendingPaymentProofsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPendingPaymentProofsData, GetPendingPaymentProofsVariables> ref() {
    GetPendingPaymentProofsVariables vars= GetPendingPaymentProofsVariables(limit: _limit,offset: _offset,);
    return _dataConnect.query("GetPendingPaymentProofs", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPendingPaymentProofsPaymentProofs {
  final String id;
  final String imageUrl;
  final double declaredAmount;
  final EnumValue<PaymentAccountType> paymentAccountType;
  final String? referenceNumber;
  final String? observations;
  final EnumValue<PaymentProofStatus> status;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final GetPendingPaymentProofsPaymentProofsOrder order;
  GetPendingPaymentProofsPaymentProofs.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  declaredAmount = nativeFromJson<double>(json['declaredAmount']),
  paymentAccountType = paymentAccountTypeDeserializer(json['paymentAccountType']),
  referenceNumber = json['referenceNumber'] == null ? null : nativeFromJson<String>(json['referenceNumber']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  status = paymentProofStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']),
  order = GetPendingPaymentProofsPaymentProofsOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsPaymentProofs otherTyped = other as GetPendingPaymentProofsPaymentProofs;
    return id == otherTyped.id && 
    imageUrl == otherTyped.imageUrl && 
    declaredAmount == otherTyped.declaredAmount && 
    paymentAccountType == otherTyped.paymentAccountType && 
    referenceNumber == otherTyped.referenceNumber && 
    observations == otherTyped.observations && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt && 
    order == otherTyped.order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, imageUrl.hashCode, declaredAmount.hashCode, paymentAccountType.hashCode, referenceNumber.hashCode, observations.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode, order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['declaredAmount'] = nativeToJson<double>(declaredAmount);
    json['paymentAccountType'] = 
    paymentAccountTypeSerializer(paymentAccountType)
    ;
    if (referenceNumber != null) {
      json['referenceNumber'] = nativeToJson<String?>(referenceNumber);
    }
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    json['status'] = 
    paymentProofStatusSerializer(status)
    ;
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    json['order'] = order.toJson();
    return json;
  }

  GetPendingPaymentProofsPaymentProofs({
    required this.id,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    this.referenceNumber,
    this.observations,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
  });
}

@immutable
class GetPendingPaymentProofsPaymentProofsOrder {
  final String id;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final String? serviceName;
  final String? observations;
  final Timestamp? createdAt;
  final GetPendingPaymentProofsPaymentProofsOrderClient client;
  final GetPendingPaymentProofsPaymentProofsOrderBusiness business;
  final GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder? orderReservation_on_order;
  GetPendingPaymentProofsPaymentProofsOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']),
  client = GetPendingPaymentProofsPaymentProofsOrderClient.fromJson(json['client']),
  business = GetPendingPaymentProofsPaymentProofsOrderBusiness.fromJson(json['business']),
  orderReservation_on_order = json['orderReservation_on_order'] == null ? null : GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder.fromJson(json['orderReservation_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsPaymentProofsOrder otherTyped = other as GetPendingPaymentProofsPaymentProofsOrder;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    createdAt == otherTyped.createdAt && 
    client == otherTyped.client && 
    business == otherTyped.business && 
    orderReservation_on_order == otherTyped.orderReservation_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, paymentMethod.hashCode, status.hashCode, serviceName.hashCode, observations.hashCode, createdAt.hashCode, client.hashCode, business.hashCode, orderReservation_on_order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    json['status'] = 
    orderStatusSerializer(status)
    ;
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    json['client'] = client.toJson();
    json['business'] = business.toJson();
    if (orderReservation_on_order != null) {
      json['orderReservation_on_order'] = orderReservation_on_order!.toJson();
    }
    return json;
  }

  GetPendingPaymentProofsPaymentProofsOrder({
    required this.id,
    required this.price,
    required this.paymentMethod,
    required this.status,
    this.serviceName,
    this.observations,
    this.createdAt,
    required this.client,
    required this.business,
    this.orderReservation_on_order,
  });
}

@immutable
class GetPendingPaymentProofsPaymentProofsOrderClient {
  final String id;
  final String nombreCompleto;
  final String? telefono;
  GetPendingPaymentProofsPaymentProofsOrderClient.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsPaymentProofsOrderClient otherTyped = other as GetPendingPaymentProofsPaymentProofsOrderClient;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetPendingPaymentProofsPaymentProofsOrderClient({
    required this.id,
    required this.nombreCompleto,
    this.telefono,
  });
}

@immutable
class GetPendingPaymentProofsPaymentProofsOrderBusiness {
  final String id;
  final String nombre;
  GetPendingPaymentProofsPaymentProofsOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsPaymentProofsOrderBusiness otherTyped = other as GetPendingPaymentProofsPaymentProofsOrderBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    return json;
  }

  GetPendingPaymentProofsPaymentProofsOrderBusiness({
    required this.id,
    required this.nombre,
  });
}

@immutable
class GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder {
  final Timestamp scheduledAt;
  final int serviceDurationMinutos;
  final GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService service;
  GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder.fromJson(dynamic json):
  
  scheduledAt = Timestamp.fromJson(json['scheduledAt']),
  serviceDurationMinutos = nativeFromJson<int>(json['serviceDurationMinutos']),
  service = GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService.fromJson(json['service']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder otherTyped = other as GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder;
    return scheduledAt == otherTyped.scheduledAt && 
    serviceDurationMinutos == otherTyped.serviceDurationMinutos && 
    service == otherTyped.service;
    
  }
  @override
  int get hashCode => Object.hashAll([scheduledAt.hashCode, serviceDurationMinutos.hashCode, service.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['scheduledAt'] = scheduledAt.toJson();
    json['serviceDurationMinutos'] = nativeToJson<int>(serviceDurationMinutos);
    json['service'] = service.toJson();
    return json;
  }

  GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrder({
    required this.scheduledAt,
    required this.serviceDurationMinutos,
    required this.service,
  });
}

@immutable
class GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService {
  final String id;
  final String nombre;
  GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService otherTyped = other as GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    return json;
  }

  GetPendingPaymentProofsPaymentProofsOrderOrderReservationOnOrderService({
    required this.id,
    required this.nombre,
  });
}

@immutable
class GetPendingPaymentProofsData {
  final List<GetPendingPaymentProofsPaymentProofs> paymentProofs;
  GetPendingPaymentProofsData.fromJson(dynamic json):
  
  paymentProofs = (json['paymentProofs'] as List<dynamic>)
        .map((e) => GetPendingPaymentProofsPaymentProofs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsData otherTyped = other as GetPendingPaymentProofsData;
    return paymentProofs == otherTyped.paymentProofs;
    
  }
  @override
  int get hashCode => paymentProofs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paymentProofs'] = paymentProofs.map((e) => e.toJson()).toList();
    return json;
  }

  GetPendingPaymentProofsData({
    required this.paymentProofs,
  });
}

@immutable
class GetPendingPaymentProofsVariables {
  late final Optional<int>limit;
  late final Optional<int>offset;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPendingPaymentProofsVariables.fromJson(Map<String, dynamic> json) {
  
  
    limit = Optional.optional(nativeFromJson, nativeToJson);
    limit.value = json['limit'] == null ? null : nativeFromJson<int>(json['limit']);
  
  
    offset = Optional.optional(nativeFromJson, nativeToJson);
    offset.value = json['offset'] == null ? null : nativeFromJson<int>(json['offset']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingPaymentProofsVariables otherTyped = other as GetPendingPaymentProofsVariables;
    return limit == otherTyped.limit && 
    offset == otherTyped.offset;
    
  }
  @override
  int get hashCode => Object.hashAll([limit.hashCode, offset.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    if(offset.state == OptionalState.set) {
      json['offset'] = offset.toJson();
    }
    return json;
  }

  GetPendingPaymentProofsVariables({
    required this.limit,
    required this.offset,
  });
}

