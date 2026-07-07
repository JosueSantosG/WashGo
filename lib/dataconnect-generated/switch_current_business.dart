part of 'example.dart';

class SwitchCurrentBusinessVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  SwitchCurrentBusinessVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<SwitchCurrentBusinessData> dataDeserializer = (dynamic json)  => SwitchCurrentBusinessData.fromJson(jsonDecode(json));
  Serializer<SwitchCurrentBusinessVariables> varsSerializer = (SwitchCurrentBusinessVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SwitchCurrentBusinessData, SwitchCurrentBusinessVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SwitchCurrentBusinessData, SwitchCurrentBusinessVariables> ref() {
    SwitchCurrentBusinessVariables vars= SwitchCurrentBusinessVariables(businessId: businessId,);
    return _dataConnect.mutation("SwitchCurrentBusiness", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SwitchCurrentBusinessUserUpdate {
  final String id;
  SwitchCurrentBusinessUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SwitchCurrentBusinessUserUpdate otherTyped = other as SwitchCurrentBusinessUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SwitchCurrentBusinessUserUpdate({
    required this.id,
  });
}

@immutable
class SwitchCurrentBusinessData {
  final SwitchCurrentBusinessUserUpdate? user_update;
  SwitchCurrentBusinessData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : SwitchCurrentBusinessUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SwitchCurrentBusinessData otherTyped = other as SwitchCurrentBusinessData;
    return user_update == otherTyped.user_update;
    
  }
  @override
  int get hashCode => user_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  SwitchCurrentBusinessData({
    this.user_update,
  });
}

@immutable
class SwitchCurrentBusinessVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SwitchCurrentBusinessVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SwitchCurrentBusinessVariables otherTyped = other as SwitchCurrentBusinessVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  SwitchCurrentBusinessVariables({
    required this.businessId,
  });
}

