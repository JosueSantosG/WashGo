part of 'example.dart';

class GetAllBusinessesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllBusinessesVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllBusinessesData> dataDeserializer = (dynamic json)  => GetAllBusinessesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllBusinessesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetAllBusinessesData, void> ref() {
    
    return _dataConnect.query("GetAllBusinesses", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllBusinessesBusinesses {
  final String id;
  final String nombre;
  final String businessCode;
  final EnumValue<BusinessStatus> status;
  final String? descripcion;
  final String? telefono;
  final double? latitud;
  final double? longitud;
  final GetAllBusinessesBusinessesOwner owner;
  final List<GetAllBusinessesBusinessesBusinessHoursOnBusiness> businessHours_on_business;
  final List<GetAllBusinessesBusinessesServicesOnBusiness> services_on_business;
  final List<GetAllBusinessesBusinessesReviewsOnBusiness> reviews_on_business;
  GetAllBusinessesBusinesses.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  businessCode = nativeFromJson<String>(json['businessCode']),
  status = businessStatusDeserializer(json['status']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  latitud = json['latitud'] == null ? null : nativeFromJson<double>(json['latitud']),
  longitud = json['longitud'] == null ? null : nativeFromJson<double>(json['longitud']),
  owner = GetAllBusinessesBusinessesOwner.fromJson(json['owner']),
  businessHours_on_business = (json['businessHours_on_business'] as List<dynamic>)
        .map((e) => GetAllBusinessesBusinessesBusinessHoursOnBusiness.fromJson(e))
        .toList(),
  services_on_business = (json['services_on_business'] as List<dynamic>)
        .map((e) => GetAllBusinessesBusinessesServicesOnBusiness.fromJson(e))
        .toList(),
  reviews_on_business = (json['reviews_on_business'] as List<dynamic>)
        .map((e) => GetAllBusinessesBusinessesReviewsOnBusiness.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBusinessesBusinesses otherTyped = other as GetAllBusinessesBusinesses;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    businessCode == otherTyped.businessCode && 
    status == otherTyped.status && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud && 
    owner == otherTyped.owner && 
    businessHours_on_business == otherTyped.businessHours_on_business && 
    services_on_business == otherTyped.services_on_business && 
    reviews_on_business == otherTyped.reviews_on_business;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, businessCode.hashCode, status.hashCode, descripcion.hashCode, telefono.hashCode, latitud.hashCode, longitud.hashCode, owner.hashCode, businessHours_on_business.hashCode, services_on_business.hashCode, reviews_on_business.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['businessCode'] = nativeToJson<String>(businessCode);
    json['status'] = 
    businessStatusSerializer(status)
    ;
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
    json['owner'] = owner.toJson();
    json['businessHours_on_business'] = businessHours_on_business.map((e) => e.toJson()).toList();
    json['services_on_business'] = services_on_business.map((e) => e.toJson()).toList();
    json['reviews_on_business'] = reviews_on_business.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllBusinessesBusinesses({
    required this.id,
    required this.nombre,
    required this.businessCode,
    required this.status,
    this.descripcion,
    this.telefono,
    this.latitud,
    this.longitud,
    required this.owner,
    required this.businessHours_on_business,
    required this.services_on_business,
    required this.reviews_on_business,
  });
}

@immutable
class GetAllBusinessesBusinessesOwner {
  final String nombreCompleto;
  GetAllBusinessesBusinessesOwner.fromJson(dynamic json):
  
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBusinessesBusinessesOwner otherTyped = other as GetAllBusinessesBusinessesOwner;
    return nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => nombreCompleto.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  GetAllBusinessesBusinessesOwner({
    required this.nombreCompleto,
  });
}

@immutable
class GetAllBusinessesBusinessesBusinessHoursOnBusiness {
  final int diaDeLaSemana;
  final String? horaApertura;
  final String? horaCierre;
  final bool esDiaDescanso;
  GetAllBusinessesBusinessesBusinessHoursOnBusiness.fromJson(dynamic json):
  
  diaDeLaSemana = nativeFromJson<int>(json['diaDeLaSemana']),
  horaApertura = json['horaApertura'] == null ? null : nativeFromJson<String>(json['horaApertura']),
  horaCierre = json['horaCierre'] == null ? null : nativeFromJson<String>(json['horaCierre']),
  esDiaDescanso = nativeFromJson<bool>(json['esDiaDescanso']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBusinessesBusinessesBusinessHoursOnBusiness otherTyped = other as GetAllBusinessesBusinessesBusinessHoursOnBusiness;
    return diaDeLaSemana == otherTyped.diaDeLaSemana && 
    horaApertura == otherTyped.horaApertura && 
    horaCierre == otherTyped.horaCierre && 
    esDiaDescanso == otherTyped.esDiaDescanso;
    
  }
  @override
  int get hashCode => Object.hashAll([diaDeLaSemana.hashCode, horaApertura.hashCode, horaCierre.hashCode, esDiaDescanso.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['diaDeLaSemana'] = nativeToJson<int>(diaDeLaSemana);
    if (horaApertura != null) {
      json['horaApertura'] = nativeToJson<String?>(horaApertura);
    }
    if (horaCierre != null) {
      json['horaCierre'] = nativeToJson<String?>(horaCierre);
    }
    json['esDiaDescanso'] = nativeToJson<bool>(esDiaDescanso);
    return json;
  }

  GetAllBusinessesBusinessesBusinessHoursOnBusiness({
    required this.diaDeLaSemana,
    this.horaApertura,
    this.horaCierre,
    required this.esDiaDescanso,
  });
}

@immutable
class GetAllBusinessesBusinessesServicesOnBusiness {
  final double precioPequeno;
  final double precioMediano;
  final double precioGrande;
  final double precioMoto;
  final bool? activo;
  final bool precioPendiente;
  GetAllBusinessesBusinessesServicesOnBusiness.fromJson(dynamic json):
  
  precioPequeno = nativeFromJson<double>(json['precioPequeno']),
  precioMediano = nativeFromJson<double>(json['precioMediano']),
  precioGrande = nativeFromJson<double>(json['precioGrande']),
  precioMoto = nativeFromJson<double>(json['precioMoto']),
  activo = json['activo'] == null ? null : nativeFromJson<bool>(json['activo']),
  precioPendiente = nativeFromJson<bool>(json['precioPendiente']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBusinessesBusinessesServicesOnBusiness otherTyped = other as GetAllBusinessesBusinessesServicesOnBusiness;
    return precioPequeno == otherTyped.precioPequeno && 
    precioMediano == otherTyped.precioMediano && 
    precioGrande == otherTyped.precioGrande && 
    precioMoto == otherTyped.precioMoto && 
    activo == otherTyped.activo && 
    precioPendiente == otherTyped.precioPendiente;
    
  }
  @override
  int get hashCode => Object.hashAll([precioPequeno.hashCode, precioMediano.hashCode, precioGrande.hashCode, precioMoto.hashCode, activo.hashCode, precioPendiente.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['precioPequeno'] = nativeToJson<double>(precioPequeno);
    json['precioMediano'] = nativeToJson<double>(precioMediano);
    json['precioGrande'] = nativeToJson<double>(precioGrande);
    json['precioMoto'] = nativeToJson<double>(precioMoto);
    if (activo != null) {
      json['activo'] = nativeToJson<bool?>(activo);
    }
    json['precioPendiente'] = nativeToJson<bool>(precioPendiente);
    return json;
  }

  GetAllBusinessesBusinessesServicesOnBusiness({
    required this.precioPequeno,
    required this.precioMediano,
    required this.precioGrande,
    required this.precioMoto,
    this.activo,
    required this.precioPendiente,
  });
}

@immutable
class GetAllBusinessesBusinessesReviewsOnBusiness {
  final int calificacion;
  GetAllBusinessesBusinessesReviewsOnBusiness.fromJson(dynamic json):
  
  calificacion = nativeFromJson<int>(json['calificacion']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBusinessesBusinessesReviewsOnBusiness otherTyped = other as GetAllBusinessesBusinessesReviewsOnBusiness;
    return calificacion == otherTyped.calificacion;
    
  }
  @override
  int get hashCode => calificacion.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['calificacion'] = nativeToJson<int>(calificacion);
    return json;
  }

  GetAllBusinessesBusinessesReviewsOnBusiness({
    required this.calificacion,
  });
}

@immutable
class GetAllBusinessesData {
  final List<GetAllBusinessesBusinesses> businesses;
  GetAllBusinessesData.fromJson(dynamic json):
  
  businesses = (json['businesses'] as List<dynamic>)
        .map((e) => GetAllBusinessesBusinesses.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBusinessesData otherTyped = other as GetAllBusinessesData;
    return businesses == otherTyped.businesses;
    
  }
  @override
  int get hashCode => businesses.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businesses'] = businesses.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllBusinessesData({
    required this.businesses,
  });
}

