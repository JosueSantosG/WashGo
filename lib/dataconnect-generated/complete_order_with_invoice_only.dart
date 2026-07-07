part of 'example.dart';

class CompleteOrderWithInvoiceOnlyVariablesBuilder {
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

  final FirebaseDataConnect _dataConnect;  CompleteOrderWithInvoiceOnlyVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithInvoiceOnlyVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  CompleteOrderWithInvoiceOnlyVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.invoiceId,required  this.numeroUnico,required  this.subtotal,required  this.discount,required  this.tax,required  this.total,required  this.paymentMethod,required  this.invoiceStatus,});
  Deserializer<CompleteOrderWithInvoiceOnlyData> dataDeserializer = (dynamic json)  => CompleteOrderWithInvoiceOnlyData.fromJson(jsonDecode(json));
  Serializer<CompleteOrderWithInvoiceOnlyVariables> varsSerializer = (CompleteOrderWithInvoiceOnlyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CompleteOrderWithInvoiceOnlyData, CompleteOrderWithInvoiceOnlyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CompleteOrderWithInvoiceOnlyData, CompleteOrderWithInvoiceOnlyVariables> ref() {
    CompleteOrderWithInvoiceOnlyVariables vars= CompleteOrderWithInvoiceOnlyVariables(orderId: orderId,observations: _observations,invoiceUrl: _invoiceUrl,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,);
    return _dataConnect.mutation("CompleteOrderWithInvoiceOnly", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CompleteOrderWithInvoiceOnlyOrderUpdate {
  final String id;
  CompleteOrderWithInvoiceOnlyOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithInvoiceOnlyOrderUpdate otherTyped = other as CompleteOrderWithInvoiceOnlyOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithInvoiceOnlyOrderUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithInvoiceOnlyInvoiceInsert {
  final String id;
  CompleteOrderWithInvoiceOnlyInvoiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithInvoiceOnlyInvoiceInsert otherTyped = other as CompleteOrderWithInvoiceOnlyInvoiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithInvoiceOnlyInvoiceInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithInvoiceOnlyData {
  final CompleteOrderWithInvoiceOnlyOrderUpdate? order_update;
  final CompleteOrderWithInvoiceOnlyInvoiceInsert invoice_insert;
  CompleteOrderWithInvoiceOnlyData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : CompleteOrderWithInvoiceOnlyOrderUpdate.fromJson(json['order_update']),
  invoice_insert = CompleteOrderWithInvoiceOnlyInvoiceInsert.fromJson(json['invoice_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithInvoiceOnlyData otherTyped = other as CompleteOrderWithInvoiceOnlyData;
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

  CompleteOrderWithInvoiceOnlyData({
    this.order_update,
    required this.invoice_insert,
  });
}

@immutable
class CompleteOrderWithInvoiceOnlyVariables {
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
  CompleteOrderWithInvoiceOnlyVariables.fromJson(Map<String, dynamic> json):
  
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

    final CompleteOrderWithInvoiceOnlyVariables otherTyped = other as CompleteOrderWithInvoiceOnlyVariables;
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

  CompleteOrderWithInvoiceOnlyVariables({
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

