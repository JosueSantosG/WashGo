part of 'example.dart';

class GetOrderDetailsForPaymentVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetOrderDetailsForPaymentVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetOrderDetailsForPaymentData> dataDeserializer = (dynamic json)  => GetOrderDetailsForPaymentData.fromJson(jsonDecode(json));
  Serializer<GetOrderDetailsForPaymentVariables> varsSerializer = (GetOrderDetailsForPaymentVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetOrderDetailsForPaymentData, GetOrderDetailsForPaymentVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetOrderDetailsForPaymentData, GetOrderDetailsForPaymentVariables> ref() {
    GetOrderDetailsForPaymentVariables vars= GetOrderDetailsForPaymentVariables(orderId: orderId,);
    return _dataConnect.query("GetOrderDetailsForPayment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetOrderDetailsForPaymentOrder {
  final String id;
  final String clientId;
  final EnumValue<OrderStatus> status;
  final double price;
  final String? serviceName;
  final GetOrderDetailsForPaymentOrderBusiness business;
  GetOrderDetailsForPaymentOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  clientId = nativeFromJson<String>(json['clientId']),
  status = orderStatusDeserializer(json['status']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  business = GetOrderDetailsForPaymentOrderBusiness.fromJson(json['business']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderDetailsForPaymentOrder otherTyped = other as GetOrderDetailsForPaymentOrder;
    return id == otherTyped.id && 
    clientId == otherTyped.clientId && 
    status == otherTyped.status && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    business == otherTyped.business;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, clientId.hashCode, status.hashCode, price.hashCode, serviceName.hashCode, business.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['clientId'] = nativeToJson<String>(clientId);
    json['status'] = 
    orderStatusSerializer(status)
    ;
    json['price'] = nativeToJson<double>(price);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['business'] = business.toJson();
    return json;
  }

  GetOrderDetailsForPaymentOrder({
    required this.id,
    required this.clientId,
    required this.status,
    required this.price,
    this.serviceName,
    required this.business,
  });
}

@immutable
class GetOrderDetailsForPaymentOrderBusiness {
  final String id;
  final String nombre;
  final GetOrderDetailsForPaymentOrderBusinessOwner owner;
  GetOrderDetailsForPaymentOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  owner = GetOrderDetailsForPaymentOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderDetailsForPaymentOrderBusiness otherTyped = other as GetOrderDetailsForPaymentOrderBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, owner.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['owner'] = owner.toJson();
    return json;
  }

  GetOrderDetailsForPaymentOrderBusiness({
    required this.id,
    required this.nombre,
    required this.owner,
  });
}

@immutable
class GetOrderDetailsForPaymentOrderBusinessOwner {
  final String id;
  GetOrderDetailsForPaymentOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderDetailsForPaymentOrderBusinessOwner otherTyped = other as GetOrderDetailsForPaymentOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetOrderDetailsForPaymentOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class GetOrderDetailsForPaymentData {
  final GetOrderDetailsForPaymentOrder? order;
  GetOrderDetailsForPaymentData.fromJson(dynamic json):
  
  order = json['order'] == null ? null : GetOrderDetailsForPaymentOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderDetailsForPaymentData otherTyped = other as GetOrderDetailsForPaymentData;
    return order == otherTyped.order;
    
  }
  @override
  int get hashCode => order.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (order != null) {
      json['order'] = order!.toJson();
    }
    return json;
  }

  GetOrderDetailsForPaymentData({
    this.order,
  });
}

@immutable
class GetOrderDetailsForPaymentVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetOrderDetailsForPaymentVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderDetailsForPaymentVariables otherTyped = other as GetOrderDetailsForPaymentVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetOrderDetailsForPaymentVariables({
    required this.orderId,
  });
}

