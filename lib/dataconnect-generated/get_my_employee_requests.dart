part of 'example.dart';

class GetMyEmployeeRequestsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyEmployeeRequestsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyEmployeeRequestsData> dataDeserializer = (dynamic json)  => GetMyEmployeeRequestsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyEmployeeRequestsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyEmployeeRequestsData, void> ref() {
    
    return _dataConnect.query("GetMyEmployeeRequests", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyEmployeeRequestsEmployeeRequests {
  final String id;
  final GetMyEmployeeRequestsEmployeeRequestsBusiness business;
  final EnumValue<EmployeeStatus> status;
  final Timestamp createdAt;
  GetMyEmployeeRequestsEmployeeRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  business = GetMyEmployeeRequestsEmployeeRequestsBusiness.fromJson(json['business']),
  status = employeeStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyEmployeeRequestsEmployeeRequests otherTyped = other as GetMyEmployeeRequestsEmployeeRequests;
    return id == otherTyped.id && 
    business == otherTyped.business && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, business.hashCode, status.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['business'] = business.toJson();
    json['status'] = 
    employeeStatusSerializer(status)
    ;
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetMyEmployeeRequestsEmployeeRequests({
    required this.id,
    required this.business,
    required this.status,
    required this.createdAt,
  });
}

@immutable
class GetMyEmployeeRequestsEmployeeRequestsBusiness {
  final String id;
  final String nombre;
  final String businessCode;
  final String? descripcion;
  GetMyEmployeeRequestsEmployeeRequestsBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  businessCode = nativeFromJson<String>(json['businessCode']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyEmployeeRequestsEmployeeRequestsBusiness otherTyped = other as GetMyEmployeeRequestsEmployeeRequestsBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    businessCode == otherTyped.businessCode && 
    descripcion == otherTyped.descripcion;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, businessCode.hashCode, descripcion.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['businessCode'] = nativeToJson<String>(businessCode);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    return json;
  }

  GetMyEmployeeRequestsEmployeeRequestsBusiness({
    required this.id,
    required this.nombre,
    required this.businessCode,
    this.descripcion,
  });
}

@immutable
class GetMyEmployeeRequestsData {
  final List<GetMyEmployeeRequestsEmployeeRequests> employeeRequests;
  GetMyEmployeeRequestsData.fromJson(dynamic json):
  
  employeeRequests = (json['employeeRequests'] as List<dynamic>)
        .map((e) => GetMyEmployeeRequestsEmployeeRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyEmployeeRequestsData otherTyped = other as GetMyEmployeeRequestsData;
    return employeeRequests == otherTyped.employeeRequests;
    
  }
  @override
  int get hashCode => employeeRequests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['employeeRequests'] = employeeRequests.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyEmployeeRequestsData({
    required this.employeeRequests,
  });
}

