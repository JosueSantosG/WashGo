part of 'example.dart';

class CreateWalkInUserVariablesBuilder {
  String id;
  String nombreCompleto;
  String telefono;
  String email;

  final FirebaseDataConnect _dataConnect;
  CreateWalkInUserVariablesBuilder(this._dataConnect, {required  this.id,required  this.nombreCompleto,required  this.telefono,required  this.email,});
  Deserializer<CreateWalkInUserData> dataDeserializer = (dynamic json)  => CreateWalkInUserData.fromJson(jsonDecode(json));
  Serializer<CreateWalkInUserVariables> varsSerializer = (CreateWalkInUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateWalkInUserData, CreateWalkInUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateWalkInUserData, CreateWalkInUserVariables> ref() {
    CreateWalkInUserVariables vars= CreateWalkInUserVariables(id: id,nombreCompleto: nombreCompleto,telefono: telefono,email: email,);
    return _dataConnect.mutation("CreateWalkInUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateWalkInUserUserInsert {
  final String id;
  CreateWalkInUserUserInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWalkInUserUserInsert otherTyped = other as CreateWalkInUserUserInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateWalkInUserUserInsert({
    required this.id,
  });
}

@immutable
class CreateWalkInUserData {
  final CreateWalkInUserUserInsert user_insert;
  CreateWalkInUserData.fromJson(dynamic json):
  
  user_insert = CreateWalkInUserUserInsert.fromJson(json['user_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWalkInUserData otherTyped = other as CreateWalkInUserData;
    return user_insert == otherTyped.user_insert;
    
  }
  @override
  int get hashCode => user_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_insert'] = user_insert.toJson();
    return json;
  }

  CreateWalkInUserData({
    required this.user_insert,
  });
}

@immutable
class CreateWalkInUserVariables {
  final String id;
  final String nombreCompleto;
  final String telefono;
  final String email;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateWalkInUserVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  telefono = nativeFromJson<String>(json['telefono']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWalkInUserVariables otherTyped = other as CreateWalkInUserVariables;
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
    json['telefono'] = nativeToJson<String>(telefono);
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  CreateWalkInUserVariables({
    required this.id,
    required this.nombreCompleto,
    required this.telefono,
    required this.email,
  });
}

