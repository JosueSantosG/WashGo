part of 'example.dart';

class CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder {
  String orderId;
  String orderIdStr;
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
  String businessId;
  double saldoPrepagoInicial;
  double saldoPrepagoConsumido;
  String historyId;
  String serviceName;
  double costoConsumido;
  double saldoResultante;
  String metricId;
  int metricCantidad;
  double metricTotalConsumido;

  final FirebaseDataConnect _dataConnect;  CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.orderIdStr,required  this.invoiceId,required  this.numeroUnico,required  this.subtotal,required  this.discount,required  this.tax,required  this.total,required  this.paymentMethod,required  this.invoiceStatus,required  this.businessId,required  this.saldoPrepagoInicial,required  this.saldoPrepagoConsumido,required  this.historyId,required  this.serviceName,required  this.costoConsumido,required  this.saldoResultante,required  this.metricId,required  this.metricCantidad,required  this.metricTotalConsumido,});
  Deserializer<CompleteOrderWithPrepaidAndUpdateMetricData> dataDeserializer = (dynamic json)  => CompleteOrderWithPrepaidAndUpdateMetricData.fromJson(jsonDecode(json));
  Serializer<CompleteOrderWithPrepaidAndUpdateMetricVariables> varsSerializer = (CompleteOrderWithPrepaidAndUpdateMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CompleteOrderWithPrepaidAndUpdateMetricData, CompleteOrderWithPrepaidAndUpdateMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CompleteOrderWithPrepaidAndUpdateMetricData, CompleteOrderWithPrepaidAndUpdateMetricVariables> ref() {
    CompleteOrderWithPrepaidAndUpdateMetricVariables vars= CompleteOrderWithPrepaidAndUpdateMetricVariables(orderId: orderId,orderIdStr: orderIdStr,observations: _observations,invoiceUrl: _invoiceUrl,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCantidad: metricCantidad,metricTotalConsumido: metricTotalConsumido,);
    return _dataConnect.mutation("CompleteOrderWithPrepaidAndUpdateMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate {
  final String id;
  CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert {
  final String id;
  CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate {
  final String id;
  CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert {
  final String id;
  CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate {
  final String id;
  CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricData {
  final CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate? order_update;
  final CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert invoice_insert;
  final CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate? business_update;
  final CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert prepaidHistory_insert;
  final CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate? prepaidServiceMetric_update;
  CompleteOrderWithPrepaidAndUpdateMetricData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : CompleteOrderWithPrepaidAndUpdateMetricOrderUpdate.fromJson(json['order_update']),
  invoice_insert = CompleteOrderWithPrepaidAndUpdateMetricInvoiceInsert.fromJson(json['invoice_insert']),
  business_update = json['business_update'] == null ? null : CompleteOrderWithPrepaidAndUpdateMetricBusinessUpdate.fromJson(json['business_update']),
  prepaidHistory_insert = CompleteOrderWithPrepaidAndUpdateMetricPrepaidHistoryInsert.fromJson(json['prepaidHistory_insert']),
  prepaidServiceMetric_update = json['prepaidServiceMetric_update'] == null ? null : CompleteOrderWithPrepaidAndUpdateMetricPrepaidServiceMetricUpdate.fromJson(json['prepaidServiceMetric_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndUpdateMetricData otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricData;
    return order_update == otherTyped.order_update && 
    invoice_insert == otherTyped.invoice_insert && 
    business_update == otherTyped.business_update && 
    prepaidHistory_insert == otherTyped.prepaidHistory_insert && 
    prepaidServiceMetric_update == otherTyped.prepaidServiceMetric_update;
    
  }
  @override
  int get hashCode => Object.hashAll([order_update.hashCode, invoice_insert.hashCode, business_update.hashCode, prepaidHistory_insert.hashCode, prepaidServiceMetric_update.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (order_update != null) {
      json['order_update'] = order_update!.toJson();
    }
    json['invoice_insert'] = invoice_insert.toJson();
    if (business_update != null) {
      json['business_update'] = business_update!.toJson();
    }
    json['prepaidHistory_insert'] = prepaidHistory_insert.toJson();
    if (prepaidServiceMetric_update != null) {
      json['prepaidServiceMetric_update'] = prepaidServiceMetric_update!.toJson();
    }
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricData({
    this.order_update,
    required this.invoice_insert,
    this.business_update,
    required this.prepaidHistory_insert,
    this.prepaidServiceMetric_update,
  });
}

@immutable
class CompleteOrderWithPrepaidAndUpdateMetricVariables {
  final String orderId;
  final String orderIdStr;
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
  final String businessId;
  final double saldoPrepagoInicial;
  final double saldoPrepagoConsumido;
  final String historyId;
  final String serviceName;
  final double costoConsumido;
  final double saldoResultante;
  final String metricId;
  final int metricCantidad;
  final double metricTotalConsumido;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CompleteOrderWithPrepaidAndUpdateMetricVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']),
  orderIdStr = nativeFromJson<String>(json['orderIdStr']),
  invoiceId = nativeFromJson<String>(json['invoiceId']),
  numeroUnico = nativeFromJson<String>(json['numeroUnico']),
  subtotal = nativeFromJson<double>(json['subtotal']),
  discount = nativeFromJson<double>(json['discount']),
  tax = nativeFromJson<double>(json['tax']),
  total = nativeFromJson<double>(json['total']),
  paymentMethod = PaymentMethod.values.byName(json['paymentMethod']),
  invoiceStatus = InvoiceStatus.values.byName(json['invoiceStatus']),
  businessId = nativeFromJson<String>(json['businessId']),
  saldoPrepagoInicial = nativeFromJson<double>(json['saldoPrepagoInicial']),
  saldoPrepagoConsumido = nativeFromJson<double>(json['saldoPrepagoConsumido']),
  historyId = nativeFromJson<String>(json['historyId']),
  serviceName = nativeFromJson<String>(json['serviceName']),
  costoConsumido = nativeFromJson<double>(json['costoConsumido']),
  saldoResultante = nativeFromJson<double>(json['saldoResultante']),
  metricId = nativeFromJson<String>(json['metricId']),
  metricCantidad = nativeFromJson<int>(json['metricCantidad']),
  metricTotalConsumido = nativeFromJson<double>(json['metricTotalConsumido']) {
  
  
  
  
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

    final CompleteOrderWithPrepaidAndUpdateMetricVariables otherTyped = other as CompleteOrderWithPrepaidAndUpdateMetricVariables;
    return orderId == otherTyped.orderId && 
    orderIdStr == otherTyped.orderIdStr && 
    observations == otherTyped.observations && 
    invoiceUrl == otherTyped.invoiceUrl && 
    invoiceId == otherTyped.invoiceId && 
    numeroUnico == otherTyped.numeroUnico && 
    subtotal == otherTyped.subtotal && 
    discount == otherTyped.discount && 
    tax == otherTyped.tax && 
    total == otherTyped.total && 
    paymentMethod == otherTyped.paymentMethod && 
    invoiceStatus == otherTyped.invoiceStatus && 
    businessId == otherTyped.businessId && 
    saldoPrepagoInicial == otherTyped.saldoPrepagoInicial && 
    saldoPrepagoConsumido == otherTyped.saldoPrepagoConsumido && 
    historyId == otherTyped.historyId && 
    serviceName == otherTyped.serviceName && 
    costoConsumido == otherTyped.costoConsumido && 
    saldoResultante == otherTyped.saldoResultante && 
    metricId == otherTyped.metricId && 
    metricCantidad == otherTyped.metricCantidad && 
    metricTotalConsumido == otherTyped.metricTotalConsumido;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, orderIdStr.hashCode, observations.hashCode, invoiceUrl.hashCode, invoiceId.hashCode, numeroUnico.hashCode, subtotal.hashCode, discount.hashCode, tax.hashCode, total.hashCode, paymentMethod.hashCode, invoiceStatus.hashCode, businessId.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, historyId.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode, metricId.hashCode, metricCantidad.hashCode, metricTotalConsumido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    json['orderIdStr'] = nativeToJson<String>(orderIdStr);
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
    json['businessId'] = nativeToJson<String>(businessId);
    json['saldoPrepagoInicial'] = nativeToJson<double>(saldoPrepagoInicial);
    json['saldoPrepagoConsumido'] = nativeToJson<double>(saldoPrepagoConsumido);
    json['historyId'] = nativeToJson<String>(historyId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['costoConsumido'] = nativeToJson<double>(costoConsumido);
    json['saldoResultante'] = nativeToJson<double>(saldoResultante);
    json['metricId'] = nativeToJson<String>(metricId);
    json['metricCantidad'] = nativeToJson<int>(metricCantidad);
    json['metricTotalConsumido'] = nativeToJson<double>(metricTotalConsumido);
    return json;
  }

  CompleteOrderWithPrepaidAndUpdateMetricVariables({
    required this.orderId,
    required this.orderIdStr,
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
    required this.businessId,
    required this.saldoPrepagoInicial,
    required this.saldoPrepagoConsumido,
    required this.historyId,
    required this.serviceName,
    required this.costoConsumido,
    required this.saldoResultante,
    required this.metricId,
    required this.metricCantidad,
    required this.metricTotalConsumido,
  });
}

