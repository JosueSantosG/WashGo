part of 'example.dart';

class SuperAdminGetCompletedOrdersVariablesBuilder {
  Timestamp startOfMonth;
  Timestamp endOfMonth;

  final FirebaseDataConnect _dataConnect;
  SuperAdminGetCompletedOrdersVariablesBuilder(this._dataConnect, {required  this.startOfMonth,required  this.endOfMonth,});
  Deserializer<SuperAdminGetCompletedOrdersData> dataDeserializer = (dynamic json)  => SuperAdminGetCompletedOrdersData.fromJson(jsonDecode(json));
  Serializer<SuperAdminGetCompletedOrdersVariables> varsSerializer = (SuperAdminGetCompletedOrdersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SuperAdminGetCompletedOrdersData, SuperAdminGetCompletedOrdersVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<SuperAdminGetCompletedOrdersData, SuperAdminGetCompletedOrdersVariables> ref() {
    SuperAdminGetCompletedOrdersVariables vars= SuperAdminGetCompletedOrdersVariables(startOfMonth: startOfMonth,endOfMonth: endOfMonth,);
    return _dataConnect.query("SuperAdminGetCompletedOrders", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SuperAdminGetCompletedOrdersOrders {
  final String id;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  SuperAdminGetCompletedOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCompletedOrdersOrders otherTyped = other as SuperAdminGetCompletedOrdersOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, paymentMethod.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    return json;
  }

  SuperAdminGetCompletedOrdersOrders({
    required this.id,
    required this.price,
    required this.paymentMethod,
  });
}

@immutable
class SuperAdminGetCompletedOrdersData {
  final List<SuperAdminGetCompletedOrdersOrders> orders;
  SuperAdminGetCompletedOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => SuperAdminGetCompletedOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCompletedOrdersData otherTyped = other as SuperAdminGetCompletedOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  SuperAdminGetCompletedOrdersData({
    required this.orders,
  });
}

@immutable
class SuperAdminGetCompletedOrdersVariables {
  final Timestamp startOfMonth;
  final Timestamp endOfMonth;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SuperAdminGetCompletedOrdersVariables.fromJson(Map<String, dynamic> json):
  
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

    final SuperAdminGetCompletedOrdersVariables otherTyped = other as SuperAdminGetCompletedOrdersVariables;
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

  SuperAdminGetCompletedOrdersVariables({
    required this.startOfMonth,
    required this.endOfMonth,
  });
}

