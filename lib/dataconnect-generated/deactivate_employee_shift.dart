part of 'example.dart';

class DeactivateEmployeeShiftVariablesBuilder {
  String businessId;
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  DeactivateEmployeeShiftVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.employeeId,});
  Deserializer<DeactivateEmployeeShiftData> dataDeserializer = (dynamic json)  => DeactivateEmployeeShiftData.fromJson(jsonDecode(json));
  Serializer<DeactivateEmployeeShiftVariables> varsSerializer = (DeactivateEmployeeShiftVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeactivateEmployeeShiftData, DeactivateEmployeeShiftVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeactivateEmployeeShiftData, DeactivateEmployeeShiftVariables> ref() {
    DeactivateEmployeeShiftVariables vars= DeactivateEmployeeShiftVariables(businessId: businessId,employeeId: employeeId,);
    return _dataConnect.mutation("DeactivateEmployeeShift", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeactivateEmployeeShiftData {
  final int businessEmployee_updateMany;
  DeactivateEmployeeShiftData.fromJson(dynamic json):
  
  businessEmployee_updateMany = nativeFromJson<int>(json['businessEmployee_updateMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeactivateEmployeeShiftData otherTyped = other as DeactivateEmployeeShiftData;
    return businessEmployee_updateMany == otherTyped.businessEmployee_updateMany;
    
  }
  @override
  int get hashCode => businessEmployee_updateMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployee_updateMany'] = nativeToJson<int>(businessEmployee_updateMany);
    return json;
  }

  DeactivateEmployeeShiftData({
    required this.businessEmployee_updateMany,
  });
}

@immutable
class DeactivateEmployeeShiftVariables {
  final String businessId;
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeactivateEmployeeShiftVariables.fromJson(Map<String, dynamic> json):
  
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

    final DeactivateEmployeeShiftVariables otherTyped = other as DeactivateEmployeeShiftVariables;
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

  DeactivateEmployeeShiftVariables({
    required this.businessId,
    required this.employeeId,
  });
}

