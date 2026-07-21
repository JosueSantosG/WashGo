part of 'example.dart';

class GetBusinessServicesVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetBusinessServicesVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetBusinessServicesData> dataDeserializer = (dynamic json)  => GetBusinessServicesData.fromJson(jsonDecode(json));
  Serializer<GetBusinessServicesVariables> varsSerializer = (GetBusinessServicesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBusinessServicesData, GetBusinessServicesVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetBusinessServicesData, GetBusinessServicesVariables> ref() {
    GetBusinessServicesVariables vars= GetBusinessServicesVariables(businessId: businessId,);
    return _dataConnect.query("GetBusinessServices", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBusinessServicesServices {
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
  final String? fotoUrl;
  final EnumValue<ServiceType> tipo;
  final bool? activo;
  GetBusinessServicesServices.fromJson(dynamic json):
  
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
  fotoUrl = json['fotoUrl'] == null ? null : nativeFromJson<String>(json['fotoUrl']),
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

    final GetBusinessServicesServices otherTyped = other as GetBusinessServicesServices;
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
    fotoUrl == otherTyped.fotoUrl && 
    tipo == otherTyped.tipo && 
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, descripcion.hashCode, precioPequeno.hashCode, precioMediano.hashCode, precioGrande.hashCode, precioMoto.hashCode, precioOwnerPequeno.hashCode, precioOwnerMediano.hashCode, precioOwnerGrande.hashCode, precioOwnerMoto.hashCode, precioPendiente.hashCode, costo.hashCode, duracionMinutos.hashCode, fotoUrl.hashCode, tipo.hashCode, activo.hashCode]);
  

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
    if (fotoUrl != null) {
      json['fotoUrl'] = nativeToJson<String?>(fotoUrl);
    }
    json['tipo'] = 
    serviceTypeSerializer(tipo)
    ;
    if (activo != null) {
      json['activo'] = nativeToJson<bool?>(activo);
    }
    return json;
  }

  GetBusinessServicesServices({
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
    this.fotoUrl,
    required this.tipo,
    this.activo,
  });
}

@immutable
class GetBusinessServicesData {
  final List<GetBusinessServicesServices> services;
  GetBusinessServicesData.fromJson(dynamic json):
  
  services = (json['services'] as List<dynamic>)
        .map((e) => GetBusinessServicesServices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessServicesData otherTyped = other as GetBusinessServicesData;
    return services == otherTyped.services;
    
  }
  @override
  int get hashCode => services.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['services'] = services.map((e) => e.toJson()).toList();
    return json;
  }

  GetBusinessServicesData({
    required this.services,
  });
}

@immutable
class GetBusinessServicesVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBusinessServicesVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessServicesVariables otherTyped = other as GetBusinessServicesVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetBusinessServicesVariables({
    required this.businessId,
  });
}

