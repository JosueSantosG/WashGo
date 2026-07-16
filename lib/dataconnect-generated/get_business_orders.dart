part of 'example.dart';

class GetBusinessOrdersVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetBusinessOrdersVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetBusinessOrdersData> dataDeserializer = (dynamic json)  => GetBusinessOrdersData.fromJson(jsonDecode(json));
  Serializer<GetBusinessOrdersVariables> varsSerializer = (GetBusinessOrdersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBusinessOrdersData, GetBusinessOrdersVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetBusinessOrdersData, GetBusinessOrdersVariables> ref() {
    GetBusinessOrdersVariables vars= GetBusinessOrdersVariables(businessId: businessId,);
    return _dataConnect.query("GetBusinessOrders", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBusinessOrdersOrders {
  final String id;
  final double price;
  final double costo;
  final String? serviceName;
  final String? observations;
  final EnumValue<OrderType> type;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final GetBusinessOrdersOrdersClient client;
  final GetBusinessOrdersOrdersEmployee? employee;
  final GetBusinessOrdersOrdersPaymentProofOnOrder? paymentProof_on_order;
  GetBusinessOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  type = orderTypeDeserializer(json['type']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  client = GetBusinessOrdersOrdersClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : GetBusinessOrdersOrdersEmployee.fromJson(json['employee']),
  paymentProof_on_order = json['paymentProof_on_order'] == null ? null : GetBusinessOrdersOrdersPaymentProofOnOrder.fromJson(json['paymentProof_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessOrdersOrders otherTyped = other as GetBusinessOrdersOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    client == otherTyped.client && 
    employee == otherTyped.employee && 
    paymentProof_on_order == otherTyped.paymentProof_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, observations.hashCode, type.hashCode, paymentMethod.hashCode, status.hashCode, client.hashCode, employee.hashCode, paymentProof_on_order.hashCode]);
  

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
    json['client'] = client.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    if (paymentProof_on_order != null) {
      json['paymentProof_on_order'] = paymentProof_on_order!.toJson();
    }
    return json;
  }

  GetBusinessOrdersOrders({
    required this.id,
    required this.price,
    required this.costo,
    this.serviceName,
    this.observations,
    required this.type,
    required this.paymentMethod,
    required this.status,
    required this.client,
    this.employee,
    this.paymentProof_on_order,
  });
}

@immutable
class GetBusinessOrdersOrdersClient {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;
  GetBusinessOrdersOrdersClient.fromJson(dynamic json):
  
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

    final GetBusinessOrdersOrdersClient otherTyped = other as GetBusinessOrdersOrdersClient;
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

  GetBusinessOrdersOrdersClient({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

@immutable
class GetBusinessOrdersOrdersEmployee {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;
  GetBusinessOrdersOrdersEmployee.fromJson(dynamic json):
  
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

    final GetBusinessOrdersOrdersEmployee otherTyped = other as GetBusinessOrdersOrdersEmployee;
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

  GetBusinessOrdersOrdersEmployee({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

@immutable
class GetBusinessOrdersOrdersPaymentProofOnOrder {
  final String id;
  final String imageUrl;
  final double declaredAmount;
  final EnumValue<PaymentAccountType> paymentAccountType;
  final String? referenceNumber;
  final String? observations;
  final EnumValue<PaymentProofStatus> status;
  GetBusinessOrdersOrdersPaymentProofOnOrder.fromJson(dynamic json):
  
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

    final GetBusinessOrdersOrdersPaymentProofOnOrder otherTyped = other as GetBusinessOrdersOrdersPaymentProofOnOrder;
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

  GetBusinessOrdersOrdersPaymentProofOnOrder({
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
class GetBusinessOrdersData {
  final List<GetBusinessOrdersOrders> orders;
  GetBusinessOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetBusinessOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessOrdersData otherTyped = other as GetBusinessOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetBusinessOrdersData({
    required this.orders,
  });
}

@immutable
class GetBusinessOrdersVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBusinessOrdersVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessOrdersVariables otherTyped = other as GetBusinessOrdersVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetBusinessOrdersVariables({
    required this.businessId,
  });
}

