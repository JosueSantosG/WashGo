part of 'example.dart';

class GetOrderLogsVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetOrderLogsVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetOrderLogsData> dataDeserializer = (dynamic json)  => GetOrderLogsData.fromJson(jsonDecode(json));
  Serializer<GetOrderLogsVariables> varsSerializer = (GetOrderLogsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetOrderLogsData, GetOrderLogsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetOrderLogsData, GetOrderLogsVariables> ref() {
    GetOrderLogsVariables vars= GetOrderLogsVariables(orderId: orderId,);
    return _dataConnect.query("GetOrderLogs", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetOrderLogsOrderLogs {
  final String id;
  final String actionType;
  final Timestamp createdAt;
  final String? previousValue;
  final String? newValue;
  GetOrderLogsOrderLogs.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  actionType = nativeFromJson<String>(json['actionType']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  previousValue = json['previousValue'] == null ? null : nativeFromJson<String>(json['previousValue']),
  newValue = json['newValue'] == null ? null : nativeFromJson<String>(json['newValue']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderLogsOrderLogs otherTyped = other as GetOrderLogsOrderLogs;
    return id == otherTyped.id && 
    actionType == otherTyped.actionType && 
    createdAt == otherTyped.createdAt && 
    previousValue == otherTyped.previousValue && 
    newValue == otherTyped.newValue;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, actionType.hashCode, createdAt.hashCode, previousValue.hashCode, newValue.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['actionType'] = nativeToJson<String>(actionType);
    json['createdAt'] = createdAt.toJson();
    if (previousValue != null) {
      json['previousValue'] = nativeToJson<String?>(previousValue);
    }
    if (newValue != null) {
      json['newValue'] = nativeToJson<String?>(newValue);
    }
    return json;
  }

  GetOrderLogsOrderLogs({
    required this.id,
    required this.actionType,
    required this.createdAt,
    this.previousValue,
    this.newValue,
  });
}

@immutable
class GetOrderLogsData {
  final List<GetOrderLogsOrderLogs> orderLogs;
  GetOrderLogsData.fromJson(dynamic json):
  
  orderLogs = (json['orderLogs'] as List<dynamic>)
        .map((e) => GetOrderLogsOrderLogs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderLogsData otherTyped = other as GetOrderLogsData;
    return orderLogs == otherTyped.orderLogs;
    
  }
  @override
  int get hashCode => orderLogs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderLogs'] = orderLogs.map((e) => e.toJson()).toList();
    return json;
  }

  GetOrderLogsData({
    required this.orderLogs,
  });
}

@immutable
class GetOrderLogsVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetOrderLogsVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderLogsVariables otherTyped = other as GetOrderLogsVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetOrderLogsVariables({
    required this.orderId,
  });
}

