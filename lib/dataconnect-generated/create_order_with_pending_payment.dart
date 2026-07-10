part of 'example.dart';

class CreateOrderWithPendingPaymentVariablesBuilder {
  String businessId;
  double price;
  double costo;
  String serviceName;
  OrderType type;
  PaymentMethod paymentMethod;
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateOrderWithPendingPaymentVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  CreateOrderWithPendingPaymentVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.price,required  this.costo,required  this.serviceName,required  this.type,required  this.paymentMethod,});
  Deserializer<CreateOrderWithPendingPaymentData> dataDeserializer = (dynamic json)  => CreateOrderWithPendingPaymentData.fromJson(jsonDecode(json));
  Serializer<CreateOrderWithPendingPaymentVariables> varsSerializer = (CreateOrderWithPendingPaymentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateOrderWithPendingPaymentData, CreateOrderWithPendingPaymentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateOrderWithPendingPaymentData, CreateOrderWithPendingPaymentVariables> ref() {
    CreateOrderWithPendingPaymentVariables vars= CreateOrderWithPendingPaymentVariables(businessId: businessId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,observations: _observations,);
    return _dataConnect.mutation("CreateOrderWithPendingPayment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateOrderWithPendingPaymentOrderInsert {
  final String id;
  CreateOrderWithPendingPaymentOrderInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderWithPendingPaymentOrderInsert otherTyped = other as CreateOrderWithPendingPaymentOrderInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateOrderWithPendingPaymentOrderInsert({
    required this.id,
  });
}

@immutable
class CreateOrderWithPendingPaymentData {
  final CreateOrderWithPendingPaymentOrderInsert order_insert;
  CreateOrderWithPendingPaymentData.fromJson(dynamic json):
  
  order_insert = CreateOrderWithPendingPaymentOrderInsert.fromJson(json['order_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderWithPendingPaymentData otherTyped = other as CreateOrderWithPendingPaymentData;
    return order_insert == otherTyped.order_insert;
    
  }
  @override
  int get hashCode => order_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['order_insert'] = order_insert.toJson();
    return json;
  }

  CreateOrderWithPendingPaymentData({
    required this.order_insert,
  });
}

@immutable
class CreateOrderWithPendingPaymentVariables {
  final String businessId;
  final double price;
  final double costo;
  final String serviceName;
  final OrderType type;
  final PaymentMethod paymentMethod;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateOrderWithPendingPaymentVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
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

    final CreateOrderWithPendingPaymentVariables otherTyped = other as CreateOrderWithPendingPaymentVariables;
    return businessId == otherTyped.businessId && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, type.hashCode, paymentMethod.hashCode, observations.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
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

  CreateOrderWithPendingPaymentVariables({
    required this.businessId,
    required this.price,
    required this.costo,
    required this.serviceName,
    required this.type,
    required this.paymentMethod,
    required this.observations,
  });
}

