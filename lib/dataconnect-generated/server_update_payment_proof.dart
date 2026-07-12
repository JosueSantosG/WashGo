part of 'example.dart';

class ServerUpdatePaymentProofVariablesBuilder {
  String id;
  String imageUrl;
  double declaredAmount;
  PaymentAccountType paymentAccountType;
  Optional<String> _referenceNumber = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ServerUpdatePaymentProofVariablesBuilder referenceNumber(String? t) {
   _referenceNumber.value = t;
   return this;
  }
  ServerUpdatePaymentProofVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  ServerUpdatePaymentProofVariablesBuilder(this._dataConnect, {required  this.id,required  this.imageUrl,required  this.declaredAmount,required  this.paymentAccountType,});
  Deserializer<ServerUpdatePaymentProofData> dataDeserializer = (dynamic json)  => ServerUpdatePaymentProofData.fromJson(jsonDecode(json));
  Serializer<ServerUpdatePaymentProofVariables> varsSerializer = (ServerUpdatePaymentProofVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ServerUpdatePaymentProofData, ServerUpdatePaymentProofVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ServerUpdatePaymentProofData, ServerUpdatePaymentProofVariables> ref() {
    ServerUpdatePaymentProofVariables vars= ServerUpdatePaymentProofVariables(id: id,imageUrl: imageUrl,declaredAmount: declaredAmount,paymentAccountType: paymentAccountType,referenceNumber: _referenceNumber,observations: _observations,);
    return _dataConnect.mutation("ServerUpdatePaymentProof", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ServerUpdatePaymentProofPaymentProofUpdate {
  final String id;
  ServerUpdatePaymentProofPaymentProofUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdatePaymentProofPaymentProofUpdate otherTyped = other as ServerUpdatePaymentProofPaymentProofUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ServerUpdatePaymentProofPaymentProofUpdate({
    required this.id,
  });
}

@immutable
class ServerUpdatePaymentProofData {
  final ServerUpdatePaymentProofPaymentProofUpdate? paymentProof_update;
  ServerUpdatePaymentProofData.fromJson(dynamic json):
  
  paymentProof_update = json['paymentProof_update'] == null ? null : ServerUpdatePaymentProofPaymentProofUpdate.fromJson(json['paymentProof_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerUpdatePaymentProofData otherTyped = other as ServerUpdatePaymentProofData;
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

  ServerUpdatePaymentProofData({
    this.paymentProof_update,
  });
}

@immutable
class ServerUpdatePaymentProofVariables {
  final String id;
  final String imageUrl;
  final double declaredAmount;
  final PaymentAccountType paymentAccountType;
  late final Optional<String>referenceNumber;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ServerUpdatePaymentProofVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  declaredAmount = nativeFromJson<double>(json['declaredAmount']),
  paymentAccountType = PaymentAccountType.values.byName(json['paymentAccountType']) {
  
  
  
  
  
  
    referenceNumber = Optional.optional(nativeFromJson, nativeToJson);
    referenceNumber.value = json['referenceNumber'] == null ? null : nativeFromJson<String>(json['referenceNumber']);
  
  
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

    final ServerUpdatePaymentProofVariables otherTyped = other as ServerUpdatePaymentProofVariables;
    return id == otherTyped.id && 
    imageUrl == otherTyped.imageUrl && 
    declaredAmount == otherTyped.declaredAmount && 
    paymentAccountType == otherTyped.paymentAccountType && 
    referenceNumber == otherTyped.referenceNumber && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, imageUrl.hashCode, declaredAmount.hashCode, paymentAccountType.hashCode, referenceNumber.hashCode, observations.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['declaredAmount'] = nativeToJson<double>(declaredAmount);
    json['paymentAccountType'] = 
    paymentAccountType.name
    ;
    if(referenceNumber.state == OptionalState.set) {
      json['referenceNumber'] = referenceNumber.toJson();
    }
    if(observations.state == OptionalState.set) {
      json['observations'] = observations.toJson();
    }
    return json;
  }

  ServerUpdatePaymentProofVariables({
    required this.id,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    required this.referenceNumber,
    required this.observations,
  });
}

