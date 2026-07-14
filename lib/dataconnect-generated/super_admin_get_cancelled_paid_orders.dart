part of 'example.dart';

class SuperAdminGetCancelledPaidOrdersVariablesBuilder {
  Timestamp startOfMonth;
  Timestamp endOfMonth;

  final FirebaseDataConnect _dataConnect;
  SuperAdminGetCancelledPaidOrdersVariablesBuilder(this._dataConnect, {required  this.startOfMonth,required  this.endOfMonth,});
  Deserializer<SuperAdminGetCancelledPaidOrdersData> dataDeserializer = (dynamic json)  => SuperAdminGetCancelledPaidOrdersData.fromJson(jsonDecode(json));
  Serializer<SuperAdminGetCancelledPaidOrdersVariables> varsSerializer = (SuperAdminGetCancelledPaidOrdersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SuperAdminGetCancelledPaidOrdersData, SuperAdminGetCancelledPaidOrdersVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<SuperAdminGetCancelledPaidOrdersData, SuperAdminGetCancelledPaidOrdersVariables> ref() {
    SuperAdminGetCancelledPaidOrdersVariables vars= SuperAdminGetCancelledPaidOrdersVariables(startOfMonth: startOfMonth,endOfMonth: endOfMonth,);
    return _dataConnect.query("SuperAdminGetCancelledPaidOrders", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SuperAdminGetCancelledPaidOrdersPaymentProofs {
  final double declaredAmount;
  final SuperAdminGetCancelledPaidOrdersPaymentProofsOrder order;
  SuperAdminGetCancelledPaidOrdersPaymentProofs.fromJson(dynamic json):
  
  declaredAmount = nativeFromJson<double>(json['declaredAmount']),
  order = SuperAdminGetCancelledPaidOrdersPaymentProofsOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCancelledPaidOrdersPaymentProofs otherTyped = other as SuperAdminGetCancelledPaidOrdersPaymentProofs;
    return declaredAmount == otherTyped.declaredAmount && 
    order == otherTyped.order;
    
  }
  @override
  int get hashCode => Object.hashAll([declaredAmount.hashCode, order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['declaredAmount'] = nativeToJson<double>(declaredAmount);
    json['order'] = order.toJson();
    return json;
  }

  SuperAdminGetCancelledPaidOrdersPaymentProofs({
    required this.declaredAmount,
    required this.order,
  });
}

@immutable
class SuperAdminGetCancelledPaidOrdersPaymentProofsOrder {
  final String id;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  SuperAdminGetCancelledPaidOrdersPaymentProofsOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCancelledPaidOrdersPaymentProofsOrder otherTyped = other as SuperAdminGetCancelledPaidOrdersPaymentProofsOrder;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, paymentMethod.hashCode, status.hashCode]);
  

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
    return json;
  }

  SuperAdminGetCancelledPaidOrdersPaymentProofsOrder({
    required this.id,
    required this.price,
    required this.paymentMethod,
    required this.status,
  });
}

@immutable
class SuperAdminGetCancelledPaidOrdersData {
  final List<SuperAdminGetCancelledPaidOrdersPaymentProofs> paymentProofs;
  SuperAdminGetCancelledPaidOrdersData.fromJson(dynamic json):
  
  paymentProofs = (json['paymentProofs'] as List<dynamic>)
        .map((e) => SuperAdminGetCancelledPaidOrdersPaymentProofs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCancelledPaidOrdersData otherTyped = other as SuperAdminGetCancelledPaidOrdersData;
    return paymentProofs == otherTyped.paymentProofs;
    
  }
  @override
  int get hashCode => paymentProofs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paymentProofs'] = paymentProofs.map((e) => e.toJson()).toList();
    return json;
  }

  SuperAdminGetCancelledPaidOrdersData({
    required this.paymentProofs,
  });
}

@immutable
class SuperAdminGetCancelledPaidOrdersVariables {
  final Timestamp startOfMonth;
  final Timestamp endOfMonth;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SuperAdminGetCancelledPaidOrdersVariables.fromJson(Map<String, dynamic> json):
  
  startOfMonth = Timestamp.fromJson(json['startOfMonth']),
  endOfMonth = Timestamp.fromJson(json['endOfMonth']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCancelledPaidOrdersVariables otherTyped = other as SuperAdminGetCancelledPaidOrdersVariables;
    return startOfMonth == otherTyped.startOfMonth && 
    endOfMonth == otherTyped.endOfMonth;
    
  }
  @override
  int get hashCode => Object.hashAll([startOfMonth.hashCode, endOfMonth.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['startOfMonth'] = startOfMonth.toJson();
    json['endOfMonth'] = endOfMonth.toJson();
    return json;
  }

  SuperAdminGetCancelledPaidOrdersVariables({
    required this.startOfMonth,
    required this.endOfMonth,
  });
}

