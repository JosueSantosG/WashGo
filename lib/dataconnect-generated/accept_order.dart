part of 'example.dart';

class AcceptOrderVariablesBuilder {
  String orderId;
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  AcceptOrderVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.employeeId,});
  Deserializer<AcceptOrderData> dataDeserializer = (dynamic json)  => AcceptOrderData.fromJson(jsonDecode(json));
  Serializer<AcceptOrderVariables> varsSerializer = (AcceptOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AcceptOrderData, AcceptOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AcceptOrderData, AcceptOrderVariables> ref() {
    AcceptOrderVariables vars= AcceptOrderVariables(orderId: orderId,employeeId: employeeId,);
    return _dataConnect.mutation("AcceptOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AcceptOrderOrderUpdate {
  final String id;
  AcceptOrderOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptOrderOrderUpdate otherTyped = other as AcceptOrderOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AcceptOrderOrderUpdate({
    required this.id,
  });
}

@immutable
class AcceptOrderData {
  final AcceptOrderOrderUpdate? order_update;
  AcceptOrderData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : AcceptOrderOrderUpdate.fromJson(json['order_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptOrderData otherTyped = other as AcceptOrderData;
    return order_update == otherTyped.order_update;
    
  }
  @override
  int get hashCode => order_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (order_update != null) {
      json['order_update'] = order_update!.toJson();
    }
    return json;
  }

  AcceptOrderData({
    this.order_update,
  });
}

@immutable
class AcceptOrderVariables {
  final String orderId;
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AcceptOrderVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  employeeId = nativeFromJson<String>(json['employeeId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptOrderVariables otherTyped = other as AcceptOrderVariables;
    return orderId == otherTyped.orderId && 
    employeeId == otherTyped.employeeId;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, employeeId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    return json;
  }

  AcceptOrderVariables({
    required this.orderId,
    required this.employeeId,
  });
}

