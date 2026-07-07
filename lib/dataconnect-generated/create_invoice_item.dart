part of 'example.dart';

class CreateInvoiceItemVariablesBuilder {
  String invoiceId;
  String serviceName;
  int quantity;
  double unitPrice;
  double total;

  final FirebaseDataConnect _dataConnect;
  CreateInvoiceItemVariablesBuilder(this._dataConnect, {required  this.invoiceId,required  this.serviceName,required  this.quantity,required  this.unitPrice,required  this.total,});
  Deserializer<CreateInvoiceItemData> dataDeserializer = (dynamic json)  => CreateInvoiceItemData.fromJson(jsonDecode(json));
  Serializer<CreateInvoiceItemVariables> varsSerializer = (CreateInvoiceItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateInvoiceItemData, CreateInvoiceItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateInvoiceItemData, CreateInvoiceItemVariables> ref() {
    CreateInvoiceItemVariables vars= CreateInvoiceItemVariables(invoiceId: invoiceId,serviceName: serviceName,quantity: quantity,unitPrice: unitPrice,total: total,);
    return _dataConnect.mutation("CreateInvoiceItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateInvoiceItemInvoiceItemInsert {
  final String id;
  CreateInvoiceItemInvoiceItemInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateInvoiceItemInvoiceItemInsert otherTyped = other as CreateInvoiceItemInvoiceItemInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateInvoiceItemInvoiceItemInsert({
    required this.id,
  });
}

@immutable
class CreateInvoiceItemData {
  final CreateInvoiceItemInvoiceItemInsert invoiceItem_insert;
  CreateInvoiceItemData.fromJson(dynamic json):
  
  invoiceItem_insert = CreateInvoiceItemInvoiceItemInsert.fromJson(json['invoiceItem_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateInvoiceItemData otherTyped = other as CreateInvoiceItemData;
    return invoiceItem_insert == otherTyped.invoiceItem_insert;
    
  }
  @override
  int get hashCode => invoiceItem_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoiceItem_insert'] = invoiceItem_insert.toJson();
    return json;
  }

  CreateInvoiceItemData({
    required this.invoiceItem_insert,
  });
}

@immutable
class CreateInvoiceItemVariables {
  final String invoiceId;
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double total;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateInvoiceItemVariables.fromJson(Map<String, dynamic> json):
  
  invoiceId = nativeFromJson<String>(json['invoiceId']),
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

    final CreateInvoiceItemVariables otherTyped = other as CreateInvoiceItemVariables;
    return invoiceId == otherTyped.invoiceId && 
    serviceName == otherTyped.serviceName && 
    quantity == otherTyped.quantity && 
    unitPrice == otherTyped.unitPrice && 
    total == otherTyped.total;
    
  }
  @override
  int get hashCode => Object.hashAll([invoiceId.hashCode, serviceName.hashCode, quantity.hashCode, unitPrice.hashCode, total.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['invoiceId'] = nativeToJson<String>(invoiceId);
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['quantity'] = nativeToJson<int>(quantity);
    json['unitPrice'] = nativeToJson<double>(unitPrice);
    json['total'] = nativeToJson<double>(total);
    return json;
  }

  CreateInvoiceItemVariables({
    required this.invoiceId,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

