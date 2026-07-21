part of 'example.dart';

class CheckBusinessEmployeeAdminVariablesBuilder {
  String businessId;
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  CheckBusinessEmployeeAdminVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.employeeId,});
  Deserializer<CheckBusinessEmployeeAdminData> dataDeserializer = (dynamic json)  => CheckBusinessEmployeeAdminData.fromJson(jsonDecode(json));
  Serializer<CheckBusinessEmployeeAdminVariables> varsSerializer = (CheckBusinessEmployeeAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<CheckBusinessEmployeeAdminData, CheckBusinessEmployeeAdminVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<CheckBusinessEmployeeAdminData, CheckBusinessEmployeeAdminVariables> ref() {
    CheckBusinessEmployeeAdminVariables vars= CheckBusinessEmployeeAdminVariables(businessId: businessId,employeeId: employeeId,);
    return _dataConnect.query("CheckBusinessEmployeeAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CheckBusinessEmployeeAdminBusinessEmployees {
  final String id;
  CheckBusinessEmployeeAdminBusinessEmployees.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CheckBusinessEmployeeAdminBusinessEmployees otherTyped = other as CheckBusinessEmployeeAdminBusinessEmployees;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CheckBusinessEmployeeAdminBusinessEmployees({
    required this.id,
  });
}

@immutable
class CheckBusinessEmployeeAdminUser {
  final List<EnumValue<UserRole>> roles;
  CheckBusinessEmployeeAdminUser.fromJson(dynamic json):
  
  roles = (json['roles'] as List<dynamic>)
        .map((e) => userRoleDeserializer(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CheckBusinessEmployeeAdminUser otherTyped = other as CheckBusinessEmployeeAdminUser;
    return roles == otherTyped.roles;
    
  }
  @override
  int get hashCode => roles.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['roles'] = roles.map((e) => userRoleSerializer(e)).toList();
    return json;
  }

  CheckBusinessEmployeeAdminUser({
    required this.roles,
  });
}

@immutable
class CheckBusinessEmployeeAdminData {
  final List<CheckBusinessEmployeeAdminBusinessEmployees> businessEmployees;
  final CheckBusinessEmployeeAdminUser? user;
  CheckBusinessEmployeeAdminData.fromJson(dynamic json):
  
  businessEmployees = (json['businessEmployees'] as List<dynamic>)
        .map((e) => CheckBusinessEmployeeAdminBusinessEmployees.fromJson(e))
        .toList(),
  user = json['user'] == null ? null : CheckBusinessEmployeeAdminUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CheckBusinessEmployeeAdminData otherTyped = other as CheckBusinessEmployeeAdminData;
    return businessEmployees == otherTyped.businessEmployees && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([businessEmployees.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployees'] = businessEmployees.map((e) => e.toJson()).toList();
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  CheckBusinessEmployeeAdminData({
    required this.businessEmployees,
    this.user,
  });
}

@immutable
class CheckBusinessEmployeeAdminVariables {
  final String businessId;
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CheckBusinessEmployeeAdminVariables.fromJson(Map<String, dynamic> json):
  
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

    final CheckBusinessEmployeeAdminVariables otherTyped = other as CheckBusinessEmployeeAdminVariables;
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

  CheckBusinessEmployeeAdminVariables({
    required this.businessId,
    required this.employeeId,
  });
}

