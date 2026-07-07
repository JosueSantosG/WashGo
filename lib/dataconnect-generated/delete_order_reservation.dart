part of 'example.dart';

class DeleteOrderReservationVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  DeleteOrderReservationVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<DeleteOrderReservationData> dataDeserializer = (dynamic json)  => DeleteOrderReservationData.fromJson(jsonDecode(json));
  Serializer<DeleteOrderReservationVariables> varsSerializer = (DeleteOrderReservationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteOrderReservationData, DeleteOrderReservationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteOrderReservationData, DeleteOrderReservationVariables> ref() {
    DeleteOrderReservationVariables vars= DeleteOrderReservationVariables(orderId: orderId,);
    return _dataConnect.mutation("DeleteOrderReservation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteOrderReservationData {
  final int orderReservation_deleteMany;
  DeleteOrderReservationData.fromJson(dynamic json):
  
  orderReservation_deleteMany = nativeFromJson<int>(json['orderReservation_deleteMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteOrderReservationData otherTyped = other as DeleteOrderReservationData;
    return orderReservation_deleteMany == otherTyped.orderReservation_deleteMany;
    
  }
  @override
  int get hashCode => orderReservation_deleteMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderReservation_deleteMany'] = nativeToJson<int>(orderReservation_deleteMany);
    return json;
  }

  DeleteOrderReservationData({
    required this.orderReservation_deleteMany,
  });
}

@immutable
class DeleteOrderReservationVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteOrderReservationVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteOrderReservationVariables otherTyped = other as DeleteOrderReservationVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  DeleteOrderReservationVariables({
    required this.orderId,
  });
}

