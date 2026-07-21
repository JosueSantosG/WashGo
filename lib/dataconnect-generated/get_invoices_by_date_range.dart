part of 'example.dart';

class GetInvoicesByDateRangeVariablesBuilder {
  String businessId;
  Timestamp startDate;
  Timestamp endDate;

  final FirebaseDataConnect _dataConnect;
  GetInvoicesByDateRangeVariablesBuilder(this._dataConnect, {required  this.businessId,required  this.startDate,required  this.endDate,});
  Deserializer<GetInvoicesByDateRangeData> dataDeserializer = (dynamic json)  => GetInvoicesByDateRangeData.fromJson(jsonDecode(json));
  Serializer<GetInvoicesByDateRangeVariables> varsSerializer = (GetInvoicesByDateRangeVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetInvoicesByDateRangeData, GetInvoicesByDateRangeVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetInvoicesByDateRangeData, GetInvoicesByDateRangeVariables> ref() {
    GetInvoicesByDateRangeVariables vars= GetInvoicesByDateRangeVariables(businessId: businessId,startDate: startDate,endDate: endDate,);
    return _dataConnect.query("GetInvoicesByDateRange", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetInvoicesByDateRangeInvoices {
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
  final GetInvoicesByDateRangeInvoicesOrder order;
  final List<GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice> invoiceItems_on_invoice;
  GetInvoicesByDateRangeInvoices.fromJson(dynamic json):
  
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
  order = GetInvoicesByDateRangeInvoicesOrder.fromJson(json['order']),
  invoiceItems_on_invoice = (json['invoiceItems_on_invoice'] as List<dynamic>)
        .map((e) => GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoicesByDateRangeInvoices otherTyped = other as GetInvoicesByDateRangeInvoices;
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

  GetInvoicesByDateRangeInvoices({
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
class GetInvoicesByDateRangeInvoicesOrder {
  final String id;
  final double price;
  final String? serviceName;
  final EnumValue<PaymentMethod> paymentMethod;
  final EnumValue<OrderStatus> status;
  final GetInvoicesByDateRangeInvoicesOrderClient client;
  GetInvoicesByDateRangeInvoicesOrder.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  price = nativeFromJson<double>(json['price']),
  serviceName = json['serviceName'] == null ? null : nativeFromJson<String>(json['serviceName']),
  paymentMethod = paymentMethodDeserializer(json['paymentMethod']),
  status = orderStatusDeserializer(json['status']),
  client = GetInvoicesByDateRangeInvoicesOrderClient.fromJson(json['client']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoicesByDateRangeInvoicesOrder otherTyped = other as GetInvoicesByDateRangeInvoicesOrder;
    return id == otherTyped.id && 
    price == otherTyped.price && 
    serviceName == otherTyped.serviceName && 
    paymentMethod == otherTyped.paymentMethod && 
    status == otherTyped.status && 
    client == otherTyped.client;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, price.hashCode, serviceName.hashCode, paymentMethod.hashCode, status.hashCode, client.hashCode]);
  

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
    json['client'] = client.toJson();
    return json;
  }

  GetInvoicesByDateRangeInvoicesOrder({
    required this.id,
    required this.price,
    this.serviceName,
    required this.paymentMethod,
    required this.status,
    required this.client,
  });
}

@immutable
class GetInvoicesByDateRangeInvoicesOrderClient {
  final String nombreCompleto;
  GetInvoicesByDateRangeInvoicesOrderClient.fromJson(dynamic json):
  
  nombreCompleto = nativeFromJson<String>(json['nombreCompleto']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoicesByDateRangeInvoicesOrderClient otherTyped = other as GetInvoicesByDateRangeInvoicesOrderClient;
    return nombreCompleto == otherTyped.nombreCompleto;
    
  }
  @override
  int get hashCode => nombreCompleto.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nombreCompleto'] = nativeToJson<String>(nombreCompleto);
    return json;
  }

  GetInvoicesByDateRangeInvoicesOrderClient({
    required this.nombreCompleto,
  });
}

@immutable
class GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice {
  final String id;
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double total;
  GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice.fromJson(dynamic json):
  
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

    final GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice otherTyped = other as GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice;
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

  GetInvoicesByDateRangeInvoicesInvoiceItemsOnInvoice({
    required this.id,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

@immutable
class GetInvoicesByDateRangeData {
  final List<GetInvoicesByDateRangeInvoices> invoices;
  GetInvoicesByDateRangeData.fromJson(dynamic json):
  
  invoices = (json['invoices'] as List<dynamic>)
        .map((e) => GetInvoicesByDateRangeInvoices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoicesByDateRangeData otherTyped = other as GetInvoicesByDateRangeData;
    return invoices == otherTyped.invoices;
    
  }
  @override
  int get hashCode => invoices.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoices'] = invoices.map((e) => e.toJson()).toList();
    return json;
  }

  GetInvoicesByDateRangeData({
    required this.invoices,
  });
}

@immutable
class GetInvoicesByDateRangeVariables {
  final String businessId;
  final Timestamp startDate;
  final Timestamp endDate;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetInvoicesByDateRangeVariables.fromJson(Map<String, dynamic> json):
  
  businessId = nativeFromJson<String>(json['businessId']),
  startDate = Timestamp.fromJson(json['startDate']),
  endDate = Timestamp.fromJson(json['endDate']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoicesByDateRangeVariables otherTyped = other as GetInvoicesByDateRangeVariables;
    return businessId == otherTyped.businessId && 
    startDate == otherTyped.startDate && 
    endDate == otherTyped.endDate;
    
  }
  @override
  int get hashCode => Object.hashAll([businessId.hashCode, startDate.hashCode, endDate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['businessId'] = nativeToJson<String>(businessId);
    json['startDate'] = startDate.toJson();
    json['endDate'] = endDate.toJson();
    return json;
  }

  GetInvoicesByDateRangeVariables({
    required this.businessId,
    required this.startDate,
    required this.endDate,
  });
}

