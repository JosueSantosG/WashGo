part of 'example.dart';

class CreateWalkInOrderVariablesBuilder {
  String businessId;
  String clientId;
  double price;
  double costo;
  String serviceName;
  OrderType type;
  PaymentMethod paymentMethod;
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateWalkInOrderVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  CreateWalkInOrderVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.clientId,required  this.price,required  this.costo,required  this.serviceName,required  this.type,required  this.paymentMethod,});
  Deserializer<CreateWalkInOrderData> dataDeserializer = (dynamic json)  => CreateWalkInOrderData.fromJson(jsonDecode(json));
  Serializer<CreateWalkInOrderVariables> varsSerializer = (CreateWalkInOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateWalkInOrderData, CreateWalkInOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateWalkInOrderData, CreateWalkInOrderVariables> ref() {
    CreateWalkInOrderVariables vars= CreateWalkInOrderVariables(businessId: businessId,clientId: clientId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,observations: _observations,);
    return _dataConnect.mutation("CreateWalkInOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateWalkInOrderOrderInsert {
  final String id;
  CreateWalkInOrderOrderInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWalkInOrderOrderInsert otherTyped = other as CreateWalkInOrderOrderInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateWalkInOrderOrderInsert({
    required this.id,
  });
}

@immutable
class CreateWalkInOrderData {
  final CreateWalkInOrderOrderInsert order_insert;
  CreateWalkInOrderData.fromJson(dynamic json):
  
  order_insert = CreateWalkInOrderOrderInsert.fromJson(json['order_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWalkInOrderData otherTyped = other as CreateWalkInOrderData;
    return order_insert == otherTyped.order_insert;
    
  }
  @override
  int get hashCode => order_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['order_insert'] = order_insert.toJson();
    return json;
  }

  CreateWalkInOrderData({
    required this.order_insert,
  });
}

@immutable
class CreateWalkInOrderVariables {
  final String businessId;
  final String clientId;
  final double price;
  final double costo;
  final String serviceName;
  final OrderType type;
  final PaymentMethod paymentMethod;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateWalkInOrderVariables.fromJson(Map<String, dynamic> json):
  
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

    final CreateWalkInOrderVariables otherTyped = other as CreateWalkInOrderVariables;
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

  CreateWalkInOrderVariables({
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

