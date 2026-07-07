part of 'example.dart';

class UpdateBusinessPrepaidBalanceVariablesBuilder {
  String id;
  double saldoPrepagoInicial;
  double saldoPrepagoConsumido;

  final FirebaseDataConnect _dataConnect;
  UpdateBusinessPrepaidBalanceVariablesBuilder(this._dataConnect, {required  this.id,required  this.saldoPrepagoInicial,required  this.saldoPrepagoConsumido,});
  Deserializer<UpdateBusinessPrepaidBalanceData> dataDeserializer = (dynamic json)  => UpdateBusinessPrepaidBalanceData.fromJson(jsonDecode(json));
  Serializer<UpdateBusinessPrepaidBalanceVariables> varsSerializer = (UpdateBusinessPrepaidBalanceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateBusinessPrepaidBalanceData, UpdateBusinessPrepaidBalanceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateBusinessPrepaidBalanceData, UpdateBusinessPrepaidBalanceVariables> ref() {
    UpdateBusinessPrepaidBalanceVariables vars= UpdateBusinessPrepaidBalanceVariables(id: id,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,);
    return _dataConnect.mutation("UpdateBusinessPrepaidBalance", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateBusinessPrepaidBalanceBusinessUpdate {
  final String id;
  UpdateBusinessPrepaidBalanceBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessPrepaidBalanceBusinessUpdate otherTyped = other as UpdateBusinessPrepaidBalanceBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateBusinessPrepaidBalanceBusinessUpdate({
    required this.id,
  });
}

@immutable
class UpdateBusinessPrepaidBalanceData {
  final UpdateBusinessPrepaidBalanceBusinessUpdate? business_update;
  UpdateBusinessPrepaidBalanceData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : UpdateBusinessPrepaidBalanceBusinessUpdate.fromJson(json['business_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessPrepaidBalanceData otherTyped = other as UpdateBusinessPrepaidBalanceData;
    return business_update == otherTyped.business_update;
    
  }
  @override
  int get hashCode => business_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (business_update != null) {
      json['business_update'] = business_update!.toJson();
    }
    return json;
  }

  UpdateBusinessPrepaidBalanceData({
    this.business_update,
  });
}

@immutable
class UpdateBusinessPrepaidBalanceVariables {
  final String id;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateBusinessPrepaidBalanceVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateBusinessPrepaidBalanceVariables otherTyped = other as UpdateBusinessPrepaidBalanceVariables;
    return id == otherTyped.id && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    return json;
  }

  UpdateBusinessPrepaidBalanceVariables({
    required this.id,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
  });
}

