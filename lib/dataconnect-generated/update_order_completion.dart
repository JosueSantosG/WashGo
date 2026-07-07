part of 'example.dart';

class UpdateOrderCompletionVariablesBuilder {
  String orderId;
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _invoiceUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateOrderCompletionVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  UpdateOrderCompletionVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  UpdateOrderCompletionVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<UpdateOrderCompletionData> dataDeserializer = (dynamic json)  => UpdateOrderCompletionData.fromJson(jsonDecode(json));
  Serializer<UpdateOrderCompletionVariables> varsSerializer = (UpdateOrderCompletionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateOrderCompletionData, UpdateOrderCompletionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateOrderCompletionData, UpdateOrderCompletionVariables> ref() {
    UpdateOrderCompletionVariables vars= UpdateOrderCompletionVariables(orderId: orderId,observations: _observations,invoiceUrl: _invoiceUrl,);
    return _dataConnect.mutation("UpdateOrderCompletion", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateOrderCompletionOrderUpdate {
  final String id;
  UpdateOrderCompletionOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateOrderCompletionOrderUpdate otherTyped = other as UpdateOrderCompletionOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateOrderCompletionOrderUpdate({
    required this.id,
  });
}

@immutable
class UpdateOrderCompletionData {
  final UpdateOrderCompletionOrderUpdate? order_update;
  UpdateOrderCompletionData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : UpdateOrderCompletionOrderUpdate.fromJson(json['order_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateOrderCompletionData otherTyped = other as UpdateOrderCompletionData;
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

  UpdateOrderCompletionData({
    this.order_update,
  });
}

@immutable
class UpdateOrderCompletionVariables {
  final String orderId;
  late final Optional<String>observations;
  late final Optional<String>invoiceUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateOrderCompletionVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']) {
  
  
  
    observations = Optional.optional(nativeFromJson, nativeToJson);
    observations.value = json['observations'] == null ? null : nativeFromJson<String>(json['observations']);
  
  
    invoiceUrl = Optional.optional(nativeFromJson, nativeToJson);
    invoiceUrl.value = json['invoiceUrl'] == null ? null : nativeFromJson<String>(json['invoiceUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateOrderCompletionVariables otherTyped = other as UpdateOrderCompletionVariables;
    return orderId == otherTyped.orderId && 
    observations == otherTyped.observations && 
    invoiceUrl == otherTyped.invoiceUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, observations.hashCode, invoiceUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    if(observations.state == OptionalState.set) {
      json['observations'] = observations.toJson();
    }
    if(invoiceUrl.state == OptionalState.set) {
      json['invoiceUrl'] = invoiceUrl.toJson();
    }
    return json;
  }

  UpdateOrderCompletionVariables({
    required this.orderId,
    required this.observations,
    required this.invoiceUrl,
  });
}

