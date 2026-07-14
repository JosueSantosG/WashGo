part of 'example.dart';

class GetPrepaidServiceMetricsVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetPrepaidServiceMetricsVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetPrepaidServiceMetricsData> dataDeserializer = (dynamic json)  => GetPrepaidServiceMetricsData.fromJson(jsonDecode(json));
  Serializer<GetPrepaidServiceMetricsVariables> varsSerializer = (GetPrepaidServiceMetricsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPrepaidServiceMetricsData, GetPrepaidServiceMetricsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPrepaidServiceMetricsData, GetPrepaidServiceMetricsVariables> ref() {
    GetPrepaidServiceMetricsVariables vars= GetPrepaidServiceMetricsVariables(businessId: businessId,);
    return _dataConnect.query("GetPrepaidServiceMetrics", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPrepaidServiceMetricsPrepaidServiceMetrics {
  final String id;
  final String serviceName;
  final double costoUnitario;
  final int cantidad;
  final double totalConsumido;
  GetPrepaidServiceMetricsPrepaidServiceMetrics.fromJson(dynamic json):
  
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

    final GetPrepaidServiceMetricsPrepaidServiceMetrics otherTyped = other as GetPrepaidServiceMetricsPrepaidServiceMetrics;
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

  GetPrepaidServiceMetricsPrepaidServiceMetrics({
    required this.id,
    required this.serviceName,
    required this.costoUnitario,
    required this.cantidad,
    required this.totalConsumido,
  });
}

@immutable
class GetPrepaidServiceMetricsData {
  final List<GetPrepaidServiceMetricsPrepaidServiceMetrics> prepaidServiceMetrics;
  GetPrepaidServiceMetricsData.fromJson(dynamic json):
  
  prepaidServiceMetrics = (json['prepaidServiceMetrics'] as List<dynamic>)
        .map((e) => GetPrepaidServiceMetricsPrepaidServiceMetrics.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidServiceMetricsData otherTyped = other as GetPrepaidServiceMetricsData;
    return prepaidServiceMetrics == otherTyped.prepaidServiceMetrics;
    
  }
  @override
  int get hashCode => prepaidServiceMetrics.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidServiceMetrics'] = prepaidServiceMetrics.map((e) => e.toJson()).toList();
    return json;
  }

  GetPrepaidServiceMetricsData({
    required this.prepaidServiceMetrics,
  });
}

@immutable
class GetPrepaidServiceMetricsVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPrepaidServiceMetricsVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidServiceMetricsVariables otherTyped = other as GetPrepaidServiceMetricsVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetPrepaidServiceMetricsVariables({
    required this.businessId,
  });
}

