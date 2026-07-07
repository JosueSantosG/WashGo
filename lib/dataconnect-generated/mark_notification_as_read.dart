part of 'example.dart';

class MarkNotificationAsReadVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  MarkNotificationAsReadVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<MarkNotificationAsReadData> dataDeserializer = (dynamic json)  => MarkNotificationAsReadData.fromJson(jsonDecode(json));
  Serializer<MarkNotificationAsReadVariables> varsSerializer = (MarkNotificationAsReadVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<MarkNotificationAsReadData, MarkNotificationAsReadVariables>> execute() {
    return ref().execute();
  }

  MutationRef<MarkNotificationAsReadData, MarkNotificationAsReadVariables> ref() {
    MarkNotificationAsReadVariables vars= MarkNotificationAsReadVariables(id: id,);
    return _dataConnect.mutation("MarkNotificationAsRead", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class MarkNotificationAsReadNotificationUpdate {
  final String id;
  MarkNotificationAsReadNotificationUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final MarkNotificationAsReadNotificationUpdate otherTyped = other as MarkNotificationAsReadNotificationUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  MarkNotificationAsReadNotificationUpdate({
    required this.id,
  });
}

@immutable
class MarkNotificationAsReadData {
  final MarkNotificationAsReadNotificationUpdate? notification_update;
  MarkNotificationAsReadData.fromJson(dynamic json):
  
  notification_update = json['notification_update'] == null ? null : MarkNotificationAsReadNotificationUpdate.fromJson(json['notification_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final MarkNotificationAsReadData otherTyped = other as MarkNotificationAsReadData;
    return notification_update == otherTyped.notification_update;
    
  }
  @override
  int get hashCode => notification_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (notification_update != null) {
      json['notification_update'] = notification_update!.toJson();
    }
    return json;
  }

  MarkNotificationAsReadData({
    this.notification_update,
  });
}

@immutable
class MarkNotificationAsReadVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  MarkNotificationAsReadVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final MarkNotificationAsReadVariables otherTyped = other as MarkNotificationAsReadVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  MarkNotificationAsReadVariables({
    required this.id,
  });
}

