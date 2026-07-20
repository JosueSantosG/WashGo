part of 'example.dart';

class GetVehicleModelsByBrandVariablesBuilder {
  String brandId;

  final FirebaseDataConnect _dataConnect;
  GetVehicleModelsByBrandVariablesBuilder(this._dataConnect, {required  this.brandId,});
  Deserializer<GetVehicleModelsByBrandData> dataDeserializer = (dynamic json)  => GetVehicleModelsByBrandData.fromJson(jsonDecode(json));
  Serializer<GetVehicleModelsByBrandVariables> varsSerializer = (GetVehicleModelsByBrandVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetVehicleModelsByBrandData, GetVehicleModelsByBrandVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetVehicleModelsByBrandData, GetVehicleModelsByBrandVariables> ref() {
    GetVehicleModelsByBrandVariables vars= GetVehicleModelsByBrandVariables(brandId: brandId,);
    return _dataConnect.query("GetVehicleModelsByBrand", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetVehicleModelsByBrandVehicleModels {
  final String id;
  final String name;
  final String category;
  GetVehicleModelsByBrandVehicleModels.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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

    final GetVehicleModelsByBrandVehicleModels otherTyped = other as GetVehicleModelsByBrandVehicleModels;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, category.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['category'] = nativeToJson<String>(category);
    return json;
  }

  GetVehicleModelsByBrandVehicleModels({
    required this.id,
    required this.name,
    required this.category,
  });
}

@immutable
class GetVehicleModelsByBrandData {
  final List<GetVehicleModelsByBrandVehicleModels> vehicleModels;
  GetVehicleModelsByBrandData.fromJson(dynamic json):
  
  vehicleModels = (json['vehicleModels'] as List<dynamic>)
        .map((e) => GetVehicleModelsByBrandVehicleModels.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetVehicleModelsByBrandData otherTyped = other as GetVehicleModelsByBrandData;
    return vehicleModels == otherTyped.vehicleModels;
    
  }
  @override
  int get hashCode => vehicleModels.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vehicleModels'] = vehicleModels.map((e) => e.toJson()).toList();
    return json;
  }

  GetVehicleModelsByBrandData({
    required this.vehicleModels,
  });
}

@immutable
class GetVehicleModelsByBrandVariables {
  final String brandId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetVehicleModelsByBrandVariables.fromJson(Map<String, dynamic> json):
  
  brandId = nativeFromJson<String>(json['brandId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetVehicleModelsByBrandVariables otherTyped = other as GetVehicleModelsByBrandVariables;
    return brandId == otherTyped.brandId;
    
  }
  @override
  int get hashCode => brandId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['brandId'] = nativeToJson<String>(brandId);
    return json;
  }

  GetVehicleModelsByBrandVariables({
    required this.brandId,
  });
}

