part of 'example.dart';

class UpdateOrderPaymentMethodAndStatusVariablesBuilder {
  String orderId;
  PaymentMethod paymentMethod;
  OrderStatus status;
  Optional<String> _cancellationReason = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateOrderPaymentMethodAndStatusVariablesBuilder cancellationReason(String? t) {
   _cancellationReason.value = t;
   return this;
  }

  UpdateOrderPaymentMethodAndStatusVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.paymentMethod,required  this.status,});
  Deserializer<UpdateOrderPaymentMethodAndStatusData> dataDeserializer = (dynamic json)  => UpdateOrderPaymentMethodAndStatusData.fromJson(jsonDecode(json));
  Serializer<UpdateOrderPaymentMethodAndStatusVariables> varsSerializer = (UpdateOrderPaymentMethodAndStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateOrderPaymentMethodAndStatusData, UpdateOrderPaymentMethodAndStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateOrderPaymentMethodAndStatusData, UpdateOrderPaymentMethodAndStatusVariables> ref() {
    UpdateOrderPaymentMethodAndStatusVariables vars= UpdateOrderPaymentMethodAndStatusVariables(orderId: orderId,paymentMethod: paymentMethod,status: status,cancellationReason: _cancellationReason,);
    return _dataConnect.mutation("UpdateOrderPaymentMethodAndStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateOrderPaymentMethodAndStatusOrderUpdate {
  final String id;
  UpdateOrderPaymentMethodAndStatusOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateOrderPaymentMethodAndStatusOrderUpdate otherTyped = other as UpdateOrderPaymentMethodAndStatusOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateOrderPaymentMethodAndStatusOrderUpdate({
    required this.id,
  });
}

@immutable
class UpdateOrderPaymentMethodAndStatusData {
  final UpdateOrderPaymentMethodAndStatusOrderUpdate? order_update;
  UpdateOrderPaymentMethodAndStatusData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : UpdateOrderPaymentMethodAndStatusOrderUpdate.fromJson(json['order_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateOrderPaymentMethodAndStatusData otherTyped = other as UpdateOrderPaymentMethodAndStatusData;
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

  UpdateOrderPaymentMethodAndStatusData({
    this.order_update,
  });
}

@immutable
class UpdateOrderPaymentMethodAndStatusVariables {
  final String orderId;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  late final Optional<String>cancellationReason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateOrderPaymentMethodAndStatusVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  paymentMethod = PaymentMethod.values.byName(json['paymentMethod']),
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

    final UpdateOrderPaymentMethodAndStatusVariables otherTyped = other as UpdateOrderPaymentMethodAndStatusVariables;
    return orderId == otherTyped.orderId && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    cancellationReason == otherTyped.cancellationReason;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, paymentMethod.hashCode, status.hashCode, cancellationReason.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['paymentMethod'] = 
    paymentMethod.name
    ;
    json['status'] = 
    status.name
    ;
    if(cancellationReason.state == OptionalState.set) {
      json['cancellationReason'] = cancellationReason.toJson();
    }
    return json;
  }

  UpdateOrderPaymentMethodAndStatusVariables({
    required this.orderId,
    required this.paymentMethod,
    required this.status,
    required this.cancellationReason,
  });
}

