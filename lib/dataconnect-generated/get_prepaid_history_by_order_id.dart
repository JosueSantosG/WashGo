part of 'example.dart';

class GetPrepaidHistoryByOrderIdVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetPrepaidHistoryByOrderIdVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetPrepaidHistoryByOrderIdData> dataDeserializer = (dynamic json)  => GetPrepaidHistoryByOrderIdData.fromJson(jsonDecode(json));
  Serializer<GetPrepaidHistoryByOrderIdVariables> varsSerializer = (GetPrepaidHistoryByOrderIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables> ref() {
    GetPrepaidHistoryByOrderIdVariables vars= GetPrepaidHistoryByOrderIdVariables(orderId: orderId,);
    return _dataConnect.query("GetPrepaidHistoryByOrderId", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPrepaidHistoryByOrderIdPrepaidHistories {
  final String id;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  GetPrepaidHistoryByOrderIdPrepaidHistories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  costoConsumido = nativeFromJson<double>(json['costoConsumido']),
  saldoResultante = nativeFromJson<double>(json['saldoResultante']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdPrepaidHistories otherTyped = other as GetPrepaidHistoryByOrderIdPrepaidHistories;
    return id == otherTyped.id && 
    serviceName == otherTyped.serviceName && 
    costoConsumido == otherTyped.costoConsumido && 
    saldoResultante == otherTyped.saldoResultante;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoConsumido'] = nativeToJson<double>(costoConsumido);
    json['saldoResultante'] = nativeToJson<double>(saldoResultante);
    return json;
  }

  GetPrepaidHistoryByOrderIdPrepaidHistories({
    required this.id,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
  });
}

@immutable
class GetPrepaidHistoryByOrderIdData {
  final List<GetPrepaidHistoryByOrderIdPrepaidHistories> prepaidHistories;
  GetPrepaidHistoryByOrderIdData.fromJson(dynamic json):
  
  prepaidHistories = (json['prepaidHistories'] as List<dynamic>)
        .map((e) => GetPrepaidHistoryByOrderIdPrepaidHistories.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdData otherTyped = other as GetPrepaidHistoryByOrderIdData;
    return prepaidHistories == otherTyped.prepaidHistories;
    
  }
  @override
  int get hashCode => prepaidHistories.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidHistories'] = prepaidHistories.map((e) => e.toJson()).toList();
    return json;
  }

  GetPrepaidHistoryByOrderIdData({
    required this.prepaidHistories,
  });
}

@immutable
class GetPrepaidHistoryByOrderIdVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPrepaidHistoryByOrderIdVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdVariables otherTyped = other as GetPrepaidHistoryByOrderIdVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetPrepaidHistoryByOrderIdVariables({
    required this.orderId,
  });
}

