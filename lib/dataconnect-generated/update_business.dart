part of 'example.dart';

class UpdateBusinessVariablesBuilder {
  String id;
  String nombre;
  String ruc;
  Optional<String> _descripcion = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _telefono = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _latitud = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _longitud = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateBusinessVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }
  UpdateBusinessVariablesBuilder telefono(String? t) {
   _telefono.value = t;
   return this;
  }
  UpdateBusinessVariablesBuilder latitud(double? t) {
   _latitud.value = t;
   return this;
  }
  UpdateBusinessVariablesBuilder longitud(double? t) {
   _longitud.value = t;
   return this;
  }

  UpdateBusinessVariablesBuilder(this._dataConnect, {required  this.id,required  this.nombre,required  this.ruc,});
  Deserializer<UpdateBusinessData> dataDeserializer = (dynamic json)  => UpdateBusinessData.fromJson(jsonDecode(json));
  Serializer<UpdateBusinessVariables> varsSerializer = (UpdateBusinessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateBusinessData, UpdateBusinessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateBusinessData, UpdateBusinessVariables> ref() {
    UpdateBusinessVariables vars= UpdateBusinessVariables(id: id,nombre: nombre,ruc: ruc,descripcion: _descripcion,telefono: _telefono,latitud: _latitud,longitud: _longitud,);
    return _dataConnect.mutation("UpdateBusiness", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateBusinessBusinessUpdate {
  final String id;
  UpdateBusinessBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessBusinessUpdate otherTyped = other as UpdateBusinessBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateBusinessBusinessUpdate({
    required this.id,
  });
}

@immutable
class UpdateBusinessData {
  final UpdateBusinessBusinessUpdate? business_update;
  UpdateBusinessData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : UpdateBusinessBusinessUpdate.fromJson(json['business_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessData otherTyped = other as UpdateBusinessData;
    return business_update == otherTyped.business_update;
    
  }
  @override
  int get hashCode => business_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (business_update != null) {
      json['business_update'] = business_update!.toJson();
    }
    return json;
  }

  UpdateBusinessData({
    this.business_update,
  });
}

@immutable
class UpdateBusinessVariables {
  final String id;
  final String nombre;
  final String ruc;
  late final Optional<String>descripcion;
  late final Optional<String>telefono;
  late final Optional<double>latitud;
  late final Optional<double>longitud;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateBusinessVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']) {
  
  
  
  
  
    descripcion = Optional.optional(nativeFromJson, nativeToJson);
    descripcion.value = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']);
  
  
    telefono = Optional.optional(nativeFromJson, nativeToJson);
    telefono.value = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  
  
    latitud = Optional.optional(nativeFromJson, nativeToJson);
    latitud.value = json['latitud'] == null ? null : nativeFromJson<double>(json['latitud']);
  
  
    longitud = Optional.optional(nativeFromJson, nativeToJson);
    longitud.value = json['longitud'] == null ? null : nativeFromJson<double>(json['longitud']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessVariables otherTyped = other as UpdateBusinessVariables;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, descripcion.hashCode, telefono.hashCode, latitud.hashCode, longitud.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['ruc'] = nativeToJson<String>(ruc);
    if(descripcion.state == OptionalState.set) {
      json['descripcion'] = descripcion.toJson();
    }
    if(telefono.state == OptionalState.set) {
      json['telefono'] = telefono.toJson();
    }
    if(latitud.state == OptionalState.set) {
      json['latitud'] = latitud.toJson();
    }
    if(longitud.state == OptionalState.set) {
      json['longitud'] = longitud.toJson();
    }
    return json;
  }

  UpdateBusinessVariables({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.descripcion,
    required this.telefono,
    required this.latitud,
    required this.longitud,
  });
}

