part of 'example.dart';

class UpdateEmployeeAvailabilityVariablesBuilder {
  String id;
  bool estadoDisponibilidad;

  final FirebaseDataConnect _dataConnect;
  UpdateEmployeeAvailabilityVariablesBuilder(this._dataConnect, {required  this.id,required  this.estadoDisponibilidad,});
  Deserializer<UpdateEmployeeAvailabilityData> dataDeserializer = (dynamic json)  => UpdateEmployeeAvailabilityData.fromJson(jsonDecode(json));
  Serializer<UpdateEmployeeAvailabilityVariables> varsSerializer = (UpdateEmployeeAvailabilityVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateEmployeeAvailabilityData, UpdateEmployeeAvailabilityVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateEmployeeAvailabilityData, UpdateEmployeeAvailabilityVariables> ref() {
    UpdateEmployeeAvailabilityVariables vars= UpdateEmployeeAvailabilityVariables(id: id,estadoDisponibilidad: estadoDisponibilidad,);
    return _dataConnect.mutation("UpdateEmployeeAvailability", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateEmployeeAvailabilityBusinessEmployeeUpdate {
  final String id;
  UpdateEmployeeAvailabilityBusinessEmployeeUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateEmployeeAvailabilityBusinessEmployeeUpdate otherTyped = other as UpdateEmployeeAvailabilityBusinessEmployeeUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateEmployeeAvailabilityBusinessEmployeeUpdate({
    required this.id,
  });
}

@immutable
class UpdateEmployeeAvailabilityData {
  final UpdateEmployeeAvailabilityBusinessEmployeeUpdate? businessEmployee_update;
  UpdateEmployeeAvailabilityData.fromJson(dynamic json):
  
  businessEmployee_update = json['businessEmployee_update'] == null ? null : UpdateEmployeeAvailabilityBusinessEmployeeUpdate.fromJson(json['businessEmployee_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateEmployeeAvailabilityData otherTyped = other as UpdateEmployeeAvailabilityData;
    return businessEmployee_update == otherTyped.businessEmployee_update;
    
  }
  @override
  int get hashCode => businessEmployee_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (businessEmployee_update != null) {
      json['businessEmployee_update'] = businessEmployee_update!.toJson();
    }
    return json;
  }

  UpdateEmployeeAvailabilityData({
    this.businessEmployee_update,
  });
}

@immutable
class UpdateEmployeeAvailabilityVariables {
  final String id;
  final bool estadoDisponibilidad;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateEmployeeAvailabilityVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  estadoDisponibilidad = nativeFromJson<bool>(json['estadoDisponibilidad']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateEmployeeAvailabilityVariables otherTyped = other as UpdateEmployeeAvailabilityVariables;
    return id == otherTyped.id && 
    estadoDisponibilidad == otherTyped.estadoDisponibilidad;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, estadoDisponibilidad.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['estadoDisponibilidad'] = nativeToJson<bool>(estadoDisponibilidad);
    return json;
  }

  UpdateEmployeeAvailabilityVariables({
    required this.id,
    required this.estadoDisponibilidad,
  });
}

