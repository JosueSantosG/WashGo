part of 'example.dart';

class GetActiveReservationsVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetActiveReservationsVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetActiveReservationsData> dataDeserializer = (dynamic json)  => GetActiveReservationsData.fromJson(jsonDecode(json));
  Serializer<GetActiveReservationsVariables> varsSerializer = (GetActiveReservationsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetActiveReservationsData, GetActiveReservationsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetActiveReservationsData, GetActiveReservationsVariables> ref() {
    GetActiveReservationsVariables vars= GetActiveReservationsVariables(businessId: businessId,);
    return _dataConnect.query("GetActiveReservations", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetActiveReservationsOrderReservations {
  final String orderId;
  final String businessId;
  final Timestamp scheduledAt;
  final int serviceDurationMinutos;
  final String serviceId;
  final Timestamp createdAt;
  GetActiveReservationsOrderReservations.fromJson(dynamic json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  businessId = nativeFromJson<String>(json['businessId']),
  scheduledAt = Timestamp.fromJson(json['scheduledAt']),
  serviceDurationMinutos = nativeFromJson<int>(json['serviceDurationMinutos']),
  serviceId = nativeFromJson<String>(json['serviceId']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveReservationsOrderReservations otherTyped = other as GetActiveReservationsOrderReservations;
    return orderId == otherTyped.orderId && 
    businessId == otherTyped.businessId && 
    scheduledAt == otherTyped.scheduledAt && 
    serviceDurationMinutos == otherTyped.serviceDurationMinutos && 
    serviceId == otherTyped.serviceId && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, businessId.hashCode, scheduledAt.hashCode, serviceDurationMinutos.hashCode, serviceId.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['businessId'] = nativeToJson<String>(businessId);
    json['scheduledAt'] = scheduledAt.toJson();
    json['serviceDurationMinutos'] = nativeToJson<int>(serviceDurationMinutos);
    json['serviceId'] = nativeToJson<String>(serviceId);
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetActiveReservationsOrderReservations({
    required this.orderId,
    required this.businessId,
    required this.scheduledAt,
    required this.serviceDurationMinutos,
    required this.serviceId,
    required this.createdAt,
  });
}

@immutable
class GetActiveReservationsData {
  final List<GetActiveReservationsOrderReservations> orderReservations;
  GetActiveReservationsData.fromJson(dynamic json):
  
  orderReservations = (json['orderReservations'] as List<dynamic>)
        .map((e) => GetActiveReservationsOrderReservations.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveReservationsData otherTyped = other as GetActiveReservationsData;
    return orderReservations == otherTyped.orderReservations;
    
  }
  @override
  int get hashCode => orderReservations.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderReservations'] = orderReservations.map((e) => e.toJson()).toList();
    return json;
  }

  GetActiveReservationsData({
    required this.orderReservations,
  });
}

@immutable
class GetActiveReservationsVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetActiveReservationsVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveReservationsVariables otherTyped = other as GetActiveReservationsVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetActiveReservationsVariables({
    required this.businessId,
  });
}

