part of 'example.dart';

class ServerUpdatePaymentProofStatusVariablesBuilder {
  String id;
  PaymentProofStatus status;
  String reviewedBy;
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ServerUpdatePaymentProofStatusVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ServerUpdatePaymentProofStatusVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,required  this.reviewedBy,});
  Deserializer<ServerUpdatePaymentProofStatusData> dataDeserializer = (dynamic json)  => ServerUpdatePaymentProofStatusData.fromJson(jsonDecode(json));
  Serializer<ServerUpdatePaymentProofStatusVariables> varsSerializer = (ServerUpdatePaymentProofStatusVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ServerUpdatePaymentProofStatusData, ServerUpdatePaymentProofStatusVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ServerUpdatePaymentProofStatusData, ServerUpdatePaymentProofStatusVariables> ref() {
    ServerUpdatePaymentProofStatusVariables vars= ServerUpdatePaymentProofStatusVariables(id: id,status: status,reviewedBy: reviewedBy,observations: _observations,);
    return _dataConnect.mutation("ServerUpdatePaymentProofStatus", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ServerUpdatePaymentProofStatusPaymentProofUpdate {
  final String id;
  ServerUpdatePaymentProofStatusPaymentProofUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdatePaymentProofStatusPaymentProofUpdate otherTyped = other as ServerUpdatePaymentProofStatusPaymentProofUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ServerUpdatePaymentProofStatusPaymentProofUpdate({
    required this.id,
  });
}

@immutable
class ServerUpdatePaymentProofStatusData {
  final ServerUpdatePaymentProofStatusPaymentProofUpdate? paymentProof_update;
  ServerUpdatePaymentProofStatusData.fromJson(dynamic json):
  
  paymentProof_update = json['paymentProof_update'] == null ? null : ServerUpdatePaymentProofStatusPaymentProofUpdate.fromJson(json['paymentProof_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdatePaymentProofStatusData otherTyped = other as ServerUpdatePaymentProofStatusData;
    return paymentProof_update == otherTyped.paymentProof_update;
    
  }
  @override
  int get hashCode => paymentProof_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (paymentProof_update != null) {
      json['paymentProof_update'] = paymentProof_update!.toJson();
    }
    return json;
  }

  ServerUpdatePaymentProofStatusData({
    this.paymentProof_update,
  });
}

@immutable
class ServerUpdatePaymentProofStatusVariables {
  final String id;
  final PaymentProofStatus status;
  final String reviewedBy;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ServerUpdatePaymentProofStatusVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  status = PaymentProofStatus.values.byName(json['status']),
  reviewedBy = nativeFromJson<String>(json['reviewedBy']) {
  
  
  
  
  
    observations = Optional.optional(nativeFromJson, nativeToJson);
    observations.value = json['observations'] == null ? null : nativeFromJson<String>(json['observations']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdatePaymentProofStatusVariables otherTyped = other as ServerUpdatePaymentProofStatusVariables;
    return id == otherTyped.id && 
    status == otherTyped.status && 
    reviewedBy == otherTyped.reviewedBy && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode, reviewedBy.hashCode, observations.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = 
    status.name
    ;
    json['reviewedBy'] = nativeToJson<String>(reviewedBy);
    if(observations.state == OptionalState.set) {
      json['observations'] = observations.toJson();
    }
    return json;
  }

  ServerUpdatePaymentProofStatusVariables({
    required this.id,
    required this.status,
    required this.reviewedBy,
    required this.observations,
  });
}

