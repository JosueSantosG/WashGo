part of 'example.dart';

class GetPendingElectronicOrdersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetPendingElectronicOrdersVariablesBuilder(this._dataConnect, );
  Deserializer<GetPendingElectronicOrdersData> dataDeserializer = (dynamic json)  => GetPendingElectronicOrdersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetPendingElectronicOrdersData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPendingElectronicOrdersData, void> ref() {
    
    return _dataConnect.query("GetPendingElectronicOrders", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetPendingElectronicOrdersOrders {
  final String id;
  final String clientId;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  final String? serviceName;
  final String businessId;
  final Timestamp? createdAt;
  GetPendingElectronicOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  clientId = nativeFromJson<String>(json['clientId']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  businessId = nativeFromJson<String>(json['businessId']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingElectronicOrdersOrders otherTyped = other as GetPendingElectronicOrdersOrders;
    return id == otherTyped.id && 
    clientId == otherTyped.clientId && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod && 
    serviceName == otherTyped.serviceName && 
    businessId == otherTyped.businessId && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, clientId.hashCode, price.hashCode, paymentMethod.hashCode, serviceName.hashCode, businessId.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['clientId'] = nativeToJson<String>(clientId);
    json['price'] = nativeToJson<double>(price);
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['businessId'] = nativeToJson<String>(businessId);
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    return json;
  }

  GetPendingElectronicOrdersOrders({
    required this.id,
    required this.clientId,
    required this.price,
    required this.paymentMethod,
    this.serviceName,
    required this.businessId,
    this.createdAt,
  });
}

@immutable
class GetPendingElectronicOrdersData {
  final List<GetPendingElectronicOrdersOrders> orders;
  GetPendingElectronicOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetPendingElectronicOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingElectronicOrdersData otherTyped = other as GetPendingElectronicOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetPendingElectronicOrdersData({
    required this.orders,
  });
}

