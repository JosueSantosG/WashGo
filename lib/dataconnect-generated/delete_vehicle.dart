part of 'example.dart';

class DeleteVehicleVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteVehicleVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteVehicleData> dataDeserializer = (dynamic json)  => DeleteVehicleData.fromJson(jsonDecode(json));
  Serializer<DeleteVehicleVariables> varsSerializer = (DeleteVehicleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteVehicleData, DeleteVehicleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteVehicleData, DeleteVehicleVariables> ref() {
    DeleteVehicleVariables vars= DeleteVehicleVariables(id: id,);
    return _dataConnect.mutation("DeleteVehicle", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteVehicleVehicleDelete {
  final String id;
  DeleteVehicleVehicleDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteVehicleVehicleDelete otherTyped = other as DeleteVehicleVehicleDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteVehicleVehicleDelete({
    required this.id,
  });
}

@immutable
class DeleteVehicleData {
  final DeleteVehicleVehicleDelete? vehicle_delete;
  DeleteVehicleData.fromJson(dynamic json):
  
  vehicle_delete = json['vehicle_delete'] == null ? null : DeleteVehicleVehicleDelete.fromJson(json['vehicle_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteVehicleData otherTyped = other as DeleteVehicleData;
    return vehicle_delete == otherTyped.vehicle_delete;
    
  }
  @override
  int get hashCode => vehicle_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (vehicle_delete != null) {
      json['vehicle_delete'] = vehicle_delete!.toJson();
    }
    return json;
  }

  DeleteVehicleData({
    this.vehicle_delete,
  });
}

@immutable
class DeleteVehicleVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteVehicleVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteVehicleVariables otherTyped = other as DeleteVehicleVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteVehicleVariables({
    required this.id,
  });
}

