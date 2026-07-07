part of 'example.dart';

class ApproveEmployeeRequestVariablesBuilder {
  String requestId;
  String employeeId;
  String businessId;

  final FirebaseDataConnect _dataConnect;
  ApproveEmployeeRequestVariablesBuilder(this._dataConnect, {required  this.requestId,required  this.employeeId,required  this.businessId,});
  Deserializer<ApproveEmployeeRequestData> dataDeserializer = (dynamic json)  => ApproveEmployeeRequestData.fromJson(jsonDecode(json));
  Serializer<ApproveEmployeeRequestVariables> varsSerializer = (ApproveEmployeeRequestVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ApproveEmployeeRequestData, ApproveEmployeeRequestVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ApproveEmployeeRequestData, ApproveEmployeeRequestVariables> ref() {
    ApproveEmployeeRequestVariables vars= ApproveEmployeeRequestVariables(requestId: requestId,employeeId: employeeId,businessId: businessId,);
    return _dataConnect.mutation("ApproveEmployeeRequest", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ApproveEmployeeRequestEmployeeRequestUpdate {
  final String id;
  ApproveEmployeeRequestEmployeeRequestUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveEmployeeRequestEmployeeRequestUpdate otherTyped = other as ApproveEmployeeRequestEmployeeRequestUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ApproveEmployeeRequestEmployeeRequestUpdate({
    required this.id,
  });
}

@immutable
class ApproveEmployeeRequestUserUpdate {
  final String id;
  ApproveEmployeeRequestUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveEmployeeRequestUserUpdate otherTyped = other as ApproveEmployeeRequestUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ApproveEmployeeRequestUserUpdate({
    required this.id,
  });
}

@immutable
class ApproveEmployeeRequestBusinessEmployeeInsert {
  final String id;
  ApproveEmployeeRequestBusinessEmployeeInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveEmployeeRequestBusinessEmployeeInsert otherTyped = other as ApproveEmployeeRequestBusinessEmployeeInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ApproveEmployeeRequestBusinessEmployeeInsert({
    required this.id,
  });
}

@immutable
class ApproveEmployeeRequestData {
  final ApproveEmployeeRequestEmployeeRequestUpdate? employeeRequest_update;
  final ApproveEmployeeRequestUserUpdate? user_update;
  final ApproveEmployeeRequestBusinessEmployeeInsert businessEmployee_insert;
  ApproveEmployeeRequestData.fromJson(dynamic json):
  
  employeeRequest_update = json['employeeRequest_update'] == null ? null : ApproveEmployeeRequestEmployeeRequestUpdate.fromJson(json['employeeRequest_update']),
  user_update = json['user_update'] == null ? null : ApproveEmployeeRequestUserUpdate.fromJson(json['user_update']),
  businessEmployee_insert = ApproveEmployeeRequestBusinessEmployeeInsert.fromJson(json['businessEmployee_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveEmployeeRequestData otherTyped = other as ApproveEmployeeRequestData;
    return employeeRequest_update == otherTyped.employeeRequest_update && 
    user_update == otherTyped.user_update && 
    businessEmployee_insert == otherTyped.businessEmployee_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([employeeRequest_update.hashCode, user_update.hashCode, businessEmployee_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (employeeRequest_update != null) {
      json['employeeRequest_update'] = employeeRequest_update!.toJson();
    }
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    json['businessEmployee_insert'] = businessEmployee_insert.toJson();
    return json;
  }

  ApproveEmployeeRequestData({
    this.employeeRequest_update,
    this.user_update,
    required this.businessEmployee_insert,
  });
}

@immutable
class ApproveEmployeeRequestVariables {
  final String requestId;
  final String employeeId;
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ApproveEmployeeRequestVariables.fromJson(Map<String, dynamic> json):
  
  requestId = nativeFromJson<String>(json['requestId']),
  employeeId = nativeFromJson<String>(json['employeeId']),
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveEmployeeRequestVariables otherTyped = other as ApproveEmployeeRequestVariables;
    return requestId == otherTyped.requestId && 
    employeeId == otherTyped.employeeId && 
    businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => Object.hashAll([requestId.hashCode, employeeId.hashCode, businessId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['requestId'] = nativeToJson<String>(requestId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  ApproveEmployeeRequestVariables({
    required this.requestId,
    required this.employeeId,
    required this.businessId,
  });
}

