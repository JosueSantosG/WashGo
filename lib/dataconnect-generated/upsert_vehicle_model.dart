part of 'example.dart';

class UpsertVehicleModelVariablesBuilder {
  String id;
  String brandId;
  String name;
  String category;

  final FirebaseDataConnect _dataConnect;
  UpsertVehicleModelVariablesBuilder(this._dataConnect, {required  this.id,required  this.brandId,required  this.name,required  this.category,});
  Deserializer<UpsertVehicleModelData> dataDeserializer = (dynamic json)  => UpsertVehicleModelData.fromJson(jsonDecode(json));
  Serializer<UpsertVehicleModelVariables> varsSerializer = (UpsertVehicleModelVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertVehicleModelData, UpsertVehicleModelVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertVehicleModelData, UpsertVehicleModelVariables> ref() {
    UpsertVehicleModelVariables vars= UpsertVehicleModelVariables(id: id,brandId: brandId,name: name,category: category,);
    return _dataConnect.mutation("UpsertVehicleModel", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertVehicleModelVehicleModelUpsert {
  final String id;
  UpsertVehicleModelVehicleModelUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertVehicleModelVehicleModelUpsert otherTyped = other as UpsertVehicleModelVehicleModelUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertVehicleModelVehicleModelUpsert({
    required this.id,
  });
}

@immutable
class UpsertVehicleModelData {
  final UpsertVehicleModelVehicleModelUpsert vehicleModel_upsert;
  UpsertVehicleModelData.fromJson(dynamic json):
  
  vehicleModel_upsert = UpsertVehicleModelVehicleModelUpsert.fromJson(json['vehicleModel_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertVehicleModelData otherTyped = other as UpsertVehicleModelData;
    return vehicleModel_upsert == otherTyped.vehicleModel_upsert;
    
  }
  @override
  int get hashCode => vehicleModel_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vehicleModel_upsert'] = vehicleModel_upsert.toJson();
    return json;
  }

  UpsertVehicleModelData({
    required this.vehicleModel_upsert,
  });
}

@immutable
class UpsertVehicleModelVariables {
  final String id;
  final String brandId;
  final String name;
  final String category;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertVehicleModelVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  brandId = nativeFromJson<String>(json['brandId']),
  name = nativeFromJson<String>(json['name']),
  category = nativeFromJson<String>(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertVehicleModelVariables otherTyped = other as UpsertVehicleModelVariables;
    return id == otherTyped.id && 
    brandId == otherTyped.brandId && 
    name == otherTyped.name && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, brandId.hashCode, name.hashCode, category.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['brandId'] = nativeToJson<String>(brandId);
    json['name'] = nativeToJson<String>(name);
    json['category'] = nativeToJson<String>(category);
    return json;
  }

  UpsertVehicleModelVariables({
    required this.id,
    required this.brandId,
    required this.name,
    required this.category,
  });
}

