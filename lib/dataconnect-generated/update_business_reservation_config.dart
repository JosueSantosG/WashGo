part of 'example.dart';

class UpdateBusinessReservationConfigVariablesBuilder {
  String id;
  int capacidadSimultanea;
  int tiempoAnticipacionMinutos;
  bool isConfigured;

  final FirebaseDataConnect _dataConnect;
  UpdateBusinessReservationConfigVariablesBuilder(this._dataConnect, {required  this.id,required  this.capacidadSimultanea,required  this.tiempoAnticipacionMinutos,required  this.isConfigured,});
  Deserializer<UpdateBusinessReservationConfigData> dataDeserializer = (dynamic json)  => UpdateBusinessReservationConfigData.fromJson(jsonDecode(json));
  Serializer<UpdateBusinessReservationConfigVariables> varsSerializer = (UpdateBusinessReservationConfigVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateBusinessReservationConfigData, UpdateBusinessReservationConfigVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateBusinessReservationConfigData, UpdateBusinessReservationConfigVariables> ref() {
    UpdateBusinessReservationConfigVariables vars= UpdateBusinessReservationConfigVariables(id: id,capacidadSimultanea: capacidadSimultanea,tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,isConfigured: isConfigured,);
    return _dataConnect.mutation("UpdateBusinessReservationConfig", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateBusinessReservationConfigBusinessReservationConfigUpdate {
  final String id;
  UpdateBusinessReservationConfigBusinessReservationConfigUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessReservationConfigBusinessReservationConfigUpdate otherTyped = other as UpdateBusinessReservationConfigBusinessReservationConfigUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateBusinessReservationConfigBusinessReservationConfigUpdate({
    required this.id,
  });
}

@immutable
class UpdateBusinessReservationConfigData {
  final UpdateBusinessReservationConfigBusinessReservationConfigUpdate? businessReservationConfig_update;
  UpdateBusinessReservationConfigData.fromJson(dynamic json):
  
  businessReservationConfig_update = json['businessReservationConfig_update'] == null ? null : UpdateBusinessReservationConfigBusinessReservationConfigUpdate.fromJson(json['businessReservationConfig_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessReservationConfigData otherTyped = other as UpdateBusinessReservationConfigData;
    return businessReservationConfig_update == otherTyped.businessReservationConfig_update;
    
  }
  @override
  int get hashCode => businessReservationConfig_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (businessReservationConfig_update != null) {
      json['businessReservationConfig_update'] = businessReservationConfig_update!.toJson();
    }
    return json;
  }

  UpdateBusinessReservationConfigData({
    this.businessReservationConfig_update,
  });
}

@immutable
class UpdateBusinessReservationConfigVariables {
  final String id;
  final int capacidadSimultanea;
  final int tiempoAnticipacionMinutos;
  final bool isConfigured;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateBusinessReservationConfigVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  capacidadSimultanea = nativeFromJson<int>(json['capacidadSimultanea']),
  tiempoAnticipacionMinutos = nativeFromJson<int>(json['tiempoAnticipacionMinutos']),
  isConfigured = nativeFromJson<bool>(json['isConfigured']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessReservationConfigVariables otherTyped = other as UpdateBusinessReservationConfigVariables;
    return id == otherTyped.id && 
    capacidadSimultanea == otherTyped.capacidadSimultanea && 
    tiempoAnticipacionMinutos == otherTyped.tiempoAnticipacionMinutos && 
    isConfigured == otherTyped.isConfigured;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, capacidadSimultanea.hashCode, tiempoAnticipacionMinutos.hashCode, isConfigured.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['capacidadSimultanea'] = nativeToJson<int>(capacidadSimultanea);
    json['tiempoAnticipacionMinutos'] = nativeToJson<int>(tiempoAnticipacionMinutos);
    json['isConfigured'] = nativeToJson<bool>(isConfigured);
    return json;
  }

  UpdateBusinessReservationConfigVariables({
    required this.id,
    required this.capacidadSimultanea,
    required this.tiempoAnticipacionMinutos,
    required this.isConfigured,
  });
}

