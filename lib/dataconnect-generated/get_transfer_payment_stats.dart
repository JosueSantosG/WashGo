part of 'example.dart';

class GetTransferPaymentStatsVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetTransferPaymentStatsVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetTransferPaymentStatsData> dataDeserializer = (dynamic json)  => GetTransferPaymentStatsData.fromJson(jsonDecode(json));
  Serializer<GetTransferPaymentStatsVariables> varsSerializer = (GetTransferPaymentStatsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetTransferPaymentStatsData, GetTransferPaymentStatsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetTransferPaymentStatsData, GetTransferPaymentStatsVariables> ref() {
    GetTransferPaymentStatsVariables vars= GetTransferPaymentStatsVariables(businessId: businessId,);
    return _dataConnect.query("GetTransferPaymentStats", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetTransferPaymentStatsOrders {
  final String id;
  final double price;
  final GetTransferPaymentStatsOrdersPaymentProofOnOrder? paymentProof_on_order;
  GetTransferPaymentStatsOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  paymentProof_on_order = json['paymentProof_on_order'] == null ? null : GetTransferPaymentStatsOrdersPaymentProofOnOrder.fromJson(json['paymentProof_on_order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTransferPaymentStatsOrders otherTyped = other as GetTransferPaymentStatsOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    paymentProof_on_order == otherTyped.paymentProof_on_order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, paymentProof_on_order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    if (paymentProof_on_order != null) {
      json['paymentProof_on_order'] = paymentProof_on_order!.toJson();
    }
    return json;
  }

  GetTransferPaymentStatsOrders({
    required this.id,
    required this.price,
    this.paymentProof_on_order,
  });
}

@immutable
class GetTransferPaymentStatsOrdersPaymentProofOnOrder {
  final EnumValue<PaymentProofStatus> status;
  GetTransferPaymentStatsOrdersPaymentProofOnOrder.fromJson(dynamic json):
  
  status = paymentProofStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTransferPaymentStatsOrdersPaymentProofOnOrder otherTyped = other as GetTransferPaymentStatsOrdersPaymentProofOnOrder;
    return status == otherTyped.status;
    
  }
  @override
  int get hashCode => status.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['status'] = 
    paymentProofStatusSerializer(status)
    ;
    return json;
  }

  GetTransferPaymentStatsOrdersPaymentProofOnOrder({
    required this.status,
  });
}

@immutable
class GetTransferPaymentStatsData {
  final List<GetTransferPaymentStatsOrders> orders;
  GetTransferPaymentStatsData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetTransferPaymentStatsOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTransferPaymentStatsData otherTyped = other as GetTransferPaymentStatsData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetTransferPaymentStatsData({
    required this.orders,
  });
}

@immutable
class GetTransferPaymentStatsVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetTransferPaymentStatsVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTransferPaymentStatsVariables otherTyped = other as GetTransferPaymentStatsVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetTransferPaymentStatsVariables({
    required this.businessId,
  });
}

