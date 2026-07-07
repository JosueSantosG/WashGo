part of 'example.dart';

class UpdateServiceDetailsVariablesBuilder {
  String id;
  String nombre;
  Optional<String> _descripcion = Optional.optional(nativeFromJson, nativeToJson);
  int duracionMinutos;
  ServiceType tipo;

  final FirebaseDataConnect _dataConnect;  UpdateServiceDetailsVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  UpdateServiceDetailsVariablesBuilder(this._dataConnect, {required  this.id,required  this.nombre,required  this.duracionMinutos,required  this.tipo,});
  Deserializer<UpdateServiceDetailsData> dataDeserializer = (dynamic json)  => UpdateServiceDetailsData.fromJson(jsonDecode(json));
  Serializer<UpdateServiceDetailsVariables> varsSerializer = (UpdateServiceDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateServiceDetailsData, UpdateServiceDetailsVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateServiceDetailsData, UpdateServiceDetailsVariables> ref() {
    UpdateServiceDetailsVariables vars= UpdateServiceDetailsVariables(id: id,nombre: nombre,descripcion: _descripcion,duracionMinutos: duracionMinutos,tipo: tipo,);
    return _dataConnect.mutation("UpdateServiceDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateServiceDetailsServiceUpdate {
  final String id;
  UpdateServiceDetailsServiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceDetailsServiceUpdate otherTyped = other as UpdateServiceDetailsServiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateServiceDetailsServiceUpdate({
    required this.id,
  });
}

@immutable
class UpdateServiceDetailsData {
  final UpdateServiceDetailsServiceUpdate? service_update;
  UpdateServiceDetailsData.fromJson(dynamic json):
  
  service_update = json['service_update'] == null ? null : UpdateServiceDetailsServiceUpdate.fromJson(json['service_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceDetailsData otherTyped = other as UpdateServiceDetailsData;
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

  UpdateServiceDetailsData({
    this.service_update,
  });
}

@immutable
class UpdateServiceDetailsVariables {
  final String id;
  final String nombre;
  late final Optional<String>descripcion;
  final int duracionMinutos;
  final ServiceType tipo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateServiceDetailsVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
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

    final UpdateServiceDetailsVariables otherTyped = other as UpdateServiceDetailsVariables;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    descripcion == otherTyped.descripcion && 
    duracionMinutos == otherTyped.duracionMinutos && 
    tipo == otherTyped.tipo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, descripcion.hashCode, duracionMinutos.hashCode, tipo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    if(descripcion.state == OptionalState.set) {
      json['descripcion'] = descripcion.toJson();
    }
    json['duracionMinutos'] = nativeToJson<int>(duracionMinutos);
    json['tipo'] = 
    tipo.name
    ;
    return json;
  }

  UpdateServiceDetailsVariables({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.duracionMinutos,
    required this.tipo,
  });
}

