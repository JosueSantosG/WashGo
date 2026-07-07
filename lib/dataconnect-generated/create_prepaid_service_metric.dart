part of 'example.dart';

class CreatePrepaidServiceMetricVariablesBuilder {
  String businessId;
  String serviceName;
  double costoUnitario;
  int cantidad;
  double totalConsumido;

  final FirebaseDataConnect _dataConnect;
  CreatePrepaidServiceMetricVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.serviceName,required  this.costoUnitario,required  this.cantidad,required  this.totalConsumido,});
  Deserializer<CreatePrepaidServiceMetricData> dataDeserializer = (dynamic json)  => CreatePrepaidServiceMetricData.fromJson(jsonDecode(json));
  Serializer<CreatePrepaidServiceMetricVariables> varsSerializer = (CreatePrepaidServiceMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePrepaidServiceMetricData, CreatePrepaidServiceMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePrepaidServiceMetricData, CreatePrepaidServiceMetricVariables> ref() {
    CreatePrepaidServiceMetricVariables vars= CreatePrepaidServiceMetricVariables(businessId: businessId,serviceName: serviceName,costoUnitario: costoUnitario,cantidad: cantidad,totalConsumido: totalConsumido,);
    return _dataConnect.mutation("CreatePrepaidServiceMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePrepaidServiceMetricPrepaidServiceMetricInsert {
  final String id;
  CreatePrepaidServiceMetricPrepaidServiceMetricInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePrepaidServiceMetricPrepaidServiceMetricInsert otherTyped = other as CreatePrepaidServiceMetricPrepaidServiceMetricInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePrepaidServiceMetricPrepaidServiceMetricInsert({
    required this.id,
  });
}

@immutable
class CreatePrepaidServiceMetricData {
  final CreatePrepaidServiceMetricPrepaidServiceMetricInsert prepaidServiceMetric_insert;
  CreatePrepaidServiceMetricData.fromJson(dynamic json):
  
  prepaidServiceMetric_insert = CreatePrepaidServiceMetricPrepaidServiceMetricInsert.fromJson(json['prepaidServiceMetric_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePrepaidServiceMetricData otherTyped = other as CreatePrepaidServiceMetricData;
    return prepaidServiceMetric_insert == otherTyped.prepaidServiceMetric_insert;
    
  }
  @override
  int get hashCode => prepaidServiceMetric_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidServiceMetric_insert'] = prepaidServiceMetric_insert.toJson();
    return json;
  }

  CreatePrepaidServiceMetricData({
    required this.prepaidServiceMetric_insert,
  });
}

@immutable
class CreatePrepaidServiceMetricVariables {
  final String businessId;
  final String serviceName;
  final double costoUnitario;
  final int cantidad;
  final double totalConsumido;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePrepaidServiceMetricVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  costoUnitario = nativeFromJson<double>(json['costoUnitario']),
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

    final CreatePrepaidServiceMetricVariables otherTyped = other as CreatePrepaidServiceMetricVariables;
    return businessId == otherTyped.businessId && 
    serviceName == otherTyped.serviceName && 
    costoUnitario == otherTyped.costoUnitario && 
    cantidad == otherTyped.cantidad && 
    totalConsumido == otherTyped.totalConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, serviceName.hashCode, costoUnitario.hashCode, cantidad.hashCode, totalConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoUnitario'] = nativeToJson<double>(costoUnitario);
    json['cantidad'] = nativeToJson<int>(cantidad);
    json['totalConsumido'] = nativeToJson<double>(totalConsumido);
    return json;
  }

  CreatePrepaidServiceMetricVariables({
    required this.businessId,
    required this.serviceName,
    required this.costoUnitario,
    required this.cantidad,
    required this.totalConsumido,
  });
}

