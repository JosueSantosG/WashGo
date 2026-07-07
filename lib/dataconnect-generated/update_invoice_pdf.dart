part of 'example.dart';

class UpdateInvoicePdfVariablesBuilder {
  String id;
  Optional<String> _pdfUrl = Optional.optional(nativeFromJson, nativeToJson);
  InvoiceStatus invoiceStatus;

  final FirebaseDataConnect _dataConnect;  UpdateInvoicePdfVariablesBuilder pdfUrl(String? t) {
   _pdfUrl.value = t;
   return this;
  }

  UpdateInvoicePdfVariablesBuilder(this._dataConnect, {required  this.id,required  this.invoiceStatus,});
  Deserializer<UpdateInvoicePdfData> dataDeserializer = (dynamic json)  => UpdateInvoicePdfData.fromJson(jsonDecode(json));
  Serializer<UpdateInvoicePdfVariables> varsSerializer = (UpdateInvoicePdfVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateInvoicePdfData, UpdateInvoicePdfVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateInvoicePdfData, UpdateInvoicePdfVariables> ref() {
    UpdateInvoicePdfVariables vars= UpdateInvoicePdfVariables(id: id,pdfUrl: _pdfUrl,invoiceStatus: invoiceStatus,);
    return _dataConnect.mutation("UpdateInvoicePdf", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateInvoicePdfInvoiceUpdate {
  final String id;
  UpdateInvoicePdfInvoiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateInvoicePdfInvoiceUpdate otherTyped = other as UpdateInvoicePdfInvoiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateInvoicePdfInvoiceUpdate({
    required this.id,
  });
}

@immutable
class UpdateInvoicePdfData {
  final UpdateInvoicePdfInvoiceUpdate? invoice_update;
  UpdateInvoicePdfData.fromJson(dynamic json):
  
  invoice_update = json['invoice_update'] == null ? null : UpdateInvoicePdfInvoiceUpdate.fromJson(json['invoice_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateInvoicePdfData otherTyped = other as UpdateInvoicePdfData;
    return invoice_update == otherTyped.invoice_update;
    
  }
  @override
  int get hashCode => invoice_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (invoice_update != null) {
      json['invoice_update'] = invoice_update!.toJson();
    }
    return json;
  }

  UpdateInvoicePdfData({
    this.invoice_update,
  });
}

@immutable
class UpdateInvoicePdfVariables {
  final String id;
  late final Optional<String>pdfUrl;
  final InvoiceStatus invoiceStatus;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateInvoicePdfVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
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

    final UpdateInvoicePdfVariables otherTyped = other as UpdateInvoicePdfVariables;
    return id == otherTyped.id && 
    pdfUrl == otherTyped.pdfUrl && 
    invoiceStatus == otherTyped.invoiceStatus;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, pdfUrl.hashCode, invoiceStatus.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(pdfUrl.state == OptionalState.set) {
      json['pdfUrl'] = pdfUrl.toJson();
    }
    json['invoiceStatus'] = 
    invoiceStatus.name
    ;
    return json;
  }

  UpdateInvoicePdfVariables({
    required this.id,
    required this.pdfUrl,
    required this.invoiceStatus,
  });
}

