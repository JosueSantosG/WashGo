part of 'example.dart';

class CreatePaymentProofVariablesBuilder {
  String orderId;
  String imageUrl;
  double declaredAmount;
  PaymentAccountType paymentAccountType;
  Optional<String> _referenceNumber = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreatePaymentProofVariablesBuilder referenceNumber(String? t) {
   _referenceNumber.value = t;
   return this;
  }
  CreatePaymentProofVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }

  CreatePaymentProofVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.imageUrl,required  this.declaredAmount,required  this.paymentAccountType,});
  Deserializer<CreatePaymentProofData> dataDeserializer = (dynamic json)  => CreatePaymentProofData.fromJson(jsonDecode(json));
  Serializer<CreatePaymentProofVariables> varsSerializer = (CreatePaymentProofVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePaymentProofData, CreatePaymentProofVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePaymentProofData, CreatePaymentProofVariables> ref() {
    CreatePaymentProofVariables vars= CreatePaymentProofVariables(orderId: orderId,imageUrl: imageUrl,declaredAmount: declaredAmount,paymentAccountType: paymentAccountType,referenceNumber: _referenceNumber,observations: _observations,);
    return _dataConnect.mutation("CreatePaymentProof", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePaymentProofPaymentProofInsert {
  final String id;
  CreatePaymentProofPaymentProofInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePaymentProofPaymentProofInsert otherTyped = other as CreatePaymentProofPaymentProofInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePaymentProofPaymentProofInsert({
    required this.id,
  });
}

@immutable
class CreatePaymentProofData {
  final CreatePaymentProofPaymentProofInsert paymentProof_insert;
  CreatePaymentProofData.fromJson(dynamic json):
  
  paymentProof_insert = CreatePaymentProofPaymentProofInsert.fromJson(json['paymentProof_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePaymentProofData otherTyped = other as CreatePaymentProofData;
    return paymentProof_insert == otherTyped.paymentProof_insert;
    
  }
  @override
  int get hashCode => paymentProof_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paymentProof_insert'] = paymentProof_insert.toJson();
    return json;
  }

  CreatePaymentProofData({
    required this.paymentProof_insert,
  });
}

@immutable
class CreatePaymentProofVariables {
  final String orderId;
  final String imageUrl;
  final double declaredAmount;
  final PaymentAccountType paymentAccountType;
  late final Optional<String>referenceNumber;
  late final Optional<String>observations;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePaymentProofVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
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

    final CreatePaymentProofVariables otherTyped = other as CreatePaymentProofVariables;
    return orderId == otherTyped.orderId && 
    imageUrl == otherTyped.imageUrl && 
    declaredAmount == otherTyped.declaredAmount && 
    paymentAccountType == otherTyped.paymentAccountType && 
    referenceNumber == otherTyped.referenceNumber && 
    observations == otherTyped.observations;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, imageUrl.hashCode, declaredAmount.hashCode, paymentAccountType.hashCode, referenceNumber.hashCode, observations.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
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

  CreatePaymentProofVariables({
    required this.orderId,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    required this.referenceNumber,
    required this.observations,
  });
}

