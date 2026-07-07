part of 'example.dart';

class GetPrepaidServiceMetricByServiceNameVariablesBuilder {
  String businessId;
  String serviceName;

  final FirebaseDataConnect _dataConnect;
  GetPrepaidServiceMetricByServiceNameVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.serviceName,});
  Deserializer<GetPrepaidServiceMetricByServiceNameData> dataDeserializer = (dynamic json)  => GetPrepaidServiceMetricByServiceNameData.fromJson(jsonDecode(json));
  Serializer<GetPrepaidServiceMetricByServiceNameVariables> varsSerializer = (GetPrepaidServiceMetricByServiceNameVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPrepaidServiceMetricByServiceNameData, GetPrepaidServiceMetricByServiceNameVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetPrepaidServiceMetricByServiceNameData, GetPrepaidServiceMetricByServiceNameVariables> ref() {
    GetPrepaidServiceMetricByServiceNameVariables vars= GetPrepaidServiceMetricByServiceNameVariables(businessId: businessId,serviceName: serviceName,);
    return _dataConnect.query("GetPrepaidServiceMetricByServiceName", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics {
  final String id;
  final String serviceName;
  final double costoUnitario;
  final int cantidad;
  final double totalConsumido;
  GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
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

    final GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics otherTyped = other as GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics;
    return id == otherTyped.id && 
    serviceName == otherTyped.serviceName && 
    costoUnitario == otherTyped.costoUnitario && 
    cantidad == otherTyped.cantidad && 
    totalConsumido == otherTyped.totalConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, serviceName.hashCode, costoUnitario.hashCode, cantidad.hashCode, totalConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoUnitario'] = nativeToJson<double>(costoUnitario);
    json['cantidad'] = nativeToJson<int>(cantidad);
    json['totalConsumido'] = nativeToJson<double>(totalConsumido);
    return json;
  }

  GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics({
    required this.id,
    required this.serviceName,
    required this.costoUnitario,
    required this.cantidad,
    required this.totalConsumido,
  });
}

@immutable
class GetPrepaidServiceMetricByServiceNameData {
  final List<GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics> prepaidServiceMetrics;
  GetPrepaidServiceMetricByServiceNameData.fromJson(dynamic json):
  
  prepaidServiceMetrics = (json['prepaidServiceMetrics'] as List<dynamic>)
        .map((e) => GetPrepaidServiceMetricByServiceNamePrepaidServiceMetrics.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidServiceMetricByServiceNameData otherTyped = other as GetPrepaidServiceMetricByServiceNameData;
    return prepaidServiceMetrics == otherTyped.prepaidServiceMetrics;
    
  }
  @override
  int get hashCode => prepaidServiceMetrics.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidServiceMetrics'] = prepaidServiceMetrics.map((e) => e.toJson()).toList();
    return json;
  }

  GetPrepaidServiceMetricByServiceNameData({
    required this.prepaidServiceMetrics,
  });
}

@immutable
class GetPrepaidServiceMetricByServiceNameVariables {
  final String businessId;
  final String serviceName;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPrepaidServiceMetricByServiceNameVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  serviceName = nativeFromJson<String>(json['serviceName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidServiceMetricByServiceNameVariables otherTyped = other as GetPrepaidServiceMetricByServiceNameVariables;
    return businessId == otherTyped.businessId && 
    serviceName == otherTyped.serviceName;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, serviceName.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    return json;
  }

  GetPrepaidServiceMetricByServiceNameVariables({
    required this.businessId,
    required this.serviceName,
  });
}

