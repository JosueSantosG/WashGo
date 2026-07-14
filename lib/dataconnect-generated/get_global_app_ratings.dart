part of 'example.dart';

class GetGlobalAppRatingsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetGlobalAppRatingsVariablesBuilder(this._dataConnect, );
  Deserializer<GetGlobalAppRatingsData> dataDeserializer = (dynamic json)  => GetGlobalAppRatingsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetGlobalAppRatingsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetGlobalAppRatingsData, void> ref() {
    
    return _dataConnect.query("GetGlobalAppRatings", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetGlobalAppRatingsReviews {
  final String id;
  final int? appCalificacion;
  final String? appComentario;
  final Timestamp fechaCreacion;
  GetGlobalAppRatingsReviews.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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

    final GetGlobalAppRatingsReviews otherTyped = other as GetGlobalAppRatingsReviews;
    return id == otherTyped.id && 
    appCalificacion == otherTyped.appCalificacion && 
    appComentario == otherTyped.appComentario && 
    fechaCreacion == otherTyped.fechaCreacion;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, appCalificacion.hashCode, appComentario.hashCode, fechaCreacion.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (appCalificacion != null) {
      json['appCalificacion'] = nativeToJson<int?>(appCalificacion);
    }
    if (appComentario != null) {
      json['appComentario'] = nativeToJson<String?>(appComentario);
    }
    json['fechaCreacion'] = fechaCreacion.toJson();
    return json;
  }

  GetGlobalAppRatingsReviews({
    required this.id,
    this.appCalificacion,
    this.appComentario,
    required this.fechaCreacion,
  });
}

@immutable
class GetGlobalAppRatingsData {
  final List<GetGlobalAppRatingsReviews> reviews;
  GetGlobalAppRatingsData.fromJson(dynamic json):
  
  reviews = (json['reviews'] as List<dynamic>)
        .map((e) => GetGlobalAppRatingsReviews.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetGlobalAppRatingsData otherTyped = other as GetGlobalAppRatingsData;
    return reviews == otherTyped.reviews;
    
  }
  @override
  int get hashCode => reviews.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['reviews'] = reviews.map((e) => e.toJson()).toList();
    return json;
  }

  GetGlobalAppRatingsData({
    required this.reviews,
  });
}

