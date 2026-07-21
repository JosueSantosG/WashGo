part of 'example.dart';

class GetActiveBusinessOrdersVariablesBuilder {
  String businessId;

  final FirebaseDataConnect _dataConnect;
  GetActiveBusinessOrdersVariablesBuilder(this._dataConnect, {required  this.businessId,});
  Deserializer<GetActiveBusinessOrdersData> dataDeserializer = (dynamic json)  => GetActiveBusinessOrdersData.fromJson(jsonDecode(json));
  Serializer<GetActiveBusinessOrdersVariables> varsSerializer = (GetActiveBusinessOrdersVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetActiveBusinessOrdersData, GetActiveBusinessOrdersVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetActiveBusinessOrdersData, GetActiveBusinessOrdersVariables> ref() {
    GetActiveBusinessOrdersVariables vars= GetActiveBusinessOrdersVariables(businessId: businessId,);
    return _dataConnect.query("GetActiveBusinessOrders", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetActiveBusinessOrdersOrders {
  final String id;
  final double price;
  final double costo;
  final String? serviceName;
  final String? observations;
  final EnumValue<OrderType> type;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final GetActiveBusinessOrdersOrdersClient client;
  final GetActiveBusinessOrdersOrdersEmployee? employee;
  final GetActiveBusinessOrdersOrdersService? service;
  GetActiveBusinessOrdersOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  type = orderTypeDeserializer(json['type']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  client = GetActiveBusinessOrdersOrdersClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : GetActiveBusinessOrdersOrdersEmployee.fromJson(json['employee']),
  service = json['service'] == null ? null : GetActiveBusinessOrdersOrdersService.fromJson(json['service']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBusinessOrdersOrders otherTyped = other as GetActiveBusinessOrdersOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    client == otherTyped.client && 
    employee == otherTyped.employee && 
    service == otherTyped.service;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, observations.hashCode, type.hashCode, paymentMethod.hashCode, status.hashCode, client.hashCode, employee.hashCode, service.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    json['costo'] = nativeToJson<double>(costo);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    json['type'] = 
    orderTypeSerializer(type)
    ;
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    json['status'] = 
    orderStatusSerializer(status)
    ;
    json['client'] = client.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    if (service != null) {
      json['service'] = service!.toJson();
    }
    return json;
  }

  GetActiveBusinessOrdersOrders({
    required this.id,
    required this.price,
    required this.costo,
    this.serviceName,
    this.observations,
    required this.type,
    required this.paymentMethod,
    required this.status,
    required this.client,
    this.employee,
    this.service,
  });
}

@immutable
class GetActiveBusinessOrdersOrdersClient {
  final String id;
  final String nombreCompleto;
  GetActiveBusinessOrdersOrdersClient.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBusinessOrdersOrdersClient otherTyped = other as GetActiveBusinessOrdersOrdersClient;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  GetActiveBusinessOrdersOrdersClient({
    required this.id,
    required this.nombreCompleto,
  });
}

@immutable
class GetActiveBusinessOrdersOrdersEmployee {
  final String id;
  final String nombreCompleto;
  GetActiveBusinessOrdersOrdersEmployee.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBusinessOrdersOrdersEmployee otherTyped = other as GetActiveBusinessOrdersOrdersEmployee;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  GetActiveBusinessOrdersOrdersEmployee({
    required this.id,
    required this.nombreCompleto,
  });
}

@immutable
class GetActiveBusinessOrdersOrdersService {
  final String id;
  final int duracionMinutos;
  GetActiveBusinessOrdersOrdersService.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  duracionMinutos = nativeFromJson<int>(json['duracionMinutos']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBusinessOrdersOrdersService otherTyped = other as GetActiveBusinessOrdersOrdersService;
    return id == otherTyped.id && 
    duracionMinutos == otherTyped.duracionMinutos;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, duracionMinutos.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['duracionMinutos'] = nativeToJson<int>(duracionMinutos);
    return json;
  }

  GetActiveBusinessOrdersOrdersService({
    required this.id,
    required this.duracionMinutos,
  });
}

@immutable
class GetActiveBusinessOrdersData {
  final List<GetActiveBusinessOrdersOrders> orders;
  GetActiveBusinessOrdersData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetActiveBusinessOrdersOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBusinessOrdersData otherTyped = other as GetActiveBusinessOrdersData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetActiveBusinessOrdersData({
    required this.orders,
  });
}

@immutable
class GetActiveBusinessOrdersVariables {
  final String businessId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetActiveBusinessOrdersVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBusinessOrdersVariables otherTyped = other as GetActiveBusinessOrdersVariables;
    return businessId == otherTyped.businessId;
    
  }
  @override
  int get hashCode => businessId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    return json;
  }

  GetActiveBusinessOrdersVariables({
    required this.businessId,
  });
}

