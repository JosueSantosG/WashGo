part of 'example.dart';

class UpsertUserVariablesBuilder {
  String email;
  String nombreCompleto;
  List<UserRole> roles;
  Optional<EmployeeStatus> _employeeStatus = Optional.optional((data) => EmployeeStatus.values.byName(data), enumSerializer);
  Optional<String> _telefono = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _fotoPerfil = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertUserVariablesBuilder employeeStatus(EmployeeStatus? t) {
   _employeeStatus.value = t;
   return this;
  }
  UpsertUserVariablesBuilder telefono(String? t) {
   _telefono.value = t;
   return this;
  }
  UpsertUserVariablesBuilder fotoPerfil(String? t) {
   _fotoPerfil.value = t;
   return this;
  }

  UpsertUserVariablesBuilder(this._dataConnect, {required  this.email,required  this.nombreCompleto,required  this.roles,});
  Deserializer<UpsertUserData> dataDeserializer = (dynamic json)  => UpsertUserData.fromJson(jsonDecode(json));
  Serializer<UpsertUserVariables> varsSerializer = (UpsertUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertUserData, UpsertUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertUserData, UpsertUserVariables> ref() {
    UpsertUserVariables vars= UpsertUserVariables(email: email,nombreCompleto: nombreCompleto,roles: roles,employeeStatus: _employeeStatus,telefono: _telefono,fotoPerfil: _fotoPerfil,);
    return _dataConnect.mutation("UpsertUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertUserUserUpsert {
  final String id;
  UpsertUserUserUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserUserUpsert otherTyped = other as UpsertUserUserUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertUserUserUpsert({
    required this.id,
  });
}

@immutable
class UpsertUserData {
  final UpsertUserUserUpsert user_upsert;
  UpsertUserData.fromJson(dynamic json):
  
  user_upsert = UpsertUserUserUpsert.fromJson(json['user_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserData otherTyped = other as UpsertUserData;
    return user_upsert == otherTyped.user_upsert;
    
  }
  @override
  int get hashCode => user_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_upsert'] = user_upsert.toJson();
    return json;
  }

  UpsertUserData({
    required this.user_upsert,
  });
}

@immutable
class UpsertUserVariables {
  final String email;
  final String nombreCompleto;
  final List<UserRole> roles;
  late final Optional<EmployeeStatus>employeeStatus;
  late final Optional<String>telefono;
  late final Optional<String>fotoPerfil;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertUserVariables.fromJson(Map<String, dynamic> json):
  
  email = nativeFromJson<String>(json['email']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  roles = (json['roles'] as List<dynamic>)
        .map((e) => UserRole.values.byName(e))
        .toList() {
  
  
  
  
  
    employeeStatus = Optional.optional((data) => EmployeeStatus.values.byName(data), enumSerializer);
    employeeStatus.value = json['employeeStatus'] == null ? null : EmployeeStatus.values.byName(json['employeeStatus']);
  
  
    telefono = Optional.optional(nativeFromJson, nativeToJson);
    telefono.value = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  
  
    fotoPerfil = Optional.optional(nativeFromJson, nativeToJson);
    fotoPerfil.value = json['fotoPerfil'] == null ? null : nativeFromJson<String>(json['fotoPerfil']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserVariables otherTyped = other as UpsertUserVariables;
    return email == otherTyped.email && 
    nombreCompleto == otherTyped.nombreCompleto && 
    roles == otherTyped.roles && 
    employeeStatus == otherTyped.employeeStatus && 
    telefono == otherTyped.telefono && 
    fotoPerfil == otherTyped.fotoPerfil;
    
  }
  @override
  int get hashCode => Object.hashAll([email.hashCode, nombreCompleto.hashCode, roles.hashCode, employeeStatus.hashCode, telefono.hashCode, fotoPerfil.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = nativeToJson<String>(email);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    json['roles'] = roles.map((e) => e.name).toList();
    if(employeeStatus.state == OptionalState.set) {
      json['employeeStatus'] = employeeStatus.toJson();
    }
    if(telefono.state == OptionalState.set) {
      json['telefono'] = telefono.toJson();
    }
    if(fotoPerfil.state == OptionalState.set) {
      json['fotoPerfil'] = fotoPerfil.toJson();
    }
    return json;
  }

  UpsertUserVariables({
    required this.email,
    required this.nombreCompleto,
    required this.roles,
    required this.employeeStatus,
    required this.telefono,
    required this.fotoPerfil,
  });
}

