part of 'example.dart';

class DeleteServiceVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteServiceVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteServiceData> dataDeserializer = (dynamic json)  => DeleteServiceData.fromJson(jsonDecode(json));
  Serializer<DeleteServiceVariables> varsSerializer = (DeleteServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteServiceData, DeleteServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteServiceData, DeleteServiceVariables> ref() {
    DeleteServiceVariables vars= DeleteServiceVariables(id: id,);
    return _dataConnect.mutation("DeleteService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteServiceServiceDelete {
  final String id;
  DeleteServiceServiceDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteServiceServiceDelete otherTyped = other as DeleteServiceServiceDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteServiceServiceDelete({
    required this.id,
  });
}

@immutable
class DeleteServiceData {
  final DeleteServiceServiceDelete? service_delete;
  DeleteServiceData.fromJson(dynamic json):
  
  service_delete = json['service_delete'] == null ? null : DeleteServiceServiceDelete.fromJson(json['service_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteServiceData otherTyped = other as DeleteServiceData;
    return service_delete == otherTyped.service_delete;
    
  }
  @override
  int get hashCode => service_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (service_delete != null) {
      json['service_delete'] = service_delete!.toJson();
    }
    return json;
  }

  DeleteServiceData({
    this.service_delete,
  });
}

@immutable
class DeleteServiceVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteServiceVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteServiceVariables otherTyped = other as DeleteServiceVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteServiceVariables({
    required this.id,
  });
}

