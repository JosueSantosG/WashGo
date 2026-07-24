part of 'example.dart';

class GetEmployeeBranchesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetEmployeeBranchesVariablesBuilder(this._dataConnect, );
  Deserializer<GetEmployeeBranchesData> dataDeserializer = (dynamic json)  => GetEmployeeBranchesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetEmployeeBranchesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetEmployeeBranchesData, void> ref() {
    
    return _dataConnect.query("GetEmployeeBranches", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetEmployeeBranchesBusinessEmployees {
  final String id;
  final GetEmployeeBranchesBusinessEmployeesBusiness business;
  final EnumValue<EmployeeStatus> status;
  final bool isDisabledByOwner;
  final bool estadoDisponibilidad;
  GetEmployeeBranchesBusinessEmployees.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  business = GetEmployeeBranchesBusinessEmployeesBusiness.fromJson(json['business']),
  status = employeeStatusDeserializer(json['status']),
  isDisabledByOwner = nativeFromJson<bool>(json['isDisabledByOwner']),
  estadoDisponibilidad = nativeFromJson<bool>(json['estadoDisponibilidad']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeBranchesBusinessEmployees otherTyped = other as GetEmployeeBranchesBusinessEmployees;
    return id == otherTyped.id && 
    business == otherTyped.business && 
    status == otherTyped.status && 
    isDisabledByOwner == otherTyped.isDisabledByOwner && 
    estadoDisponibilidad == otherTyped.estadoDisponibilidad;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, business.hashCode, status.hashCode, isDisabledByOwner.hashCode, estadoDisponibilidad.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['business'] = business.toJson();
    json['status'] = 
    employeeStatusSerializer(status)
    ;
    json['isDisabledByOwner'] = nativeToJson<bool>(isDisabledByOwner);
    json['estadoDisponibilidad'] = nativeToJson<bool>(estadoDisponibilidad);
    return json;
  }

  GetEmployeeBranchesBusinessEmployees({
    required this.id,
    required this.business,
    required this.status,
    required this.isDisabledByOwner,
    required this.estadoDisponibilidad,
  });
}

@immutable
class GetEmployeeBranchesBusinessEmployeesBusiness {
  final String id;
  final String nombre;
  final String businessCode;
  final String? descripcion;
  final EnumValue<BusinessStatus> status;
  GetEmployeeBranchesBusinessEmployeesBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  businessCode = nativeFromJson<String>(json['businessCode']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  status = businessStatusDeserializer(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeBranchesBusinessEmployeesBusiness otherTyped = other as GetEmployeeBranchesBusinessEmployeesBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    businessCode == otherTyped.businessCode && 
    descripcion == otherTyped.descripcion && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, businessCode.hashCode, descripcion.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['businessCode'] = nativeToJson<String>(businessCode);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    json['status'] = 
    businessStatusSerializer(status)
    ;
    return json;
  }

  GetEmployeeBranchesBusinessEmployeesBusiness({
    required this.id,
    required this.nombre,
    required this.businessCode,
    this.descripcion,
    required this.status,
  });
}

@immutable
class GetEmployeeBranchesData {
  final List<GetEmployeeBranchesBusinessEmployees> businessEmployees;
  GetEmployeeBranchesData.fromJson(dynamic json):
  
  businessEmployees = (json['businessEmployees'] as List<dynamic>)
        .map((e) => GetEmployeeBranchesBusinessEmployees.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeBranchesData otherTyped = other as GetEmployeeBranchesData;
    return businessEmployees == otherTyped.businessEmployees;
    
  }
  @override
  int get hashCode => businessEmployees.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployees'] = businessEmployees.map((e) => e.toJson()).toList();
    return json;
  }

  GetEmployeeBranchesData({
    required this.businessEmployees,
  });
}

