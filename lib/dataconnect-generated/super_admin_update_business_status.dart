part of 'example.dart';

class SuperAdminUpdateBusinessStatusVariablesBuilder {
  String id;
  BusinessStatus status;

  final FirebaseDataConnect _dataConnect;
  SuperAdminUpdateBusinessStatusVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<SuperAdminUpdateBusinessStatusData> dataDeserializer = (dynamic json)  => SuperAdminUpdateBusinessStatusData.fromJson(jsonDecode(json));
  Serializer<SuperAdminUpdateBusinessStatusVariables> varsSerializer = (SuperAdminUpdateBusinessStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SuperAdminUpdateBusinessStatusData, SuperAdminUpdateBusinessStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SuperAdminUpdateBusinessStatusData, SuperAdminUpdateBusinessStatusVariables> ref() {
    SuperAdminUpdateBusinessStatusVariables vars= SuperAdminUpdateBusinessStatusVariables(id: id,status: status,);
    return _dataConnect.mutation("SuperAdminUpdateBusinessStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SuperAdminUpdateBusinessStatusBusinessUpdate {
  final String id;
  SuperAdminUpdateBusinessStatusBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminUpdateBusinessStatusBusinessUpdate otherTyped = other as SuperAdminUpdateBusinessStatusBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SuperAdminUpdateBusinessStatusBusinessUpdate({
    required this.id,
  });
}

@immutable
class SuperAdminUpdateBusinessStatusData {
  final SuperAdminUpdateBusinessStatusBusinessUpdate? business_update;
  SuperAdminUpdateBusinessStatusData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : SuperAdminUpdateBusinessStatusBusinessUpdate.fromJson(json['business_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminUpdateBusinessStatusData otherTyped = other as SuperAdminUpdateBusinessStatusData;
    return business_update == otherTyped.business_update;
    
  }
  @override
  int get hashCode => business_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (business_update != null) {
      json['business_update'] = business_update!.toJson();
    }
    return json;
  }

  SuperAdminUpdateBusinessStatusData({
    this.business_update,
  });
}

@immutable
class SuperAdminUpdateBusinessStatusVariables {
  final String id;
  final BusinessStatus status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SuperAdminUpdateBusinessStatusVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  status = BusinessStatus.values.byName(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminUpdateBusinessStatusVariables otherTyped = other as SuperAdminUpdateBusinessStatusVariables;
    return id == otherTyped.id && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = 
    status.name
    ;
    return json;
  }

  SuperAdminUpdateBusinessStatusVariables({
    required this.id,
    required this.status,
  });
}

