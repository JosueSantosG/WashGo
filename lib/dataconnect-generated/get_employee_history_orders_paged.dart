part of 'example.dart';

class GetEmployeeHistoryOrdersPagedVariablesBuilder {
  String businessId;
  String employeeId;
  int limit;
  int offset;

  final FirebaseDataConnect _dataConnect;
  GetEmployeeHistoryOrdersPagedVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.employeeId,required  this.limit,required  this.offset,});
  Deserializer<GetEmployeeHistoryOrdersPagedData> dataDeserializer = (dynamic json)  => GetEmployeeHistoryOrdersPagedData.fromJson(jsonDecode(json));
  Serializer<GetEmployeeHistoryOrdersPagedVariables> varsSerializer = (GetEmployeeHistoryOrdersPagedVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetEmployeeHistoryOrdersPagedData, GetEmployeeHistoryOrdersPagedVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetEmployeeHistoryOrdersPagedData, GetEmployeeHistoryOrdersPagedVariables> ref() {
    GetEmployeeHistoryOrdersPagedVariables vars= GetEmployeeHistoryOrdersPagedVariables(businessId: businessId,employeeId: employeeId,limit: limit,offset: offset,);
    return _dataConnect.query("GetEmployeeHistoryOrdersPaged", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetEmployeeHistoryOrdersPagedOrders {
  final String id;
  final double price;
  final double costo;
  final String? serviceName;
  final String? observations;
  final EnumValue<OrderType> type;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final GetEmployeeHistoryOrdersPagedOrdersClient client;
  final GetEmployeeHistoryOrdersPagedOrdersEmployee? employee;
  GetEmployeeHistoryOrdersPagedOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  type = orderTypeDeserializer(json['type']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  client = GetEmployeeHistoryOrdersPagedOrdersClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : GetEmployeeHistoryOrdersPagedOrdersEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeHistoryOrdersPagedOrders otherTyped = other as GetEmployeeHistoryOrdersPagedOrders;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    observations == otherTyped.observations && 
    type == otherTyped.type && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    client == otherTyped.client && 
    employee == otherTyped.employee;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, costo.hashCode, serviceName.hashCode, observations.hashCode, type.hashCode, paymentMethod.hashCode, status.hashCode, client.hashCode, employee.hashCode]);
  

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
    return json;
  }

  GetEmployeeHistoryOrdersPagedOrders({
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
  });
}

@immutable
class GetEmployeeHistoryOrdersPagedOrdersClient {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;
  GetEmployeeHistoryOrdersPagedOrdersClient.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  fotoPerfil = json['fotoPerfil'] == null ? null : nativeFromJson<String>(json['fotoPerfil']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeHistoryOrdersPagedOrdersClient otherTyped = other as GetEmployeeHistoryOrdersPagedOrdersClient;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    fotoPerfil == otherTyped.fotoPerfil && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, fotoPerfil.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (fotoPerfil != null) {
      json['fotoPerfil'] = nativeToJson<String?>(fotoPerfil);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetEmployeeHistoryOrdersPagedOrdersClient({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

@immutable
class GetEmployeeHistoryOrdersPagedOrdersEmployee {
  final String id;
  final String nombreCompleto;
  final String? fotoPerfil;
  final String? telefono;
  GetEmployeeHistoryOrdersPagedOrdersEmployee.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  fotoPerfil = json['fotoPerfil'] == null ? null : nativeFromJson<String>(json['fotoPerfil']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeHistoryOrdersPagedOrdersEmployee otherTyped = other as GetEmployeeHistoryOrdersPagedOrdersEmployee;
    return id == otherTyped.id && 
    nombreCompleto == otherTyped.nombreCompleto && 
    fotoPerfil == otherTyped.fotoPerfil && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombreCompleto.hashCode, fotoPerfil.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (fotoPerfil != null) {
      json['fotoPerfil'] = nativeToJson<String?>(fotoPerfil);
    }
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetEmployeeHistoryOrdersPagedOrdersEmployee({
    required this.id,
    required this.nombreCompleto,
    this.fotoPerfil,
    this.telefono,
  });
}

@immutable
class GetEmployeeHistoryOrdersPagedData {
  final List<GetEmployeeHistoryOrdersPagedOrders> orders;
  GetEmployeeHistoryOrdersPagedData.fromJson(dynamic json):
  
  orders = (json['orders'] as List<dynamic>)
        .map((e) => GetEmployeeHistoryOrdersPagedOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeHistoryOrdersPagedData otherTyped = other as GetEmployeeHistoryOrdersPagedData;
    return orders == otherTyped.orders;
    
  }
  @override
  int get hashCode => orders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orders'] = orders.map((e) => e.toJson()).toList();
    return json;
  }

  GetEmployeeHistoryOrdersPagedData({
    required this.orders,
  });
}

@immutable
class GetEmployeeHistoryOrdersPagedVariables {
  final String businessId;
  final String employeeId;
  final int limit;
  final int offset;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetEmployeeHistoryOrdersPagedVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  employeeId = nativeFromJson<String>(json['employeeId']),
  limit = nativeFromJson<int>(json['limit']),
  offset = nativeFromJson<int>(json['offset']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetEmployeeHistoryOrdersPagedVariables otherTyped = other as GetEmployeeHistoryOrdersPagedVariables;
    return businessId == otherTyped.businessId && 
    employeeId == otherTyped.employeeId && 
    limit == otherTyped.limit && 
    offset == otherTyped.offset;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, employeeId.hashCode, limit.hashCode, offset.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['employeeId'] = nativeToJson<String>(employeeId);
    json['limit'] = nativeToJson<int>(limit);
    json['offset'] = nativeToJson<int>(offset);
    return json;
  }

  GetEmployeeHistoryOrdersPagedVariables({
    required this.businessId,
    required this.employeeId,
    required this.limit,
    required this.offset,
  });
}

