part of 'example.dart';

class AddVehicleVariablesBuilder {
  String modelId;
  Optional<String> _plate = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  AddVehicleVariablesBuilder plate(String? t) {
   _plate.value = t;
   return this;
  }

  AddVehicleVariablesBuilder(this._dataConnect, {required  this.modelId,});
  Deserializer<AddVehicleData> dataDeserializer = (dynamic json)  => AddVehicleData.fromJson(jsonDecode(json));
  Serializer<AddVehicleVariables> varsSerializer = (AddVehicleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddVehicleData, AddVehicleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddVehicleData, AddVehicleVariables> ref() {
    AddVehicleVariables vars= AddVehicleVariables(modelId: modelId,plate: _plate,);
    return _dataConnect.mutation("AddVehicle", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddVehicleVehicleInsert {
  final String id;
  AddVehicleVehicleInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddVehicleVehicleInsert otherTyped = other as AddVehicleVehicleInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddVehicleVehicleInsert({
    required this.id,
  });
}

@immutable
class AddVehicleData {
  final AddVehicleVehicleInsert vehicle_insert;
  AddVehicleData.fromJson(dynamic json):
  
  vehicle_insert = AddVehicleVehicleInsert.fromJson(json['vehicle_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddVehicleData otherTyped = other as AddVehicleData;
    return vehicle_insert == otherTyped.vehicle_insert;
    
  }
  @override
  int get hashCode => vehicle_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vehicle_insert'] = vehicle_insert.toJson();
    return json;
  }

  AddVehicleData({
    required this.vehicle_insert,
  });
}

@immutable
class AddVehicleVariables {
  final String modelId;
  late final Optional<String>plate;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddVehicleVariables.fromJson(Map<String, dynamic> json):
  
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

    final AddVehicleVariables otherTyped = other as AddVehicleVariables;
    return modelId == otherTyped.modelId && 
    plate == otherTyped.plate;
    
  }
  @override
  int get hashCode => Object.hashAll([modelId.hashCode, plate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['modelId'] = nativeToJson<String>(modelId);
    if(plate.state == OptionalState.set) {
      json['plate'] = plate.toJson();
    }
    return json;
  }

  AddVehicleVariables({
    required this.modelId,
    required this.plate,
  });
}

