part of 'example.dart';

class GetInvoiceByOrderIdVariablesBuilder {
  String orderId;

  final FirebaseDataConnect _dataConnect;
  GetInvoiceByOrderIdVariablesBuilder(this._dataConnect, {required  this.orderId,});
  Deserializer<GetInvoiceByOrderIdData> dataDeserializer = (dynamic json)  => GetInvoiceByOrderIdData.fromJson(jsonDecode(json));
  Serializer<GetInvoiceByOrderIdVariables> varsSerializer = (GetInvoiceByOrderIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetInvoiceByOrderIdData, GetInvoiceByOrderIdVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetInvoiceByOrderIdData, GetInvoiceByOrderIdVariables> ref() {
    GetInvoiceByOrderIdVariables vars= GetInvoiceByOrderIdVariables(orderId: orderId,);
    return _dataConnect.query("GetInvoiceByOrderId", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetInvoiceByOrderIdInvoices {
  final String id;
  final EnumValue<InvoiceStatus> invoiceStatus;
  final String? pdfUrl;
  GetInvoiceByOrderIdInvoices.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  invoiceStatus = invoiceStatusDeserializer(json['invoiceStatus']),
  pdfUrl = json['pdfUrl'] == null ? null : nativeFromJson<String>(json['pdfUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByOrderIdInvoices otherTyped = other as GetInvoiceByOrderIdInvoices;
    return id == otherTyped.id && 
    invoiceStatus == otherTyped.invoiceStatus && 
    pdfUrl == otherTyped.pdfUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, invoiceStatus.hashCode, pdfUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['invoiceStatus'] = 
    invoiceStatusSerializer(invoiceStatus)
    ;
    if (pdfUrl != null) {
      json['pdfUrl'] = nativeToJson<String?>(pdfUrl);
    }
    return json;
  }

  GetInvoiceByOrderIdInvoices({
    required this.id,
    required this.invoiceStatus,
    this.pdfUrl,
  });
}

@immutable
class GetInvoiceByOrderIdData {
  final List<GetInvoiceByOrderIdInvoices> invoices;
  GetInvoiceByOrderIdData.fromJson(dynamic json):
  
  invoices = (json['invoices'] as List<dynamic>)
        .map((e) => GetInvoiceByOrderIdInvoices.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByOrderIdData otherTyped = other as GetInvoiceByOrderIdData;
    return invoices == otherTyped.invoices;
    
  }
  @override
  int get hashCode => invoices.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoices'] = invoices.map((e) => e.toJson()).toList();
    return json;
  }

  GetInvoiceByOrderIdData({
    required this.invoices,
  });
}

@immutable
class GetInvoiceByOrderIdVariables {
  final String orderId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetInvoiceByOrderIdVariables.fromJson(Map<String, dynamic> json):
  
  orderId = nativeFromJson<String>(json['orderId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceByOrderIdVariables otherTyped = other as GetInvoiceByOrderIdVariables;
    return orderId == otherTyped.orderId;
    
  }
  @override
  int get hashCode => orderId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['orderId'] = nativeToJson<String>(orderId);
    return json;
  }

  GetInvoiceByOrderIdVariables({
    required this.orderId,
  });
}

