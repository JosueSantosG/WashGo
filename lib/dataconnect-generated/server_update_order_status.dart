part of 'example.dart';

class ServerUpdateOrderStatusVariablesBuilder {
  String orderId;
  OrderStatus status;
  Optional<String> _cancellationReason = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ServerUpdateOrderStatusVariablesBuilder cancellationReason(String? t) {
   _cancellationReason.value = t;
   return this;
  }

  ServerUpdateOrderStatusVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.status,});
  Deserializer<ServerUpdateOrderStatusData> dataDeserializer = (dynamic json)  => ServerUpdateOrderStatusData.fromJson(jsonDecode(json));
  Serializer<ServerUpdateOrderStatusVariables> varsSerializer = (ServerUpdateOrderStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ServerUpdateOrderStatusData, ServerUpdateOrderStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ServerUpdateOrderStatusData, ServerUpdateOrderStatusVariables> ref() {
    ServerUpdateOrderStatusVariables vars= ServerUpdateOrderStatusVariables(orderId: orderId,status: status,cancellationReason: _cancellationReason,);
    return _dataConnect.mutation("ServerUpdateOrderStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ServerUpdateOrderStatusOrderUpdate {
  final String id;
  ServerUpdateOrderStatusOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdateOrderStatusOrderUpdate otherTyped = other as ServerUpdateOrderStatusOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ServerUpdateOrderStatusOrderUpdate({
    required this.id,
  });
}

@immutable
class ServerUpdateOrderStatusData {
  final ServerUpdateOrderStatusOrderUpdate? order_update;
  ServerUpdateOrderStatusData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : ServerUpdateOrderStatusOrderUpdate.fromJson(json['order_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdateOrderStatusData otherTyped = other as ServerUpdateOrderStatusData;
    return order_update == otherTyped.order_update;
    
  }
  @override
  int get hashCode => order_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (order_update != null) {
      json['order_update'] = order_update!.toJson();
    }
    return json;
  }

  ServerUpdateOrderStatusData({
    this.order_update,
  });
}

@immutable
class ServerUpdateOrderStatusVariables {
  final String orderId;
  final OrderStatus status;
  late final Optional<String>cancellationReason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ServerUpdateOrderStatusVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  status = OrderStatus.values.byName(json['status']) {
  
  
  
  
    cancellationReason = Optional.optional(nativeFromJson, nativeToJson);
    cancellationReason.value = json['cancellationReason'] == null ? null : nativeFromJson<String>(json['cancellationReason']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdateOrderStatusVariables otherTyped = other as ServerUpdateOrderStatusVariables;
    return orderId == otherTyped.orderId && 
    status == otherTyped.status && 
    cancellationReason == otherTyped.cancellationReason;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, status.hashCode, cancellationReason.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['status'] = 
    status.name
    ;
    if(cancellationReason.state == OptionalState.set) {
      json['cancellationReason'] = cancellationReason.toJson();
    }
    return json;
  }

  ServerUpdateOrderStatusVariables({
    required this.orderId,
    required this.status,
    required this.cancellationReason,
  });
}

