part of 'example.dart';

class CreatePrepaidHistoryVariablesBuilder {
  String businessId;
  String orderId;
  String serviceName;
  double costoConsumido;
  double saldoResultante;

  final FirebaseDataConnect _dataConnect;
  CreatePrepaidHistoryVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.orderId,required  this.serviceName,required  this.costoConsumido,required  this.saldoResultante,});
  Deserializer<CreatePrepaidHistoryData> dataDeserializer = (dynamic json)  => CreatePrepaidHistoryData.fromJson(jsonDecode(json));
  Serializer<CreatePrepaidHistoryVariables> varsSerializer = (CreatePrepaidHistoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePrepaidHistoryData, CreatePrepaidHistoryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePrepaidHistoryData, CreatePrepaidHistoryVariables> ref() {
    CreatePrepaidHistoryVariables vars= CreatePrepaidHistoryVariables(businessId: businessId,orderId: orderId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,);
    return _dataConnect.mutation("CreatePrepaidHistory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePrepaidHistoryPrepaidHistoryInsert {
  final String id;
  CreatePrepaidHistoryPrepaidHistoryInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePrepaidHistoryPrepaidHistoryInsert otherTyped = other as CreatePrepaidHistoryPrepaidHistoryInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePrepaidHistoryPrepaidHistoryInsert({
    required this.id,
  });
}

@immutable
class CreatePrepaidHistoryData {
  final CreatePrepaidHistoryPrepaidHistoryInsert prepaidHistory_insert;
  CreatePrepaidHistoryData.fromJson(dynamic json):
  
  prepaidHistory_insert = CreatePrepaidHistoryPrepaidHistoryInsert.fromJson(json['prepaidHistory_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePrepaidHistoryData otherTyped = other as CreatePrepaidHistoryData;
    return prepaidHistory_insert == otherTyped.prepaidHistory_insert;
    
  }
  @override
  int get hashCode => prepaidHistory_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidHistory_insert'] = prepaidHistory_insert.toJson();
    return json;
  }

  CreatePrepaidHistoryData({
    required this.prepaidHistory_insert,
  });
}

@immutable
class CreatePrepaidHistoryVariables {
  final String businessId;
  final String orderId;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePrepaidHistoryVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  orderId = nativeFromJson<String>(json['orderId']),
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

    final CreatePrepaidHistoryVariables otherTyped = other as CreatePrepaidHistoryVariables;
    return businessId == otherTyped.businessId && 
    orderId == otherTyped.orderId && 
    serviceName == otherTyped.serviceName && 
    costoConsumido == otherTyped.costoConsumido && 
    saldoResultante == otherTyped.saldoResultante;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, orderId.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['orderId'] = nativeToJson<String>(orderId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoConsumido'] = nativeToJson<double>(costoConsumido);
    json['saldoResultante'] = nativeToJson<double>(saldoResultante);
    return json;
  }

  CreatePrepaidHistoryVariables({
    required this.businessId,
    required this.orderId,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
  });
}

