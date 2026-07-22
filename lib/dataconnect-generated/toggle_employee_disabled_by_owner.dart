part of 'example.dart';

class ToggleEmployeeDisabledByOwnerVariablesBuilder {
  String businessId;
  String employeeId;
  bool isDisabled;

  final FirebaseDataConnect _dataConnect;
  ToggleEmployeeDisabledByOwnerVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.employeeId,required  this.isDisabled,});
  Deserializer<ToggleEmployeeDisabledByOwnerData> dataDeserializer = (dynamic json)  => ToggleEmployeeDisabledByOwnerData.fromJson(jsonDecode(json));
  Serializer<ToggleEmployeeDisabledByOwnerVariables> varsSerializer = (ToggleEmployeeDisabledByOwnerVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ToggleEmployeeDisabledByOwnerData, ToggleEmployeeDisabledByOwnerVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ToggleEmployeeDisabledByOwnerData, ToggleEmployeeDisabledByOwnerVariables> ref() {
    ToggleEmployeeDisabledByOwnerVariables vars= ToggleEmployeeDisabledByOwnerVariables(businessId: businessId,employeeId: employeeId,isDisabled: isDisabled,);
    return _dataConnect.mutation("ToggleEmployeeDisabledByOwner", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ToggleEmployeeDisabledByOwnerData {
  final int businessEmployee_updateMany;
  ToggleEmployeeDisabledByOwnerData.fromJson(dynamic json):
  
  businessEmployee_updateMany = nativeFromJson<int>(json['businessEmployee_updateMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleEmployeeDisabledByOwnerData otherTyped = other as ToggleEmployeeDisabledByOwnerData;
    return businessEmployee_updateMany == otherTyped.businessEmployee_updateMany;
    
  }
  @override
  int get hashCode => businessEmployee_updateMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessEmployee_updateMany'] = nativeToJson<int>(businessEmployee_updateMany);
    return json;
  }

  ToggleEmployeeDisabledByOwnerData({
    required this.businessEmployee_updateMany,
  });
}

@immutable
class ToggleEmployeeDisabledByOwnerVariables {
  final String businessId;
  final String employeeId;
  final bool isDisabled;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ToggleEmployeeDisabledByOwnerVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  employeeId = nativeFromJson<String>(json['employeeId']),
  isDisabled = nativeFromJson<bool>(json['isDisabled']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ToggleEmployeeDisabledByOwnerVariables otherTyped = other as ToggleEmployeeDisabledByOwnerVariables;
    return businessId == otherTyped.businessId && 
    employeeId == otherTyped.employeeId && 
    isDisabled == otherTyped.isDisabled;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, employeeId.hashCode, isDisabled.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    json['isDisabled'] = nativeToJson<bool>(isDisabled);
    return json;
  }

  ToggleEmployeeDisabledByOwnerVariables({
    required this.businessId,
    required this.employeeId,
    required this.isDisabled,
  });
}

