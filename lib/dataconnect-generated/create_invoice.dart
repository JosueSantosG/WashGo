part of 'example.dart';

class CreateInvoiceVariablesBuilder {
  String id;
  String orderId;
  String numeroUnico;
  double subtotal;
  double discount;
  double tax;
  double total;
  PaymentMethod paymentMethod;
  InvoiceStatus invoiceStatus;
  Optional<String> _pdfUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateInvoiceVariablesBuilder pdfUrl(String? t) {
   _pdfUrl.value = t;
   return this;
  }

  CreateInvoiceVariablesBuilder(this._dataConnect, {required  this.id,required  this.orderId,required  this.numeroUnico,required  this.subtotal,required  this.discount,required  this.tax,required  this.total,required  this.paymentMethod,required  this.invoiceStatus,});
  Deserializer<CreateInvoiceData> dataDeserializer = (dynamic json)  => CreateInvoiceData.fromJson(jsonDecode(json));
  Serializer<CreateInvoiceVariables> varsSerializer = (CreateInvoiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateInvoiceData, CreateInvoiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateInvoiceData, CreateInvoiceVariables> ref() {
    CreateInvoiceVariables vars= CreateInvoiceVariables(id: id,orderId: orderId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,pdfUrl: _pdfUrl,);
    return _dataConnect.mutation("CreateInvoice", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateInvoiceInvoiceInsert {
  final String id;
  CreateInvoiceInvoiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateInvoiceInvoiceInsert otherTyped = other as CreateInvoiceInvoiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateInvoiceInvoiceInsert({
    required this.id,
  });
}

@immutable
class CreateInvoiceData {
  final CreateInvoiceInvoiceInsert invoice_insert;
  CreateInvoiceData.fromJson(dynamic json):
  
  invoice_insert = CreateInvoiceInvoiceInsert.fromJson(json['invoice_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateInvoiceData otherTyped = other as CreateInvoiceData;
    return invoice_insert == otherTyped.invoice_insert;
    
  }
  @override
  int get hashCode => invoice_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoice_insert'] = invoice_insert.toJson();
    return json;
  }

  CreateInvoiceData({
    required this.invoice_insert,
  });
}

@immutable
class CreateInvoiceVariables {
  final String id;
  final String orderId;
  final String numeroUnico;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final PaymentMethod paymentMethod;
  final InvoiceStatus invoiceStatus;
  late final Optional<String>pdfUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateInvoiceVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  orderId = nativeFromJson<String>(json['orderId']),
  numeroUnico = nativeFromJson<String>(json['numeroUnico']),
  subtotal = nativeFromJson<double>(json['subtotal']),
  discount = nativeFromJson<double>(json['discount']),
  tax = nativeFromJson<double>(json['tax']),
  total = nativeFromJson<double>(json['total']),
  paymentMethod = PaymentMethod.values.byName(json['paymentMethod']),
  invoiceStatus = InvoiceStatus.values.byName(json['invoiceStatus']) {
  
  
  
  
  
  
  
  
  
  
  
    pdfUrl = Optional.optional(nativeFromJson, nativeToJson);
    pdfUrl.value = json['pdfUrl'] == null ? null : nativeFromJson<String>(json['pdfUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateInvoiceVariables otherTyped = other as CreateInvoiceVariables;
    return id == otherTyped.id && 
    orderId == otherTyped.orderId && 
    numeroUnico == otherTyped.numeroUnico && 
    subtotal == otherTyped.subtotal && 
    discount == otherTyped.discount && 
    tax == otherTyped.tax && 
    total == otherTyped.total && 
    paymentMethod == otherTyped.paymentMethod && 
    invoiceStatus == otherTyped.invoiceStatus && 
    pdfUrl == otherTyped.pdfUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, orderId.hashCode, numeroUnico.hashCode, subtotal.hashCode, discount.hashCode, tax.hashCode, total.hashCode, paymentMethod.hashCode, invoiceStatus.hashCode, pdfUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['orderId'] = nativeToJson<String>(orderId);
    json['numeroUnico'] = nativeToJson<String>(numeroUnico);
    json['subtotal'] = nativeToJson<double>(subtotal);
    json['discount'] = nativeToJson<double>(discount);
    json['tax'] = nativeToJson<double>(tax);
    json['total'] = nativeToJson<double>(total);
    json['paymentMethod'] = 
    paymentMethod.name
    ;
    json['invoiceStatus'] = 
    invoiceStatus.name
    ;
    if(pdfUrl.state == OptionalState.set) {
      json['pdfUrl'] = pdfUrl.toJson();
    }
    return json;
  }

  CreateInvoiceVariables({
    required this.id,
    required this.orderId,
    required this.numeroUnico,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.invoiceStatus,
    required this.pdfUrl,
  });
}

