part of 'example.dart';

class GetBusinessDetailsVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetBusinessDetailsVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetBusinessDetailsData> dataDeserializer = (dynamic json)  => GetBusinessDetailsData.fromJson(jsonDecode(json));
  Serializer<GetBusinessDetailsVariables> varsSerializer = (GetBusinessDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBusinessDetailsData, GetBusinessDetailsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetBusinessDetailsData, GetBusinessDetailsVariables> ref() {
    GetBusinessDetailsVariables vars= GetBusinessDetailsVariables(id: id,);
    return _dataConnect.query("GetBusinessDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBusinessDetailsBusiness {
  final String id;
  final String nombre;
  final String ruc;
  final String? descripcion;
  final String? telefono;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  GetBusinessDetailsBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessDetailsBusiness otherTyped = other as GetBusinessDetailsBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, descripcion.hashCode, telefono.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['ruc'] = nativeToJson<String>(ruc);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    return json;
  }

  GetBusinessDetailsBusiness({
    required this.id,
    required this.nombre,
    required this.ruc,
    this.descripcion,
    this.telefono,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
  });
}

@immutable
class GetBusinessDetailsData {
  final GetBusinessDetailsBusiness? business;
  GetBusinessDetailsData.fromJson(dynamic json):
  
  business = json['business'] == null ? null : GetBusinessDetailsBusiness.fromJson(json['business']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessDetailsData otherTyped = other as GetBusinessDetailsData;
    return business == otherTyped.business;
    
  }
  @override
  int get hashCode => business.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (business != null) {
      json['business'] = business!.toJson();
    }
    return json;
  }

  GetBusinessDetailsData({
    this.business,
  });
}

@immutable
class GetBusinessDetailsVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBusinessDetailsVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessDetailsVariables otherTyped = other as GetBusinessDetailsVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetBusinessDetailsVariables({
    required this.id,
  });
}

