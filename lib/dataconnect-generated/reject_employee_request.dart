part of 'example.dart';

class RejectEmployeeRequestVariablesBuilder {
  String requestId;
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  RejectEmployeeRequestVariablesBuilder(this._dataConnect, {required  this.requestId,required  this.employeeId,});
  Deserializer<RejectEmployeeRequestData> dataDeserializer = (dynamic json)  => RejectEmployeeRequestData.fromJson(jsonDecode(json));
  Serializer<RejectEmployeeRequestVariables> varsSerializer = (RejectEmployeeRequestVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RejectEmployeeRequestData, RejectEmployeeRequestVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RejectEmployeeRequestData, RejectEmployeeRequestVariables> ref() {
    RejectEmployeeRequestVariables vars= RejectEmployeeRequestVariables(requestId: requestId,employeeId: employeeId,);
    return _dataConnect.mutation("RejectEmployeeRequest", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RejectEmployeeRequestEmployeeRequestUpdate {
  final String id;
  RejectEmployeeRequestEmployeeRequestUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RejectEmployeeRequestEmployeeRequestUpdate otherTyped = other as RejectEmployeeRequestEmployeeRequestUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RejectEmployeeRequestEmployeeRequestUpdate({
    required this.id,
  });
}

@immutable
class RejectEmployeeRequestUserUpdate {
  final String id;
  RejectEmployeeRequestUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RejectEmployeeRequestUserUpdate otherTyped = other as RejectEmployeeRequestUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RejectEmployeeRequestUserUpdate({
    required this.id,
  });
}

@immutable
class RejectEmployeeRequestData {
  final RejectEmployeeRequestEmployeeRequestUpdate? employeeRequest_update;
  final RejectEmployeeRequestUserUpdate? user_update;
  RejectEmployeeRequestData.fromJson(dynamic json):
  
  employeeRequest_update = json['employeeRequest_update'] == null ? null : RejectEmployeeRequestEmployeeRequestUpdate.fromJson(json['employeeRequest_update']),
  user_update = json['user_update'] == null ? null : RejectEmployeeRequestUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RejectEmployeeRequestData otherTyped = other as RejectEmployeeRequestData;
    return employeeRequest_update == otherTyped.employeeRequest_update && 
    user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => Object.hashAll([employeeRequest_update.hashCode, user_update.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (employeeRequest_update != null) {
      json['employeeRequest_update'] = employeeRequest_update!.toJson();
    }
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  RejectEmployeeRequestData({
    this.employeeRequest_update,
    this.user_update,
  });
}

@immutable
class RejectEmployeeRequestVariables {
  final String requestId;
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RejectEmployeeRequestVariables.fromJson(Map<String, dynamic> json):
  
  requestId = nativeFromJson<String>(json['requestId']),
  employeeId = nativeFromJson<String>(json['employeeId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RejectEmployeeRequestVariables otherTyped = other as RejectEmployeeRequestVariables;
    return requestId == otherTyped.requestId && 
    employeeId == otherTyped.employeeId;
    
  }
  @override
  int get hashCode => Object.hashAll([requestId.hashCode, employeeId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['requestId'] = nativeToJson<String>(requestId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    return json;
  }

  RejectEmployeeRequestVariables({
    required this.requestId,
    required this.employeeId,
  });
}

