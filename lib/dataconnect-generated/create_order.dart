part of 'example.dart';

class CreateOrderVariablesBuilder {
  String businessId;
  double price;
  double costo;
  String serviceName;
  OrderType type;
  PaymentMethod paymentMethod;
  Optional<OrderStatus> _status = Optional.optional((data) => OrderStatus.values.byName(data), enumSerializer);
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateOrderVariablesBuilder status(OrderStatus t) {
   _status.value = t;
   return this;
  }
  CreateOrderVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  CreateOrderVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.price,required  this.costo,required  this.serviceName,required  this.type,required  this.paymentMethod,});
  Deserializer<CreateOrderData> dataDeserializer = (dynamic json)  => CreateOrderData.fromJson(jsonDecode(json));
  Serializer<CreateOrderVariables> varsSerializer = (CreateOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateOrderData, CreateOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateOrderData, CreateOrderVariables> ref() {
    CreateOrderVariables vars= CreateOrderVariables(businessId: businessId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,status: _status,observations: _observations,);
    return _dataConnect.mutation("CreateOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateOrderOrderInsert {
  final String id;
  CreateOrderOrderInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderOrderInsert otherTyped = other as CreateOrderOrderInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateOrderOrderInsert({
    required this.id,
  });
}

@immutable
class CreateOrderData {
  final CreateOrderOrderInsert order_insert;
  CreateOrderData.fromJson(dynamic json):
  
  order_insert = CreateOrderOrderInsert.fromJson(json['order_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderData otherTyped = other as CreateOrderData;
    return order_insert == otherTyped.order_insert;
    
  }
  @override
  int get hashCode => order_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['order_insert'] = order_insert.toJson();
    return json;
  }

  CreateOrderData({
    required this.order_insert,
  });
}

@immutable
class CreateOrderVariables {
  final String businessId;
  final double price;
  final double costo;
  final String serviceName;
  final OrderType type;
  final PaymentMethod paymentMethod;
  late final Optional<OrderStatus>status;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateOrderVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  type = OrderType.values.byName(json['type']),
  paymentMethod = PaymentMethod.values.byName(json['paymentMethod']) {
  
  
  
  
  
  
  
  
    status = Optional.optional((data) => OrderStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : OrderStatus.values.byName(json['status']);
  
  
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

    final CreateOrderVariables otherTyped = other as CreateOrderVariables;
    return businessId == otherTyped.businessId && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, type.hashCode, paymentMethod.hashCode, status.hashCode, observations.hashCode]);
  

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
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    if(observations.state == OptionalState.set) {
      json['observations'] = observations.toJson();
    }
    return json;
  }

  CreateOrderVariables({
    required this.businessId,
    required this.price,
    required this.costo,
    required this.serviceName,
    required this.type,
    required this.paymentMethod,
    required this.status,
    required this.observations,
  });
}

