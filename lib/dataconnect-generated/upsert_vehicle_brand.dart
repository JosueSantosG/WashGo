part of 'example.dart';

class UpsertVehicleBrandVariablesBuilder {
  String id;
  String name;

  final FirebaseDataConnect _dataConnect;
  UpsertVehicleBrandVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,});
  Deserializer<UpsertVehicleBrandData> dataDeserializer = (dynamic json)  => UpsertVehicleBrandData.fromJson(jsonDecode(json));
  Serializer<UpsertVehicleBrandVariables> varsSerializer = (UpsertVehicleBrandVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertVehicleBrandData, UpsertVehicleBrandVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertVehicleBrandData, UpsertVehicleBrandVariables> ref() {
    UpsertVehicleBrandVariables vars= UpsertVehicleBrandVariables(id: id,name: name,);
    return _dataConnect.mutation("UpsertVehicleBrand", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertVehicleBrandVehicleBrandUpsert {
  final String id;
  UpsertVehicleBrandVehicleBrandUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertVehicleBrandVehicleBrandUpsert otherTyped = other as UpsertVehicleBrandVehicleBrandUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertVehicleBrandVehicleBrandUpsert({
    required this.id,
  });
}

@immutable
class UpsertVehicleBrandData {
  final UpsertVehicleBrandVehicleBrandUpsert vehicleBrand_upsert;
  UpsertVehicleBrandData.fromJson(dynamic json):
  
  vehicleBrand_upsert = UpsertVehicleBrandVehicleBrandUpsert.fromJson(json['vehicleBrand_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertVehicleBrandData otherTyped = other as UpsertVehicleBrandData;
    return vehicleBrand_upsert == otherTyped.vehicleBrand_upsert;
    
  }
  @override
  int get hashCode => vehicleBrand_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vehicleBrand_upsert'] = vehicleBrand_upsert.toJson();
    return json;
  }

  UpsertVehicleBrandData({
    required this.vehicleBrand_upsert,
  });
}

@immutable
class UpsertVehicleBrandVariables {
  final String id;
  final String name;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertVehicleBrandVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertVehicleBrandVariables otherTyped = other as UpsertVehicleBrandVariables;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  UpsertVehicleBrandVariables({
    required this.id,
    required this.name,
  });
}

