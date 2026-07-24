part of 'example.dart';

class SuperAdminGetBusinessesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  SuperAdminGetBusinessesVariablesBuilder(this._dataConnect, );
  Deserializer<SuperAdminGetBusinessesData> dataDeserializer = (dynamic json)  => SuperAdminGetBusinessesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<SuperAdminGetBusinessesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<SuperAdminGetBusinessesData, void> ref() {
    
    return _dataConnect.query("SuperAdminGetBusinesses", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class SuperAdminGetBusinessesBusinesses {
  final String id;
  final String nombre;
  final String ruc;
  final String businessCode;
  final EnumValue<BusinessStatus> status;
  final bool wasApprovedBySuperAdmin;
  final String? descripcion;
  final String? telefono;
  final double? latitud;
  final double? longitud;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final SuperAdminGetBusinessesBusinessesOwner owner;
  final List<SuperAdminGetBusinessesBusinessesServicesOnBusiness> services_on_business;
  SuperAdminGetBusinessesBusinesses.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  businessCode = nativeFromJson<String>(json['businessCode']),
  status = businessStatusDeserializer(json['status']),
  wasApprovedBySuperAdmin = nativeFromJson<bool>(json['wasApprovedBySuperAdmin']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  latitud = json['latitud'] == null ? null : nativeFromJson<double>(json['latitud']),
  longitud = json['longitud'] == null ? null : nativeFromJson<double>(json['longitud']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  owner = SuperAdminGetBusinessesBusinessesOwner.fromJson(json['owner']),
  services_on_business = (json['services_on_business'] as List<dynamic>)
        .map((e) => SuperAdminGetBusinessesBusinessesServicesOnBusiness.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetBusinessesBusinesses otherTyped = other as SuperAdminGetBusinessesBusinesses;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    businessCode == otherTyped.businessCode && 
    status == otherTyped.status && 
    wasApprovedBySuperAdmin == otherTyped.wasApprovedBySuperAdmin && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido && 
    owner == otherTyped.owner && 
    services_on_business == otherTyped.services_on_business;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, businessCode.hashCode, status.hashCode, wasApprovedBySuperAdmin.hashCode, descripcion.hashCode, telefono.hashCode, latitud.hashCode, longitud.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, owner.hashCode, services_on_business.hashCode]);
  

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
    if (latitud != null) {
      json['latitud'] = nativeToJson<double?>(latitud);
    }
    if (longitud != null) {
      json['longitud'] = nativeToJson<double?>(longitud);
    }
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    json['owner'] = owner.toJson();
    json['services_on_business'] = services_on_business.map((e) => e.toJson()).toList();
    return json;
  }

  SuperAdminGetBusinessesBusinesses({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.businessCode,
    required this.status,
    required this.wasApprovedBySuperAdmin,
    this.descripcion,
    this.telefono,
    this.latitud,
    this.longitud,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    required this.owner,
    required this.services_on_business,
  });
}

@immutable
class SuperAdminGetBusinessesBusinessesOwner {
  final String id;
  final String nombreCompleto;
  SuperAdminGetBusinessesBusinessesOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetBusinessesBusinessesOwner otherTyped = other as SuperAdminGetBusinessesBusinessesOwner;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  SuperAdminGetBusinessesBusinessesOwner({
    required this.id,
    required this.nombreCompleto,
  });
}

@immutable
class SuperAdminGetBusinessesBusinessesServicesOnBusiness {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precioPequeno;
  final double precioMediano;
  final double precioGrande;
  final double precioMoto;
  final double precioOwnerPequeno;
  final double precioOwnerMediano;
  final double precioOwnerGrande;
  final double precioOwnerMoto;
  final bool precioPendiente;
  final double costo;
  final int duracionMinutos;
  final EnumValue<ServiceType> tipo;
  final bool? activo;
  SuperAdminGetBusinessesBusinessesServicesOnBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  precioPequeno = nativeFromJson<double>(json['precioPequeno']),
  precioMediano = nativeFromJson<double>(json['precioMediano']),
  precioGrande = nativeFromJson<double>(json['precioGrande']),
  precioMoto = nativeFromJson<double>(json['precioMoto']),
  precioOwnerPequeno = nativeFromJson<double>(json['precioOwnerPequeno']),
  precioOwnerMediano = nativeFromJson<double>(json['precioOwnerMediano']),
  precioOwnerGrande = nativeFromJson<double>(json['precioOwnerGrande']),
  precioOwnerMoto = nativeFromJson<double>(json['precioOwnerMoto']),
  precioPendiente = nativeFromJson<bool>(json['precioPendiente']),
  costo = nativeFromJson<double>(json['costo']),
  duracionMinutos = nativeFromJson<int>(json['duracionMinutos']),
  tipo = serviceTypeDeserializer(json['tipo']),
  activo = json['activo'] == null ? null : nativeFromJson<bool>(json['activo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetBusinessesBusinessesServicesOnBusiness otherTyped = other as SuperAdminGetBusinessesBusinessesServicesOnBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    descripcion == otherTyped.descripcion && 
    precioPequeno == otherTyped.precioPequeno && 
    precioMediano == otherTyped.precioMediano && 
    precioGrande == otherTyped.precioGrande && 
    precioMoto == otherTyped.precioMoto && 
    precioOwnerPequeno == otherTyped.precioOwnerPequeno && 
    precioOwnerMediano == otherTyped.precioOwnerMediano && 
    precioOwnerGrande == otherTyped.precioOwnerGrande && 
    precioOwnerMoto == otherTyped.precioOwnerMoto && 
    precioPendiente == otherTyped.precioPendiente && 
    costo == otherTyped.costo && 
    duracionMinutos == otherTyped.duracionMinutos && 
    tipo == otherTyped.tipo && 
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, descripcion.hashCode, precioPequeno.hashCode, precioMediano.hashCode, precioGrande.hashCode, precioMoto.hashCode, precioOwnerPequeno.hashCode, precioOwnerMediano.hashCode, precioOwnerGrande.hashCode, precioOwnerMoto.hashCode, precioPendiente.hashCode, costo.hashCode, duracionMinutos.hashCode, tipo.hashCode, activo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    json['precioPequeno'] = nativeToJson<double>(precioPequeno);
    json['precioMediano'] = nativeToJson<double>(precioMediano);
    json['precioGrande'] = nativeToJson<double>(precioGrande);
    json['precioMoto'] = nativeToJson<double>(precioMoto);
    json['precioOwnerPequeno'] = nativeToJson<double>(precioOwnerPequeno);
    json['precioOwnerMediano'] = nativeToJson<double>(precioOwnerMediano);
    json['precioOwnerGrande'] = nativeToJson<double>(precioOwnerGrande);
    json['precioOwnerMoto'] = nativeToJson<double>(precioOwnerMoto);
    json['precioPendiente'] = nativeToJson<bool>(precioPendiente);
    json['costo'] = nativeToJson<double>(costo);
    json['duracionMinutos'] = nativeToJson<int>(duracionMinutos);
    json['tipo'] = 
    serviceTypeSerializer(tipo)
    ;
    if (activo != null) {
      json['activo'] = nativeToJson<bool?>(activo);
    }
    return json;
  }

  SuperAdminGetBusinessesBusinessesServicesOnBusiness({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precioPequeno,
    required this.precioMediano,
    required this.precioGrande,
    required this.precioMoto,
    required this.precioOwnerPequeno,
    required this.precioOwnerMediano,
    required this.precioOwnerGrande,
    required this.precioOwnerMoto,
    required this.precioPendiente,
    required this.costo,
    required this.duracionMinutos,
    required this.tipo,
    this.activo,
  });
}

@immutable
class SuperAdminGetBusinessesData {
  final List<SuperAdminGetBusinessesBusinesses> businesses;
  SuperAdminGetBusinessesData.fromJson(dynamic json):
  
  businesses = (json['businesses'] as List<dynamic>)
        .map((e) => SuperAdminGetBusinessesBusinesses.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminGetBusinessesData otherTyped = other as SuperAdminGetBusinessesData;
    return businesses == otherTyped.businesses;
    
  }
  @override
  int get hashCode => businesses.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businesses'] = businesses.map((e) => e.toJson()).toList();
    return json;
  }

  SuperAdminGetBusinessesData({
    required this.businesses,
  });
}

