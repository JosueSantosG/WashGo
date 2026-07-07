part of 'example.dart';

class GetClientInvoicesVariablesBuilder {
  Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _offset = Optional.optional(nativeFromJson, nativeToJson);
  Optional<Timestamp> _startDate = Optional.optional((json) => json['startDate'] = Timestamp.fromJson(json['startDate']), defaultSerializer);
  Optional<Timestamp> _endDate = Optional.optional((json) => json['endDate'] = Timestamp.fromJson(json['endDate']), defaultSerializer);
  Optional<PaymentMethod> _paymentMethod = Optional.optional((data) => PaymentMethod.values.byName(data), enumSerializer);
  Optional<InvoiceStatus> _status = Optional.optional((data) => InvoiceStatus.values.byName(data), enumSerializer);
  Optional<String> _searchQuery = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  GetClientInvoicesVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder offset(int? t) {
   _offset.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder startDate(Timestamp? t) {
   _startDate.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder endDate(Timestamp? t) {
   _endDate.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder paymentMethod(PaymentMethod? t) {
   _paymentMethod.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder status(InvoiceStatus? t) {
   _status.value = t;
   return this;
  }
  GetClientInvoicesVariablesBuilder searchQuery(String? t) {
   _searchQuery.value = t;
   return this;
  }

  GetClientInvoicesVariablesBuilder(this._dataConnect, );
  Deserializer<GetClientInvoicesData> dataDeserializer = (dynamic json)  => GetClientInvoicesData.fromJson(jsonDecode(json));
  Serializer<GetClientInvoicesVariables> varsSerializer = (GetClientInvoicesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetClientInvoicesData, GetClientInvoicesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetClientInvoicesData, GetClientInvoicesVariables> ref() {
    GetClientInvoicesVariables vars= GetClientInvoicesVariables(limit: _limit,offset: _offset,startDate: _startDate,endDate: _endDate,paymentMethod: _paymentMethod,status: _status,searchQuery: _searchQuery,);
    return _dataConnect.query("GetClientInvoices", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetClientInvoicesInvoices {
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
  final GetClientInvoicesInvoicesOrder order;
  final List<GetClientInvoicesInvoicesInvoiceItemsOnInvoice> invoiceItems_on_invoice;
  GetClientInvoicesInvoices.fromJson(dynamic json):
  
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
  order = GetClientInvoicesInvoicesOrder.fromJson(json['order']),
  invoiceItems_on_invoice = (json['invoiceItems_on_invoice'] as List<dynamic>)
        .map((e) => GetClientInvoicesInvoicesInvoiceItemsOnInvoice.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientInvoicesInvoices otherTyped = other as GetClientInvoicesInvoices;
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

  GetClientInvoicesInvoices({
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
class GetClientInvoicesInvoicesOrder {
  final String id;
  final double price;
  final String? serviceName;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final GetClientInvoicesInvoicesOrderBusiness business;
  final GetClientInvoicesInvoicesOrderEmployee? employee;
  GetClientInvoicesInvoicesOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  business = GetClientInvoicesInvoicesOrderBusiness.fromJson(json['business']),
  employee = json['employee'] == null ? null : GetClientInvoicesInvoicesOrderEmployee.fromJson(json['employee']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientInvoicesInvoicesOrder otherTyped = other as GetClientInvoicesInvoicesOrder;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    business == otherTyped.business && 
    employee == otherTyped.employee;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, serviceName.hashCode, paymentMethod.hashCode, status.hashCode, business.hashCode, employee.hashCode]);
  

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
    json['business'] = business.toJson();
    if (employee != null) {
      json['employee'] = employee!.toJson();
    }
    return json;
  }

  GetClientInvoicesInvoicesOrder({
    required this.id,
    required this.price,
    this.serviceName,
    required this.paymentMethod,
    required this.status,
    required this.business,
    this.employee,
  });
}

@immutable
class GetClientInvoicesInvoicesOrderBusiness {
  final String nombre;
  GetClientInvoicesInvoicesOrderBusiness.fromJson(dynamic json):
  
  nombre = nativeFromJson<String>(json['nombre']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientInvoicesInvoicesOrderBusiness otherTyped = other as GetClientInvoicesInvoicesOrderBusiness;
    return nombre == otherTyped.nombre;
    
  }
  @override
  int get hashCode => nombre.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nombre'] = nativeToJson<String>(nombre);
    return json;
  }

  GetClientInvoicesInvoicesOrderBusiness({
    required this.nombre,
  });
}

@immutable
class GetClientInvoicesInvoicesOrderEmployee {
  final String nombreCompleto;
  final String? telefono;
  GetClientInvoicesInvoicesOrderEmployee.fromJson(dynamic json):
  
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

    final GetClientInvoicesInvoicesOrderEmployee otherTyped = other as GetClientInvoicesInvoicesOrderEmployee;
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

  GetClientInvoicesInvoicesOrderEmployee({
    required this.nombreCompleto,
    this.telefono,
  });
}

@immutable
class GetClientInvoicesInvoicesInvoiceItemsOnInvoice {
  final String id;
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double total;
  GetClientInvoicesInvoicesInvoiceItemsOnInvoice.fromJson(dynamic json):
  
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

    final GetClientInvoicesInvoicesInvoiceItemsOnInvoice otherTyped = other as GetClientInvoicesInvoicesInvoiceItemsOnInvoice;
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

  GetClientInvoicesInvoicesInvoiceItemsOnInvoice({
    required this.id,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

@immutable
class GetClientInvoicesData {
  final List<GetClientInvoicesInvoices> invoices;
  GetClientInvoicesData.fromJson(dynamic json):
  
  invoices = (json['invoices'] as List<dynamic>)
        .map((e) => GetClientInvoicesInvoices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientInvoicesData otherTyped = other as GetClientInvoicesData;
    return invoices == otherTyped.invoices;
    
  }
  @override
  int get hashCode => invoices.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoices'] = invoices.map((e) => e.toJson()).toList();
    return json;
  }

  GetClientInvoicesData({
    required this.invoices,
  });
}

@immutable
class GetClientInvoicesVariables {
  late final Optional<int>limit;
  late final Optional<int>offset;
  late final Optional<Timestamp>startDate;
  late final Optional<Timestamp>endDate;
  late final Optional<PaymentMethod>paymentMethod;
  late final Optional<InvoiceStatus>status;
  late final Optional<String>searchQuery;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetClientInvoicesVariables.fromJson(Map<String, dynamic> json) {
  
  
    limit = Optional.optional(nativeFromJson, nativeToJson);
    limit.value = json['limit'] == null ? null : nativeFromJson<int>(json['limit']);
  
  
    offset = Optional.optional(nativeFromJson, nativeToJson);
    offset.value = json['offset'] == null ? null : nativeFromJson<int>(json['offset']);
  
  
    startDate = Optional.optional((json) => json['startDate'] = Timestamp.fromJson(json['startDate']), defaultSerializer);
    startDate.value = json['startDate'] == null ? null : Timestamp.fromJson(json['startDate']);
  
  
    endDate = Optional.optional((json) => json['endDate'] = Timestamp.fromJson(json['endDate']), defaultSerializer);
    endDate.value = json['endDate'] == null ? null : Timestamp.fromJson(json['endDate']);
  
  
    paymentMethod = Optional.optional((data) => PaymentMethod.values.byName(data), enumSerializer);
    paymentMethod.value = json['paymentMethod'] == null ? null : PaymentMethod.values.byName(json['paymentMethod']);
  
  
    status = Optional.optional((data) => InvoiceStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : InvoiceStatus.values.byName(json['status']);
  
  
    searchQuery = Optional.optional(nativeFromJson, nativeToJson);
    searchQuery.value = json['searchQuery'] == null ? null : nativeFromJson<String>(json['searchQuery']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetClientInvoicesVariables otherTyped = other as GetClientInvoicesVariables;
    return limit == otherTyped.limit && 
    offset == otherTyped.offset && 
    startDate == otherTyped.startDate && 
    endDate == otherTyped.endDate && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    searchQuery == otherTyped.searchQuery;
    
  }
  @override
  int get hashCode => Object.hashAll([limit.hashCode, offset.hashCode, startDate.hashCode, endDate.hashCode, paymentMethod.hashCode, status.hashCode, searchQuery.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    if(offset.state == OptionalState.set) {
      json['offset'] = offset.toJson();
    }
    if(startDate.state == OptionalState.set) {
      json['startDate'] = startDate.toJson();
    }
    if(endDate.state == OptionalState.set) {
      json['endDate'] = endDate.toJson();
    }
    if(paymentMethod.state == OptionalState.set) {
      json['paymentMethod'] = paymentMethod.toJson();
    }
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    if(searchQuery.state == OptionalState.set) {
      json['searchQuery'] = searchQuery.toJson();
    }
    return json;
  }

  GetClientInvoicesVariables({
    required this.limit,
    required this.offset,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.status,
    required this.searchQuery,
  });
}

