part of 'example.dart';

class CreateBusinessHourVariablesBuilder {
  String businessId;
  int diaDeLaSemana;
  Optional<String> _horaApertura = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _horaCierre = Optional.optional(nativeFromJson, nativeToJson);
  bool esDiaDescanso;

  final FirebaseDataConnect _dataConnect;  CreateBusinessHourVariablesBuilder horaApertura(String? t) {
   _horaApertura.value = t;
   return this;
  }
  CreateBusinessHourVariablesBuilder horaCierre(String? t) {
   _horaCierre.value = t;
   return this;
  }

  CreateBusinessHourVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.diaDeLaSemana,required  this.esDiaDescanso,});
  Deserializer<CreateBusinessHourData> dataDeserializer = (dynamic json)  => CreateBusinessHourData.fromJson(jsonDecode(json));
  Serializer<CreateBusinessHourVariables> varsSerializer = (CreateBusinessHourVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateBusinessHourData, CreateBusinessHourVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateBusinessHourData, CreateBusinessHourVariables> ref() {
    CreateBusinessHourVariables vars= CreateBusinessHourVariables(businessId: businessId,diaDeLaSemana: diaDeLaSemana,horaApertura: _horaApertura,horaCierre: _horaCierre,esDiaDescanso: esDiaDescanso,);
    return _dataConnect.mutation("CreateBusinessHour", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateBusinessHourBusinessHourInsert {
  final String id;
  CreateBusinessHourBusinessHourInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessHourBusinessHourInsert otherTyped = other as CreateBusinessHourBusinessHourInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateBusinessHourBusinessHourInsert({
    required this.id,
  });
}

@immutable
class CreateBusinessHourData {
  final CreateBusinessHourBusinessHourInsert businessHour_insert;
  CreateBusinessHourData.fromJson(dynamic json):
  
  businessHour_insert = CreateBusinessHourBusinessHourInsert.fromJson(json['businessHour_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessHourData otherTyped = other as CreateBusinessHourData;
    return businessHour_insert == otherTyped.businessHour_insert;
    
  }
  @override
  int get hashCode => businessHour_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessHour_insert'] = businessHour_insert.toJson();
    return json;
  }

  CreateBusinessHourData({
    required this.businessHour_insert,
  });
}

@immutable
class CreateBusinessHourVariables {
  final String businessId;
  final int diaDeLaSemana;
  late final Optional<String>horaApertura;
  late final Optional<String>horaCierre;
  final bool esDiaDescanso;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateBusinessHourVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  diaDeLaSemana = nativeFromJson<int>(json['diaDeLaSemana']),
  esDiaDescanso = nativeFromJson<bool>(json['esDiaDescanso']) {
  
  
  
  
    horaApertura = Optional.optional(nativeFromJson, nativeToJson);
    horaApertura.value = json['horaApertura'] == null ? null : nativeFromJson<String>(json['horaApertura']);
  
  
    horaCierre = Optional.optional(nativeFromJson, nativeToJson);
    horaCierre.value = json['horaCierre'] == null ? null : nativeFromJson<String>(json['horaCierre']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessHourVariables otherTyped = other as CreateBusinessHourVariables;
    return businessId == otherTyped.businessId && 
    diaDeLaSemana == otherTyped.diaDeLaSemana && 
    horaApertura == otherTyped.horaApertura && 
    horaCierre == otherTyped.horaCierre && 
    esDiaDescanso == otherTyped.esDiaDescanso;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, diaDeLaSemana.hashCode, horaApertura.hashCode, horaCierre.hashCode, esDiaDescanso.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['diaDeLaSemana'] = nativeToJson<int>(diaDeLaSemana);
    if(horaApertura.state == OptionalState.set) {
      json['horaApertura'] = horaApertura.toJson();
    }
    if(horaCierre.state == OptionalState.set) {
      json['horaCierre'] = horaCierre.toJson();
    }
    json['esDiaDescanso'] = nativeToJson<bool>(esDiaDescanso);
    return json;
  }

  CreateBusinessHourVariables({
    required this.businessId,
    required this.diaDeLaSemana,
    required this.horaApertura,
    required this.horaCierre,
    required this.esDiaDescanso,
  });
}

