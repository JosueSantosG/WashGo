part of 'example.dart';

class RescheduleOrderVariablesBuilder {
  String orderId;
  String observations;

  final FirebaseDataConnect _dataConnect;
  RescheduleOrderVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.observations,});
  Deserializer<RescheduleOrderData> dataDeserializer = (dynamic json)  => RescheduleOrderData.fromJson(jsonDecode(json));
  Serializer<RescheduleOrderVariables> varsSerializer = (RescheduleOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RescheduleOrderData, RescheduleOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RescheduleOrderData, RescheduleOrderVariables> ref() {
    RescheduleOrderVariables vars= RescheduleOrderVariables(orderId: orderId,observations: observations,);
    return _dataConnect.mutation("RescheduleOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RescheduleOrderOrderUpdate {
  final String id;
  RescheduleOrderOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RescheduleOrderOrderUpdate otherTyped = other as RescheduleOrderOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RescheduleOrderOrderUpdate({
    required this.id,
  });
}

@immutable
class RescheduleOrderData {
  final RescheduleOrderOrderUpdate? order_update;
  RescheduleOrderData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : RescheduleOrderOrderUpdate.fromJson(json['order_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RescheduleOrderData otherTyped = other as RescheduleOrderData;
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

  RescheduleOrderData({
    this.order_update,
  });
}

@immutable
class RescheduleOrderVariables {
  final String orderId;
  final String observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RescheduleOrderVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  observations = nativeFromJson<String>(json['observations']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RescheduleOrderVariables otherTyped = other as RescheduleOrderVariables;
    return orderId == otherTyped.orderId && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, observations.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['observations'] = nativeToJson<String>(observations);
    return json;
  }

  RescheduleOrderVariables({
    required this.orderId,
    required this.observations,
  });
}

