part of 'example.dart';

class CompleteOrderWithTransferAndInvoiceVariablesBuilder {
  String orderId;
  Optional<String> _observations = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _invoiceUrl = Optional.optional(nativeFromJson, nativeToJson);
  String invoiceId;
  String numeroUnico;
  double subtotal;
  double discount;
  double tax;
  double total;
  PaymentMethod paymentMethod;
  InvoiceStatus invoiceStatus;

  final FirebaseDataConnect _dataConnect;  CompleteOrderWithTransferAndInvoiceVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithTransferAndInvoiceVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  CompleteOrderWithTransferAndInvoiceVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.invoiceId,required  this.numeroUnico,required  this.subtotal,required  this.discount,required  this.tax,required  this.total,required  this.paymentMethod,required  this.invoiceStatus,});
  Deserializer<CompleteOrderWithTransferAndInvoiceData> dataDeserializer = (dynamic json)  => CompleteOrderWithTransferAndInvoiceData.fromJson(jsonDecode(json));
  Serializer<CompleteOrderWithTransferAndInvoiceVariables> varsSerializer = (CompleteOrderWithTransferAndInvoiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CompleteOrderWithTransferAndInvoiceData, CompleteOrderWithTransferAndInvoiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CompleteOrderWithTransferAndInvoiceData, CompleteOrderWithTransferAndInvoiceVariables> ref() {
    CompleteOrderWithTransferAndInvoiceVariables vars= CompleteOrderWithTransferAndInvoiceVariables(orderId: orderId,observations: _observations,invoiceUrl: _invoiceUrl,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,);
    return _dataConnect.mutation("CompleteOrderWithTransferAndInvoice", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CompleteOrderWithTransferAndInvoiceOrderUpdate {
  final String id;
  CompleteOrderWithTransferAndInvoiceOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithTransferAndInvoiceOrderUpdate otherTyped = other as CompleteOrderWithTransferAndInvoiceOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithTransferAndInvoiceOrderUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithTransferAndInvoiceInvoiceInsert {
  final String id;
  CompleteOrderWithTransferAndInvoiceInvoiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithTransferAndInvoiceInvoiceInsert otherTyped = other as CompleteOrderWithTransferAndInvoiceInvoiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithTransferAndInvoiceInvoiceInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithTransferAndInvoiceData {
  final CompleteOrderWithTransferAndInvoiceOrderUpdate? order_update;
  final CompleteOrderWithTransferAndInvoiceInvoiceInsert invoice_insert;
  CompleteOrderWithTransferAndInvoiceData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : CompleteOrderWithTransferAndInvoiceOrderUpdate.fromJson(json['order_update']),
  invoice_insert = CompleteOrderWithTransferAndInvoiceInvoiceInsert.fromJson(json['invoice_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithTransferAndInvoiceData otherTyped = other as CompleteOrderWithTransferAndInvoiceData;
    return order_update == otherTyped.order_update && 
    invoice_insert == otherTyped.invoice_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([order_update.hashCode, invoice_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (order_update != null) {
      json['order_update'] = order_update!.toJson();
    }
    json['invoice_insert'] = invoice_insert.toJson();
    return json;
  }

  CompleteOrderWithTransferAndInvoiceData({
    this.order_update,
    required this.invoice_insert,
  });
}

@immutable
class CompleteOrderWithTransferAndInvoiceVariables {
  final String orderId;
  late final Optional<String>observations;
  late final Optional<String>invoiceUrl;
  final String invoiceId;
  final String numeroUnico;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final PaymentMethod paymentMethod;
  final InvoiceStatus invoiceStatus;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CompleteOrderWithTransferAndInvoiceVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  invoiceId = nativeFromJson<String>(json['invoiceId']),
  numeroUnico = nativeFromJson<String>(json['numeroUnico']),
  subtotal = nativeFromJson<double>(json['subtotal']),
  discount = nativeFromJson<double>(json['discount']),
  tax = nativeFromJson<double>(json['tax']),
  total = nativeFromJson<double>(json['total']),
  paymentMethod = PaymentMethod.values.byName(json['paymentMethod']),
  invoiceStatus = InvoiceStatus.values.byName(json['invoiceStatus']) {
  
  
  
    observations = Optional.optional(nativeFromJson, nativeToJson);
    observations.value = json['observations'] == null ? null : nativeFromJson<String>(json['observations']);
  
  
    invoiceUrl = Optional.optional(nativeFromJson, nativeToJson);
    invoiceUrl.value = json['invoiceUrl'] == null ? null : nativeFromJson<String>(json['invoiceUrl']);
  
  
  
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithTransferAndInvoiceVariables otherTyped = other as CompleteOrderWithTransferAndInvoiceVariables;
    return orderId == otherTyped.orderId && 
    observations == otherTyped.observations && 
    invoiceUrl == otherTyped.invoiceUrl && 
    invoiceId == otherTyped.invoiceId && 
    numeroUnico == otherTyped.numeroUnico && 
    subtotal == otherTyped.subtotal && 
    discount == otherTyped.discount && 
    tax == otherTyped.tax && 
    total == otherTyped.total && 
    paymentMethod == otherTyped.paymentMethod && 
    invoiceStatus == otherTyped.invoiceStatus;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, observations.hashCode, invoiceUrl.hashCode, invoiceId.hashCode, numeroUnico.hashCode, subtotal.hashCode, discount.hashCode, tax.hashCode, total.hashCode, paymentMethod.hashCode, invoiceStatus.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    if(observations.state == OptionalState.set) {
      json['observations'] = observations.toJson();
    }
    if(invoiceUrl.state == OptionalState.set) {
      json['invoiceUrl'] = invoiceUrl.toJson();
    }
    json['invoiceId'] = nativeToJson<String>(invoiceId);
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
    return json;
  }

  CompleteOrderWithTransferAndInvoiceVariables({
    required this.orderId,
    required this.observations,
    required this.invoiceUrl,
    required this.invoiceId,
    required this.numeroUnico,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.invoiceStatus,
  });
}

