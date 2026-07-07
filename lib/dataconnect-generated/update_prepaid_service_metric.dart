part of 'example.dart';

class UpdatePrepaidServiceMetricVariablesBuilder {
  String id;
  int cantidad;
  double totalConsumido;

  final FirebaseDataConnect _dataConnect;
  UpdatePrepaidServiceMetricVariablesBuilder(this._dataConnect, {required  this.id,required  this.cantidad,required  this.totalConsumido,});
  Deserializer<UpdatePrepaidServiceMetricData> dataDeserializer = (dynamic json)  => UpdatePrepaidServiceMetricData.fromJson(jsonDecode(json));
  Serializer<UpdatePrepaidServiceMetricVariables> varsSerializer = (UpdatePrepaidServiceMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdatePrepaidServiceMetricData, UpdatePrepaidServiceMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdatePrepaidServiceMetricData, UpdatePrepaidServiceMetricVariables> ref() {
    UpdatePrepaidServiceMetricVariables vars= UpdatePrepaidServiceMetricVariables(id: id,cantidad: cantidad,totalConsumido: totalConsumido,);
    return _dataConnect.mutation("UpdatePrepaidServiceMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate {
  final String id;
  UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate otherTyped = other as UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate({
    required this.id,
  });
}

@immutable
class UpdatePrepaidServiceMetricData {
  final UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate? prepaidServiceMetric_update;
  UpdatePrepaidServiceMetricData.fromJson(dynamic json):
  
  prepaidServiceMetric_update = json['prepaidServiceMetric_update'] == null ? null : UpdatePrepaidServiceMetricPrepaidServiceMetricUpdate.fromJson(json['prepaidServiceMetric_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePrepaidServiceMetricData otherTyped = other as UpdatePrepaidServiceMetricData;
    return prepaidServiceMetric_update == otherTyped.prepaidServiceMetric_update;
    
  }
  @override
  int get hashCode => prepaidServiceMetric_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (prepaidServiceMetric_update != null) {
      json['prepaidServiceMetric_update'] = prepaidServiceMetric_update!.toJson();
    }
    return json;
  }

  UpdatePrepaidServiceMetricData({
    this.prepaidServiceMetric_update,
  });
}

@immutable
class UpdatePrepaidServiceMetricVariables {
  final String id;
  final int cantidad;
  final double totalConsumido;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdatePrepaidServiceMetricVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  cantidad = nativeFromJson<int>(json['cantidad']),
  totalConsumido = nativeFromJson<double>(json['totalConsumido']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePrepaidServiceMetricVariables otherTyped = other as UpdatePrepaidServiceMetricVariables;
    return id == otherTyped.id && 
    cantidad == otherTyped.cantidad && 
    totalConsumido == otherTyped.totalConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, cantidad.hashCode, totalConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['cantidad'] = nativeToJson<int>(cantidad);
    json['totalConsumido'] = nativeToJson<double>(totalConsumido);
    return json;
  }

  UpdatePrepaidServiceMetricVariables({
    required this.id,
    required this.cantidad,
    required this.totalConsumido,
  });
}

