part of 'example.dart';

class DeleteBusinessHoursVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  DeleteBusinessHoursVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<DeleteBusinessHoursData> dataDeserializer = (dynamic json)  => DeleteBusinessHoursData.fromJson(jsonDecode(json));
  Serializer<DeleteBusinessHoursVariables> varsSerializer = (DeleteBusinessHoursVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteBusinessHoursData, DeleteBusinessHoursVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteBusinessHoursData, DeleteBusinessHoursVariables> ref() {
    DeleteBusinessHoursVariables vars= DeleteBusinessHoursVariables(businessId: businessId,);
    return _dataConnect.mutation("DeleteBusinessHours", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteBusinessHoursData {
  final int businessHour_deleteMany;
  DeleteBusinessHoursData.fromJson(dynamic json):
  
  businessHour_deleteMany = nativeFromJson<int>(json['businessHour_deleteMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteBusinessHoursData otherTyped = other as DeleteBusinessHoursData;
    return businessHour_deleteMany == otherTyped.businessHour_deleteMany;
    
  }
  @override
  int get hashCode => businessHour_deleteMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessHour_deleteMany'] = nativeToJson<int>(businessHour_deleteMany);
    return json;
  }

  DeleteBusinessHoursData({
    required this.businessHour_deleteMany,
  });
}

@immutable
class DeleteBusinessHoursVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteBusinessHoursVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteBusinessHoursVariables otherTyped = other as DeleteBusinessHoursVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  DeleteBusinessHoursVariables({
    required this.businessId,
  });
}

