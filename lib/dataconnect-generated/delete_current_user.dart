part of 'example.dart';

class DeleteCurrentUserVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  DeleteCurrentUserVariablesBuilder(this._dataConnect, );
  Deserializer<DeleteCurrentUserData> dataDeserializer = (dynamic json)  => DeleteCurrentUserData.fromJson(jsonDecode(json));
  
  Future<OperationResult<DeleteCurrentUserData, void>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteCurrentUserData, void> ref() {
    
    return _dataConnect.mutation("DeleteCurrentUser", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class DeleteCurrentUserUserDelete {
  final String id;
  DeleteCurrentUserUserDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrentUserUserDelete otherTyped = other as DeleteCurrentUserUserDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCurrentUserUserDelete({
    required this.id,
  });
}

@immutable
class DeleteCurrentUserData {
  final DeleteCurrentUserUserDelete? user_delete;
  DeleteCurrentUserData.fromJson(dynamic json):
  
  user_delete = json['user_delete'] == null ? null : DeleteCurrentUserUserDelete.fromJson(json['user_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrentUserData otherTyped = other as DeleteCurrentUserData;
    return user_delete == otherTyped.user_delete;
    
  }
  @override
  int get hashCode => user_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_delete != null) {
      json['user_delete'] = user_delete!.toJson();
    }
    return json;
  }

  DeleteCurrentUserData({
    this.user_delete,
  });
}

