part of 'example.dart';

class GetBusinessReservationConfigVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetBusinessReservationConfigVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetBusinessReservationConfigData> dataDeserializer = (dynamic json)  => GetBusinessReservationConfigData.fromJson(jsonDecode(json));
  Serializer<GetBusinessReservationConfigVariables> varsSerializer = (GetBusinessReservationConfigVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBusinessReservationConfigData, GetBusinessReservationConfigVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetBusinessReservationConfigData, GetBusinessReservationConfigVariables> ref() {
    GetBusinessReservationConfigVariables vars= GetBusinessReservationConfigVariables(businessId: businessId,);
    return _dataConnect.query("GetBusinessReservationConfig", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBusinessReservationConfigBusinessReservationConfigs {
  final String id;
  final int capacidadSimultanea;
  final int tiempoAnticipacionMinutos;
  final bool isConfigured;
  final Timestamp updatedAt;
  GetBusinessReservationConfigBusinessReservationConfigs.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  capacidadSimultanea = nativeFromJson<int>(json['capacidadSimultanea']),
  tiempoAnticipacionMinutos = nativeFromJson<int>(json['tiempoAnticipacionMinutos']),
  isConfigured = nativeFromJson<bool>(json['isConfigured']),
  updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReservationConfigBusinessReservationConfigs otherTyped = other as GetBusinessReservationConfigBusinessReservationConfigs;
    return id == otherTyped.id && 
    capacidadSimultanea == otherTyped.capacidadSimultanea && 
    tiempoAnticipacionMinutos == otherTyped.tiempoAnticipacionMinutos && 
    isConfigured == otherTyped.isConfigured && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, capacidadSimultanea.hashCode, tiempoAnticipacionMinutos.hashCode, isConfigured.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['capacidadSimultanea'] = nativeToJson<int>(capacidadSimultanea);
    json['tiempoAnticipacionMinutos'] = nativeToJson<int>(tiempoAnticipacionMinutos);
    json['isConfigured'] = nativeToJson<bool>(isConfigured);
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  GetBusinessReservationConfigBusinessReservationConfigs({
    required this.id,
    required this.capacidadSimultanea,
    required this.tiempoAnticipacionMinutos,
    required this.isConfigured,
    required this.updatedAt,
  });
}

@immutable
class GetBusinessReservationConfigData {
  final List<GetBusinessReservationConfigBusinessReservationConfigs> businessReservationConfigs;
  GetBusinessReservationConfigData.fromJson(dynamic json):
  
  businessReservationConfigs = (json['businessReservationConfigs'] as List<dynamic>)
        .map((e) => GetBusinessReservationConfigBusinessReservationConfigs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReservationConfigData otherTyped = other as GetBusinessReservationConfigData;
    return businessReservationConfigs == otherTyped.businessReservationConfigs;
    
  }
  @override
  int get hashCode => businessReservationConfigs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessReservationConfigs'] = businessReservationConfigs.map((e) => e.toJson()).toList();
    return json;
  }

  GetBusinessReservationConfigData({
    required this.businessReservationConfigs,
  });
}

@immutable
class GetBusinessReservationConfigVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBusinessReservationConfigVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBusinessReservationConfigVariables otherTyped = other as GetBusinessReservationConfigVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetBusinessReservationConfigVariables({
    required this.businessId,
  });
}

