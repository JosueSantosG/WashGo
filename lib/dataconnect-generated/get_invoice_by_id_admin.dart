part of 'example.dart';

class GetInvoiceByIdAdminVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetInvoiceByIdAdminVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetInvoiceByIdAdminData> dataDeserializer = (dynamic json)  => GetInvoiceByIdAdminData.fromJson(jsonDecode(json));
  Serializer<GetInvoiceByIdAdminVariables> varsSerializer = (GetInvoiceByIdAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetInvoiceByIdAdminData, GetInvoiceByIdAdminVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetInvoiceByIdAdminData, GetInvoiceByIdAdminVariables> ref() {
    GetInvoiceByIdAdminVariables vars= GetInvoiceByIdAdminVariables(id: id,);
    return _dataConnect.query("GetInvoiceByIdAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetInvoiceByIdAdminInvoice {
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
  final GetInvoiceByIdAdminInvoiceOrder order;
  final List<GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice> invoiceItems_on_invoice;
  GetInvoiceByIdAdminInvoice.fromJson(dynamic json):
  
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
  order = GetInvoiceByIdAdminInvoiceOrder.fromJson(json['order']),
  invoiceItems_on_invoice = (json['invoiceItems_on_invoice'] as List<dynamic>)
        .map((e) => GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdAdminInvoice otherTyped = other as GetInvoiceByIdAdminInvoice;
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

  GetInvoiceByIdAdminInvoice({
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
class GetInvoiceByIdAdminInvoiceOrder {
  final String id;
  final double price;
  final String? serviceName;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final String? observations;
  final String clientId;
  final String? employeeId;
  final GetInvoiceByIdAdminInvoiceOrderBusiness business;
  final GetInvoiceByIdAdminInvoiceOrderClient client;
  final GetInvoiceByIdAdminInvoiceOrderEmployee? employee;
  GetInvoiceByIdAdminInvoiceOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  observations = json['observations'] == null ? null : nativeFromJson<String>(json['observations']),
  clientId = nativeFromJson<String>(json['clientId']),
  employeeId = json['employeeId'] == null ? null : nativeFromJson<String>(json['employeeId']),
  business = GetInvoiceByIdAdminInvoiceOrderBusiness.fromJson(json['business']),
  client = GetInvoiceByIdAdminInvoiceOrderClient.fromJson(json['client']),
  employee = json['employee'] == null ? null : GetInvoiceByIdAdminInvoiceOrderEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdAdminInvoiceOrder otherTyped = other as GetInvoiceByIdAdminInvoiceOrder;
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

  GetInvoiceByIdAdminInvoiceOrder({
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
class GetInvoiceByIdAdminInvoiceOrderBusiness {
  final String id;
  final String nombre;
  final String ruc;
  final String? descripcion;
  final GetInvoiceByIdAdminInvoiceOrderBusinessOwner owner;
  GetInvoiceByIdAdminInvoiceOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  ruc = nativeFromJson<String>(json['ruc']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  owner = GetInvoiceByIdAdminInvoiceOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdAdminInvoiceOrderBusiness otherTyped = other as GetInvoiceByIdAdminInvoiceOrderBusiness;
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

  GetInvoiceByIdAdminInvoiceOrderBusiness({
    required this.id,
    required this.nombre,
    required this.ruc,
    this.descripcion,
    required this.owner,
  });
}

@immutable
class GetInvoiceByIdAdminInvoiceOrderBusinessOwner {
  final String id;
  GetInvoiceByIdAdminInvoiceOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdAdminInvoiceOrderBusinessOwner otherTyped = other as GetInvoiceByIdAdminInvoiceOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetInvoiceByIdAdminInvoiceOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class GetInvoiceByIdAdminInvoiceOrderClient {
  final String nombreCompleto;
  final String email;
  final String? telefono;
  GetInvoiceByIdAdminInvoiceOrderClient.fromJson(dynamic json):
  
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

    final GetInvoiceByIdAdminInvoiceOrderClient otherTyped = other as GetInvoiceByIdAdminInvoiceOrderClient;
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

  GetInvoiceByIdAdminInvoiceOrderClient({
    required this.nombreCompleto,
    required this.email,
    this.telefono,
  });
}

@immutable
class GetInvoiceByIdAdminInvoiceOrderEmployee {
  final String nombreCompleto;
  final String? telefono;
  GetInvoiceByIdAdminInvoiceOrderEmployee.fromJson(dynamic json):
  
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

    final GetInvoiceByIdAdminInvoiceOrderEmployee otherTyped = other as GetInvoiceByIdAdminInvoiceOrderEmployee;
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

  GetInvoiceByIdAdminInvoiceOrderEmployee({
    required this.nombreCompleto,
    this.telefono,
  });
}

@immutable
class GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice {
  final String id;
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double total;
  GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice.fromJson(dynamic json):
  
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

    final GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice otherTyped = other as GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice;
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

  GetInvoiceByIdAdminInvoiceInvoiceItemsOnInvoice({
    required this.id,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

@immutable
class GetInvoiceByIdAdminData {
  final GetInvoiceByIdAdminInvoice? invoice;
  GetInvoiceByIdAdminData.fromJson(dynamic json):
  
  invoice = json['invoice'] == null ? null : GetInvoiceByIdAdminInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdAdminData otherTyped = other as GetInvoiceByIdAdminData;
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

  GetInvoiceByIdAdminData({
    this.invoice,
  });
}

@immutable
class GetInvoiceByIdAdminVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetInvoiceByIdAdminVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByIdAdminVariables otherTyped = other as GetInvoiceByIdAdminVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetInvoiceByIdAdminVariables({
    required this.id,
  });
}

