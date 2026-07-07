part of 'example.dart';

class SuperAdminApproveServicePriceVariablesBuilder {
  String id;
  double precioAprobadoPequeno;
  double precioAprobadoMediano;
  double precioAprobadoGrande;
  double precioAprobadoMoto;

  final FirebaseDataConnect _dataConnect;
  SuperAdminApproveServicePriceVariablesBuilder(this._dataConnect, {required  this.id,required  this.precioAprobadoPequeno,required  this.precioAprobadoMediano,required  this.precioAprobadoGrande,required  this.precioAprobadoMoto,});
  Deserializer<SuperAdminApproveServicePriceData> dataDeserializer = (dynamic json)  => SuperAdminApproveServicePriceData.fromJson(jsonDecode(json));
  Serializer<SuperAdminApproveServicePriceVariables> varsSerializer = (SuperAdminApproveServicePriceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SuperAdminApproveServicePriceData, SuperAdminApproveServicePriceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SuperAdminApproveServicePriceData, SuperAdminApproveServicePriceVariables> ref() {
    SuperAdminApproveServicePriceVariables vars= SuperAdminApproveServicePriceVariables(id: id,precioAprobadoPequeno: precioAprobadoPequeno,precioAprobadoMediano: precioAprobadoMediano,precioAprobadoGrande: precioAprobadoGrande,precioAprobadoMoto: precioAprobadoMoto,);
    return _dataConnect.mutation("SuperAdminApproveServicePrice", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SuperAdminApproveServicePriceServiceUpdate {
  final String id;
  SuperAdminApproveServicePriceServiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminApproveServicePriceServiceUpdate otherTyped = other as SuperAdminApproveServicePriceServiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SuperAdminApproveServicePriceServiceUpdate({
    required this.id,
  });
}

@immutable
class SuperAdminApproveServicePriceData {
  final SuperAdminApproveServicePriceServiceUpdate? service_update;
  SuperAdminApproveServicePriceData.fromJson(dynamic json):
  
  service_update = json['service_update'] == null ? null : SuperAdminApproveServicePriceServiceUpdate.fromJson(json['service_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminApproveServicePriceData otherTyped = other as SuperAdminApproveServicePriceData;
    return service_update == otherTyped.service_update;
    
  }
  @override
  int get hashCode => service_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (service_update != null) {
      json['service_update'] = service_update!.toJson();
    }
    return json;
  }

  SuperAdminApproveServicePriceData({
    this.service_update,
  });
}

@immutable
class SuperAdminApproveServicePriceVariables {
  final String id;
  final double precioAprobadoPequeno;
  final double precioAprobadoMediano;
  final double precioAprobadoGrande;
  final double precioAprobadoMoto;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SuperAdminApproveServicePriceVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  precioAprobadoPequeno = nativeFromJson<double>(json['precioAprobadoPequeno']),
  precioAprobadoMediano = nativeFromJson<double>(json['precioAprobadoMediano']),
  precioAprobadoGrande = nativeFromJson<double>(json['precioAprobadoGrande']),
  precioAprobadoMoto = nativeFromJson<double>(json['precioAprobadoMoto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminApproveServicePriceVariables otherTyped = other as SuperAdminApproveServicePriceVariables;
    return id == otherTyped.id && 
    precioAprobadoPequeno == otherTyped.precioAprobadoPequeno && 
    precioAprobadoMediano == otherTyped.precioAprobadoMediano && 
    precioAprobadoGrande == otherTyped.precioAprobadoGrande && 
    precioAprobadoMoto == otherTyped.precioAprobadoMoto;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, precioAprobadoPequeno.hashCode, precioAprobadoMediano.hashCode, precioAprobadoGrande.hashCode, precioAprobadoMoto.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['precioAprobadoPequeno'] = nativeToJson<double>(precioAprobadoPequeno);
    json['precioAprobadoMediano'] = nativeToJson<double>(precioAprobadoMediano);
    json['precioAprobadoGrande'] = nativeToJson<double>(precioAprobadoGrande);
    json['precioAprobadoMoto'] = nativeToJson<double>(precioAprobadoMoto);
    return json;
  }

  SuperAdminApproveServicePriceVariables({
    required this.id,
    required this.precioAprobadoPequeno,
    required this.precioAprobadoMediano,
    required this.precioAprobadoGrande,
    required this.precioAprobadoMoto,
  });
}

