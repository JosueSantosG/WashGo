part of 'example.dart';

class GetClientOrdersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetClientOrdersVariablesBuilder(this._dataConnect, );
  Deserializer<GetClientOrdersData> dataDeserializer = (dynamic json)  => GetClientOrdersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetClientOrdersData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetClientOrdersData, void> ref() {
    
    return _dataConnect.query("GetClientOrders", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetClientOrdersOrders {
  final String id;
  final double price;
  final double costo;
  final String? serviceName;
  final String? observations;
  final EnumValue<OrderType> type;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final String? invoiceUrl;
  final Timestamp? createdAt;
  final GetClientOrdersOrdersBusiness business;
  final GetClientOrdersOrdersEmployee? employee;
  final GetClientOrdersOrdersReviewOnOrder? review_on_order;
  final GetClientOrdersOrdersPaymentProofOnOrder? paymentProof_on_order;
  GetClientOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  type = orderTypeDeserializer(json['type']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  invoiceUrl = json['invoiceUrl'] == null ? null : nativeFromJson<String>(json['invoiceUrl']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']),
  business = GetClientOrdersOrdersBusiness.fromJson(json['business']),
  employee = json['employee'] == null ? null : GetClientOrdersOrdersEmployee.fromJson(json['employee']),
  review_on_order = json['review_on_order'] == null ? null : GetClientOrdersOrdersReviewOnOrder.fromJson(json['review_on_order']),
  paymentProof_on_order = json['paymentProof_on_order'] == null ? null : GetClientOrdersOrdersPaymentProofOnOrder.fromJson(json['paymentProof_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientOrdersOrders otherTyped = other as GetClientOrdersOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    invoiceUrl == otherTyped.invoiceUrl && 
    createdAt == otherTyped.createdAt && 
    business == otherTyped.business && 
    employee == otherTyped.employee && 
    review_on_order == otherTyped.review_on_order && 
    paymentProof_on_order == otherTyped.paymentProof_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, observations.hashCode, type.hashCode, paymentMethod.hashCode, status.hashCode, invoiceUrl.hashCode, createdAt.hashCode, business.hashCode, employee.hashCode, review_on_order.hashCode, paymentProof_on_order.hashCode]);
  

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
    if (paymentProof_on_order != null) {
      json['paymentProof_on_order'] = paymentProof_on_order!.toJson();
    }
    return json;
  }

  GetClientOrdersOrders({
    required this.id,
    required this.price,
    required this.costo,
    this.serviceName,
    this.observations,
    required this.type,
    required this.paymentMethod,
    required this.status,
    this.invoiceUrl,
    this.createdAt,
    required this.business,
    this.employee,
    this.review_on_order,
    this.paymentProof_on_order,
  });
}

@immutable
class GetClientOrdersOrdersBusiness {
  final String id;
  final String nombre;
  final double? latitud;
  final double? longitud;
  final String? telefono;
  GetClientOrdersOrdersBusiness.fromJson(dynamic json):
  
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

    final GetClientOrdersOrdersBusiness otherTyped = other as GetClientOrdersOrdersBusiness;
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

  GetClientOrdersOrdersBusiness({
    required this.id,
    required this.nombre,
    this.latitud,
    this.longitud,
    this.telefono,
  });
}

@immutable
class GetClientOrdersOrdersEmployee {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;
  GetClientOrdersOrdersEmployee.fromJson(dynamic json):
  
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

    final GetClientOrdersOrdersEmployee otherTyped = other as GetClientOrdersOrdersEmployee;
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

  GetClientOrdersOrdersEmployee({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

@immutable
class GetClientOrdersOrdersReviewOnOrder {
  final String id;
  final int calificacion;
  final String? comentario;
  GetClientOrdersOrdersReviewOnOrder.fromJson(dynamic json):
  
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

    final GetClientOrdersOrdersReviewOnOrder otherTyped = other as GetClientOrdersOrdersReviewOnOrder;
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

  GetClientOrdersOrdersReviewOnOrder({
    required this.id,
    required this.calificacion,
    this.comentario,
  });
}

@immutable
class GetClientOrdersOrdersPaymentProofOnOrder {
  final String id;
  final String imageUrl;
  final double declaredAmount;
  final EnumValue<PaymentAccountType> paymentAccountType;
  final String? referenceNumber;
  final String? observations;
  final EnumValue<PaymentProofStatus> status;
  GetClientOrdersOrdersPaymentProofOnOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  declaredAmount = nativeFromJson<double>(json['declaredAmount']),
  paymentAccountType = paymentAccountTypeDeserializer(json['paymentAccountType']),
  referenceNumber = json['referenceNumber'] == null ? null : nativeFromJson<String>(json['referenceNumber']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  status = paymentProofStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientOrdersOrdersPaymentProofOnOrder otherTyped = other as GetClientOrdersOrdersPaymentProofOnOrder;
    return id == otherTyped.id && 
    imageUrl == otherTyped.imageUrl && 
    declaredAmount == otherTyped.declaredAmount && 
    paymentAccountType == otherTyped.paymentAccountType && 
    referenceNumber == otherTyped.referenceNumber && 
    observations == otherTyped.observations && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, imageUrl.hashCode, declaredAmount.hashCode, paymentAccountType.hashCode, referenceNumber.hashCode, observations.hashCode, status.hashCode]);
  

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
    return json;
  }

  GetClientOrdersOrdersPaymentProofOnOrder({
    required this.id,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    this.referenceNumber,
    this.observations,
    required this.status,
  });
}

@immutable
class GetClientOrdersData {
  final List<GetClientOrdersOrders> orders;
  GetClientOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetClientOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientOrdersData otherTyped = other as GetClientOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetClientOrdersData({
    required this.orders,
  });
}

