part of 'example.dart';

class CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder {
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
  double metricCostoUnitario;

  final FirebaseDataConnect _dataConnect;  CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder observations(String? t) {
   _observations.value = t;
   return this;
  }
  CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder invoiceUrl(String? t) {
   _invoiceUrl.value = t;
   return this;
  }

  CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder(this._dataConnect, {required  this.orderId,required  this.orderIdStr,required  this.invoiceId,required  this.numeroUnico,required  this.subtotal,required  this.discount,required  this.tax,required  this.total,required  this.paymentMethod,required  this.invoiceStatus,required  this.businessId,required  this.saldoPrepagoInicial,required  this.saldoPrepagoConsumido,required  this.historyId,required  this.serviceName,required  this.costoConsumido,required  this.saldoResultante,required  this.metricId,required  this.metricCostoUnitario,});
  Deserializer<CompleteOrderWithPrepaidAndCreateMetricData> dataDeserializer = (dynamic json)  => CompleteOrderWithPrepaidAndCreateMetricData.fromJson(jsonDecode(json));
  Serializer<CompleteOrderWithPrepaidAndCreateMetricVariables> varsSerializer = (CompleteOrderWithPrepaidAndCreateMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CompleteOrderWithPrepaidAndCreateMetricData, CompleteOrderWithPrepaidAndCreateMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CompleteOrderWithPrepaidAndCreateMetricData, CompleteOrderWithPrepaidAndCreateMetricVariables> ref() {
    CompleteOrderWithPrepaidAndCreateMetricVariables vars= CompleteOrderWithPrepaidAndCreateMetricVariables(orderId: orderId,orderIdStr: orderIdStr,observations: _observations,invoiceUrl: _invoiceUrl,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCostoUnitario: metricCostoUnitario,);
    return _dataConnect.mutation("CompleteOrderWithPrepaidAndCreateMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricOrderUpdate {
  final String id;
  CompleteOrderWithPrepaidAndCreateMetricOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndCreateMetricOrderUpdate otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricOrderUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert {
  final String id;
  CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate {
  final String id;
  CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert {
  final String id;
  CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert {
  final String id;
  CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert({
    required this.id,
  });
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricData {
  final CompleteOrderWithPrepaidAndCreateMetricOrderUpdate? order_update;
  final CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert invoice_insert;
  final CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate? business_update;
  final CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert prepaidHistory_insert;
  final CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert prepaidServiceMetric_insert;
  CompleteOrderWithPrepaidAndCreateMetricData.fromJson(dynamic json):
  
  order_update = json['order_update'] == null ? null : CompleteOrderWithPrepaidAndCreateMetricOrderUpdate.fromJson(json['order_update']),
  invoice_insert = CompleteOrderWithPrepaidAndCreateMetricInvoiceInsert.fromJson(json['invoice_insert']),
  business_update = json['business_update'] == null ? null : CompleteOrderWithPrepaidAndCreateMetricBusinessUpdate.fromJson(json['business_update']),
  prepaidHistory_insert = CompleteOrderWithPrepaidAndCreateMetricPrepaidHistoryInsert.fromJson(json['prepaidHistory_insert']),
  prepaidServiceMetric_insert = CompleteOrderWithPrepaidAndCreateMetricPrepaidServiceMetricInsert.fromJson(json['prepaidServiceMetric_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteOrderWithPrepaidAndCreateMetricData otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricData;
    return order_update == otherTyped.order_update && 
    invoice_insert == otherTyped.invoice_insert && 
    business_update == otherTyped.business_update && 
    prepaidHistory_insert == otherTyped.prepaidHistory_insert && 
    prepaidServiceMetric_insert == otherTyped.prepaidServiceMetric_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([order_update.hashCode, invoice_insert.hashCode, business_update.hashCode, prepaidHistory_insert.hashCode, prepaidServiceMetric_insert.hashCode]);
  

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
    json['prepaidServiceMetric_insert'] = prepaidServiceMetric_insert.toJson();
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricData({
    this.order_update,
    required this.invoice_insert,
    this.business_update,
    required this.prepaidHistory_insert,
    required this.prepaidServiceMetric_insert,
  });
}

@immutable
class CompleteOrderWithPrepaidAndCreateMetricVariables {
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
  final double metricCostoUnitario;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CompleteOrderWithPrepaidAndCreateMetricVariables.fromJson(Map<String, dynamic> json):
  
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
  metricCostoUnitario = nativeFromJson<double>(json['metricCostoUnitario']) {
  
  
  
  
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

    final CompleteOrderWithPrepaidAndCreateMetricVariables otherTyped = other as CompleteOrderWithPrepaidAndCreateMetricVariables;
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
    metricCostoUnitario == otherTyped.metricCostoUnitario;
    
  }
  @override
  int get hashCode => Object.hashAll([orderId.hashCode, orderIdStr.hashCode, observations.hashCode, invoiceUrl.hashCode, invoiceId.hashCode, numeroUnico.hashCode, subtotal.hashCode, discount.hashCode, tax.hashCode, total.hashCode, paymentMethod.hashCode, invoiceStatus.hashCode, businessId.hashCode, saldoPrepagoInicial.hashCode, saldoPrepagoConsumido.hashCode, historyId.hashCode, serviceName.hashCode, costoConsumido.hashCode, saldoResultante.hashCode, metricId.hashCode, metricCostoUnitario.hashCode]);
  

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
    json['metricCostoUnitario'] = nativeToJson<double>(metricCostoUnitario);
    return json;
  }

  CompleteOrderWithPrepaidAndCreateMetricVariables({
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
    required this.metricCostoUnitario,
  });
}

