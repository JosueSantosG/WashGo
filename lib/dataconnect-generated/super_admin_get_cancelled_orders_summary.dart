part of 'example.dart';

class SuperAdminGetCancelledOrdersSummaryVariablesBuilder {
  Timestamp startOfMonth;
  Timestamp endOfMonth;

  final FirebaseDataConnect _dataConnect;
  SuperAdminGetCancelledOrdersSummaryVariablesBuilder(this._dataConnect, {required  this.startOfMonth,required  this.endOfMonth,});
  Deserializer<SuperAdminGetCancelledOrdersSummaryData> dataDeserializer = (dynamic json)  => SuperAdminGetCancelledOrdersSummaryData.fromJson(jsonDecode(json));
  Serializer<SuperAdminGetCancelledOrdersSummaryVariables> varsSerializer = (SuperAdminGetCancelledOrdersSummaryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SuperAdminGetCancelledOrdersSummaryData, SuperAdminGetCancelledOrdersSummaryVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<SuperAdminGetCancelledOrdersSummaryData, SuperAdminGetCancelledOrdersSummaryVariables> ref() {
    SuperAdminGetCancelledOrdersSummaryVariables vars= SuperAdminGetCancelledOrdersSummaryVariables(startOfMonth: startOfMonth,endOfMonth: endOfMonth,);
    return _dataConnect.query("SuperAdminGetCancelledOrdersSummary", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SuperAdminGetCancelledOrdersSummaryOrders {
  final String id;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  SuperAdminGetCancelledOrdersSummaryOrders.fromJson(dynamic json):
  
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

    final SuperAdminGetCancelledOrdersSummaryOrders otherTyped = other as SuperAdminGetCancelledOrdersSummaryOrders;
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

  SuperAdminGetCancelledOrdersSummaryOrders({
    required this.id,
    required this.price,
    required this.paymentMethod,
  });
}

@immutable
class SuperAdminGetCancelledOrdersSummaryData {
  final List<SuperAdminGetCancelledOrdersSummaryOrders> orders;
  SuperAdminGetCancelledOrdersSummaryData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => SuperAdminGetCancelledOrdersSummaryOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetCancelledOrdersSummaryData otherTyped = other as SuperAdminGetCancelledOrdersSummaryData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  SuperAdminGetCancelledOrdersSummaryData({
    required this.orders,
  });
}

@immutable
class SuperAdminGetCancelledOrdersSummaryVariables {
  final Timestamp startOfMonth;
  final Timestamp endOfMonth;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SuperAdminGetCancelledOrdersSummaryVariables.fromJson(Map<String, dynamic> json):
  
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

    final SuperAdminGetCancelledOrdersSummaryVariables otherTyped = other as SuperAdminGetCancelledOrdersSummaryVariables;
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

  SuperAdminGetCancelledOrdersSummaryVariables({
    required this.startOfMonth,
    required this.endOfMonth,
  });
}

