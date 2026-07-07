part of 'example.dart';

class GetReservationByOrderIdVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetReservationByOrderIdVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetReservationByOrderIdData> dataDeserializer = (dynamic json)  => GetReservationByOrderIdData.fromJson(jsonDecode(json));
  Serializer<GetReservationByOrderIdVariables> varsSerializer = (GetReservationByOrderIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetReservationByOrderIdData, GetReservationByOrderIdVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetReservationByOrderIdData, GetReservationByOrderIdVariables> ref() {
    GetReservationByOrderIdVariables vars= GetReservationByOrderIdVariables(orderId: orderId,);
    return _dataConnect.query("GetReservationByOrderId", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetReservationByOrderIdOrderReservations {
  final String orderId;
  final String businessId;
  final Timestamp scheduledAt;
  final int serviceDurationMinutos;
  final String serviceId;
  final Timestamp createdAt;
  final GetReservationByOrderIdOrderReservationsBusiness business;
  final GetReservationByOrderIdOrderReservationsOrder order;
  GetReservationByOrderIdOrderReservations.fromJson(dynamic json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  businessId = nativeFromJson<String>(json['businessId']),
  scheduledAt = Timestamp.fromJson(json['scheduledAt']),
  serviceDurationMinutos = nativeFromJson<int>(json['serviceDurationMinutos']),
  serviceId = nativeFromJson<String>(json['serviceId']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  business = GetReservationByOrderIdOrderReservationsBusiness.fromJson(json['business']),
  order = GetReservationByOrderIdOrderReservationsOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReservationByOrderIdOrderReservations otherTyped = other as GetReservationByOrderIdOrderReservations;
    return orderId == otherTyped.orderId && 
    businessId == otherTyped.businessId && 
    scheduledAt == otherTyped.scheduledAt && 
    serviceDurationMinutos == otherTyped.serviceDurationMinutos && 
    serviceId == otherTyped.serviceId && 
    createdAt == otherTyped.createdAt && 
    business == otherTyped.business && 
    order == otherTyped.order;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, businessId.hashCode, scheduledAt.hashCode, serviceDurationMinutos.hashCode, serviceId.hashCode, createdAt.hashCode, business.hashCode, order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['businessId'] = nativeToJson<String>(businessId);
    json['scheduledAt'] = scheduledAt.toJson();
    json['serviceDurationMinutos'] = nativeToJson<int>(serviceDurationMinutos);
    json['serviceId'] = nativeToJson<String>(serviceId);
    json['createdAt'] = createdAt.toJson();
    json['business'] = business.toJson();
    json['order'] = order.toJson();
    return json;
  }

  GetReservationByOrderIdOrderReservations({
    required this.orderId,
    required this.businessId,
    required this.scheduledAt,
    required this.serviceDurationMinutos,
    required this.serviceId,
    required this.createdAt,
    required this.business,
    required this.order,
  });
}

@immutable
class GetReservationByOrderIdOrderReservationsBusiness {
  final GetReservationByOrderIdOrderReservationsBusinessOwner owner;
  GetReservationByOrderIdOrderReservationsBusiness.fromJson(dynamic json):
  
  owner = GetReservationByOrderIdOrderReservationsBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReservationByOrderIdOrderReservationsBusiness otherTyped = other as GetReservationByOrderIdOrderReservationsBusiness;
    return owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => owner.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['owner'] = owner.toJson();
    return json;
  }

  GetReservationByOrderIdOrderReservationsBusiness({
    required this.owner,
  });
}

@immutable
class GetReservationByOrderIdOrderReservationsBusinessOwner {
  final String id;
  GetReservationByOrderIdOrderReservationsBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReservationByOrderIdOrderReservationsBusinessOwner otherTyped = other as GetReservationByOrderIdOrderReservationsBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetReservationByOrderIdOrderReservationsBusinessOwner({
    required this.id,
  });
}

@immutable
class GetReservationByOrderIdOrderReservationsOrder {
  final String clientId;
  GetReservationByOrderIdOrderReservationsOrder.fromJson(dynamic json):
  
  clientId = nativeFromJson<String>(json['clientId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReservationByOrderIdOrderReservationsOrder otherTyped = other as GetReservationByOrderIdOrderReservationsOrder;
    return clientId == otherTyped.clientId;
    
  }
  @override
  int get hashCode => clientId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['clientId'] = nativeToJson<String>(clientId);
    return json;
  }

  GetReservationByOrderIdOrderReservationsOrder({
    required this.clientId,
  });
}

@immutable
class GetReservationByOrderIdData {
  final List<GetReservationByOrderIdOrderReservations> orderReservations;
  GetReservationByOrderIdData.fromJson(dynamic json):
  
  orderReservations = (json['orderReservations'] as List<dynamic>)
        .map((e) => GetReservationByOrderIdOrderReservations.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReservationByOrderIdData otherTyped = other as GetReservationByOrderIdData;
    return orderReservations == otherTyped.orderReservations;
    
  }
  @override
  int get hashCode => orderReservations.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderReservations'] = orderReservations.map((e) => e.toJson()).toList();
    return json;
  }

  GetReservationByOrderIdData({
    required this.orderReservations,
  });
}

@immutable
class GetReservationByOrderIdVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetReservationByOrderIdVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetReservationByOrderIdVariables otherTyped = other as GetReservationByOrderIdVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetReservationByOrderIdVariables({
    required this.orderId,
  });
}

