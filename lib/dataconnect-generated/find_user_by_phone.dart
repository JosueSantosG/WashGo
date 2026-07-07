part of 'example.dart';

class FindUserByPhoneVariablesBuilder {
  String phone;

  final FirebaseDataConnect _dataConnect;
  FindUserByPhoneVariablesBuilder(this._dataConnect, {required  this.phone,});
  Deserializer<FindUserByPhoneData> dataDeserializer = (dynamic json)  => FindUserByPhoneData.fromJson(jsonDecode(json));
  Serializer<FindUserByPhoneVariables> varsSerializer = (FindUserByPhoneVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<FindUserByPhoneData, FindUserByPhoneVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<FindUserByPhoneData, FindUserByPhoneVariables> ref() {
    FindUserByPhoneVariables vars= FindUserByPhoneVariables(phone: phone,);
    return _dataConnect.query("FindUserByPhone", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class FindUserByPhoneUsers {
  final String id;
  final String nombreCompleto;
  final String? telefono;
  final String email;
  FindUserByPhoneUsers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final FindUserByPhoneUsers otherTyped = other as FindUserByPhoneUsers;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    telefono == otherTyped.telefono && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, telefono.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  FindUserByPhoneUsers({
    required this.id,
    required this.nombreCompleto,
    this.telefono,
    required this.email,
  });
}

@immutable
class FindUserByPhoneData {
  final List<FindUserByPhoneUsers> users;
  FindUserByPhoneData.fromJson(dynamic json):
  
  users = (json['users'] as List<dynamic>)
        .map((e) => FindUserByPhoneUsers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final FindUserByPhoneData otherTyped = other as FindUserByPhoneData;
    return users == otherTyped.users;
    
  }
  @override
  int get hashCode => users.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  FindUserByPhoneData({
    required this.users,
  });
}

@immutable
class FindUserByPhoneVariables {
  final String phone;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  FindUserByPhoneVariables.fromJson(Map<String, dynamic> json):
  
  phone = nativeFromJson<String>(json['phone']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final FindUserByPhoneVariables otherTyped = other as FindUserByPhoneVariables;
    return phone == otherTyped.phone;
    
  }
  @override
  int get hashCode => phone.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['phone'] = nativeToJson<String>(phone);
    return json;
  }

  FindUserByPhoneVariables({
    required this.phone,
  });
}

