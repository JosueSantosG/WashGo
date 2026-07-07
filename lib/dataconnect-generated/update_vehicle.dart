part of 'example.dart';

class UpdateVehicleVariablesBuilder {
  String id;
  String modelId;
  Optional<String> _plate = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateVehicleVariablesBuilder plate(String? t) {
   _plate.value = t;
   return this;
  }

  UpdateVehicleVariablesBuilder(this._dataConnect, {required  this.id,required  this.modelId,});
  Deserializer<UpdateVehicleData> dataDeserializer = (dynamic json)  => UpdateVehicleData.fromJson(jsonDecode(json));
  Serializer<UpdateVehicleVariables> varsSerializer = (UpdateVehicleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateVehicleData, UpdateVehicleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateVehicleData, UpdateVehicleVariables> ref() {
    UpdateVehicleVariables vars= UpdateVehicleVariables(id: id,modelId: modelId,plate: _plate,);
    return _dataConnect.mutation("UpdateVehicle", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateVehicleVehicleUpdate {
  final String id;
  UpdateVehicleVehicleUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVehicleVehicleUpdate otherTyped = other as UpdateVehicleVehicleUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateVehicleVehicleUpdate({
    required this.id,
  });
}

@immutable
class UpdateVehicleData {
  final UpdateVehicleVehicleUpdate? vehicle_update;
  UpdateVehicleData.fromJson(dynamic json):
  
  vehicle_update = json['vehicle_update'] == null ? null : UpdateVehicleVehicleUpdate.fromJson(json['vehicle_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVehicleData otherTyped = other as UpdateVehicleData;
    return vehicle_update == otherTyped.vehicle_update;
    
  }
  @override
  int get hashCode => vehicle_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (vehicle_update != null) {
      json['vehicle_update'] = vehicle_update!.toJson();
    }
    return json;
  }

  UpdateVehicleData({
    this.vehicle_update,
  });
}

@immutable
class UpdateVehicleVariables {
  final String id;
  final String modelId;
  late final Optional<String>plate;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateVehicleVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  modelId = nativeFromJson<String>(json['modelId']) {
  
  
  
  
    plate = Optional.optional(nativeFromJson, nativeToJson);
    plate.value = json['plate'] == null ? null : nativeFromJson<String>(json['plate']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateVehicleVariables otherTyped = other as UpdateVehicleVariables;
    return id == otherTyped.id && 
    modelId == otherTyped.modelId && 
    plate == otherTyped.plate;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, modelId.hashCode, plate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['modelId'] = nativeToJson<String>(modelId);
    if(plate.state == OptionalState.set) {
      json['plate'] = plate.toJson();
    }
    return json;
  }

  UpdateVehicleVariables({
    required this.id,
    required this.modelId,
    required this.plate,
  });
}

