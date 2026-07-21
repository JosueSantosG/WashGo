part of 'example.dart';

class GetPaymentProofVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetPaymentProofVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetPaymentProofData> dataDeserializer = (dynamic json)  => GetPaymentProofData.fromJson(jsonDecode(json));
  Serializer<GetPaymentProofVariables> varsSerializer = (GetPaymentProofVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPaymentProofData, GetPaymentProofVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPaymentProofData, GetPaymentProofVariables> ref() {
    GetPaymentProofVariables vars= GetPaymentProofVariables(orderId: orderId,);
    return _dataConnect.query("GetPaymentProof", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPaymentProofPaymentProofs {
  final String id;
  final String imageUrl;
  final double declaredAmount;
  final EnumValue<PaymentAccountType> paymentAccountType;
  final String? referenceNumber;
  final String? observations;
  final EnumValue<PaymentProofStatus> status;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? reviewedBy;
  final Timestamp? reviewedAt;
  final GetPaymentProofPaymentProofsOrder order;
  GetPaymentProofPaymentProofs.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  declaredAmount = nativeFromJson<double>(json['declaredAmount']),
  paymentAccountType = paymentAccountTypeDeserializer(json['paymentAccountType']),
  referenceNumber = json['referenceNumber'] == null ? null : nativeFromJson<String>(json['referenceNumber']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  status = paymentProofStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']),
  reviewedBy = json['reviewedBy'] == null ? null : nativeFromJson<String>(json['reviewedBy']),
  reviewedAt = json['reviewedAt'] == null ? null : Timestamp.fromJson(json['reviewedAt']),
  order = GetPaymentProofPaymentProofsOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPaymentProofPaymentProofs otherTyped = other as GetPaymentProofPaymentProofs;
    return id == otherTyped.id && 
    imageUrl == otherTyped.imageUrl && 
    declaredAmount == otherTyped.declaredAmount && 
    paymentAccountType == otherTyped.paymentAccountType && 
    referenceNumber == otherTyped.referenceNumber && 
    observations == otherTyped.observations && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt && 
    reviewedBy == otherTyped.reviewedBy && 
    reviewedAt == otherTyped.reviewedAt && 
    order == otherTyped.order;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, imageUrl.hashCode, declaredAmount.hashCode, paymentAccountType.hashCode, referenceNumber.hashCode, observations.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode, reviewedBy.hashCode, reviewedAt.hashCode, order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['declaredAmount'] = nativeToJson<double>(declaredAmount);
    json['paymentAccountType'] = 
    paymentAccountTypeSerializer(paymentAccountType)
    ;
    if (referenceNumber != null) {
      json['referenceNumber'] = nativeToJson<String?>(referenceNumber);
    }
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    json['status'] = 
    paymentProofStatusSerializer(status)
    ;
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    if (reviewedBy != null) {
      json['reviewedBy'] = nativeToJson<String?>(reviewedBy);
    }
    if (reviewedAt != null) {
      json['reviewedAt'] = reviewedAt!.toJson();
    }
    json['order'] = order.toJson();
    return json;
  }

  GetPaymentProofPaymentProofs({
    required this.id,
    required this.imageUrl,
    required this.declaredAmount,
    required this.paymentAccountType,
    this.referenceNumber,
    this.observations,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedBy,
    this.reviewedAt,
    required this.order,
  });
}

@immutable
class GetPaymentProofPaymentProofsOrder {
  final String id;
  final String clientId;
  final EnumValue<OrderStatus> status;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  final String? serviceName;
  final GetPaymentProofPaymentProofsOrderBusiness business;
  GetPaymentProofPaymentProofsOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  clientId = nativeFromJson<String>(json['clientId']),
  status = orderStatusDeserializer(json['status']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  business = GetPaymentProofPaymentProofsOrderBusiness.fromJson(json['business']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPaymentProofPaymentProofsOrder otherTyped = other as GetPaymentProofPaymentProofsOrder;
    return id == otherTyped.id && 
    clientId == otherTyped.clientId && 
    status == otherTyped.status && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod && 
    serviceName == otherTyped.serviceName && 
    business == otherTyped.business;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, clientId.hashCode, status.hashCode, price.hashCode, paymentMethod.hashCode, serviceName.hashCode, business.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['clientId'] = nativeToJson<String>(clientId);
    json['status'] = 
    orderStatusSerializer(status)
    ;
    json['price'] = nativeToJson<double>(price);
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['business'] = business.toJson();
    return json;
  }

  GetPaymentProofPaymentProofsOrder({
    required this.id,
    required this.clientId,
    required this.status,
    required this.price,
    required this.paymentMethod,
    this.serviceName,
    required this.business,
  });
}

@immutable
class GetPaymentProofPaymentProofsOrderBusiness {
  final String id;
  final String nombre;
  final GetPaymentProofPaymentProofsOrderBusinessOwner owner;
  GetPaymentProofPaymentProofsOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  owner = GetPaymentProofPaymentProofsOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPaymentProofPaymentProofsOrderBusiness otherTyped = other as GetPaymentProofPaymentProofsOrderBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, owner.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['owner'] = owner.toJson();
    return json;
  }

  GetPaymentProofPaymentProofsOrderBusiness({
    required this.id,
    required this.nombre,
    required this.owner,
  });
}

@immutable
class GetPaymentProofPaymentProofsOrderBusinessOwner {
  final String id;
  GetPaymentProofPaymentProofsOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPaymentProofPaymentProofsOrderBusinessOwner otherTyped = other as GetPaymentProofPaymentProofsOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetPaymentProofPaymentProofsOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class GetPaymentProofData {
  final List<GetPaymentProofPaymentProofs> paymentProofs;
  GetPaymentProofData.fromJson(dynamic json):
  
  paymentProofs = (json['paymentProofs'] as List<dynamic>)
        .map((e) => GetPaymentProofPaymentProofs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPaymentProofData otherTyped = other as GetPaymentProofData;
    return paymentProofs == otherTyped.paymentProofs;
    
  }
  @override
  int get hashCode => paymentProofs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paymentProofs'] = paymentProofs.map((e) => e.toJson()).toList();
    return json;
  }

  GetPaymentProofData({
    required this.paymentProofs,
  });
}

@immutable
class GetPaymentProofVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPaymentProofVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPaymentProofVariables otherTyped = other as GetPaymentProofVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetPaymentProofVariables({
    required this.orderId,
  });
}

