part of 'example.dart';

class CreateSystemNotificationVariablesBuilder {
  String userId;
  String titulo;
  String mensaje;

  final FirebaseDataConnect _dataConnect;
  CreateSystemNotificationVariablesBuilder(this._dataConnect, {required  this.userId,required  this.titulo,required  this.mensaje,});
  Deserializer<CreateSystemNotificationData> dataDeserializer = (dynamic json)  => CreateSystemNotificationData.fromJson(jsonDecode(json));
  Serializer<CreateSystemNotificationVariables> varsSerializer = (CreateSystemNotificationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateSystemNotificationData, CreateSystemNotificationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateSystemNotificationData, CreateSystemNotificationVariables> ref() {
    CreateSystemNotificationVariables vars= CreateSystemNotificationVariables(userId: userId,titulo: titulo,mensaje: mensaje,);
    return _dataConnect.mutation("CreateSystemNotification", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateSystemNotificationNotificationInsert {
  final String id;
  CreateSystemNotificationNotificationInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSystemNotificationNotificationInsert otherTyped = other as CreateSystemNotificationNotificationInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateSystemNotificationNotificationInsert({
    required this.id,
  });
}

@immutable
class CreateSystemNotificationData {
  final CreateSystemNotificationNotificationInsert notification_insert;
  CreateSystemNotificationData.fromJson(dynamic json):
  
  notification_insert = CreateSystemNotificationNotificationInsert.fromJson(json['notification_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSystemNotificationData otherTyped = other as CreateSystemNotificationData;
    return notification_insert == otherTyped.notification_insert;
    
  }
  @override
  int get hashCode => notification_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['notification_insert'] = notification_insert.toJson();
    return json;
  }

  CreateSystemNotificationData({
    required this.notification_insert,
  });
}

@immutable
class CreateSystemNotificationVariables {
  final String userId;
  final String titulo;
  final String mensaje;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateSystemNotificationVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']),
  titulo = nativeFromJson<String>(json['titulo']),
  mensaje = nativeFromJson<String>(json['mensaje']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateSystemNotificationVariables otherTyped = other as CreateSystemNotificationVariables;
    return userId == otherTyped.userId && 
    titulo == otherTyped.titulo && 
    mensaje == otherTyped.mensaje;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, titulo.hashCode, mensaje.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['titulo'] = nativeToJson<String>(titulo);
    json['mensaje'] = nativeToJson<String>(mensaje);
    return json;
  }

  CreateSystemNotificationVariables({
    required this.userId,
    required this.titulo,
    required this.mensaje,
  });
}

