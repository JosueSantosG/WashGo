part of 'example.dart';

class ConsumePrepaidAndUpdateMetricVariablesBuilder {
  String businessId;
  double saldoPrepagoInicial;
  double saldoPrepagoConsumido;
  String historyId;
  String orderId;
  String serviceName;
  double costoConsumido;
  double saldoResultante;
  String metricId;
  int metricCantidad;
  double metricTotalConsumido;

  final FirebaseDataConnect _dataConnect;
  ConsumePrepaidAndUpdateMetricVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.saldoPrepagoInicial,required  this.saldoPrepagoConsumido,required  this.historyId,required  this.orderId,required  this.serviceName,required  this.costoConsumido,required  this.saldoResultante,required  this.metricId,required  this.metricCantidad,required  this.metricTotalConsumido,});
  Deserializer<ConsumePrepaidAndUpdateMetricData> dataDeserializer = (dynamic json)  => ConsumePrepaidAndUpdateMetricData.fromJson(jsonDecode(json));
  Serializer<ConsumePrepaidAndUpdateMetricVariables> varsSerializer = (ConsumePrepaidAndUpdateMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ConsumePrepaidAndUpdateMetricData, ConsumePrepaidAndUpdateMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ConsumePrepaidAndUpdateMetricData, ConsumePrepaidAndUpdateMetricVariables> ref() {
    ConsumePrepaidAndUpdateMetricVariables vars= ConsumePrepaidAndUpdateMetricVariables(businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,orderId: orderId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCantidad: metricCantidad,metricTotalConsumido: metricTotalConsumido,);
    return _dataConnect.mutation("ConsumePrepaidAndUpdateMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ConsumePrepaidAndUpdateMetricBusinessUpdate {
  final String id;
  ConsumePrepaidAndUpdateMetricBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndUpdateMetricBusinessUpdate otherTyped = other as ConsumePrepaidAndUpdateMetricBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ConsumePrepaidAndUpdateMetricBusinessUpdate({
    required this.id,
  });
}

@immutable
class ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert {
  final String id;
  ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert otherTyped = other as ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert({
    required this.id,
  });
}

@immutable
class ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate {
  final String id;
  ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate otherTyped = other as ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate({
    required this.id,
  });
}

@immutable
class ConsumePrepaidAndUpdateMetricData {
  final ConsumePrepaidAndUpdateMetricBusinessUpdate? business_update;
  final ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert prepaidHistory_insert;
  final ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate? prepaidServiceMetric_update;
  ConsumePrepaidAndUpdateMetricData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : ConsumePrepaidAndUpdateMetricBusinessUpdate.fromJson(json['business_update']),
  prepaidHistory_insert = ConsumePrepaidAndUpdateMetricPrepaidHistoryInsert.fromJson(json['prepaidHistory_insert']),
  prepaidServiceMetric_update = json['prepaidServiceMetric_update'] == null ? null : ConsumePrepaidAndUpdateMetricPrepaidServiceMetricUpdate.fromJson(json['prepaidServiceMetric_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndUpdateMetricData otherTyped = other as ConsumePrepaidAndUpdateMetricData;
    return business_update == otherTyped.business_update && 
    prepaidHistory_insert == otherTyped.prepaidHistory_insert && 
    prepaidServiceMetric_update == otherTyped.prepaidServiceMetric_update;
    
  }
  @override
  int get hashCode => Object.hashAll([business_update.hashCode, prepaidHistory_insert.hashCode, prepaidServiceMetric_update.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (business_update != null) {
      json['business_update'] = business_update!.toJson();
    }
    json['prepaidHistory_insert'] = prepaidHistory_insert.toJson();
    if (prepaidServiceMetric_update != null) {
      json['prepaidServiceMetric_update'] = prepaidServiceMetric_update!.toJson();
    }
    return json;
  }

  ConsumePrepaidAndUpdateMetricData({
    this.business_update,
    required this.prepaidHistory_insert,
    this.prepaidServiceMetric_update,
  });
}

@immutable
class ConsumePrepaidAndUpdateMetricVariables {
  final String businessId;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final String historyId;
  final String orderId;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  final String metricId;
  final int metricCantidad;
  final double metricTotalConsumido;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ConsumePrepaidAndUpdateMetricVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  historyId = nativeFromJson<String>(json['historyId']),
  orderId = nativeFromJson<String>(json['orderId']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  costoConsumido = nativeFromJson<double>(json['costoConsumido']),
  saldoResultante = nativeFromJson<double>(json['saldoResultante']),
  metricId = nativeFromJson<String>(json['metricId']),
  metricCantidad = nativeFromJson<int>(json['metricCantidad']),
  metricTotalConsumido = nativeFromJson<double>(json['metricTotalConsumido']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndUpdateMetricVariables otherTyped = other as ConsumePrepaidAndUpdateMetricVariables;
    return businessId == otherTyped.businessId && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido && 
    historyId == otherTyped.historyId && 
    orderId == otherTyped.orderId && 
    serviceName == otherTyped.serviceName && 
    costoConsumido == otherTyped.costoConsumido && 
    saldoResultante == otherTyped.saldoResultante && 
    metricId == otherTyped.metricId && 
    metricCantidad == otherTyped.metricCantidad && 
    metricTotalConsumido == otherTyped.metricTotalConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, historyId.hashCode, orderId.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode, metricId.hashCode, metricCantidad.hashCode, metricTotalConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    json['historyId'] = nativeToJson<String>(historyId);
    json['orderId'] = nativeToJson<String>(orderId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoConsumido'] = nativeToJson<double>(costoConsumido);
    json['saldoResultante'] = nativeToJson<double>(saldoResultante);
    json['metricId'] = nativeToJson<String>(metricId);
    json['metricCantidad'] = nativeToJson<int>(metricCantidad);
    json['metricTotalConsumido'] = nativeToJson<double>(metricTotalConsumido);
    return json;
  }

  ConsumePrepaidAndUpdateMetricVariables({
    required this.businessId,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    required this.historyId,
    required this.orderId,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
    required this.metricId,
    required this.metricCantidad,
    required this.metricTotalConsumido,
  });
}

