part of 'example.dart';

class ToggleServiceActiveVariablesBuilder {
  String id;
  bool activo;

  final FirebaseDataConnect _dataConnect;
  ToggleServiceActiveVariablesBuilder(this._dataConnect, {required  this.id,required  this.activo,});
  Deserializer<ToggleServiceActiveData> dataDeserializer = (dynamic json)  => ToggleServiceActiveData.fromJson(jsonDecode(json));
  Serializer<ToggleServiceActiveVariables> varsSerializer = (ToggleServiceActiveVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ToggleServiceActiveData, ToggleServiceActiveVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ToggleServiceActiveData, ToggleServiceActiveVariables> ref() {
    ToggleServiceActiveVariables vars= ToggleServiceActiveVariables(id: id,activo: activo,);
    return _dataConnect.mutation("ToggleServiceActive", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ToggleServiceActiveServiceUpdate {
  final String id;
  ToggleServiceActiveServiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleServiceActiveServiceUpdate otherTyped = other as ToggleServiceActiveServiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ToggleServiceActiveServiceUpdate({
    required this.id,
  });
}

@immutable
class ToggleServiceActiveData {
  final ToggleServiceActiveServiceUpdate? service_update;
  ToggleServiceActiveData.fromJson(dynamic json):
  
  service_update = json['service_update'] == null ? null : ToggleServiceActiveServiceUpdate.fromJson(json['service_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleServiceActiveData otherTyped = other as ToggleServiceActiveData;
    return service_update == otherTyped.service_update;
    
  }
  @override
  int get hashCode => service_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (service_update != null) {
      json['service_update'] = service_update!.toJson();
    }
    return json;
  }

  ToggleServiceActiveData({
    this.service_update,
  });
}

@immutable
class ToggleServiceActiveVariables {
  final String id;
  final bool activo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ToggleServiceActiveVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  activo = nativeFromJson<bool>(json['activo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleServiceActiveVariables otherTyped = other as ToggleServiceActiveVariables;
    return id == otherTyped.id && 
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, activo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['activo'] = nativeToJson<bool>(activo);
    return json;
  }

  ToggleServiceActiveVariables({
    required this.id,
    required this.activo,
  });
}

