part of 'example.dart';

class GetPendingEmployeeRequestsVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetPendingEmployeeRequestsVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetPendingEmployeeRequestsData> dataDeserializer = (dynamic json)  => GetPendingEmployeeRequestsData.fromJson(jsonDecode(json));
  Serializer<GetPendingEmployeeRequestsVariables> varsSerializer = (GetPendingEmployeeRequestsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPendingEmployeeRequestsData, GetPendingEmployeeRequestsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPendingEmployeeRequestsData, GetPendingEmployeeRequestsVariables> ref() {
    GetPendingEmployeeRequestsVariables vars= GetPendingEmployeeRequestsVariables(businessId: businessId,);
    return _dataConnect.query("GetPendingEmployeeRequests", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPendingEmployeeRequestsEmployeeRequests {
  final String id;
  final GetPendingEmployeeRequestsEmployeeRequestsUser user;
  final Timestamp createdAt;
  GetPendingEmployeeRequestsEmployeeRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  user = GetPendingEmployeeRequestsEmployeeRequestsUser.fromJson(json['user']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingEmployeeRequestsEmployeeRequests otherTyped = other as GetPendingEmployeeRequestsEmployeeRequests;
    return id == otherTyped.id && 
    user == otherTyped.user && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, user.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['user'] = user.toJson();
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetPendingEmployeeRequestsEmployeeRequests({
    required this.id,
    required this.user,
    required this.createdAt,
  });
}

@immutable
class GetPendingEmployeeRequestsEmployeeRequestsUser {
  final String id;
  final String nombreCompleto;
  final String email;
  GetPendingEmployeeRequestsEmployeeRequestsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingEmployeeRequestsEmployeeRequestsUser otherTyped = other as GetPendingEmployeeRequestsEmployeeRequestsUser;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  GetPendingEmployeeRequestsEmployeeRequestsUser({
    required this.id,
    required this.nombreCompleto,
    required this.email,
  });
}

@immutable
class GetPendingEmployeeRequestsData {
  final List<GetPendingEmployeeRequestsEmployeeRequests> employeeRequests;
  GetPendingEmployeeRequestsData.fromJson(dynamic json):
  
  employeeRequests = (json['employeeRequests'] as List<dynamic>)
        .map((e) => GetPendingEmployeeRequestsEmployeeRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingEmployeeRequestsData otherTyped = other as GetPendingEmployeeRequestsData;
    return employeeRequests == otherTyped.employeeRequests;
    
  }
  @override
  int get hashCode => employeeRequests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['employeeRequests'] = employeeRequests.map((e) => e.toJson()).toList();
    return json;
  }

  GetPendingEmployeeRequestsData({
    required this.employeeRequests,
  });
}

@immutable
class GetPendingEmployeeRequestsVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPendingEmployeeRequestsVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingEmployeeRequestsVariables otherTyped = other as GetPendingEmployeeRequestsVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetPendingEmployeeRequestsVariables({
    required this.businessId,
  });
}

