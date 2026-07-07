part of 'example.dart';

class CreateReviewVariablesBuilder {
  String orderId;
  String businessId;
  Optional<String> _employeeId = Optional.optional(nativeFromJson, nativeToJson);
  int calificacion;
  Optional<String> _comentario = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _appCalificacion = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _appComentario = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateReviewVariablesBuilder employeeId(String? t) {
   _employeeId.value = t;
   return this;
  }
  CreateReviewVariablesBuilder comentario(String? t) {
   _comentario.value = t;
   return this;
  }
  CreateReviewVariablesBuilder appCalificacion(int? t) {
   _appCalificacion.value = t;
   return this;
  }
  CreateReviewVariablesBuilder appComentario(String? t) {
   _appComentario.value = t;
   return this;
  }

  CreateReviewVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.businessId,required  this.calificacion,});
  Deserializer<CreateReviewData> dataDeserializer = (dynamic json)  => CreateReviewData.fromJson(jsonDecode(json));
  Serializer<CreateReviewVariables> varsSerializer = (CreateReviewVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateReviewData, CreateReviewVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateReviewData, CreateReviewVariables> ref() {
    CreateReviewVariables vars= CreateReviewVariables(orderId: orderId,businessId: businessId,employeeId: _employeeId,calificacion: calificacion,comentario: _comentario,appCalificacion: _appCalificacion,appComentario: _appComentario,);
    return _dataConnect.mutation("CreateReview", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateReviewReviewInsert {
  final String id;
  CreateReviewReviewInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateReviewReviewInsert otherTyped = other as CreateReviewReviewInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateReviewReviewInsert({
    required this.id,
  });
}

@immutable
class CreateReviewData {
  final CreateReviewReviewInsert review_insert;
  CreateReviewData.fromJson(dynamic json):
  
  review_insert = CreateReviewReviewInsert.fromJson(json['review_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateReviewData otherTyped = other as CreateReviewData;
    return review_insert == otherTyped.review_insert;
    
  }
  @override
  int get hashCode => review_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['review_insert'] = review_insert.toJson();
    return json;
  }

  CreateReviewData({
    required this.review_insert,
  });
}

@immutable
class CreateReviewVariables {
  final String orderId;
  final String businessId;
  late final Optional<String>employeeId;
  final int calificacion;
  late final Optional<String>comentario;
  late final Optional<int>appCalificacion;
  late final Optional<String>appComentario;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateReviewVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  businessId = nativeFromJson<String>(json['businessId']),
  calificacion = nativeFromJson<int>(json['calificacion']) {
  
  
  
  
    employeeId = Optional.optional(nativeFromJson, nativeToJson);
    employeeId.value = json['employeeId'] == null ? null : nativeFromJson<String>(json['employeeId']);
  
  
  
    comentario = Optional.optional(nativeFromJson, nativeToJson);
    comentario.value = json['comentario'] == null ? null : nativeFromJson<String>(json['comentario']);
  
  
    appCalificacion = Optional.optional(nativeFromJson, nativeToJson);
    appCalificacion.value = json['appCalificacion'] == null ? null : nativeFromJson<int>(json['appCalificacion']);
  
  
    appComentario = Optional.optional(nativeFromJson, nativeToJson);
    appComentario.value = json['appComentario'] == null ? null : nativeFromJson<String>(json['appComentario']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateReviewVariables otherTyped = other as CreateReviewVariables;
    return orderId == otherTyped.orderId && 
    businessId == otherTyped.businessId && 
    employeeId == otherTyped.employeeId && 
    calificacion == otherTyped.calificacion && 
    comentario == otherTyped.comentario && 
    appCalificacion == otherTyped.appCalificacion && 
    appComentario == otherTyped.appComentario;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, businessId.hashCode, employeeId.hashCode, calificacion.hashCode, comentario.hashCode, appCalificacion.hashCode, appComentario.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['businessId'] = nativeToJson<String>(businessId);
    if(employeeId.state == OptionalState.set) {
      json['employeeId'] = employeeId.toJson();
    }
    json['calificacion'] = nativeToJson<int>(calificacion);
    if(comentario.state == OptionalState.set) {
      json['comentario'] = comentario.toJson();
    }
    if(appCalificacion.state == OptionalState.set) {
      json['appCalificacion'] = appCalificacion.toJson();
    }
    if(appComentario.state == OptionalState.set) {
      json['appComentario'] = appComentario.toJson();
    }
    return json;
  }

  CreateReviewVariables({
    required this.orderId,
    required this.businessId,
    required this.employeeId,
    required this.calificacion,
    required this.comentario,
    required this.appCalificacion,
    required this.appComentario,
  });
}

