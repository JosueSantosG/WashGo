part of 'example.dart';

class GetPendingTransferOrdersVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetPendingTransferOrdersVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetPendingTransferOrdersData> dataDeserializer = (dynamic json)  => GetPendingTransferOrdersData.fromJson(jsonDecode(json));
  Serializer<GetPendingTransferOrdersVariables> varsSerializer = (GetPendingTransferOrdersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPendingTransferOrdersData, GetPendingTransferOrdersVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPendingTransferOrdersData, GetPendingTransferOrdersVariables> ref() {
    GetPendingTransferOrdersVariables vars= GetPendingTransferOrdersVariables(businessId: businessId,);
    return _dataConnect.query("GetPendingTransferOrders", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPendingTransferOrdersOrders {
  final String id;
  final double price;
  final String? serviceName;
  final EnumValue<OrderStatus> status;
  final String? observations;
  final Timestamp? createdAt;
  final GetPendingTransferOrdersOrdersClient client;
  final GetPendingTransferOrdersOrdersPaymentProofOnOrder? paymentProof_on_order;
  GetPendingTransferOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  status = orderStatusDeserializer(json['status']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']),
  client = GetPendingTransferOrdersOrdersClient.fromJson(json['client']),
  paymentProof_on_order = json['paymentProof_on_order'] == null ? null : GetPendingTransferOrdersOrdersPaymentProofOnOrder.fromJson(json['paymentProof_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersOrders otherTyped = other as GetPendingTransferOrdersOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    status == otherTyped.status && 
    observations == otherTyped.observations && 
    createdAt == otherTyped.createdAt && 
    client == otherTyped.client && 
    paymentProof_on_order == otherTyped.paymentProof_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, serviceName.hashCode, status.hashCode, observations.hashCode, createdAt.hashCode, client.hashCode, paymentProof_on_order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['status'] = 
    orderStatusSerializer(status)
    ;
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    json['client'] = client.toJson();
    if (paymentProof_on_order != null) {
      json['paymentProof_on_order'] = paymentProof_on_order!.toJson();
    }
    return json;
  }

  GetPendingTransferOrdersOrders({
    required this.id,
    required this.price,
    this.serviceName,
    required this.status,
    this.observations,
    this.createdAt,
    required this.client,
    this.paymentProof_on_order,
  });
}

@immutable
class GetPendingTransferOrdersOrdersClient {
  final String id;
  final String nombreCompleto;
  final String? telefono;
  GetPendingTransferOrdersOrdersClient.fromJson(dynamic json):
  
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

    final GetPendingTransferOrdersOrdersClient otherTyped = other as GetPendingTransferOrdersOrdersClient;
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

  GetPendingTransferOrdersOrdersClient({
    required this.id,
    required this.nombreCompleto,
    this.telefono,
  });
}

@immutable
class GetPendingTransferOrdersOrdersPaymentProofOnOrder {
  final String id;
  final String imageUrl;
  final double declaredAmount;
  final EnumValue<PaymentAccountType> paymentAccountType;
  final String? referenceNumber;
  final String? observations;
  final EnumValue<PaymentProofStatus> status;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  GetPendingTransferOrdersOrdersPaymentProofOnOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  declaredAmount = nativeFromJson<double>(json['declaredAmount']),
  paymentAccountType = paymentAccountTypeDeserializer(json['paymentAccountType']),
  referenceNumber = json['referenceNumber'] == null ? null : nativeFromJson<String>(json['referenceNumber']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  status = paymentProofStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersOrdersPaymentProofOnOrder otherTyped = other as GetPendingTransferOrdersOrdersPaymentProofOnOrder;
    return id == otherTyped.id && 
    imageUrl == otherTyped.imageUrl && 
    declaredAmount == otherTyped.declaredAmount && 
    paymentAccountType == otherTyped.paymentAccountType && 
    referenceNumber == otherTyped.referenceNumber && 
    observations == otherTyped.observations && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, imageUrl.hashCode, declaredAmount.hashCode, paymentAccountType.hashCode, referenceNumber.hashCode, observations.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

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
    return json;
  }

  GetPendingTransferOrdersOrdersPaymentProofOnOrder({
    required this.id,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    this.referenceNumber,
    this.observations,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

@immutable
class GetPendingTransferOrdersData {
  final List<GetPendingTransferOrdersOrders> orders;
  GetPendingTransferOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetPendingTransferOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersData otherTyped = other as GetPendingTransferOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetPendingTransferOrdersData({
    required this.orders,
  });
}

@immutable
class GetPendingTransferOrdersVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPendingTransferOrdersVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersVariables otherTyped = other as GetPendingTransferOrdersVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetPendingTransferOrdersVariables({
    required this.businessId,
  });
}

