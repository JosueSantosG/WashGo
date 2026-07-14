part of 'example.dart';

class CreateOrderLogVariablesBuilder {
  String orderId;
  String actionType;
  Optional<String> _previousValue = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _newValue = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateOrderLogVariablesBuilder previousValue(String? t) {
   _previousValue.value = t;
   return this;
  }
  CreateOrderLogVariablesBuilder newValue(String? t) {
   _newValue.value = t;
   return this;
  }

  CreateOrderLogVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.actionType,});
  Deserializer<CreateOrderLogData> dataDeserializer = (dynamic json)  => CreateOrderLogData.fromJson(jsonDecode(json));
  Serializer<CreateOrderLogVariables> varsSerializer = (CreateOrderLogVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateOrderLogData, CreateOrderLogVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateOrderLogData, CreateOrderLogVariables> ref() {
    CreateOrderLogVariables vars= CreateOrderLogVariables(orderId: orderId,actionType: actionType,previousValue: _previousValue,newValue: _newValue,);
    return _dataConnect.mutation("CreateOrderLog", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateOrderLogOrderLogInsert {
  final String id;
  CreateOrderLogOrderLogInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderLogOrderLogInsert otherTyped = other as CreateOrderLogOrderLogInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateOrderLogOrderLogInsert({
    required this.id,
  });
}

@immutable
class CreateOrderLogData {
  final CreateOrderLogOrderLogInsert orderLog_insert;
  CreateOrderLogData.fromJson(dynamic json):
  
  orderLog_insert = CreateOrderLogOrderLogInsert.fromJson(json['orderLog_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderLogData otherTyped = other as CreateOrderLogData;
    return orderLog_insert == otherTyped.orderLog_insert;
    
  }
  @override
  int get hashCode => orderLog_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderLog_insert'] = orderLog_insert.toJson();
    return json;
  }

  CreateOrderLogData({
    required this.orderLog_insert,
  });
}

@immutable
class CreateOrderLogVariables {
  final String orderId;
  final String actionType;
  late final Optional<String>previousValue;
  late final Optional<String>newValue;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateOrderLogVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  actionType = nativeFromJson<String>(json['actionType']) {
  
  
  
  
    previousValue = Optional.optional(nativeFromJson, nativeToJson);
    previousValue.value = json['previousValue'] == null ? null : nativeFromJson<String>(json['previousValue']);
  
  
    newValue = Optional.optional(nativeFromJson, nativeToJson);
    newValue.value = json['newValue'] == null ? null : nativeFromJson<String>(json['newValue']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderLogVariables otherTyped = other as CreateOrderLogVariables;
    return orderId == otherTyped.orderId && 
    actionType == otherTyped.actionType && 
    previousValue == otherTyped.previousValue && 
    newValue == otherTyped.newValue;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, actionType.hashCode, previousValue.hashCode, newValue.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['actionType'] = nativeToJson<String>(actionType);
    if(previousValue.state == OptionalState.set) {
      json['previousValue'] = previousValue.toJson();
    }
    if(newValue.state == OptionalState.set) {
      json['newValue'] = newValue.toJson();
    }
    return json;
  }

  CreateOrderLogVariables({
    required this.orderId,
    required this.actionType,
    required this.previousValue,
    required this.newValue,
  });
}

