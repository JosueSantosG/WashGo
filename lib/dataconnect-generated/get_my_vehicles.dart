part of 'example.dart';

class GetMyVehiclesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyVehiclesVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyVehiclesData> dataDeserializer = (dynamic json)  => GetMyVehiclesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyVehiclesData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetMyVehiclesData, void> ref() {
    
    return _dataConnect.query("GetMyVehicles", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyVehiclesVehicles {
  final String id;
  final String? plate;
  final String? category;
  final GetMyVehiclesVehiclesModel model;
  GetMyVehiclesVehicles.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  plate = json['plate'] == null ? null : nativeFromJson<String>(json['plate']),
  category = json['category'] == null ? null : nativeFromJson<String>(json['category']),
  model = GetMyVehiclesVehiclesModel.fromJson(json['model']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyVehiclesVehicles otherTyped = other as GetMyVehiclesVehicles;
    return id == otherTyped.id && 
    plate == otherTyped.plate && 
    category == otherTyped.category && 
    model == otherTyped.model;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, plate.hashCode, category.hashCode, model.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (plate != null) {
      json['plate'] = nativeToJson<String?>(plate);
    }
    if (category != null) {
      json['category'] = nativeToJson<String?>(category);
    }
    json['model'] = model.toJson();
    return json;
  }

  GetMyVehiclesVehicles({
    required this.id,
    this.plate,
    this.category,
    required this.model,
  });
}

@immutable
class GetMyVehiclesVehiclesModel {
  final String id;
  final String name;
  final String category;
  final GetMyVehiclesVehiclesModelBrand brand;
  GetMyVehiclesVehiclesModel.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  category = nativeFromJson<String>(json['category']),
  brand = GetMyVehiclesVehiclesModelBrand.fromJson(json['brand']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyVehiclesVehiclesModel otherTyped = other as GetMyVehiclesVehiclesModel;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    category == otherTyped.category && 
    brand == otherTyped.brand;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, category.hashCode, brand.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['category'] = nativeToJson<String>(category);
    json['brand'] = brand.toJson();
    return json;
  }

  GetMyVehiclesVehiclesModel({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
  });
}

@immutable
class GetMyVehiclesVehiclesModelBrand {
  final String id;
  final String name;
  GetMyVehiclesVehiclesModelBrand.fromJson(dynamic json):
  
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

    final GetMyVehiclesVehiclesModelBrand otherTyped = other as GetMyVehiclesVehiclesModelBrand;
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

  GetMyVehiclesVehiclesModelBrand({
    required this.id,
    required this.name,
  });
}

@immutable
class GetMyVehiclesData {
  final List<GetMyVehiclesVehicles> vehicles;
  GetMyVehiclesData.fromJson(dynamic json):
  
  vehicles = (json['vehicles'] as List<dynamic>)
        .map((e) => GetMyVehiclesVehicles.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyVehiclesData otherTyped = other as GetMyVehiclesData;
    return vehicles == otherTyped.vehicles;
    
  }
  @override
  int get hashCode => vehicles.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vehicles'] = vehicles.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyVehiclesData({
    required this.vehicles,
  });
}

