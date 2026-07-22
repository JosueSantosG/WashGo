part of 'example.dart';

class ActivateEmployeeShiftVariablesBuilder {
  String businessId;
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  ActivateEmployeeShiftVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.employeeId,});
  Deserializer<ActivateEmployeeShiftData> dataDeserializer = (dynamic json)  => ActivateEmployeeShiftData.fromJson(jsonDecode(json));
  Serializer<ActivateEmployeeShiftVariables> varsSerializer = (ActivateEmployeeShiftVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ActivateEmployeeShiftData, ActivateEmployeeShiftVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ActivateEmployeeShiftData, ActivateEmployeeShiftVariables> ref() {
    ActivateEmployeeShiftVariables vars= ActivateEmployeeShiftVariables(businessId: businessId,employeeId: employeeId,);
    return _dataConnect.mutation("ActivateEmployeeShift", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ActivateEmployeeShiftUserUpdate {
  final String id;
  ActivateEmployeeShiftUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActivateEmployeeShiftUserUpdate otherTyped = other as ActivateEmployeeShiftUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ActivateEmployeeShiftUserUpdate({
    required this.id,
  });
}

@immutable
class ActivateEmployeeShiftData {
  final int businessEmployee_updateMany;
  final ActivateEmployeeShiftUserUpdate? user_update;
  ActivateEmployeeShiftData.fromJson(dynamic json):
  
  businessEmployee_updateMany = nativeFromJson<int>(json['businessEmployee_updateMany']),
  user_update = json['user_update'] == null ? null : ActivateEmployeeShiftUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActivateEmployeeShiftData otherTyped = other as ActivateEmployeeShiftData;
    return businessEmployee_updateMany == otherTyped.businessEmployee_updateMany && 
    user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => Object.hashAll([businessEmployee_updateMany.hashCode, user_update.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployee_updateMany'] = nativeToJson<int>(businessEmployee_updateMany);
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  ActivateEmployeeShiftData({
    required this.businessEmployee_updateMany,
    this.user_update,
  });
}

@immutable
class ActivateEmployeeShiftVariables {
  final String businessId;
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ActivateEmployeeShiftVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  employeeId = nativeFromJson<String>(json['employeeId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActivateEmployeeShiftVariables otherTyped = other as ActivateEmployeeShiftVariables;
    return businessId == otherTyped.businessId && 
    employeeId == otherTyped.employeeId;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, employeeId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    return json;
  }

  ActivateEmployeeShiftVariables({
    required this.businessId,
    required this.employeeId,
  });
}

