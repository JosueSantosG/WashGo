part of 'example.dart';

class SuperAdminUpdateBusinessPrepaidVariablesBuilder {
  String id;
  double saldoPrepagoInicial;
  double saldoPrepagoConsumido;

  final FirebaseDataConnect _dataConnect;
  SuperAdminUpdateBusinessPrepaidVariablesBuilder(this._dataConnect, {required  this.id,required  this.saldoPrepagoInicial,required  this.saldoPrepagoConsumido,});
  Deserializer<SuperAdminUpdateBusinessPrepaidData> dataDeserializer = (dynamic json)  => SuperAdminUpdateBusinessPrepaidData.fromJson(jsonDecode(json));
  Serializer<SuperAdminUpdateBusinessPrepaidVariables> varsSerializer = (SuperAdminUpdateBusinessPrepaidVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SuperAdminUpdateBusinessPrepaidData, SuperAdminUpdateBusinessPrepaidVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SuperAdminUpdateBusinessPrepaidData, SuperAdminUpdateBusinessPrepaidVariables> ref() {
    SuperAdminUpdateBusinessPrepaidVariables vars= SuperAdminUpdateBusinessPrepaidVariables(id: id,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,);
    return _dataConnect.mutation("SuperAdminUpdateBusinessPrepaid", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SuperAdminUpdateBusinessPrepaidBusinessUpdate {
  final String id;
  SuperAdminUpdateBusinessPrepaidBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminUpdateBusinessPrepaidBusinessUpdate otherTyped = other as SuperAdminUpdateBusinessPrepaidBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SuperAdminUpdateBusinessPrepaidBusinessUpdate({
    required this.id,
  });
}

@immutable
class SuperAdminUpdateBusinessPrepaidData {
  final SuperAdminUpdateBusinessPrepaidBusinessUpdate? business_update;
  SuperAdminUpdateBusinessPrepaidData.fromJson(dynamic json):
  
  business_update = json['business_update'] == null ? null : SuperAdminUpdateBusinessPrepaidBusinessUpdate.fromJson(json['business_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SuperAdminUpdateBusinessPrepaidData otherTyped = other as SuperAdminUpdateBusinessPrepaidData;
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

  SuperAdminUpdateBusinessPrepaidData({
    this.business_update,
  });
}

@immutable
class SuperAdminUpdateBusinessPrepaidVariables {
  final String id;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SuperAdminUpdateBusinessPrepaidVariables.fromJson(Map<String, dynamic> json):
  
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

    final SuperAdminUpdateBusinessPrepaidVariables otherTyped = other as SuperAdminUpdateBusinessPrepaidVariables;
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

  SuperAdminUpdateBusinessPrepaidVariables({
    required this.id,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
  });
}

