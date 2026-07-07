part of 'example.dart';

class GetPrepaidHistoryByOrderIdVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetPrepaidHistoryByOrderIdVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetPrepaidHistoryByOrderIdData> dataDeserializer = (dynamic json)  => GetPrepaidHistoryByOrderIdData.fromJson(jsonDecode(json));
  Serializer<GetPrepaidHistoryByOrderIdVariables> varsSerializer = (GetPrepaidHistoryByOrderIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPrepaidHistoryByOrderIdData, GetPrepaidHistoryByOrderIdVariables> ref() {
    GetPrepaidHistoryByOrderIdVariables vars= GetPrepaidHistoryByOrderIdVariables(orderId: orderId,);
    return _dataConnect.query("GetPrepaidHistoryByOrderId", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPrepaidHistoryByOrderIdPrepaidHistories {
  final String id;
  final GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness business;
  GetPrepaidHistoryByOrderIdPrepaidHistories.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  business = GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness.fromJson(json['business']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdPrepaidHistories otherTyped = other as GetPrepaidHistoryByOrderIdPrepaidHistories;
    return id == otherTyped.id && 
    business == otherTyped.business;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, business.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['business'] = business.toJson();
    return json;
  }

  GetPrepaidHistoryByOrderIdPrepaidHistories({
    required this.id,
    required this.business,
  });
}

@immutable
class GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness {
  final GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner owner;
  GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness.fromJson(dynamic json):
  
  owner = GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness otherTyped = other as GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness;
    return owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => owner.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['owner'] = owner.toJson();
    return json;
  }

  GetPrepaidHistoryByOrderIdPrepaidHistoriesBusiness({
    required this.owner,
  });
}

@immutable
class GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner {
  final String id;
  GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner otherTyped = other as GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetPrepaidHistoryByOrderIdPrepaidHistoriesBusinessOwner({
    required this.id,
  });
}

@immutable
class GetPrepaidHistoryByOrderIdData {
  final List<GetPrepaidHistoryByOrderIdPrepaidHistories> prepaidHistories;
  GetPrepaidHistoryByOrderIdData.fromJson(dynamic json):
  
  prepaidHistories = (json['prepaidHistories'] as List<dynamic>)
        .map((e) => GetPrepaidHistoryByOrderIdPrepaidHistories.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdData otherTyped = other as GetPrepaidHistoryByOrderIdData;
    return prepaidHistories == otherTyped.prepaidHistories;
    
  }
  @override
  int get hashCode => prepaidHistories.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['prepaidHistories'] = prepaidHistories.map((e) => e.toJson()).toList();
    return json;
  }

  GetPrepaidHistoryByOrderIdData({
    required this.prepaidHistories,
  });
}

@immutable
class GetPrepaidHistoryByOrderIdVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPrepaidHistoryByOrderIdVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPrepaidHistoryByOrderIdVariables otherTyped = other as GetPrepaidHistoryByOrderIdVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetPrepaidHistoryByOrderIdVariables({
    required this.orderId,
  });
}

