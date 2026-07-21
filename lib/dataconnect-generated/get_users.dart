part of 'example.dart';

class GetUsersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetUsersVariablesBuilder(this._dataConnect, );
  Deserializer<GetUsersData> dataDeserializer = (dynamic json)  => GetUsersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetUsersData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetUsersData, void> ref() {
    
    return _dataConnect.query("GetUsers", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetUsersUsers {
  final String id;
  final String nombreCompleto;
  final String email;
  final List<EnumValue<UserRole>> roles;
  GetUsersUsers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  email = nativeFromJson<String>(json['email']),
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

    final GetUsersUsers otherTyped = other as GetUsersUsers;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    email == otherTyped.email && 
    roles == otherTyped.roles;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, email.hashCode, roles.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    json['email'] = nativeToJson<String>(email);
    json['roles'] = roles.map((e) => userRoleSerializer(e)).toList();
    return json;
  }

  GetUsersUsers({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    required this.roles,
  });
}

@immutable
class GetUsersData {
  final List<GetUsersUsers> users;
  GetUsersData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => GetUsersUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUsersData otherTyped = other as GetUsersData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  GetUsersData({
    required this.users,
  });
}

