part of 'example.dart';

class GetInvoiceDetailsForUrlVariablesBuilder {
  String invoiceId;

  final FirebaseDataConnect _dataConnect;
  GetInvoiceDetailsForUrlVariablesBuilder(this._dataConnect, {required  this.invoiceId,});
  Deserializer<GetInvoiceDetailsForUrlData> dataDeserializer = (dynamic json)  => GetInvoiceDetailsForUrlData.fromJson(jsonDecode(json));
  Serializer<GetInvoiceDetailsForUrlVariables> varsSerializer = (GetInvoiceDetailsForUrlVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetInvoiceDetailsForUrlData, GetInvoiceDetailsForUrlVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetInvoiceDetailsForUrlData, GetInvoiceDetailsForUrlVariables> ref() {
    GetInvoiceDetailsForUrlVariables vars= GetInvoiceDetailsForUrlVariables(invoiceId: invoiceId,);
    return _dataConnect.query("GetInvoiceDetailsForUrl", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetInvoiceDetailsForUrlInvoice {
  final String? pdfUrl;
  final GetInvoiceDetailsForUrlInvoiceOrder order;
  GetInvoiceDetailsForUrlInvoice.fromJson(dynamic json):
  
  pdfUrl = json['pdfUrl'] == null ? null : nativeFromJson<String>(json['pdfUrl']),
  order = GetInvoiceDetailsForUrlInvoiceOrder.fromJson(json['order']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceDetailsForUrlInvoice otherTyped = other as GetInvoiceDetailsForUrlInvoice;
    return pdfUrl == otherTyped.pdfUrl && 
    order == otherTyped.order;
    
  }
  @override
  int get hashCode => Object.hashAll([pdfUrl.hashCode, order.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pdfUrl != null) {
      json['pdfUrl'] = nativeToJson<String?>(pdfUrl);
    }
    json['order'] = order.toJson();
    return json;
  }

  GetInvoiceDetailsForUrlInvoice({
    this.pdfUrl,
    required this.order,
  });
}

@immutable
class GetInvoiceDetailsForUrlInvoiceOrder {
  final String clientId;
  final String? employeeId;
  final GetInvoiceDetailsForUrlInvoiceOrderBusiness business;
  GetInvoiceDetailsForUrlInvoiceOrder.fromJson(dynamic json):
  
  clientId = nativeFromJson<String>(json['clientId']),
  employeeId = json['employeeId'] == null ? null : nativeFromJson<String>(json['employeeId']),
  business = GetInvoiceDetailsForUrlInvoiceOrderBusiness.fromJson(json['business']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceDetailsForUrlInvoiceOrder otherTyped = other as GetInvoiceDetailsForUrlInvoiceOrder;
    return clientId == otherTyped.clientId && 
    employeeId == otherTyped.employeeId && 
    business == otherTyped.business;
    
  }
  @override
  int get hashCode => Object.hashAll([clientId.hashCode, employeeId.hashCode, business.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['clientId'] = nativeToJson<String>(clientId);
    if (employeeId != null) {
      json['employeeId'] = nativeToJson<String?>(employeeId);
    }
    json['business'] = business.toJson();
    return json;
  }

  GetInvoiceDetailsForUrlInvoiceOrder({
    required this.clientId,
    this.employeeId,
    required this.business,
  });
}

@immutable
class GetInvoiceDetailsForUrlInvoiceOrderBusiness {
  final String id;
  final GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner owner;
  GetInvoiceDetailsForUrlInvoiceOrderBusiness.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  owner = GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner.fromJson(json['owner']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceDetailsForUrlInvoiceOrderBusiness otherTyped = other as GetInvoiceDetailsForUrlInvoiceOrderBusiness;
    return id == otherTyped.id && 
    owner == otherTyped.owner;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, owner.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['owner'] = owner.toJson();
    return json;
  }

  GetInvoiceDetailsForUrlInvoiceOrderBusiness({
    required this.id,
    required this.owner,
  });
}

@immutable
class GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner {
  final String id;
  GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner otherTyped = other as GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetInvoiceDetailsForUrlInvoiceOrderBusinessOwner({
    required this.id,
  });
}

@immutable
class GetInvoiceDetailsForUrlData {
  final GetInvoiceDetailsForUrlInvoice? invoice;
  GetInvoiceDetailsForUrlData.fromJson(dynamic json):
  
  invoice = json['invoice'] == null ? null : GetInvoiceDetailsForUrlInvoice.fromJson(json['invoice']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceDetailsForUrlData otherTyped = other as GetInvoiceDetailsForUrlData;
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

  GetInvoiceDetailsForUrlData({
    this.invoice,
  });
}

@immutable
class GetInvoiceDetailsForUrlVariables {
  final String invoiceId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetInvoiceDetailsForUrlVariables.fromJson(Map<String, dynamic> json):
  
  invoiceId = nativeFromJson<String>(json['invoiceId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetInvoiceDetailsForUrlVariables otherTyped = other as GetInvoiceDetailsForUrlVariables;
    return invoiceId == otherTyped.invoiceId;
    
  }
  @override
  int get hashCode => invoiceId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoiceId'] = nativeToJson<String>(invoiceId);
    return json;
  }

  GetInvoiceDetailsForUrlVariables({
    required this.invoiceId,
  });
}

