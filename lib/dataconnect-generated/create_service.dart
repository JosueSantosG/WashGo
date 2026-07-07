part of 'example.dart';

class CreateServiceVariablesBuilder {
  String businessId;
  String nombre;
  Optional<String> _descripcion = Optional.optional(nativeFromJson, nativeToJson);
  double precioPequeno;
  double precioMediano;
  double precioGrande;
  double precioMoto;
  int duracionMinutos;
  ServiceType tipo;

  final FirebaseDataConnect _dataConnect;  CreateServiceVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  CreateServiceVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.nombre,required  this.precioPequeno,required  this.precioMediano,required  this.precioGrande,required  this.precioMoto,required  this.duracionMinutos,required  this.tipo,});
  Deserializer<CreateServiceData> dataDeserializer = (dynamic json)  => CreateServiceData.fromJson(jsonDecode(json));
  Serializer<CreateServiceVariables> varsSerializer = (CreateServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateServiceData, CreateServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateServiceData, CreateServiceVariables> ref() {
    CreateServiceVariables vars= CreateServiceVariables(businessId: businessId,nombre: nombre,descripcion: _descripcion,precioPequeno: precioPequeno,precioMediano: precioMediano,precioGrande: precioGrande,precioMoto: precioMoto,duracionMinutos: duracionMinutos,tipo: tipo,);
    return _dataConnect.mutation("CreateService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateServiceServiceInsert {
  final String id;
  CreateServiceServiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateServiceServiceInsert otherTyped = other as CreateServiceServiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateServiceServiceInsert({
    required this.id,
  });
}

@immutable
class CreateServiceData {
  final CreateServiceServiceInsert service_insert;
  CreateServiceData.fromJson(dynamic json):
  
  service_insert = CreateServiceServiceInsert.fromJson(json['service_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateServiceData otherTyped = other as CreateServiceData;
    return service_insert == otherTyped.service_insert;
    
  }
  @override
  int get hashCode => service_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['service_insert'] = service_insert.toJson();
    return json;
  }

  CreateServiceData({
    required this.service_insert,
  });
}

@immutable
class CreateServiceVariables {
  final String businessId;
  final String nombre;
  late final Optional<String>descripcion;
  final double precioPequeno;
  final double precioMediano;
  final double precioGrande;
  final double precioMoto;
  final int duracionMinutos;
  final ServiceType tipo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateServiceVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  nombre = nativeFromJson<String>(json['nombre']),
  precioPequeno = nativeFromJson<double>(json['precioPequeno']),
  precioMediano = nativeFromJson<double>(json['precioMediano']),
  precioGrande = nativeFromJson<double>(json['precioGrande']),
  precioMoto = nativeFromJson<double>(json['precioMoto']),
  duracionMinutos = nativeFromJson<int>(json['duracionMinutos']),
  tipo = ServiceType.values.byName(json['tipo']) {
  
  
  
  
    descripcion = Optional.optional(nativeFromJson, nativeToJson);
    descripcion.value = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']);
  
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateServiceVariables otherTyped = other as CreateServiceVariables;
    return businessId == otherTyped.businessId && 
    nombre == otherTyped.nombre && 
    descripcion == otherTyped.descripcion && 
    precioPequeno == otherTyped.precioPequeno && 
    precioMediano == otherTyped.precioMediano && 
    precioGrande == otherTyped.precioGrande && 
    precioMoto == otherTyped.precioMoto && 
    duracionMinutos == otherTyped.duracionMinutos && 
    tipo == otherTyped.tipo;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, nombre.hashCode, descripcion.hashCode, precioPequeno.hashCode, precioMediano.hashCode, precioGrande.hashCode, precioMoto.hashCode, duracionMinutos.hashCode, tipo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['nombre'] = nativeToJson<String>(nombre);
    if(descripcion.state == OptionalState.set) {
      json['descripcion'] = descripcion.toJson();
    }
    json['precioPequeno'] = nativeToJson<double>(precioPequeno);
    json['precioMediano'] = nativeToJson<double>(precioMediano);
    json['precioGrande'] = nativeToJson<double>(precioGrande);
    json['precioMoto'] = nativeToJson<double>(precioMoto);
    json['duracionMinutos'] = nativeToJson<int>(duracionMinutos);
    json['tipo'] = 
    tipo.name
    ;
    return json;
  }

  CreateServiceVariables({
    required this.businessId,
    required this.nombre,
    required this.descripcion,
    required this.precioPequeno,
    required this.precioMediano,
    required this.precioGrande,
    required this.precioMoto,
    required this.duracionMinutos,
    required this.tipo,
  });
}

