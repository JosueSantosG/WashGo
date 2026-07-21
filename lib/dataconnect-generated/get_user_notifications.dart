part of 'example.dart';

class GetUserNotificationsVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetUserNotificationsVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetUserNotificationsData> dataDeserializer = (dynamic json)  => GetUserNotificationsData.fromJson(jsonDecode(json));
  Serializer<GetUserNotificationsVariables> varsSerializer = (GetUserNotificationsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserNotificationsData, GetUserNotificationsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetUserNotificationsData, GetUserNotificationsVariables> ref() {
    GetUserNotificationsVariables vars= GetUserNotificationsVariables(userId: userId,);
    return _dataConnect.query("GetUserNotifications", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUserNotificationsNotifications {
  final String id;
  final String titulo;
  final String mensaje;
  final bool leida;
  final Timestamp fechaCreacion;
  GetUserNotificationsNotifications.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  titulo = nativeFromJson<String>(json['titulo']),
  mensaje = nativeFromJson<String>(json['mensaje']),
  leida = nativeFromJson<bool>(json['leida']),
  fechaCreacion = Timestamp.fromJson(json['fechaCreacion']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserNotificationsNotifications otherTyped = other as GetUserNotificationsNotifications;
    return id == otherTyped.id && 
    titulo == otherTyped.titulo && 
    mensaje == otherTyped.mensaje && 
    leida == otherTyped.leida && 
    fechaCreacion == otherTyped.fechaCreacion;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, titulo.hashCode, mensaje.hashCode, leida.hashCode, fechaCreacion.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['titulo'] = nativeToJson<String>(titulo);
    json['mensaje'] = nativeToJson<String>(mensaje);
    json['leida'] = nativeToJson<bool>(leida);
    json['fechaCreacion'] = fechaCreacion.toJson();
    return json;
  }

  GetUserNotificationsNotifications({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.leida,
    required this.fechaCreacion,
  });
}

@immutable
class GetUserNotificationsData {
  final List<GetUserNotificationsNotifications> notifications;
  GetUserNotificationsData.fromJson(dynamic json):
  
  notifications = (json['notifications'] as List<dynamic>)
        .map((e) => GetUserNotificationsNotifications.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserNotificationsData otherTyped = other as GetUserNotificationsData;
    return notifications == otherTyped.notifications;
    
  }
  @override
  int get hashCode => notifications.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['notifications'] = notifications.map((e) => e.toJson()).toList();
    return json;
  }

  GetUserNotificationsData({
    required this.notifications,
  });
}

@immutable
class GetUserNotificationsVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUserNotificationsVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserNotificationsVariables otherTyped = other as GetUserNotificationsVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetUserNotificationsVariables({
    required this.userId,
  });
}

