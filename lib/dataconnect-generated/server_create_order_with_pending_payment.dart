part of 'example.dart';

class ServerCreateOrderWithPendingPaymentVariablesBuilder {
  String businessId;
  String clientId;
  double price;
  double costo;
  String serviceName;
  OrderType type;
  PaymentMethod paymentMethod;
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ServerCreateOrderWithPendingPaymentVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ServerCreateOrderWithPendingPaymentVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.clientId,required  this.price,required  this.costo,required  this.serviceName,required  this.type,required  this.paymentMethod,});
  Deserializer<ServerCreateOrderWithPendingPaymentData> dataDeserializer = (dynamic json)  => ServerCreateOrderWithPendingPaymentData.fromJson(jsonDecode(json));
  Serializer<ServerCreateOrderWithPendingPaymentVariables> varsSerializer = (ServerCreateOrderWithPendingPaymentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ServerCreateOrderWithPendingPaymentData, ServerCreateOrderWithPendingPaymentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ServerCreateOrderWithPendingPaymentData, ServerCreateOrderWithPendingPaymentVariables> ref() {
    ServerCreateOrderWithPendingPaymentVariables vars= ServerCreateOrderWithPendingPaymentVariables(businessId: businessId,clientId: clientId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,observations: _observations,);
    return _dataConnect.mutation("ServerCreateOrderWithPendingPayment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ServerCreateOrderWithPendingPaymentOrderInsert {
  final String id;
  ServerCreateOrderWithPendingPaymentOrderInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerCreateOrderWithPendingPaymentOrderInsert otherTyped = other as ServerCreateOrderWithPendingPaymentOrderInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ServerCreateOrderWithPendingPaymentOrderInsert({
    required this.id,
  });
}

@immutable
class ServerCreateOrderWithPendingPaymentData {
  final ServerCreateOrderWithPendingPaymentOrderInsert order_insert;
  ServerCreateOrderWithPendingPaymentData.fromJson(dynamic json):
  
  order_insert = ServerCreateOrderWithPendingPaymentOrderInsert.fromJson(json['order_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerCreateOrderWithPendingPaymentData otherTyped = other as ServerCreateOrderWithPendingPaymentData;
    return order_insert == otherTyped.order_insert;
    
  }
  @override
  int get hashCode => order_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['order_insert'] = order_insert.toJson();
    return json;
  }

  ServerCreateOrderWithPendingPaymentData({
    required this.order_insert,
  });
}

@immutable
class ServerCreateOrderWithPendingPaymentVariables {
  final String businessId;
  final String clientId;
  final double price;
  final double costo;
  final String serviceName;
  final OrderType type;
  final PaymentMethod paymentMethod;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ServerCreateOrderWithPendingPaymentVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  clientId = nativeFromJson<String>(json['clientId']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  type = OrderType.values.byName(json['type']),
  paymentMethod = PaymentMethod.values.byName(json['paymentMethod']) {
  
  
  
  
  
  
  
  
  
    observations = Optional.optional(nativeFromJson, nativeToJson);
    observations.value = json['observations'] == null ? null : nativeFromJson<String>(json['observations']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerCreateOrderWithPendingPaymentVariables otherTyped = other as ServerCreateOrderWithPendingPaymentVariables;
    return businessId == otherTyped.businessId && 
    clientId == otherTyped.clientId && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, clientId.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, type.hashCode, paymentMethod.hashCode, observations.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['clientId'] = nativeToJson<String>(clientId);
    json['price'] = nativeToJson<double>(price);
    json['costo'] = nativeToJson<double>(costo);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['type'] = 
    type.name
    ;
    json['paymentMethod'] = 
    paymentMethod.name
    ;
    if(observations.state == OptionalState.set) {
      json['observations'] = observations.toJson();
    }
    return json;
  }

  ServerCreateOrderWithPendingPaymentVariables({
    required this.businessId,
    required this.clientId,
    required this.price,
    required this.costo,
    required this.serviceName,
    required this.type,
    required this.paymentMethod,
    required this.observations,
  });
}

