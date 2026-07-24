part of 'example.dart';

class GetActiveEmployeesVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetActiveEmployeesVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetActiveEmployeesData> dataDeserializer = (dynamic json)  => GetActiveEmployeesData.fromJson(jsonDecode(json));
  Serializer<GetActiveEmployeesVariables> varsSerializer = (GetActiveEmployeesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetActiveEmployeesData, GetActiveEmployeesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetActiveEmployeesData, GetActiveEmployeesVariables> ref() {
    GetActiveEmployeesVariables vars= GetActiveEmployeesVariables(businessId: businessId,);
    return _dataConnect.query("GetActiveEmployees", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetActiveEmployeesBusinessEmployees {
  final String id;
  final GetActiveEmployeesBusinessEmployeesEmployee employee;
  final bool estadoDisponibilidad;
  final bool isDisabledByOwner;
  final Timestamp joinedAt;
  GetActiveEmployeesBusinessEmployees.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  employee = GetActiveEmployeesBusinessEmployeesEmployee.fromJson(json['employee']),
  estadoDisponibilidad = nativeFromJson<bool>(json['estadoDisponibilidad']),
  isDisabledByOwner = nativeFromJson<bool>(json['isDisabledByOwner']),
  joinedAt = Timestamp.fromJson(json['joinedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveEmployeesBusinessEmployees otherTyped = other as GetActiveEmployeesBusinessEmployees;
    return id == otherTyped.id && 
    employee == otherTyped.employee && 
    estadoDisponibilidad == otherTyped.estadoDisponibilidad && 
    isDisabledByOwner == otherTyped.isDisabledByOwner && 
    joinedAt == otherTyped.joinedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, employee.hashCode, estadoDisponibilidad.hashCode, isDisabledByOwner.hashCode, joinedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['employee'] = employee.toJson();
    json['estadoDisponibilidad'] = nativeToJson<bool>(estadoDisponibilidad);
    json['isDisabledByOwner'] = nativeToJson<bool>(isDisabledByOwner);
    json['joinedAt'] = joinedAt.toJson();
    return json;
  }

  GetActiveEmployeesBusinessEmployees({
    required this.id,
    required this.employee,
    required this.estadoDisponibilidad,
    required this.isDisabledByOwner,
    required this.joinedAt,
  });
}

@immutable
class GetActiveEmployeesBusinessEmployeesEmployee {
  final String id;
  final String nombreCompleto;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness? currentBusiness;
  GetActiveEmployeesBusinessEmployeesEmployee.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  email = nativeFromJson<String>(json['email']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  fotoPerfil = json['fotoPerfil'] == null ? null : nativeFromJson<String>(json['fotoPerfil']),
  currentBusiness = json['currentBusiness'] == null ? null : GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness.fromJson(json['currentBusiness']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveEmployeesBusinessEmployeesEmployee otherTyped = other as GetActiveEmployeesBusinessEmployeesEmployee;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    email == otherTyped.email && 
    telefono == otherTyped.telefono && 
    fotoPerfil == otherTyped.fotoPerfil && 
    currentBusiness == otherTyped.currentBusiness;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, email.hashCode, telefono.hashCode, fotoPerfil.hashCode, currentBusiness.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    json['email'] = nativeToJson<String>(email);
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    if (fotoPerfil != null) {
      json['fotoPerfil'] = nativeToJson<String?>(fotoPerfil);
    }
    if (currentBusiness != null) {
      json['currentBusiness'] = currentBusiness!.toJson();
    }
    return json;
  }

  GetActiveEmployeesBusinessEmployeesEmployee({
    required this.id,
    required this.nombreCompleto,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    this.currentBusiness,
  });
}

@immutable
class GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness {
  final String id;
  final String nombre;
  GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness otherTyped = other as GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    return json;
  }

  GetActiveEmployeesBusinessEmployeesEmployeeCurrentBusiness({
    required this.id,
    required this.nombre,
  });
}

@immutable
class GetActiveEmployeesData {
  final List<GetActiveEmployeesBusinessEmployees> businessEmployees;
  GetActiveEmployeesData.fromJson(dynamic json):
  
  businessEmployees = (json['businessEmployees'] as List<dynamic>)
        .map((e) => GetActiveEmployeesBusinessEmployees.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveEmployeesData otherTyped = other as GetActiveEmployeesData;
    return businessEmployees == otherTyped.businessEmployees;
    
  }
  @override
  int get hashCode => businessEmployees.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployees'] = businessEmployees.map((e) => e.toJson()).toList();
    return json;
  }

  GetActiveEmployeesData({
    required this.businessEmployees,
  });
}

@immutable
class GetActiveEmployeesVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetActiveEmployeesVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveEmployeesVariables otherTyped = other as GetActiveEmployeesVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetActiveEmployeesVariables({
    required this.businessId,
  });
}

