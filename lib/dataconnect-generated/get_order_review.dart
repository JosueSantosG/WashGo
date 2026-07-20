part of 'example.dart';

class GetOrderReviewVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetOrderReviewVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetOrderReviewData> dataDeserializer = (dynamic json)  => GetOrderReviewData.fromJson(jsonDecode(json));
  Serializer<GetOrderReviewVariables> varsSerializer = (GetOrderReviewVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetOrderReviewData, GetOrderReviewVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetOrderReviewData, GetOrderReviewVariables> ref() {
    GetOrderReviewVariables vars= GetOrderReviewVariables(orderId: orderId,);
    return _dataConnect.query("GetOrderReview", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetOrderReviewReviews {
  final String id;
  final int calificacion;
  final String? comentario;
  final int? appCalificacion;
  final String? appComentario;
  final Timestamp fechaCreacion;
  GetOrderReviewReviews.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  calificacion = nativeFromJson<int>(json['calificacion']),
  comentario = json['comentario'] == null ? null : nativeFromJson<String>(json['comentario']),
  appCalificacion = json['appCalificacion'] == null ? null : nativeFromJson<int>(json['appCalificacion']),
  appComentario = json['appComentario'] == null ? null : nativeFromJson<String>(json['appComentario']),
  fechaCreacion = Timestamp.fromJson(json['fechaCreacion']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderReviewReviews otherTyped = other as GetOrderReviewReviews;
    return id == otherTyped.id && 
    calificacion == otherTyped.calificacion && 
    comentario == otherTyped.comentario && 
    appCalificacion == otherTyped.appCalificacion && 
    appComentario == otherTyped.appComentario && 
    fechaCreacion == otherTyped.fechaCreacion;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, calificacion.hashCode, comentario.hashCode, appCalificacion.hashCode, appComentario.hashCode, fechaCreacion.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['calificacion'] = nativeToJson<int>(calificacion);
    if (comentario != null) {
      json['comentario'] = nativeToJson<String?>(comentario);
    }
    if (appCalificacion != null) {
      json['appCalificacion'] = nativeToJson<int?>(appCalificacion);
    }
    if (appComentario != null) {
      json['appComentario'] = nativeToJson<String?>(appComentario);
    }
    json['fechaCreacion'] = fechaCreacion.toJson();
    return json;
  }

  GetOrderReviewReviews({
    required this.id,
    required this.calificacion,
    this.comentario,
    this.appCalificacion,
    this.appComentario,
    required this.fechaCreacion,
  });
}

@immutable
class GetOrderReviewData {
  final List<GetOrderReviewReviews> reviews;
  GetOrderReviewData.fromJson(dynamic json):
  
  reviews = (json['reviews'] as List<dynamic>)
        .map((e) => GetOrderReviewReviews.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderReviewData otherTyped = other as GetOrderReviewData;
    return reviews == otherTyped.reviews;
    
  }
  @override
  int get hashCode => reviews.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['reviews'] = reviews.map((e) => e.toJson()).toList();
    return json;
  }

  GetOrderReviewData({
    required this.reviews,
  });
}

@immutable
class GetOrderReviewVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetOrderReviewVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderReviewVariables otherTyped = other as GetOrderReviewVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetOrderReviewVariables({
    required this.orderId,
  });
}

