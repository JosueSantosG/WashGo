part of 'example.dart';

class DeleteCurrentUserVariablesBuilder {
  String email;
  String nombreCompleto;

  final FirebaseDataConnect _dataConnect;
  DeleteCurrentUserVariablesBuilder(this._dataConnect, {required  this.email,required  this.nombreCompleto,});
  Deserializer<DeleteCurrentUserData> dataDeserializer = (dynamic json)  => DeleteCurrentUserData.fromJson(jsonDecode(json));
  Serializer<DeleteCurrentUserVariables> varsSerializer = (DeleteCurrentUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteCurrentUserData, DeleteCurrentUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteCurrentUserData, DeleteCurrentUserVariables> ref() {
    DeleteCurrentUserVariables vars= DeleteCurrentUserVariables(email: email,nombreCompleto: nombreCompleto,);
    return _dataConnect.mutation("DeleteCurrentUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteCurrentUserUserUpdate {
  final String id;
  DeleteCurrentUserUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrentUserUserUpdate otherTyped = other as DeleteCurrentUserUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCurrentUserUserUpdate({
    required this.id,
  });
}

@immutable
class DeleteCurrentUserData {
  final DeleteCurrentUserUserUpdate? user_update;
  DeleteCurrentUserData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : DeleteCurrentUserUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrentUserData otherTyped = other as DeleteCurrentUserData;
    return user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => user_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  DeleteCurrentUserData({
    this.user_update,
  });
}

@immutable
class DeleteCurrentUserVariables {
  final String email;
  final String nombreCompleto;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteCurrentUserVariables.fromJson(Map<String, dynamic> json):
  
  email = nativeFromJson<String>(json['email']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrentUserVariables otherTyped = other as DeleteCurrentUserVariables;
    return email == otherTyped.email && 
    nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => Object.hashAll([email.hashCode, nombreCompleto.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = nativeToJson<String>(email);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  DeleteCurrentUserVariables({
    required this.email,
    required this.nombreCompleto,
  });
}

