part of 'example.dart';

class DeactivateAllEmployeeShiftsVariablesBuilder {
  String employeeId;

  final FirebaseDataConnect _dataConnect;
  DeactivateAllEmployeeShiftsVariablesBuilder(this._dataConnect, {required  this.employeeId,});
  Deserializer<DeactivateAllEmployeeShiftsData> dataDeserializer = (dynamic json)  => DeactivateAllEmployeeShiftsData.fromJson(jsonDecode(json));
  Serializer<DeactivateAllEmployeeShiftsVariables> varsSerializer = (DeactivateAllEmployeeShiftsVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeactivateAllEmployeeShiftsData, DeactivateAllEmployeeShiftsVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeactivateAllEmployeeShiftsData, DeactivateAllEmployeeShiftsVariables> ref() {
    DeactivateAllEmployeeShiftsVariables vars= DeactivateAllEmployeeShiftsVariables(employeeId: employeeId,);
    return _dataConnect.mutation("DeactivateAllEmployeeShifts", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeactivateAllEmployeeShiftsData {
  final int businessEmployee_updateMany;
  DeactivateAllEmployeeShiftsData.fromJson(dynamic json):
  
  businessEmployee_updateMany = nativeFromJson<int>(json['businessEmployee_updateMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeactivateAllEmployeeShiftsData otherTyped = other as DeactivateAllEmployeeShiftsData;
    return businessEmployee_updateMany == otherTyped.businessEmployee_updateMany;
    
  }
  @override
  int get hashCode => businessEmployee_updateMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployee_updateMany'] = nativeToJson<int>(businessEmployee_updateMany);
    return json;
  }

  DeactivateAllEmployeeShiftsData({
    required this.businessEmployee_updateMany,
  });
}

@immutable
class DeactivateAllEmployeeShiftsVariables {
  final String employeeId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeactivateAllEmployeeShiftsVariables.fromJson(Map<String, dynamic> json):
  
  employeeId = nativeFromJson<String>(json['employeeId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeactivateAllEmployeeShiftsVariables otherTyped = other as DeactivateAllEmployeeShiftsVariables;
    return employeeId == otherTyped.employeeId;
    
  }
  @override
  int get hashCode => employeeId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['employeeId'] = nativeToJson<String>(employeeId);
    return json;
  }

  DeactivateAllEmployeeShiftsVariables({
    required this.employeeId,
  });
}

