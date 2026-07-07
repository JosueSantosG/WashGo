part of 'example.dart';

class GetInvoiceByIdVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetInvoiceByIdVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetInvoiceByIdData> dataDeserializer = (dynamic json)  => GetInvoiceByIdData.fromJson(jsonDecode(json));
  Serializer<GetInvoiceByIdVariables> varsSerializer = (GetInvoiceByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetInvoiceByIdData, GetInvoiceByIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetInvoiceByIdData, GetInvoiceByIdVariables> ref() {
    GetInvoiceByIdVariables vars= GetInvoiceByIdVariables(id: id,);
    return _dataConnect.query("GetInvoiceById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetInvoiceByIdInvoice {
  final String id;
  final String numeroUnico;
  final Timestamp fechaEmision;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<InvoiceStatus> invoiceStatus;
  final Timestamp? generatedAt;
  final String? pdfUrl;
  final GetInvoiceByIdInvoiceOrder order;
  final List<GetInvoiceByIdInvoiceInvoiceItemsOnInvoice> invoiceItems_on_invoice;
  GetInvoiceByIdInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  numeroUnico = nativeFromJson<String>(json['numeroUnico']),
  fechaEmision = Timestamp.fromJson(json['fechaEmision']),
  subtotal = nativeFromJson<double>(json['subtotal']),
  discount = nativeFromJson<double>(json['discount']),
  tax = nativeFromJson<double>(json['tax']),
  total = nativeFromJson<double>(json['total']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  invoiceStatus = invoiceStatusDeserializer(json['invoiceStatus']),
  generatedAt = json['generatedAt'] == null ? null : Timestamp.fromJson(json['generatedAt']),
  pdfUrl = json['pdfUrl'] == null ? null : nativeFromJson<String>(json['pdfUrl']),
  order = GetInvoiceByIdInvoiceOrder.fromJson(json['order']),
  invoiceItems_on_invoice = (json['invoiceItems_on_invoice'] as List<dynamic>)
        .map((e) => GetInvoiceByIdInvoiceInvoiceItemsOnInvoice.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoice otherTyped = other as GetInvoiceByIdInvoice;
    return id == otherTyped.id && 
    numeroUnico == otherTyped.numeroUnico && 
    fechaEmision == otherTyped.fechaEmision && 
    subtotal == otherTyped.subtotal && 
    discount == otherTyped.discount && 
    tax == otherTyped.tax && 
    total == otherTyped.total && 
    paymentMethod == otherTyped.paymentMethod && 
    invoiceStatus == otherTyped.invoiceStatus && 
    generatedAt == otherTyped.generatedAt && 
    pdfUrl == otherTyped.pdfUrl && 
    order == otherTyped.order && 
    invoiceItems_on_invoice == otherTyped.invoiceItems_on_invoice;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, numeroUnico.hashCode, fechaEmision.hashCode, subtotal.hashCode, discount.hashCode, tax.hashCode, total.hashCode, paymentMethod.hashCode, invoiceStatus.hashCode, generatedAt.hashCode, pdfUrl.hashCode, order.hashCode, invoiceItems_on_invoice.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['numeroUnico'] = nativeToJson<String>(numeroUnico);
    json['fechaEmision'] = fechaEmision.toJson();
    json['subtotal'] = nativeToJson<double>(subtotal);
    json['discount'] = nativeToJson<double>(discount);
    json['tax'] = nativeToJson<double>(tax);
    json['total'] = nativeToJson<double>(total);
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    json['invoiceStatus'] = 
    invoiceStatusSerializer(invoiceStatus)
    ;
    if (generatedAt != null) {
      json['generatedAt'] = generatedAt!.toJson();
    }
    if (pdfUrl != null) {
      json['pdfUrl'] = nativeToJson<String?>(pdfUrl);
    }
    json['order'] = order.toJson();
    json['invoiceItems_on_invoice'] = invoiceItems_on_invoice.map((e) => e.toJson()).toList();
    return json;
  }

  GetInvoiceByIdInvoice({
    required this.id,
    required this.numeroUnico,
    required this.fechaEmision,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.invoiceStatus,
    this.generatedAt,
    this.pdfUrl,
    required this.order,
    required this.invoiceItems_on_invoice,
  });
}

@immutable
class GetInvoiceByIdInvoiceOrder {
  final String id;
  final double price;
  final String? serviceName;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final String? observations;
  final String clientId;
  final String? employeeId;
  final GetInvoiceByIdInvoiceOrderBusiness business;
  final GetInvoiceByIdInvoiceOrderClient client;
  final GetInvoiceByIdInvoiceOrderEmployee? employee;
  GetInvoiceByIdInvoiceOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  clientId = nativeFromJson<String>(json['clientId']),
  employeeId = json['employeeId'] == null ? null : nativeFromJson<String>(json['employeeId']),
  business = GetInvoiceByIdInvoiceOrderBusiness.fromJson(json['business']),
  client = GetInvoiceByIdInvoiceOrderClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : GetInvoiceByIdInvoiceOrderEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoiceOrder otherTyped = other as GetInvoiceByIdInvoiceOrder;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    observations == otherTyped.observations && 
    clientId == otherTyped.clientId && 
    employeeId == otherTyped.employeeId && 
    business == otherTyped.business && 
    client == otherTyped.client && 
    employee == otherTyped.employee;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, serviceName.hashCode, paymentMethod.hashCode, status.hashCode, observations.hashCode, clientId.hashCode, employeeId.hashCode, business.hashCode, client.hashCode, employee.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['price'] = nativeToJson<double>(price);
    if (serviceName != null) {
      json['serviceName'] = nativeToJson<String?>(serviceName);
    }
    json['paymentMethod'] = 
    paymentMethodSerializer(paymentMethod)
    ;
    json['status'] = 
    orderStatusSerializer(status)
    ;
    if (observations != null) {
      json['observations'] = nativeToJson<String?>(observations);
    }
    json['clientId'] = nativeToJson<String>(clientId);
    if (employeeId != null) {
      json['employeeId'] = nativeToJson<String?>(employeeId);
    }
    json['business'] = business.toJson();
    json['client'] = client.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    return json;
  }

  GetInvoiceByIdInvoiceOrder({
    required this.id,
    required this.price,
    this.serviceName,
    required this.paymentMethod,
    required this.status,
    this.observations,
    required this.clientId,
    this.employeeId,
    required this.business,
    required this.client,
    this.employee,
  });
}

@immutable
class GetInvoiceByIdInvoiceOrderBusiness {
  final String id;
  final String nombre;
  final String ruc;
  final String? descripcion;
  final GetInvoiceByIdInvoiceOrderBusinessOwner owner;
  GetInvoiceByIdInvoiceOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  owner = GetInvoiceByIdInvoiceOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoiceOrderBusiness otherTyped = other as GetInvoiceByIdInvoiceOrderBusiness;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    ruc == otherTyped.ruc && 
    descripcion == otherTyped.descripcion && 
    owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, ruc.hashCode, descripcion.hashCode, owner.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['ruc'] = nativeToJson<String>(ruc);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    json['owner'] = owner.toJson();
    return json;
  }

  GetInvoiceByIdInvoiceOrderBusiness({
    required this.id,
    required this.nombre,
    required this.ruc,
    this.descripcion,
    required this.owner,
  });
}

@immutable
class GetInvoiceByIdInvoiceOrderBusinessOwner {
  final String id;
  GetInvoiceByIdInvoiceOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoiceOrderBusinessOwner otherTyped = other as GetInvoiceByIdInvoiceOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetInvoiceByIdInvoiceOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class GetInvoiceByIdInvoiceOrderClient {
  final String nombreCompleto;
  final String email;
  final String? telefono;
  GetInvoiceByIdInvoiceOrderClient.fromJson(dynamic json):
  
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  email = nativeFromJson<String>(json['email']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoiceOrderClient otherTyped = other as GetInvoiceByIdInvoiceOrderClient;
    return nombreCompleto == otherTyped.nombreCompleto && 
    email == otherTyped.email && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([nombreCompleto.hashCode, email.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    json['email'] = nativeToJson<String>(email);
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetInvoiceByIdInvoiceOrderClient({
    required this.nombreCompleto,
    required this.email,
    this.telefono,
  });
}

@immutable
class GetInvoiceByIdInvoiceOrderEmployee {
  final String nombreCompleto;
  final String? telefono;
  GetInvoiceByIdInvoiceOrderEmployee.fromJson(dynamic json):
  
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']),
  telefono = json['telefono'] == null ? null : nativeFromJson<String>(json['telefono']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoiceOrderEmployee otherTyped = other as GetInvoiceByIdInvoiceOrderEmployee;
    return nombreCompleto == otherTyped.nombreCompleto && 
    telefono == otherTyped.telefono;
    
  }
  @override
  int get hashCode => Object.hashAll([nombreCompleto.hashCode, telefono.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    if (telefono != null) {
      json['telefono'] = nativeToJson<String?>(telefono);
    }
    return json;
  }

  GetInvoiceByIdInvoiceOrderEmployee({
    required this.nombreCompleto,
    this.telefono,
  });
}

@immutable
class GetInvoiceByIdInvoiceInvoiceItemsOnInvoice {
  final String id;
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double total;
  GetInvoiceByIdInvoiceInvoiceItemsOnInvoice.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  quantity = nativeFromJson<int>(json['quantity']),
  unitPrice = nativeFromJson<double>(json['unitPrice']),
  total = nativeFromJson<double>(json['total']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdInvoiceInvoiceItemsOnInvoice otherTyped = other as GetInvoiceByIdInvoiceInvoiceItemsOnInvoice;
    return id == otherTyped.id && 
    serviceName == otherTyped.serviceName && 
    quantity == otherTyped.quantity && 
    unitPrice == otherTyped.unitPrice && 
    total == otherTyped.total;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, serviceName.hashCode, quantity.hashCode, unitPrice.hashCode, total.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['quantity'] = nativeToJson<int>(quantity);
    json['unitPrice'] = nativeToJson<double>(unitPrice);
    json['total'] = nativeToJson<double>(total);
    return json;
  }

  GetInvoiceByIdInvoiceInvoiceItemsOnInvoice({
    required this.id,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

@immutable
class GetInvoiceByIdData {
  final GetInvoiceByIdInvoice? invoice;
  GetInvoiceByIdData.fromJson(dynamic json):
  
  invoice = json['invoice'] == null ? null : GetInvoiceByIdInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdData otherTyped = other as GetInvoiceByIdData;
    return invoice == otherTyped.invoice;
    
  }
  @override
  int get hashCode => invoice.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (invoice != null) {
      json['invoice'] = invoice!.toJson();
    }
    return json;
  }

  GetInvoiceByIdData({
    this.invoice,
  });
}

@immutable
class GetInvoiceByIdVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetInvoiceByIdVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdVariables otherTyped = other as GetInvoiceByIdVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetInvoiceByIdVariables({
    required this.id,
  });
}

