part of 'example.dart';

class GetCurrentUserVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetCurrentUserVariablesBuilder(this._dataConnect, );
  Deserializer<GetCurrentUserData> dataDeserializer = (dynamic json)  => GetCurrentUserData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetCurrentUserData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetCurrentUserData, void> ref() {
    
    return _dataConnect.query("GetCurrentUser", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetCurrentUserUser {
  final String id;
  final String nombreCompleto;
  final String email;
  final List<EnumValue<UserRole>> roles;
  final String? fotoPerfil;
  final String? telefono;
  final Timestamp fechaCreacion;
  final EnumValue<EmployeeStatus> employeeStatus;
  final GetCurrentUserUserCurrentBusiness? currentBusiness;
  GetCurrentUserUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  email = nativeFromJson<String>(json['email']),
  roles = (json['roles'] as List<dynamic>)
        .map((e) => userRoleDeserializer(e))
        .toList(),
  fotoPerfil = json['fotoPerfil'] == null ? null : nativeFromJson<String>(json['fotoPerfil']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  fechaCreacion = Timestamp.fromJson(json['fechaCreacion']),
  employeeStatus = employeeStatusDeserializer(json['employeeStatus']),
  currentBusiness = json['currentBusiness'] == null ? null : GetCurrentUserUserCurrentBusiness.fromJson(json['currentBusiness']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCurrentUserUser otherTyped = other as GetCurrentUserUser;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    email == otherTyped.email && 
    roles == otherTyped.roles && 
    fotoPerfil == otherTyped.fotoPerfil && 
    telefono == otherTyped.telefono && 
    fechaCreacion == otherTyped.fechaCreacion && 
    employeeStatus == otherTyped.employeeStatus && 
    currentBusiness == otherTyped.currentBusiness;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, email.hashCode, roles.hashCode, fotoPerfil.hashCode, telefono.hashCode, fechaCreacion.hashCode, employeeStatus.hashCode, currentBusiness.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    json['email'] = nativeToJson<String>(email);
    json['roles'] = roles.map((e) => userRoleSerializer(e)).toList();
    if (fotoPerfil != null) {
      json['fotoPerfil'] = nativeToJson<String?>(fotoPerfil);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    json['fechaCreacion'] = fechaCreacion.toJson();
    json['employeeStatus'] = 
    employeeStatusSerializer(employeeStatus)
    ;
    if (currentBusiness != null) {
      json['currentBusiness'] = currentBusiness!.toJson();
    }
    return json;
  }

  GetCurrentUserUser({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    required this.roles,
    this.fotoPerfil,
    this.telefono,
    required this.fechaCreacion,
    required this.employeeStatus,
    this.currentBusiness,
  });
}

@immutable
class GetCurrentUserUserCurrentBusiness {
  final String id;
  final String nombre;
  final String ruc;
  final String businessCode;
  final String? descripcion;
  final String? telefono;
  final double? latitud;
  final double? longitud;
  final EnumValue<BusinessStatus> status;
  final bool wasApprovedBySuperAdmin;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  GetCurrentUserUserCurrentBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  businessCode = nativeFromJson<String>(json['businessCode']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  latitud = json['latitud'] == null ? null : nativeFromJson<double>(json['latitud']),
  longitud = json['longitud'] == null ? null : nativeFromJson<double>(json['longitud']),
  status = businessStatusDeserializer(json['status']),
  wasApprovedBySuperAdmin = nativeFromJson<bool>(json['wasApprovedBySuperAdmin']),
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

    final GetCurrentUserUserCurrentBusiness otherTyped = other as GetCurrentUserUserCurrentBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    businessCode == otherTyped.businessCode && 
    descripcion == otherTyped.descripcion && 
    telefono == otherTyped.telefono && 
    latitud == otherTyped.latitud && 
    longitud == otherTyped.longitud && 
    status == otherTyped.status && 
    wasApprovedBySuperAdmin == otherTyped.wasApprovedBySuperAdmin && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, businessCode.hashCode, descripcion.hashCode, telefono.hashCode, latitud.hashCode, longitud.hashCode, status.hashCode, wasApprovedBySuperAdmin.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['ruc'] = nativeToJson<String>(ruc);
    json['businessCode'] = nativeToJson<String>(businessCode);
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
    json['status'] = 
    businessStatusSerializer(status)
    ;
    json['wasApprovedBySuperAdmin'] = nativeToJson<bool>(wasApprovedBySuperAdmin);
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    return json;
  }

  GetCurrentUserUserCurrentBusiness({
    required this.id,
    required this.nombre,
    required this.ruc,
    required this.businessCode,
    this.descripcion,
    this.telefono,
    this.latitud,
    this.longitud,
    required this.status,
    required this.wasApprovedBySuperAdmin,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
  });
}

@immutable
class GetCurrentUserData {
  final GetCurrentUserUser? user;
  GetCurrentUserData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetCurrentUserUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCurrentUserData otherTyped = other as GetCurrentUserData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  GetCurrentUserData({
    this.user,
  });
}

