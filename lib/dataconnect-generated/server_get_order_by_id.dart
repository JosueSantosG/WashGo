part of 'example.dart';

class ServerGetOrderByIdVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  ServerGetOrderByIdVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ServerGetOrderByIdData> dataDeserializer = (dynamic json)  => ServerGetOrderByIdData.fromJson(jsonDecode(json));
  Serializer<ServerGetOrderByIdVariables> varsSerializer = (ServerGetOrderByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ServerGetOrderByIdData, ServerGetOrderByIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ServerGetOrderByIdData, ServerGetOrderByIdVariables> ref() {
    ServerGetOrderByIdVariables vars= ServerGetOrderByIdVariables(id: id,);
    return _dataConnect.query("ServerGetOrderById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ServerGetOrderByIdOrder {
  final String id;
  final String clientId;
  final String? employeeId;
  final double costo;
  final String? serviceName;
  final EnumValue<OrderStatus> status;
  final String? observations;
  final String? cancellationReason;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderType> type;
  final ServerGetOrderByIdOrderBusiness business;
  final ServerGetOrderByIdOrderClient client;
  final ServerGetOrderByIdOrderEmployee? employee;
  ServerGetOrderByIdOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  clientId = nativeFromJson<String>(json['clientId']),
  employeeId = json['employeeId'] == null ? null : nativeFromJson<String>(json['employeeId']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  status = orderStatusDeserializer(json['status']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  cancellationReason = json['cancellationReason'] == null ? null : nativeFromJson<String>(json['cancellationReason']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  type = orderTypeDeserializer(json['type']),
  business = ServerGetOrderByIdOrderBusiness.fromJson(json['business']),
  client = ServerGetOrderByIdOrderClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : ServerGetOrderByIdOrderEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerGetOrderByIdOrder otherTyped = other as ServerGetOrderByIdOrder;
    return id == otherTyped.id && 
    clientId == otherTyped.clientId && 
    employeeId == otherTyped.employeeId && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    status == otherTyped.status && 
    observations == otherTyped.observations && 
    cancellationReason == otherTyped.cancellationReason && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod && 
    type == otherTyped.type && 
    business == otherTyped.business && 
    client == otherTyped.client && 
    employee == otherTyped.employee;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, clientId.hashCode, employeeId.hashCode, costo.hashCode, serviceName.hashCode, status.hashCode, observations.hashCode, cancellationReason.hashCode, price.hashCode, paymentMethod.hashCode, type.hashCode, business.hashCode, client.hashCode, employee.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['clientId'] = nativeToJson<String>(clientId);
    if (employeeId != null) {
      json['employeeId'] = nativeToJson<String?>(employeeId);
    }
    json['costo'] = nativeToJson<double>(costo);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['status'] = 
    orderStatusSerializer(status)
    ;
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    if (cancellationReason != null) {
      json['cancellationReason'] = nativeToJson<String?>(cancellationReason);
    }
    json['price'] = nativeToJson<double>(price);
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    json['type'] = 
    orderTypeSerializer(type)
    ;
    json['business'] = business.toJson();
    json['client'] = client.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    return json;
  }

  ServerGetOrderByIdOrder({
    required this.id,
    required this.clientId,
    this.employeeId,
    required this.costo,
    this.serviceName,
    required this.status,
    this.observations,
    this.cancellationReason,
    required this.price,
    required this.paymentMethod,
    required this.type,
    required this.business,
    required this.client,
    this.employee,
  });
}

@immutable
class ServerGetOrderByIdOrderBusiness {
  final String id;
  final String nombre;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final ServerGetOrderByIdOrderBusinessOwner owner;
  ServerGetOrderByIdOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  owner = ServerGetOrderByIdOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerGetOrderByIdOrderBusiness otherTyped = other as ServerGetOrderByIdOrderBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido && 
    owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, owner.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    json['owner'] = owner.toJson();
    return json;
  }

  ServerGetOrderByIdOrderBusiness({
    required this.id,
    required this.nombre,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    required this.owner,
  });
}

@immutable
class ServerGetOrderByIdOrderBusinessOwner {
  final String id;
  ServerGetOrderByIdOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerGetOrderByIdOrderBusinessOwner otherTyped = other as ServerGetOrderByIdOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ServerGetOrderByIdOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class ServerGetOrderByIdOrderClient {
  final String id;
  final String nombreCompleto;
  final String? telefono;
  final String email;
  ServerGetOrderByIdOrderClient.fromJson(dynamic json):
  
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

    final ServerGetOrderByIdOrderClient otherTyped = other as ServerGetOrderByIdOrderClient;
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

  ServerGetOrderByIdOrderClient({
    required this.id,
    required this.nombreCompleto,
    this.telefono,
    required this.email,
  });
}

@immutable
class ServerGetOrderByIdOrderEmployee {
  final String id;
  final String nombreCompleto;
  ServerGetOrderByIdOrderEmployee.fromJson(dynamic json):
  
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

    final ServerGetOrderByIdOrderEmployee otherTyped = other as ServerGetOrderByIdOrderEmployee;
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

  ServerGetOrderByIdOrderEmployee({
    required this.id,
    required this.nombreCompleto,
  });
}

@immutable
class ServerGetOrderByIdData {
  final ServerGetOrderByIdOrder? order;
  ServerGetOrderByIdData.fromJson(dynamic json):
  
  order = json['order'] == null ? null : ServerGetOrderByIdOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerGetOrderByIdData otherTyped = other as ServerGetOrderByIdData;
    return order == otherTyped.order;
    
  }
  @override
  int get hashCode => order.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (order != null) {
      json['order'] = order!.toJson();
    }
    return json;
  }

  ServerGetOrderByIdData({
    this.order,
  });
}

@immutable
class ServerGetOrderByIdVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ServerGetOrderByIdVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ServerGetOrderByIdVariables otherTyped = other as ServerGetOrderByIdVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ServerGetOrderByIdVariables({
    required this.id,
  });
}

