part of 'example.dart';

class GetExpiredPendingTransferOrdersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetExpiredPendingTransferOrdersVariablesBuilder(this._dataConnect, );
  Deserializer<GetExpiredPendingTransferOrdersData> dataDeserializer = (dynamic json)  => GetExpiredPendingTransferOrdersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetExpiredPendingTransferOrdersData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetExpiredPendingTransferOrdersData, void> ref() {
    
    return _dataConnect.query("GetExpiredPendingTransferOrders", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetExpiredPendingTransferOrdersOrders {
  final String id;
  final String clientId;
  final double price;
  final String? serviceName;
  final String businessId;
  final Timestamp? createdAt;
  final GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder? paymentProof_on_order;
  GetExpiredPendingTransferOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  clientId = nativeFromJson<String>(json['clientId']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  businessId = nativeFromJson<String>(json['businessId']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']),
  paymentProof_on_order = json['paymentProof_on_order'] == null ? null : GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder.fromJson(json['paymentProof_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetExpiredPendingTransferOrdersOrders otherTyped = other as GetExpiredPendingTransferOrdersOrders;
    return id == otherTyped.id && 
    clientId == otherTyped.clientId && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    businessId == otherTyped.businessId && 
    createdAt == otherTyped.createdAt && 
    paymentProof_on_order == otherTyped.paymentProof_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, clientId.hashCode, price.hashCode, serviceName.hashCode, businessId.hashCode, createdAt.hashCode, paymentProof_on_order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['clientId'] = nativeToJson<String>(clientId);
    json['price'] = nativeToJson<double>(price);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['businessId'] = nativeToJson<String>(businessId);
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    if (paymentProof_on_order != null) {
      json['paymentProof_on_order'] = paymentProof_on_order!.toJson();
    }
    return json;
  }

  GetExpiredPendingTransferOrdersOrders({
    required this.id,
    required this.clientId,
    required this.price,
    this.serviceName,
    required this.businessId,
    this.createdAt,
    this.paymentProof_on_order,
  });
}

@immutable
class GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder {
  final String id;
  final EnumValue<PaymentProofStatus> status;
  GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  status = paymentProofStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder otherTyped = other as GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder;
    return id == otherTyped.id && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = 
    paymentProofStatusSerializer(status)
    ;
    return json;
  }

  GetExpiredPendingTransferOrdersOrdersPaymentProofOnOrder({
    required this.id,
    required this.status,
  });
}

@immutable
class GetExpiredPendingTransferOrdersData {
  final List<GetExpiredPendingTransferOrdersOrders> orders;
  GetExpiredPendingTransferOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetExpiredPendingTransferOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetExpiredPendingTransferOrdersData otherTyped = other as GetExpiredPendingTransferOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetExpiredPendingTransferOrdersData({
    required this.orders,
  });
}

