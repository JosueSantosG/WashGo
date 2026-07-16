part of 'example.dart';

class GetBusinessHoursVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetBusinessHoursVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetBusinessHoursData> dataDeserializer = (dynamic json)  => GetBusinessHoursData.fromJson(jsonDecode(json));
  Serializer<GetBusinessHoursVariables> varsSerializer = (GetBusinessHoursVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBusinessHoursData, GetBusinessHoursVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetBusinessHoursData, GetBusinessHoursVariables> ref() {
    GetBusinessHoursVariables vars= GetBusinessHoursVariables(businessId: businessId,);
    return _dataConnect.query("GetBusinessHours", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBusinessHoursBusinessHours {
  final String id;
  final int diaDeLaSemana;
  final String? horaApertura;
  final String? horaCierre;
  final bool esDiaDescanso;
  GetBusinessHoursBusinessHours.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  diaDeLaSemana = nativeFromJson<int>(json['diaDeLaSemana']),
  horaApertura = json['horaApertura'] == null ? null : nativeFromJson<String>(json['horaApertura']),
  horaCierre = json['horaCierre'] == null ? null : nativeFromJson<String>(json['horaCierre']),
  esDiaDescanso = nativeFromJson<bool>(json['esDiaDescanso']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessHoursBusinessHours otherTyped = other as GetBusinessHoursBusinessHours;
    return id == otherTyped.id && 
    diaDeLaSemana == otherTyped.diaDeLaSemana && 
    horaApertura == otherTyped.horaApertura && 
    horaCierre == otherTyped.horaCierre && 
    esDiaDescanso == otherTyped.esDiaDescanso;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, diaDeLaSemana.hashCode, horaApertura.hashCode, horaCierre.hashCode, esDiaDescanso.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['diaDeLaSemana'] = nativeToJson<int>(diaDeLaSemana);
    if (horaApertura != null) {
      json['horaApertura'] = nativeToJson<String?>(horaApertura);
    }
    if (horaCierre != null) {
      json['horaCierre'] = nativeToJson<String?>(horaCierre);
    }
    json['esDiaDescanso'] = nativeToJson<bool>(esDiaDescanso);
    return json;
  }

  GetBusinessHoursBusinessHours({
    required this.id,
    required this.diaDeLaSemana,
    this.horaApertura,
    this.horaCierre,
    required this.esDiaDescanso,
  });
}

@immutable
class GetBusinessHoursData {
  final List<GetBusinessHoursBusinessHours> businessHours;
  GetBusinessHoursData.fromJson(dynamic json):
  
  businessHours = (json['businessHours'] as List<dynamic>)
        .map((e) => GetBusinessHoursBusinessHours.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessHoursData otherTyped = other as GetBusinessHoursData;
    return businessHours == otherTyped.businessHours;
    
  }
  @override
  int get hashCode => businessHours.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessHours'] = businessHours.map((e) => e.toJson()).toList();
    return json;
  }

  GetBusinessHoursData({
    required this.businessHours,
  });
}

@immutable
class GetBusinessHoursVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBusinessHoursVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessHoursVariables otherTyped = other as GetBusinessHoursVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetBusinessHoursVariables({
    required this.businessId,
  });
}

