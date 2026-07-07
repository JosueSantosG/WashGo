part of 'example.dart';

class UpdateUserPhoneVariablesBuilder {
  String telefono;

  final FirebaseDataConnect _dataConnect;
  UpdateUserPhoneVariablesBuilder(this._dataConnect, {required  this.telefono,});
  Deserializer<UpdateUserPhoneData> dataDeserializer = (dynamic json)  => UpdateUserPhoneData.fromJson(jsonDecode(json));
  Serializer<UpdateUserPhoneVariables> varsSerializer = (UpdateUserPhoneVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserPhoneData, UpdateUserPhoneVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserPhoneData, UpdateUserPhoneVariables> ref() {
    UpdateUserPhoneVariables vars= UpdateUserPhoneVariables(telefono: telefono,);
    return _dataConnect.mutation("UpdateUserPhone", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateUserPhoneUserUpdate {
  final String id;
  UpdateUserPhoneUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserPhoneUserUpdate otherTyped = other as UpdateUserPhoneUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateUserPhoneUserUpdate({
    required this.id,
  });
}

@immutable
class UpdateUserPhoneData {
  final UpdateUserPhoneUserUpdate? user_update;
  UpdateUserPhoneData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : UpdateUserPhoneUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserPhoneData otherTyped = other as UpdateUserPhoneData;
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

  UpdateUserPhoneData({
    this.user_update,
  });
}

@immutable
class UpdateUserPhoneVariables {
  final String telefono;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateUserPhoneVariables.fromJson(Map<String, dynamic> json):
  
  telefono = nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserPhoneVariables otherTyped = other as UpdateUserPhoneVariables;
    return telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => telefono.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['telefono'] = nativeToJson<String>(telefono);
    return json;
  }

  UpdateUserPhoneVariables({
    required this.telefono,
  });
}

