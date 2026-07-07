part of 'example.dart';

class CreateBusinessVariablesBuilder {
  String id;
  String nombre;
  String ruc;
  String businessCode;
  Optional<String> _descripcion = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _telefono = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _latitud = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _longitud = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateBusinessVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }
  CreateBusinessVariablesBuilder telefono(String? t) {
   _telefono.value = t;
   return this;
  }
  CreateBusinessVariablesBuilder latitud(double? t) {
   _latitud.value = t;
   return this;
  }
  CreateBusinessVariablesBuilder longitud(double? t) {
   _longitud.value = t;
   return this;
  }

  CreateBusinessVariablesBuilder(this._dataConnect, {required  this.id,required  this.nombre,required  this.ruc,required  this.businessCode,});
  Deserializer<CreateBusinessData> dataDeserializer = (dynamic json)  => CreateBusinessData.fromJson(jsonDecode(json));
  Serializer<CreateBusinessVariables> varsSerializer = (CreateBusinessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateBusinessData, CreateBusinessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateBusinessData, CreateBusinessVariables> ref() {
    CreateBusinessVariables vars= CreateBusinessVariables(id: id,nombre: nombre,ruc: ruc,businessCode: businessCode,descripcion: _descripcion,telefono: _telefono,latitud: _latitud,longitud: _longitud,);
    return _dataConnect.mutation("CreateBusiness", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateBusinessBusinessInsert {
  final String id;
  CreateBusinessBusinessInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessBusinessInsert otherTyped = other as CreateBusinessBusinessInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateBusinessBusinessInsert({
    required this.id,
  });
}

@immutable
class CreateBusinessUserUpdate {
  final String id;
  CreateBusinessUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessUserUpdate otherTyped = other as CreateBusinessUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateBusinessUserUpdate({
    required this.id,
  });
}

@immutable
class CreateBusinessData {
  final CreateBusinessBusinessInsert business_insert;
  final CreateBusinessUserUpdate? user_update;
  CreateBusinessData.fromJson(dynamic json):
  
  business_insert = CreateBusinessBusinessInsert.fromJson(json['business_insert']),
  user_update = json['user_update'] == null ? null : CreateBusinessUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessData otherTyped = other as CreateBusinessData;
    return business_insert == otherTyped.business_insert && 
    user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => Object.hashAll([business_insert.hashCode, user_update.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['business_insert'] = business_insert.toJson();
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  CreateBusinessData({
    required this.business_insert,
    this.user_update,
  });
}

@immutable
class CreateBusinessVariables {
  final String id;
  final String nombre;
  final String ruc;
  final String businessCode;
  late final Optional<String>descripcion;
  late final Optional<String>telefono;
  late final Optional<double>latitud;
  late final Optional<double>longitud;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateBusinessVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  businessCode = nativeFromJson<String>(json['businessCode']) {
  
  
  
  
  
  
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

    final CreateBusinessVariables otherTyped = other as CreateBusinessVariables;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    businessCode == otherTyped.businessCode && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, businessCode.hashCode, descripcion.hashCode, telefono.hashCode, latitud.hashCode, longitud.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['ruc'] = nativeToJson<String>(ruc);
    json['businessCode'] = nativeToJson<String>(businessCode);
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

  CreateBusinessVariables({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.businessCode,
    required this.descripcion,
    required this.telefono,
    required this.latitud,
    required this.longitud,
  });
}

