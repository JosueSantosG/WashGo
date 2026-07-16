part of 'example.dart';

class GetBusinessReviewsVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetBusinessReviewsVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetBusinessReviewsData> dataDeserializer = (dynamic json)  => GetBusinessReviewsData.fromJson(jsonDecode(json));
  Serializer<GetBusinessReviewsVariables> varsSerializer = (GetBusinessReviewsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBusinessReviewsData, GetBusinessReviewsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetBusinessReviewsData, GetBusinessReviewsVariables> ref() {
    GetBusinessReviewsVariables vars= GetBusinessReviewsVariables(businessId: businessId,);
    return _dataConnect.query("GetBusinessReviews", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBusinessReviewsReviews {
  final String id;
  final int calificacion;
  final String? comentario;
  final Timestamp fechaCreacion;
  final GetBusinessReviewsReviewsEmployee? employee;
  GetBusinessReviewsReviews.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  calificacion = nativeFromJson<int>(json['calificacion']),
  comentario = json['comentario'] == null ? null : nativeFromJson<String>(json['comentario']),
  fechaCreacion = Timestamp.fromJson(json['fechaCreacion']),
  employee = json['employee'] == null ? null : GetBusinessReviewsReviewsEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReviewsReviews otherTyped = other as GetBusinessReviewsReviews;
    return id == otherTyped.id && 
    calificacion == otherTyped.calificacion && 
    comentario == otherTyped.comentario && 
    fechaCreacion == otherTyped.fechaCreacion && 
    employee == otherTyped.employee;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, calificacion.hashCode, comentario.hashCode, fechaCreacion.hashCode, employee.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['calificacion'] = nativeToJson<int>(calificacion);
    if (comentario != null) {
      json['comentario'] = nativeToJson<String?>(comentario);
    }
    json['fechaCreacion'] = fechaCreacion.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    return json;
  }

  GetBusinessReviewsReviews({
    required this.id,
    required this.calificacion,
    this.comentario,
    required this.fechaCreacion,
    this.employee,
  });
}

@immutable
class GetBusinessReviewsReviewsEmployee {
  final String id;
  final String nombreCompleto;
  GetBusinessReviewsReviewsEmployee.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReviewsReviewsEmployee otherTyped = other as GetBusinessReviewsReviewsEmployee;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  GetBusinessReviewsReviewsEmployee({
    required this.id,
    required this.nombreCompleto,
  });
}

@immutable
class GetBusinessReviewsData {
  final List<GetBusinessReviewsReviews> reviews;
  GetBusinessReviewsData.fromJson(dynamic json):
  
  reviews = (json['reviews'] as List<dynamic>)
        .map((e) => GetBusinessReviewsReviews.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReviewsData otherTyped = other as GetBusinessReviewsData;
    return reviews == otherTyped.reviews;
    
  }
  @override
  int get hashCode => reviews.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['reviews'] = reviews.map((e) => e.toJson()).toList();
    return json;
  }

  GetBusinessReviewsData({
    required this.reviews,
  });
}

@immutable
class GetBusinessReviewsVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBusinessReviewsVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReviewsVariables otherTyped = other as GetBusinessReviewsVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetBusinessReviewsVariables({
    required this.businessId,
  });
}

