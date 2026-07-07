part of 'example.dart';

class UpdateServiceVariablesBuilder {
  String id;
  String nombre;
  Optional<String> _descripcion = Optional.optional(nativeFromJson, nativeToJson);
  double precioPequeno;
  double precioMediano;
  double precioGrande;
  double precioMoto;
  int duracionMinutos;
  ServiceType tipo;

  final FirebaseDataConnect _dataConnect;  UpdateServiceVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  UpdateServiceVariablesBuilder(this._dataConnect, {required  this.id,required  this.nombre,required  this.precioPequeno,required  this.precioMediano,required  this.precioGrande,required  this.precioMoto,required  this.duracionMinutos,required  this.tipo,});
  Deserializer<UpdateServiceData> dataDeserializer = (dynamic json)  => UpdateServiceData.fromJson(jsonDecode(json));
  Serializer<UpdateServiceVariables> varsSerializer = (UpdateServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateServiceData, UpdateServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateServiceData, UpdateServiceVariables> ref() {
    UpdateServiceVariables vars= UpdateServiceVariables(id: id,nombre: nombre,descripcion: _descripcion,precioPequeno: precioPequeno,precioMediano: precioMediano,precioGrande: precioGrande,precioMoto: precioMoto,duracionMinutos: duracionMinutos,tipo: tipo,);
    return _dataConnect.mutation("UpdateService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateServiceServiceUpdate {
  final String id;
  UpdateServiceServiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceServiceUpdate otherTyped = other as UpdateServiceServiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateServiceServiceUpdate({
    required this.id,
  });
}

@immutable
class UpdateServiceData {
  final UpdateServiceServiceUpdate? service_update;
  UpdateServiceData.fromJson(dynamic json):
  
  service_update = json['service_update'] == null ? null : UpdateServiceServiceUpdate.fromJson(json['service_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceData otherTyped = other as UpdateServiceData;
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

  UpdateServiceData({
    this.service_update,
  });
}

@immutable
class UpdateServiceVariables {
  final String id;
  final String nombre;
  late final Optional<String>descripcion;
  final double precioPequeno;
  final double precioMediano;
  final double precioGrande;
  final double precioMoto;
  final int duracionMinutos;
  final ServiceType tipo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateServiceVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
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

    final UpdateServiceVariables otherTyped = other as UpdateServiceVariables;
    return id == otherTyped.id && 
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
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, descripcion.hashCode, precioPequeno.hashCode, precioMediano.hashCode, precioGrande.hashCode, precioMoto.hashCode, duracionMinutos.hashCode, tipo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
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

  UpdateServiceVariables({
    required this.id,
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

