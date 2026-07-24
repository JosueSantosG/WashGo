part of 'example.dart';

class GetMyBusinessesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyBusinessesVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyBusinessesData> dataDeserializer = (dynamic json)  => GetMyBusinessesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyBusinessesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyBusinessesData, void> ref() {
    
    return _dataConnect.query("GetMyBusinesses", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyBusinessesBusinesses {
  final String id;
  final String nombre;
  final String ruc;
  final String businessCode;
  final EnumValue<BusinessStatus> status;
  final bool wasApprovedBySuperAdmin;
  final String? descripcion;
  final String? telefono;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final double? latitud;
  final double? longitud;
  GetMyBusinessesBusinesses.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  businessCode = nativeFromJson<String>(json['businessCode']),
  status = businessStatusDeserializer(json['status']),
  wasApprovedBySuperAdmin = nativeFromJson<bool>(json['wasApprovedBySuperAdmin']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  latitud = json['latitud'] == null ? null : nativeFromJson<double>(json['latitud']),
  longitud = json['longitud'] == null ? null : nativeFromJson<double>(json['longitud']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyBusinessesBusinesses otherTyped = other as GetMyBusinessesBusinesses;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    businessCode == otherTyped.businessCode && 
    status == otherTyped.status && 
    wasApprovedBySuperAdmin == otherTyped.wasApprovedBySuperAdmin && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, businessCode.hashCode, status.hashCode, wasApprovedBySuperAdmin.hashCode, descripcion.hashCode, telefono.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, latitud.hashCode, longitud.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['ruc'] = nativeToJson<String>(ruc);
    json['businessCode'] = nativeToJson<String>(businessCode);
    json['status'] = 
    businessStatusSerializer(status)
    ;
    json['wasApprovedBySuperAdmin'] = nativeToJson<bool>(wasApprovedBySuperAdmin);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    if (latitud != null) {
      json['latitud'] = nativeToJson<double?>(latitud);
    }
    if (longitud != null) {
      json['longitud'] = nativeToJson<double?>(longitud);
    }
    return json;
  }

  GetMyBusinessesBusinesses({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.businessCode,
    required this.status,
    required this.wasApprovedBySuperAdmin,
    this.descripcion,
    this.telefono,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    this.latitud,
    this.longitud,
  });
}

@immutable
class GetMyBusinessesData {
  final List<GetMyBusinessesBusinesses> businesses;
  GetMyBusinessesData.fromJson(dynamic json):
  
  businesses = (json['businesses'] as List<dynamic>)
        .map((e) => GetMyBusinessesBusinesses.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyBusinessesData otherTyped = other as GetMyBusinessesData;
    return businesses == otherTyped.businesses;
    
  }
  @override
  int get hashCode => businesses.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businesses'] = businesses.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyBusinessesData({
    required this.businesses,
  });
}

