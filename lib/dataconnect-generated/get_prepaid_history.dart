part of 'example.dart';

class GetPrepaidHistoryVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetPrepaidHistoryVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetPrepaidHistoryData> dataDeserializer = (dynamic json)  => GetPrepaidHistoryData.fromJson(jsonDecode(json));
  Serializer<GetPrepaidHistoryVariables> varsSerializer = (GetPrepaidHistoryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPrepaidHistoryData, GetPrepaidHistoryVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPrepaidHistoryData, GetPrepaidHistoryVariables> ref() {
    GetPrepaidHistoryVariables vars= GetPrepaidHistoryVariables(businessId: businessId,);
    return _dataConnect.query("GetPrepaidHistory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPrepaidHistoryPrepaidHistories {
  final String id;
  final String orderId;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  final Timestamp fecha;
  GetPrepaidHistoryPrepaidHistories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  orderId = nativeFromJson<String>(json['orderId']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  costoConsumido = nativeFromJson<double>(json['costoConsumido']),
  saldoResultante = nativeFromJson<double>(json['saldoResultante']),
  fecha = Timestamp.fromJson(json['fecha']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryPrepaidHistories otherTyped = other as GetPrepaidHistoryPrepaidHistories;
    return id == otherTyped.id && 
    orderId == otherTyped.orderId && 
    serviceName == otherTyped.serviceName && 
    costoConsumido == otherTyped.costoConsumido && 
    saldoResultante == otherTyped.saldoResultante && 
    fecha == otherTyped.fecha;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, orderId.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode, fecha.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['orderId'] = nativeToJson<String>(orderId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoConsumido'] = nativeToJson<double>(costoConsumido);
    json['saldoResultante'] = nativeToJson<double>(saldoResultante);
    json['fecha'] = fecha.toJson();
    return json;
  }

  GetPrepaidHistoryPrepaidHistories({
    required this.id,
    required this.orderId,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
    required this.fecha,
  });
}

@immutable
class GetPrepaidHistoryData {
  final List<GetPrepaidHistoryPrepaidHistories> prepaidHistories;
  GetPrepaidHistoryData.fromJson(dynamic json):
  
  prepaidHistories = (json['prepaidHistories'] as List<dynamic>)
        .map((e) => GetPrepaidHistoryPrepaidHistories.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryData otherTyped = other as GetPrepaidHistoryData;
    return prepaidHistories == otherTyped.prepaidHistories;
    
  }
  @override
  int get hashCode => prepaidHistories.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidHistories'] = prepaidHistories.map((e) => e.toJson()).toList();
    return json;
  }

  GetPrepaidHistoryData({
    required this.prepaidHistories,
  });
}

@immutable
class GetPrepaidHistoryVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPrepaidHistoryVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryVariables otherTyped = other as GetPrepaidHistoryVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetPrepaidHistoryVariables({
    required this.businessId,
  });
}

