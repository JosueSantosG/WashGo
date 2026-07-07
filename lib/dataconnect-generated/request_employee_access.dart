part of 'example.dart';

class RequestEmployeeAccessVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  RequestEmployeeAccessVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<RequestEmployeeAccessData> dataDeserializer = (dynamic json)  => RequestEmployeeAccessData.fromJson(jsonDecode(json));
  Serializer<RequestEmployeeAccessVariables> varsSerializer = (RequestEmployeeAccessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RequestEmployeeAccessData, RequestEmployeeAccessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RequestEmployeeAccessData, RequestEmployeeAccessVariables> ref() {
    RequestEmployeeAccessVariables vars= RequestEmployeeAccessVariables(businessId: businessId,);
    return _dataConnect.mutation("RequestEmployeeAccess", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RequestEmployeeAccessUserUpdate {
  final String id;
  RequestEmployeeAccessUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RequestEmployeeAccessUserUpdate otherTyped = other as RequestEmployeeAccessUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RequestEmployeeAccessUserUpdate({
    required this.id,
  });
}

@immutable
class RequestEmployeeAccessEmployeeRequestInsert {
  final String id;
  RequestEmployeeAccessEmployeeRequestInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RequestEmployeeAccessEmployeeRequestInsert otherTyped = other as RequestEmployeeAccessEmployeeRequestInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RequestEmployeeAccessEmployeeRequestInsert({
    required this.id,
  });
}

@immutable
class RequestEmployeeAccessData {
  final RequestEmployeeAccessUserUpdate? user_update;
  final RequestEmployeeAccessEmployeeRequestInsert employeeRequest_insert;
  RequestEmployeeAccessData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : RequestEmployeeAccessUserUpdate.fromJson(json['user_update']),
  employeeRequest_insert = RequestEmployeeAccessEmployeeRequestInsert.fromJson(json['employeeRequest_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RequestEmployeeAccessData otherTyped = other as RequestEmployeeAccessData;
    return user_update == otherTyped.user_update && 
    employeeRequest_insert == otherTyped.employeeRequest_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([user_update.hashCode, employeeRequest_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    json['employeeRequest_insert'] = employeeRequest_insert.toJson();
    return json;
  }

  RequestEmployeeAccessData({
    this.user_update,
    required this.employeeRequest_insert,
  });
}

@immutable
class RequestEmployeeAccessVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RequestEmployeeAccessVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RequestEmployeeAccessVariables otherTyped = other as RequestEmployeeAccessVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  RequestEmployeeAccessVariables({
    required this.businessId,
  });
}

