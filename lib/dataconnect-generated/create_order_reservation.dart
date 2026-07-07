part of 'example.dart';

class CreateOrderReservationVariablesBuilder {
  String orderId;
  String businessId;
  Timestamp scheduledAt;
  int serviceDurationMinutos;
  String serviceId;
  Timestamp createdAt;

  final FirebaseDataConnect _dataConnect;
  CreateOrderReservationVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.businessId,required  this.scheduledAt,required  this.serviceDurationMinutos,required  this.serviceId,required  this.createdAt,});
  Deserializer<CreateOrderReservationData> dataDeserializer = (dynamic json)  => CreateOrderReservationData.fromJson(jsonDecode(json));
  Serializer<CreateOrderReservationVariables> varsSerializer = (CreateOrderReservationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateOrderReservationData, CreateOrderReservationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateOrderReservationData, CreateOrderReservationVariables> ref() {
    CreateOrderReservationVariables vars= CreateOrderReservationVariables(orderId: orderId,businessId: businessId,scheduledAt: scheduledAt,serviceDurationMinutos: serviceDurationMinutos,serviceId: serviceId,createdAt: createdAt,);
    return _dataConnect.mutation("CreateOrderReservation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateOrderReservationOrderReservationInsert {
  final String id;
  CreateOrderReservationOrderReservationInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderReservationOrderReservationInsert otherTyped = other as CreateOrderReservationOrderReservationInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateOrderReservationOrderReservationInsert({
    required this.id,
  });
}

@immutable
class CreateOrderReservationData {
  final CreateOrderReservationOrderReservationInsert orderReservation_insert;
  CreateOrderReservationData.fromJson(dynamic json):
  
  orderReservation_insert = CreateOrderReservationOrderReservationInsert.fromJson(json['orderReservation_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateOrderReservationData otherTyped = other as CreateOrderReservationData;
    return orderReservation_insert == otherTyped.orderReservation_insert;
    
  }
  @override
  int get hashCode => orderReservation_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderReservation_insert'] = orderReservation_insert.toJson();
    return json;
  }

  CreateOrderReservationData({
    required this.orderReservation_insert,
  });
}

@immutable
class CreateOrderReservationVariables {
  final String orderId;
  final String businessId;
  final Timestamp scheduledAt;
  final int serviceDurationMinutos;
  final String serviceId;
  final Timestamp createdAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateOrderReservationVariables.fromJson(Map<String, dynamic> json):
  
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

    final CreateOrderReservationVariables otherTyped = other as CreateOrderReservationVariables;
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

  CreateOrderReservationVariables({
    required this.orderId,
    required this.businessId,
    required this.scheduledAt,
    required this.serviceDurationMinutos,
    required this.serviceId,
    required this.createdAt,
  });
}

