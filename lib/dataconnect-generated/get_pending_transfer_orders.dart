part of 'example.dart';

class GetPendingTransferOrdersVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetPendingTransferOrdersVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetPendingTransferOrdersData> dataDeserializer = (dynamic json)  => GetPendingTransferOrdersData.fromJson(jsonDecode(json));
  Serializer<GetPendingTransferOrdersVariables> varsSerializer = (GetPendingTransferOrdersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPendingTransferOrdersData, GetPendingTransferOrdersVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetPendingTransferOrdersData, GetPendingTransferOrdersVariables> ref() {
    GetPendingTransferOrdersVariables vars= GetPendingTransferOrdersVariables(businessId: businessId,);
    return _dataConnect.query("GetPendingTransferOrders", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPendingTransferOrdersOrders {
  final String id;
  final double price;
  final String? serviceName;
  final String? observations;
  final EnumValue<OrderStatus> status;
  final GetPendingTransferOrdersOrdersClient client;
  GetPendingTransferOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  status = orderStatusDeserializer(json['status']),
  client = GetPendingTransferOrdersOrdersClient.fromJson(json['client']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersOrders otherTyped = other as GetPendingTransferOrdersOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    status == otherTyped.status && 
    client == otherTyped.client;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, serviceName.hashCode, observations.hashCode, status.hashCode, client.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    json['status'] = 
    orderStatusSerializer(status)
    ;
    json['client'] = client.toJson();
    return json;
  }

  GetPendingTransferOrdersOrders({
    required this.id,
    required this.price,
    this.serviceName,
    this.observations,
    required this.status,
    required this.client,
  });
}

@immutable
class GetPendingTransferOrdersOrdersClient {
  final String id;
  final String nombreCompleto;
  final String? telefono;
  final String email;
  GetPendingTransferOrdersOrdersClient.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersOrdersClient otherTyped = other as GetPendingTransferOrdersOrdersClient;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    telefono == otherTyped.telefono && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, telefono.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  GetPendingTransferOrdersOrdersClient({
    required this.id,
    required this.nombreCompleto,
    this.telefono,
    required this.email,
  });
}

@immutable
class GetPendingTransferOrdersData {
  final List<GetPendingTransferOrdersOrders> orders;
  GetPendingTransferOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetPendingTransferOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersData otherTyped = other as GetPendingTransferOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetPendingTransferOrdersData({
    required this.orders,
  });
}

@immutable
class GetPendingTransferOrdersVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPendingTransferOrdersVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPendingTransferOrdersVariables otherTyped = other as GetPendingTransferOrdersVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetPendingTransferOrdersVariables({
    required this.businessId,
  });
}

