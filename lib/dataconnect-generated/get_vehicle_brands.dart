part of 'example.dart';

class GetVehicleBrandsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetVehicleBrandsVariablesBuilder(this._dataConnect, );
  Deserializer<GetVehicleBrandsData> dataDeserializer = (dynamic json)  => GetVehicleBrandsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetVehicleBrandsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetVehicleBrandsData, void> ref() {
    
    return _dataConnect.query("GetVehicleBrands", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetVehicleBrandsVehicleBrands {
  final String id;
  final String name;
  GetVehicleBrandsVehicleBrands.fromJson(dynamic json):
  
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

    final GetVehicleBrandsVehicleBrands otherTyped = other as GetVehicleBrandsVehicleBrands;
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

  GetVehicleBrandsVehicleBrands({
    required this.id,
    required this.name,
  });
}

@immutable
class GetVehicleBrandsData {
  final List<GetVehicleBrandsVehicleBrands> vehicleBrands;
  GetVehicleBrandsData.fromJson(dynamic json):
  
  vehicleBrands = (json['vehicleBrands'] as List<dynamic>)
        .map((e) => GetVehicleBrandsVehicleBrands.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetVehicleBrandsData otherTyped = other as GetVehicleBrandsData;
    return vehicleBrands == otherTyped.vehicleBrands;
    
  }
  @override
  int get hashCode => vehicleBrands.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['vehicleBrands'] = vehicleBrands.map((e) => e.toJson()).toList();
    return json;
  }

  GetVehicleBrandsData({
    required this.vehicleBrands,
  });
}

