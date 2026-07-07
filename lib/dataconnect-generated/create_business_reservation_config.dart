part of 'example.dart';

class CreateBusinessReservationConfigVariablesBuilder {
  String businessId;
  int capacidadSimultanea;
  int tiempoAnticipacionMinutos;
  bool isConfigured;

  final FirebaseDataConnect _dataConnect;
  CreateBusinessReservationConfigVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.capacidadSimultanea,required  this.tiempoAnticipacionMinutos,required  this.isConfigured,});
  Deserializer<CreateBusinessReservationConfigData> dataDeserializer = (dynamic json)  => CreateBusinessReservationConfigData.fromJson(jsonDecode(json));
  Serializer<CreateBusinessReservationConfigVariables> varsSerializer = (CreateBusinessReservationConfigVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateBusinessReservationConfigData, CreateBusinessReservationConfigVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateBusinessReservationConfigData, CreateBusinessReservationConfigVariables> ref() {
    CreateBusinessReservationConfigVariables vars= CreateBusinessReservationConfigVariables(businessId: businessId,capacidadSimultanea: capacidadSimultanea,tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,isConfigured: isConfigured,);
    return _dataConnect.mutation("CreateBusinessReservationConfig", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateBusinessReservationConfigBusinessReservationConfigInsert {
  final String id;
  CreateBusinessReservationConfigBusinessReservationConfigInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessReservationConfigBusinessReservationConfigInsert otherTyped = other as CreateBusinessReservationConfigBusinessReservationConfigInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateBusinessReservationConfigBusinessReservationConfigInsert({
    required this.id,
  });
}

@immutable
class CreateBusinessReservationConfigData {
  final CreateBusinessReservationConfigBusinessReservationConfigInsert businessReservationConfig_insert;
  CreateBusinessReservationConfigData.fromJson(dynamic json):
  
  businessReservationConfig_insert = CreateBusinessReservationConfigBusinessReservationConfigInsert.fromJson(json['businessReservationConfig_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessReservationConfigData otherTyped = other as CreateBusinessReservationConfigData;
    return businessReservationConfig_insert == otherTyped.businessReservationConfig_insert;
    
  }
  @override
  int get hashCode => businessReservationConfig_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessReservationConfig_insert'] = businessReservationConfig_insert.toJson();
    return json;
  }

  CreateBusinessReservationConfigData({
    required this.businessReservationConfig_insert,
  });
}

@immutable
class CreateBusinessReservationConfigVariables {
  final String businessId;
  final int capacidadSimultanea;
  final int tiempoAnticipacionMinutos;
  final bool isConfigured;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateBusinessReservationConfigVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  capacidadSimultanea = nativeFromJson<int>(json['capacidadSimultanea']),
  tiempoAnticipacionMinutos = nativeFromJson<int>(json['tiempoAnticipacionMinutos']),
  isConfigured = nativeFromJson<bool>(json['isConfigured']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBusinessReservationConfigVariables otherTyped = other as CreateBusinessReservationConfigVariables;
    return businessId == otherTyped.businessId && 
    capacidadSimultanea == otherTyped.capacidadSimultanea && 
    tiempoAnticipacionMinutos == otherTyped.tiempoAnticipacionMinutos && 
    isConfigured == otherTyped.isConfigured;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, capacidadSimultanea.hashCode, tiempoAnticipacionMinutos.hashCode, isConfigured.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['capacidadSimultanea'] = nativeToJson<int>(capacidadSimultanea);
    json['tiempoAnticipacionMinutos'] = nativeToJson<int>(tiempoAnticipacionMinutos);
    json['isConfigured'] = nativeToJson<bool>(isConfigured);
    return json;
  }

  CreateBusinessReservationConfigVariables({
    required this.businessId,
    required this.capacidadSimultanea,
    required this.tiempoAnticipacionMinutos,
    required this.isConfigured,
  });
}

