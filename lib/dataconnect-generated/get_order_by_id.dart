part of 'example.dart';

class GetOrderByIdVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetOrderByIdVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetOrderByIdData> dataDeserializer = (dynamic json)  => GetOrderByIdData.fromJson(jsonDecode(json));
  Serializer<GetOrderByIdVariables> varsSerializer = (GetOrderByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetOrderByIdData, GetOrderByIdVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetOrderByIdData, GetOrderByIdVariables> ref() {
    GetOrderByIdVariables vars= GetOrderByIdVariables(id: id,);
    return _dataConnect.query("GetOrderById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetOrderByIdOrder {
  final String id;
  final GetOrderByIdOrderBusiness business;
  final double costo;
  final String? serviceName;
  final EnumValue<OrderStatus> status;
  final String? observations;
  final String? cancellationReason;
  final double price;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderType> type;
  final GetOrderByIdOrderClient client;
  final GetOrderByIdOrderEmployee? employee;
  GetOrderByIdOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  business = GetOrderByIdOrderBusiness.fromJson(json['business']),
  costo = nativeFromJson<double>(json['costo']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  status = orderStatusDeserializer(json['status']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  cancellationReason = json['cancellationReason'] == null ? null : nativeFromJson<String>(json['cancellationReason']),
  price = nativeFromJson<double>(json['price']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  type = orderTypeDeserializer(json['type']),
  client = GetOrderByIdOrderClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : GetOrderByIdOrderEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderByIdOrder otherTyped = other as GetOrderByIdOrder;
    return id == otherTyped.id && 
    business == otherTyped.business && 
    costo == otherTyped.costo && 
    serviceName == otherTyped.serviceName && 
    status == otherTyped.status && 
    observations == otherTyped.observations && 
    cancellationReason == otherTyped.cancellationReason && 
    price == otherTyped.price && 
    paymentMethod == otherTyped.paymentMethod && 
    type == otherTyped.type && 
    client == otherTyped.client && 
    employee == otherTyped.employee;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, business.hashCode, costo.hashCode, serviceName.hashCode, status.hashCode, observations.hashCode, cancellationReason.hashCode, price.hashCode, paymentMethod.hashCode, type.hashCode, client.hashCode, employee.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['business'] = business.toJson();
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
    json['client'] = client.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    return json;
  }

  GetOrderByIdOrder({
    required this.id,
    required this.business,
    required this.costo,
    this.serviceName,
    required this.status,
    this.observations,
    this.cancellationReason,
    required this.price,
    required this.paymentMethod,
    required this.type,
    required this.client,
    this.employee,
  });
}

@immutable
class GetOrderByIdOrderBusiness {
  final String id;
  final String nombre;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final GetOrderByIdOrderBusinessOwner owner;
  GetOrderByIdOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  owner = GetOrderByIdOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderByIdOrderBusiness otherTyped = other as GetOrderByIdOrderBusiness;
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

  GetOrderByIdOrderBusiness({
    required this.id,
    required this.nombre,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    required this.owner,
  });
}

@immutable
class GetOrderByIdOrderBusinessOwner {
  final String id;
  GetOrderByIdOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderByIdOrderBusinessOwner otherTyped = other as GetOrderByIdOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetOrderByIdOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class GetOrderByIdOrderClient {
  final String id;
  final String nombreCompleto;
  final String? telefono;
  final String email;
  GetOrderByIdOrderClient.fromJson(dynamic json):
  
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

    final GetOrderByIdOrderClient otherTyped = other as GetOrderByIdOrderClient;
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

  GetOrderByIdOrderClient({
    required this.id,
    required this.nombreCompleto,
    this.telefono,
    required this.email,
  });
}

@immutable
class GetOrderByIdOrderEmployee {
  final String id;
  final String nombreCompleto;
  GetOrderByIdOrderEmployee.fromJson(dynamic json):
  
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

    final GetOrderByIdOrderEmployee otherTyped = other as GetOrderByIdOrderEmployee;
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

  GetOrderByIdOrderEmployee({
    required this.id,
    required this.nombreCompleto,
  });
}

@immutable
class GetOrderByIdData {
  final GetOrderByIdOrder? order;
  GetOrderByIdData.fromJson(dynamic json):
  
  order = json['order'] == null ? null : GetOrderByIdOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderByIdData otherTyped = other as GetOrderByIdData;
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

  GetOrderByIdData({
    this.order,
  });
}

@immutable
class GetOrderByIdVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetOrderByIdVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOrderByIdVariables otherTyped = other as GetOrderByIdVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetOrderByIdVariables({
    required this.id,
  });
}

