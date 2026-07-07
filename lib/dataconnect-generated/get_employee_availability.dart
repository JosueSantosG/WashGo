part of 'example.dart';

class GetEmployeeAvailabilityVariablesBuilder {
  String businessId;
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  GetEmployeeAvailabilityVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.employeeId,});
  Deserializer<GetEmployeeAvailabilityData> dataDeserializer = (dynamic json)  => GetEmployeeAvailabilityData.fromJson(jsonDecode(json));
  Serializer<GetEmployeeAvailabilityVariables> varsSerializer = (GetEmployeeAvailabilityVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetEmployeeAvailabilityData, GetEmployeeAvailabilityVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetEmployeeAvailabilityData, GetEmployeeAvailabilityVariables> ref() {
    GetEmployeeAvailabilityVariables vars= GetEmployeeAvailabilityVariables(businessId: businessId,employeeId: employeeId,);
    return _dataConnect.query("GetEmployeeAvailability", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetEmployeeAvailabilityBusinessEmployees {
  final String id;
  final bool estadoDisponibilidad;
  GetEmployeeAvailabilityBusinessEmployees.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  estadoDisponibilidad = nativeFromJson<bool>(json['estadoDisponibilidad']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeAvailabilityBusinessEmployees otherTyped = other as GetEmployeeAvailabilityBusinessEmployees;
    return id == otherTyped.id && 
    estadoDisponibilidad == otherTyped.estadoDisponibilidad;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, estadoDisponibilidad.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['estadoDisponibilidad'] = nativeToJson<bool>(estadoDisponibilidad);
    return json;
  }

  GetEmployeeAvailabilityBusinessEmployees({
    required this.id,
    required this.estadoDisponibilidad,
  });
}

@immutable
class GetEmployeeAvailabilityData {
  final List<GetEmployeeAvailabilityBusinessEmployees> businessEmployees;
  GetEmployeeAvailabilityData.fromJson(dynamic json):
  
  businessEmployees = (json['businessEmployees'] as List<dynamic>)
        .map((e) => GetEmployeeAvailabilityBusinessEmployees.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeAvailabilityData otherTyped = other as GetEmployeeAvailabilityData;
    return businessEmployees == otherTyped.businessEmployees;
    
  }
  @override
  int get hashCode => businessEmployees.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployees'] = businessEmployees.map((e) => e.toJson()).toList();
    return json;
  }

  GetEmployeeAvailabilityData({
    required this.businessEmployees,
  });
}

@immutable
class GetEmployeeAvailabilityVariables {
  final String businessId;
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetEmployeeAvailabilityVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  employeeId = nativeFromJson<String>(json['employeeId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeAvailabilityVariables otherTyped = other as GetEmployeeAvailabilityVariables;
    return businessId == otherTyped.businessId && 
    employeeId == otherTyped.employeeId;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, employeeId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    return json;
  }

  GetEmployeeAvailabilityVariables({
    required this.businessId,
    required this.employeeId,
  });
}

