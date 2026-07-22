part of 'example.dart';

class OwnerUpdateBusinessStatusVariablesBuilder {
  String id;
  BusinessStatus status;

  final FirebaseDataConnect _dataConnect;
  OwnerUpdateBusinessStatusVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<OwnerUpdateBusinessStatusData> dataDeserializer = (dynamic json)  => OwnerUpdateBusinessStatusData.fromJson(jsonDecode(json));
  Serializer<OwnerUpdateBusinessStatusVariables> varsSerializer = (OwnerUpdateBusinessStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<OwnerUpdateBusinessStatusData, OwnerUpdateBusinessStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<OwnerUpdateBusinessStatusData, OwnerUpdateBusinessStatusVariables> ref() {
    OwnerUpdateBusinessStatusVariables vars= OwnerUpdateBusinessStatusVariables(id: id,status: status,);
    return _dataConnect.mutation("OwnerUpdateBusinessStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class OwnerUpdateBusinessStatusBusinessUpdate {
  final String id;
  OwnerUpdateBusinessStatusBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final OwnerUpdateBusinessStatusBusinessUpdate otherTyped = other as OwnerUpdateBusinessStatusBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  OwnerUpdateBusinessStatusBusinessUpdate({
    required this.id,
  });
}

@immutable
class OwnerUpdateBusinessStatusData {
  final OwnerUpdateBusinessStatusBusinessUpdate? business_update;
  OwnerUpdateBusinessStatusData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : OwnerUpdateBusinessStatusBusinessUpdate.fromJson(json['business_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final OwnerUpdateBusinessStatusData otherTyped = other as OwnerUpdateBusinessStatusData;
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

  OwnerUpdateBusinessStatusData({
    this.business_update,
  });
}

@immutable
class OwnerUpdateBusinessStatusVariables {
  final String id;
  final BusinessStatus status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  OwnerUpdateBusinessStatusVariables.fromJson(Map<String, dynamic> json):
  
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

    final OwnerUpdateBusinessStatusVariables otherTyped = other as OwnerUpdateBusinessStatusVariables;
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

  OwnerUpdateBusinessStatusVariables({
    required this.id,
    required this.status,
  });
}

