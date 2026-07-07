part of 'example.dart';

class CreateNotificationVariablesBuilder {
  String userId;
  String titulo;
  String mensaje;

  final FirebaseDataConnect _dataConnect;
  CreateNotificationVariablesBuilder(this._dataConnect, {required  this.userId,required  this.titulo,required  this.mensaje,});
  Deserializer<CreateNotificationData> dataDeserializer = (dynamic json)  => CreateNotificationData.fromJson(jsonDecode(json));
  Serializer<CreateNotificationVariables> varsSerializer = (CreateNotificationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateNotificationData, CreateNotificationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateNotificationData, CreateNotificationVariables> ref() {
    CreateNotificationVariables vars= CreateNotificationVariables(userId: userId,titulo: titulo,mensaje: mensaje,);
    return _dataConnect.mutation("CreateNotification", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateNotificationNotificationInsert {
  final String id;
  CreateNotificationNotificationInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNotificationNotificationInsert otherTyped = other as CreateNotificationNotificationInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateNotificationNotificationInsert({
    required this.id,
  });
}

@immutable
class CreateNotificationData {
  final CreateNotificationNotificationInsert notification_insert;
  CreateNotificationData.fromJson(dynamic json):
  
  notification_insert = CreateNotificationNotificationInsert.fromJson(json['notification_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateNotificationData otherTyped = other as CreateNotificationData;
    return notification_insert == otherTyped.notification_insert;
    
  }
  @override
  int get hashCode => notification_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['notification_insert'] = notification_insert.toJson();
    return json;
  }

  CreateNotificationData({
    required this.notification_insert,
  });
}

@immutable
class CreateNotificationVariables {
  final String userId;
  final String titulo;
  final String mensaje;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateNotificationVariables.fromJson(Map<String, dynamic> json):
  
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

    final CreateNotificationVariables otherTyped = other as CreateNotificationVariables;
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

  CreateNotificationVariables({
    required this.userId,
    required this.titulo,
    required this.mensaje,
  });
}

