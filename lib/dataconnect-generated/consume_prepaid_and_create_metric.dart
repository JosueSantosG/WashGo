part of 'example.dart';

class ConsumePrepaidAndCreateMetricVariablesBuilder {
  String businessId;
  double saldoPrepagoInicial;
  double saldoPrepagoConsumido;
  String historyId;
  String orderId;
  String serviceName;
  double costoConsumido;
  double saldoResultante;
  String metricId;
  double metricCostoUnitario;

  final FirebaseDataConnect _dataConnect;
  ConsumePrepaidAndCreateMetricVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.saldoPrepagoInicial,required  this.saldoPrepagoConsumido,required  this.historyId,required  this.orderId,required  this.serviceName,required  this.costoConsumido,required  this.saldoResultante,required  this.metricId,required  this.metricCostoUnitario,});
  Deserializer<ConsumePrepaidAndCreateMetricData> dataDeserializer = (dynamic json)  => ConsumePrepaidAndCreateMetricData.fromJson(jsonDecode(json));
  Serializer<ConsumePrepaidAndCreateMetricVariables> varsSerializer = (ConsumePrepaidAndCreateMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ConsumePrepaidAndCreateMetricData, ConsumePrepaidAndCreateMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ConsumePrepaidAndCreateMetricData, ConsumePrepaidAndCreateMetricVariables> ref() {
    ConsumePrepaidAndCreateMetricVariables vars= ConsumePrepaidAndCreateMetricVariables(businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,orderId: orderId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCostoUnitario: metricCostoUnitario,);
    return _dataConnect.mutation("ConsumePrepaidAndCreateMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ConsumePrepaidAndCreateMetricBusinessUpdate {
  final String id;
  ConsumePrepaidAndCreateMetricBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndCreateMetricBusinessUpdate otherTyped = other as ConsumePrepaidAndCreateMetricBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ConsumePrepaidAndCreateMetricBusinessUpdate({
    required this.id,
  });
}

@immutable
class ConsumePrepaidAndCreateMetricPrepaidHistoryInsert {
  final String id;
  ConsumePrepaidAndCreateMetricPrepaidHistoryInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndCreateMetricPrepaidHistoryInsert otherTyped = other as ConsumePrepaidAndCreateMetricPrepaidHistoryInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ConsumePrepaidAndCreateMetricPrepaidHistoryInsert({
    required this.id,
  });
}

@immutable
class ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert {
  final String id;
  ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert otherTyped = other as ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert({
    required this.id,
  });
}

@immutable
class ConsumePrepaidAndCreateMetricData {
  final ConsumePrepaidAndCreateMetricBusinessUpdate? business_update;
  final ConsumePrepaidAndCreateMetricPrepaidHistoryInsert prepaidHistory_insert;
  final ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert prepaidServiceMetric_insert;
  ConsumePrepaidAndCreateMetricData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : ConsumePrepaidAndCreateMetricBusinessUpdate.fromJson(json['business_update']),
  prepaidHistory_insert = ConsumePrepaidAndCreateMetricPrepaidHistoryInsert.fromJson(json['prepaidHistory_insert']),
  prepaidServiceMetric_insert = ConsumePrepaidAndCreateMetricPrepaidServiceMetricInsert.fromJson(json['prepaidServiceMetric_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndCreateMetricData otherTyped = other as ConsumePrepaidAndCreateMetricData;
    return business_update == otherTyped.business_update && 
    prepaidHistory_insert == otherTyped.prepaidHistory_insert && 
    prepaidServiceMetric_insert == otherTyped.prepaidServiceMetric_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([business_update.hashCode, prepaidHistory_insert.hashCode, prepaidServiceMetric_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (business_update != null) {
      json['business_update'] = business_update!.toJson();
    }
    json['prepaidHistory_insert'] = prepaidHistory_insert.toJson();
    json['prepaidServiceMetric_insert'] = prepaidServiceMetric_insert.toJson();
    return json;
  }

  ConsumePrepaidAndCreateMetricData({
    this.business_update,
    required this.prepaidHistory_insert,
    required this.prepaidServiceMetric_insert,
  });
}

@immutable
class ConsumePrepaidAndCreateMetricVariables {
  final String businessId;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final String historyId;
  final String orderId;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  final String metricId;
  final double metricCostoUnitario;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ConsumePrepaidAndCreateMetricVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  historyId = nativeFromJson<String>(json['historyId']),
  orderId = nativeFromJson<String>(json['orderId']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  costoConsumido = nativeFromJson<double>(json['costoConsumido']),
  saldoResultante = nativeFromJson<double>(json['saldoResultante']),
  metricId = nativeFromJson<String>(json['metricId']),
  metricCostoUnitario = nativeFromJson<double>(json['metricCostoUnitario']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ConsumePrepaidAndCreateMetricVariables otherTyped = other as ConsumePrepaidAndCreateMetricVariables;
    return businessId == otherTyped.businessId && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido && 
    historyId == otherTyped.historyId && 
    orderId == otherTyped.orderId && 
    serviceName == otherTyped.serviceName && 
    costoConsumido == otherTyped.costoConsumido && 
    saldoResultante == otherTyped.saldoResultante && 
    metricId == otherTyped.metricId && 
    metricCostoUnitario == otherTyped.metricCostoUnitario;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, historyId.hashCode, orderId.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode, metricId.hashCode, metricCostoUnitario.hashCode]);
  

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
    json['metricCostoUnitario'] = nativeToJson<double>(metricCostoUnitario);
    return json;
  }

  ConsumePrepaidAndCreateMetricVariables({
    required this.businessId,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    required this.historyId,
    required this.orderId,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
    required this.metricId,
    required this.metricCostoUnitario,
  });
}

