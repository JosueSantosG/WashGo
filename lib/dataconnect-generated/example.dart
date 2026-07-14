library washgo;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'upsert_user.dart';

part 'request_employee_access.dart';

part 'approve_employee_request.dart';

part 'reject_employee_request.dart';

part 'create_business.dart';

part 'update_business.dart';

part 'create_order.dart';

part 'accept_order.dart';

part 'update_order_status.dart';

part 'update_order_payment_method_and_status.dart';

part 'reschedule_order.dart';

part 'create_service.dart';

part 'update_service.dart';

part 'update_service_details.dart';

part 'super_admin_approve_service_price.dart';

part 'delete_service.dart';

part 'toggle_service_active.dart';

part 'create_business_hour.dart';

part 'add_vehicle.dart';

part 'delete_vehicle.dart';

part 'update_vehicle.dart';

part 'update_employee_availability.dart';

part 'delete_business_hours.dart';

part 'super_admin_update_business_status.dart';

part 'switch_current_business.dart';

part 'create_walk_in_user.dart';

part 'create_walk_in_order.dart';

part 'update_order_completion.dart';

part 'create_invoice.dart';

part 'create_invoice_item.dart';

part 'update_invoice_pdf.dart';

part 'create_review.dart';

part 'update_business_prepaid_balance.dart';

part 'super_admin_update_business_prepaid.dart';

part 'create_notification.dart';

part 'mark_notification_as_read.dart';

part 'create_prepaid_history.dart';

part 'create_prepaid_service_metric.dart';

part 'update_prepaid_service_metric.dart';

part 'create_business_reservation_config.dart';

part 'update_business_reservation_config.dart';

part 'create_order_reservation.dart';

part 'delete_order_reservation.dart';

part 'upsert_vehicle_brand.dart';

part 'upsert_vehicle_model.dart';

part 'update_user_phone.dart';

part 'delete_current_user.dart';

part 'complete_order_with_invoice_only.dart';

part 'complete_order_with_prepaid_and_update_metric.dart';

part 'complete_order_with_prepaid_and_create_metric.dart';

part 'consume_prepaid_and_update_metric.dart';

part 'consume_prepaid_and_create_metric.dart';

part 'server_create_order_with_pending_payment.dart';

part 'create_payment_proof.dart';

part 'server_update_payment_proof_status.dart';

part 'server_update_payment_proof.dart';

part 'server_update_order_status.dart';

part 'create_system_notification.dart';

part 'complete_order_with_transfer_and_invoice.dart';

part 'create_order_log.dart';

part 'get_users.dart';

part 'get_current_user.dart';

part 'get_business_by_code.dart';

part 'get_pending_employee_requests.dart';

part 'get_all_businesses.dart';

part 'get_client_orders.dart';

part 'get_business_orders.dart';

part 'get_active_employees.dart';

part 'get_business_services.dart';

part 'get_my_vehicles.dart';

part 'get_vehicle_brands.dart';

part 'get_vehicle_models_by_brand.dart';

part 'get_active_business_orders.dart';

part 'get_employee_availability.dart';

part 'get_business_hours.dart';

part 'super_admin_get_businesses.dart';

part 'get_my_businesses.dart';

part 'get_employee_history_orders_paged.dart';

part 'get_client_history_orders_paged.dart';

part 'find_user_by_phone.dart';

part 'get_client_invoices.dart';

part 'get_employee_invoices.dart';

part 'get_business_invoices.dart';

part 'get_invoice_by_id.dart';

part 'get_invoices_by_date_range.dart';

part 'get_business_details.dart';

part 'get_user_notifications.dart';

part 'get_prepaid_history.dart';

part 'get_prepaid_service_metrics.dart';

part 'get_prepaid_service_metric_by_service_name.dart';

part 'get_order_by_id.dart';

part 'server_get_order_by_id.dart';

part 'get_prepaid_history_by_order_id.dart';

part 'get_business_reservation_config.dart';

part 'get_active_reservations.dart';

part 'get_reservation_by_order_id.dart';

part 'get_business_reviews.dart';

part 'get_order_review.dart';

part 'get_global_app_ratings.dart';

part 'get_order_details_for_payment.dart';

part 'get_invoice_by_order_id.dart';

part 'get_invoice_details_for_url.dart';

part 'check_business_employee_admin.dart';

part 'get_payment_proof.dart';

part 'get_pending_transfer_orders.dart';

part 'get_transfer_payment_stats.dart';

part 'get_expired_pending_transfer_orders.dart';

part 'get_pending_payment_proofs.dart';

part 'get_order_logs.dart';

part 'super_admin_get_completed_orders.dart';

part 'super_admin_get_cancelled_paid_orders.dart';

part 'super_admin_get_cancelled_orders_summary.dart';

part 'get_pending_electronic_orders.dart';



  enum BusinessStatus {
    
      PENDING_APPROVAL,
    
      APPROVED,
    
      REJECTED,
    
  }
  
  String businessStatusSerializer(EnumValue<BusinessStatus> e) {
    return e.stringValue;
  }
  EnumValue<BusinessStatus> businessStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDING_APPROVAL':
        return const Known(BusinessStatus.PENDING_APPROVAL);
      
      case 'APPROVED':
        return const Known(BusinessStatus.APPROVED);
      
      case 'REJECTED':
        return const Known(BusinessStatus.REJECTED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum EmployeeStatus {
    
      UNASSIGNED,
    
      PENDING,
    
      ACTIVE,
    
      REJECTED,
    
  }
  
  String employeeStatusSerializer(EnumValue<EmployeeStatus> e) {
    return e.stringValue;
  }
  EnumValue<EmployeeStatus> employeeStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'UNASSIGNED':
        return const Known(EmployeeStatus.UNASSIGNED);
      
      case 'PENDING':
        return const Known(EmployeeStatus.PENDING);
      
      case 'ACTIVE':
        return const Known(EmployeeStatus.ACTIVE);
      
      case 'REJECTED':
        return const Known(EmployeeStatus.REJECTED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum InvoiceStatus {
    
      PENDING,
    
      GENERATED,
    
      FAILED,
    
  }
  
  String invoiceStatusSerializer(EnumValue<InvoiceStatus> e) {
    return e.stringValue;
  }
  EnumValue<InvoiceStatus> invoiceStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDING':
        return const Known(InvoiceStatus.PENDING);
      
      case 'GENERATED':
        return const Known(InvoiceStatus.GENERATED);
      
      case 'FAILED':
        return const Known(InvoiceStatus.FAILED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum OrderStatus {
    
      PENDIENTE_PAGO,
    
      EN_COLA,
    
      ACEPTADO,
    
      EN_CAMINO,
    
      EN_SERVICIO,
    
      COMPLETADO,
    
      CANCELADO,
    
  }
  
  String orderStatusSerializer(EnumValue<OrderStatus> e) {
    return e.stringValue;
  }
  EnumValue<OrderStatus> orderStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDIENTE_PAGO':
        return const Known(OrderStatus.PENDIENTE_PAGO);
      
      case 'EN_COLA':
        return const Known(OrderStatus.EN_COLA);
      
      case 'ACEPTADO':
        return const Known(OrderStatus.ACEPTADO);
      
      case 'EN_CAMINO':
        return const Known(OrderStatus.EN_CAMINO);
      
      case 'EN_SERVICIO':
        return const Known(OrderStatus.EN_SERVICIO);
      
      case 'COMPLETADO':
        return const Known(OrderStatus.COMPLETADO);
      
      case 'CANCELADO':
        return const Known(OrderStatus.CANCELADO);
      
      default:
        return Unknown(data);
    }
  }
  

  enum OrderType {
    
      LOCAL,
    
      DELIVERY,
    
  }
  
  String orderTypeSerializer(EnumValue<OrderType> e) {
    return e.stringValue;
  }
  EnumValue<OrderType> orderTypeDeserializer(dynamic data) {
    switch (data) {
      
      case 'LOCAL':
        return const Known(OrderType.LOCAL);
      
      case 'DELIVERY':
        return const Known(OrderType.DELIVERY);
      
      default:
        return Unknown(data);
    }
  }
  

  enum PaymentAccountType {
    
      GUAYAQUIL,
    
      PICHINCHA,
    
  }
  
  String paymentAccountTypeSerializer(EnumValue<PaymentAccountType> e) {
    return e.stringValue;
  }
  EnumValue<PaymentAccountType> paymentAccountTypeDeserializer(dynamic data) {
    switch (data) {
      
      case 'GUAYAQUIL':
        return const Known(PaymentAccountType.GUAYAQUIL);
      
      case 'PICHINCHA':
        return const Known(PaymentAccountType.PICHINCHA);
      
      default:
        return Unknown(data);
    }
  }
  

  enum PaymentMethod {
    
      PAYPAL,
    
      CASH,
    
      TRANSFERENCIA_BANCARIA,
    
      PAYPHONE,
    
  }
  
  String paymentMethodSerializer(EnumValue<PaymentMethod> e) {
    return e.stringValue;
  }
  EnumValue<PaymentMethod> paymentMethodDeserializer(dynamic data) {
    switch (data) {
      
      case 'PAYPAL':
        return const Known(PaymentMethod.PAYPAL);
      
      case 'CASH':
        return const Known(PaymentMethod.CASH);
      
      case 'TRANSFERENCIA_BANCARIA':
        return const Known(PaymentMethod.TRANSFERENCIA_BANCARIA);
      
      case 'PAYPHONE':
        return const Known(PaymentMethod.PAYPHONE);
      
      default:
        return Unknown(data);
    }
  }
  

  enum PaymentProofStatus {
    
      PENDING,
    
      APPROVED,
    
      REJECTED,
    
  }
  
  String paymentProofStatusSerializer(EnumValue<PaymentProofStatus> e) {
    return e.stringValue;
  }
  EnumValue<PaymentProofStatus> paymentProofStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDING':
        return const Known(PaymentProofStatus.PENDING);
      
      case 'APPROVED':
        return const Known(PaymentProofStatus.APPROVED);
      
      case 'REJECTED':
        return const Known(PaymentProofStatus.REJECTED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum ServiceType {
    
      LOCAL,
    
      DOMICILIO,
    
  }
  
  String serviceTypeSerializer(EnumValue<ServiceType> e) {
    return e.stringValue;
  }
  EnumValue<ServiceType> serviceTypeDeserializer(dynamic data) {
    switch (data) {
      
      case 'LOCAL':
        return const Known(ServiceType.LOCAL);
      
      case 'DOMICILIO':
        return const Known(ServiceType.DOMICILIO);
      
      default:
        return Unknown(data);
    }
  }
  

  enum UserRole {
    
      CLIENTE,
    
      EMPLEADO,
    
      ADMINISTRADOR,
    
      SUPER_ADMIN,
    
  }
  
  String userRoleSerializer(EnumValue<UserRole> e) {
    return e.stringValue;
  }
  EnumValue<UserRole> userRoleDeserializer(dynamic data) {
    switch (data) {
      
      case 'CLIENTE':
        return const Known(UserRole.CLIENTE);
      
      case 'EMPLEADO':
        return const Known(UserRole.EMPLEADO);
      
      case 'ADMINISTRADOR':
        return const Known(UserRole.ADMINISTRADOR);
      
      case 'SUPER_ADMIN':
        return const Known(UserRole.SUPER_ADMIN);
      
      default:
        return Unknown(data);
    }
  }
  



String enumSerializer(Enum e) {
  return e.name;
}



/// A sealed class representing either a known enum value or an unknown string value.
@immutable
sealed class EnumValue<T extends Enum> {
  const EnumValue();

  

  /// The string representation of the value.
  String get stringValue;
  @override
  String toString() {
    return "EnumValue($stringValue)";
  }
}

/// Represents a known, valid enum value.
class Known<T extends Enum> extends EnumValue<T> {
  /// The actual enum value.
  final T value;

  const Known(this.value);

  @override
  String get stringValue => value.name;

  @override
  String toString() {
    return "Known($stringValue)";
  }
}
/// Represents an unknown or unrecognized enum value.
class Unknown extends EnumValue<Never> {
  /// The raw string value that couldn't be mapped to a known enum.
  @override
  final String stringValue;

  const Unknown(this.stringValue);
  @override
  String toString() {
    return "Unknown($stringValue)";
  }
}

class ExampleConnector {
  
  
  UpsertUserVariablesBuilder upsertUser ({required String email, required String nombreCompleto, required List<UserRole> roles, }) {
    return UpsertUserVariablesBuilder(dataConnect, email: email,nombreCompleto: nombreCompleto,roles: roles,);
  }
  
  
  RequestEmployeeAccessVariablesBuilder requestEmployeeAccess ({required String businessId, }) {
    return RequestEmployeeAccessVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  ApproveEmployeeRequestVariablesBuilder approveEmployeeRequest ({required String requestId, required String employeeId, required String businessId, }) {
    return ApproveEmployeeRequestVariablesBuilder(dataConnect, requestId: requestId,employeeId: employeeId,businessId: businessId,);
  }
  
  
  RejectEmployeeRequestVariablesBuilder rejectEmployeeRequest ({required String requestId, required String employeeId, }) {
    return RejectEmployeeRequestVariablesBuilder(dataConnect, requestId: requestId,employeeId: employeeId,);
  }
  
  
  CreateBusinessVariablesBuilder createBusiness ({required String id, required String nombre, required String ruc, required String businessCode, }) {
    return CreateBusinessVariablesBuilder(dataConnect, id: id,nombre: nombre,ruc: ruc,businessCode: businessCode,);
  }
  
  
  UpdateBusinessVariablesBuilder updateBusiness ({required String id, required String nombre, required String ruc, }) {
    return UpdateBusinessVariablesBuilder(dataConnect, id: id,nombre: nombre,ruc: ruc,);
  }
  
  
  CreateOrderVariablesBuilder createOrder ({required String businessId, required double price, required double costo, required String serviceName, required OrderType type, required PaymentMethod paymentMethod, }) {
    return CreateOrderVariablesBuilder(dataConnect, businessId: businessId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,);
  }
  
  
  AcceptOrderVariablesBuilder acceptOrder ({required String orderId, required String employeeId, }) {
    return AcceptOrderVariablesBuilder(dataConnect, orderId: orderId,employeeId: employeeId,);
  }
  
  
  UpdateOrderStatusVariablesBuilder updateOrderStatus ({required String orderId, required OrderStatus status, }) {
    return UpdateOrderStatusVariablesBuilder(dataConnect, orderId: orderId,status: status,);
  }
  
  
  UpdateOrderPaymentMethodAndStatusVariablesBuilder updateOrderPaymentMethodAndStatus ({required String orderId, required PaymentMethod paymentMethod, required OrderStatus status, }) {
    return UpdateOrderPaymentMethodAndStatusVariablesBuilder(dataConnect, orderId: orderId,paymentMethod: paymentMethod,status: status,);
  }
  
  
  RescheduleOrderVariablesBuilder rescheduleOrder ({required String orderId, required String observations, }) {
    return RescheduleOrderVariablesBuilder(dataConnect, orderId: orderId,observations: observations,);
  }
  
  
  CreateServiceVariablesBuilder createService ({required String businessId, required String nombre, required double precioPequeno, required double precioMediano, required double precioGrande, required double precioMoto, required int duracionMinutos, required ServiceType tipo, }) {
    return CreateServiceVariablesBuilder(dataConnect, businessId: businessId,nombre: nombre,precioPequeno: precioPequeno,precioMediano: precioMediano,precioGrande: precioGrande,precioMoto: precioMoto,duracionMinutos: duracionMinutos,tipo: tipo,);
  }
  
  
  UpdateServiceVariablesBuilder updateService ({required String id, required String nombre, required double precioPequeno, required double precioMediano, required double precioGrande, required double precioMoto, required int duracionMinutos, required ServiceType tipo, }) {
    return UpdateServiceVariablesBuilder(dataConnect, id: id,nombre: nombre,precioPequeno: precioPequeno,precioMediano: precioMediano,precioGrande: precioGrande,precioMoto: precioMoto,duracionMinutos: duracionMinutos,tipo: tipo,);
  }
  
  
  UpdateServiceDetailsVariablesBuilder updateServiceDetails ({required String id, required String nombre, required int duracionMinutos, required ServiceType tipo, }) {
    return UpdateServiceDetailsVariablesBuilder(dataConnect, id: id,nombre: nombre,duracionMinutos: duracionMinutos,tipo: tipo,);
  }
  
  
  SuperAdminApproveServicePriceVariablesBuilder superAdminApproveServicePrice ({required String id, required double precioAprobadoPequeno, required double precioAprobadoMediano, required double precioAprobadoGrande, required double precioAprobadoMoto, }) {
    return SuperAdminApproveServicePriceVariablesBuilder(dataConnect, id: id,precioAprobadoPequeno: precioAprobadoPequeno,precioAprobadoMediano: precioAprobadoMediano,precioAprobadoGrande: precioAprobadoGrande,precioAprobadoMoto: precioAprobadoMoto,);
  }
  
  
  DeleteServiceVariablesBuilder deleteService ({required String id, }) {
    return DeleteServiceVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ToggleServiceActiveVariablesBuilder toggleServiceActive ({required String id, required bool activo, }) {
    return ToggleServiceActiveVariablesBuilder(dataConnect, id: id,activo: activo,);
  }
  
  
  CreateBusinessHourVariablesBuilder createBusinessHour ({required String businessId, required int diaDeLaSemana, required bool esDiaDescanso, }) {
    return CreateBusinessHourVariablesBuilder(dataConnect, businessId: businessId,diaDeLaSemana: diaDeLaSemana,esDiaDescanso: esDiaDescanso,);
  }
  
  
  AddVehicleVariablesBuilder addVehicle ({required String modelId, }) {
    return AddVehicleVariablesBuilder(dataConnect, modelId: modelId,);
  }
  
  
  DeleteVehicleVariablesBuilder deleteVehicle ({required String id, }) {
    return DeleteVehicleVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateVehicleVariablesBuilder updateVehicle ({required String id, required String modelId, }) {
    return UpdateVehicleVariablesBuilder(dataConnect, id: id,modelId: modelId,);
  }
  
  
  UpdateEmployeeAvailabilityVariablesBuilder updateEmployeeAvailability ({required String id, required bool estadoDisponibilidad, }) {
    return UpdateEmployeeAvailabilityVariablesBuilder(dataConnect, id: id,estadoDisponibilidad: estadoDisponibilidad,);
  }
  
  
  DeleteBusinessHoursVariablesBuilder deleteBusinessHours ({required String businessId, }) {
    return DeleteBusinessHoursVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  SuperAdminUpdateBusinessStatusVariablesBuilder superAdminUpdateBusinessStatus ({required String id, required BusinessStatus status, }) {
    return SuperAdminUpdateBusinessStatusVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  SwitchCurrentBusinessVariablesBuilder switchCurrentBusiness ({required String businessId, }) {
    return SwitchCurrentBusinessVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  CreateWalkInUserVariablesBuilder createWalkInUser ({required String id, required String nombreCompleto, required String telefono, required String email, }) {
    return CreateWalkInUserVariablesBuilder(dataConnect, id: id,nombreCompleto: nombreCompleto,telefono: telefono,email: email,);
  }
  
  
  CreateWalkInOrderVariablesBuilder createWalkInOrder ({required String businessId, required String clientId, required double price, required double costo, required String serviceName, required OrderType type, required PaymentMethod paymentMethod, }) {
    return CreateWalkInOrderVariablesBuilder(dataConnect, businessId: businessId,clientId: clientId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,);
  }
  
  
  UpdateOrderCompletionVariablesBuilder updateOrderCompletion ({required String orderId, }) {
    return UpdateOrderCompletionVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  CreateInvoiceVariablesBuilder createInvoice ({required String id, required String orderId, required String numeroUnico, required double subtotal, required double discount, required double tax, required double total, required PaymentMethod paymentMethod, required InvoiceStatus invoiceStatus, }) {
    return CreateInvoiceVariablesBuilder(dataConnect, id: id,orderId: orderId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,);
  }
  
  
  CreateInvoiceItemVariablesBuilder createInvoiceItem ({required String invoiceId, required String serviceName, required int quantity, required double unitPrice, required double total, }) {
    return CreateInvoiceItemVariablesBuilder(dataConnect, invoiceId: invoiceId,serviceName: serviceName,quantity: quantity,unitPrice: unitPrice,total: total,);
  }
  
  
  UpdateInvoicePdfVariablesBuilder updateInvoicePdf ({required String id, required InvoiceStatus invoiceStatus, }) {
    return UpdateInvoicePdfVariablesBuilder(dataConnect, id: id,invoiceStatus: invoiceStatus,);
  }
  
  
  CreateReviewVariablesBuilder createReview ({required String orderId, required String businessId, required int calificacion, }) {
    return CreateReviewVariablesBuilder(dataConnect, orderId: orderId,businessId: businessId,calificacion: calificacion,);
  }
  
  
  UpdateBusinessPrepaidBalanceVariablesBuilder updateBusinessPrepaidBalance ({required String id, required double saldoPrepagoInicial, required double saldoPrepagoConsumido, }) {
    return UpdateBusinessPrepaidBalanceVariablesBuilder(dataConnect, id: id,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,);
  }
  
  
  SuperAdminUpdateBusinessPrepaidVariablesBuilder superAdminUpdateBusinessPrepaid ({required String id, required double saldoPrepagoInicial, required double saldoPrepagoConsumido, }) {
    return SuperAdminUpdateBusinessPrepaidVariablesBuilder(dataConnect, id: id,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,);
  }
  
  
  CreateNotificationVariablesBuilder createNotification ({required String userId, required String titulo, required String mensaje, }) {
    return CreateNotificationVariablesBuilder(dataConnect, userId: userId,titulo: titulo,mensaje: mensaje,);
  }
  
  
  MarkNotificationAsReadVariablesBuilder markNotificationAsRead ({required String id, }) {
    return MarkNotificationAsReadVariablesBuilder(dataConnect, id: id,);
  }
  
  
  CreatePrepaidHistoryVariablesBuilder createPrepaidHistory ({required String businessId, required String orderId, required String serviceName, required double costoConsumido, required double saldoResultante, }) {
    return CreatePrepaidHistoryVariablesBuilder(dataConnect, businessId: businessId,orderId: orderId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,);
  }
  
  
  CreatePrepaidServiceMetricVariablesBuilder createPrepaidServiceMetric ({required String businessId, required String serviceName, required double costoUnitario, required int cantidad, required double totalConsumido, }) {
    return CreatePrepaidServiceMetricVariablesBuilder(dataConnect, businessId: businessId,serviceName: serviceName,costoUnitario: costoUnitario,cantidad: cantidad,totalConsumido: totalConsumido,);
  }
  
  
  UpdatePrepaidServiceMetricVariablesBuilder updatePrepaidServiceMetric ({required String id, required int cantidad, required double totalConsumido, }) {
    return UpdatePrepaidServiceMetricVariablesBuilder(dataConnect, id: id,cantidad: cantidad,totalConsumido: totalConsumido,);
  }
  
  
  CreateBusinessReservationConfigVariablesBuilder createBusinessReservationConfig ({required String businessId, required int capacidadSimultanea, required int tiempoAnticipacionMinutos, required bool isConfigured, }) {
    return CreateBusinessReservationConfigVariablesBuilder(dataConnect, businessId: businessId,capacidadSimultanea: capacidadSimultanea,tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,isConfigured: isConfigured,);
  }
  
  
  UpdateBusinessReservationConfigVariablesBuilder updateBusinessReservationConfig ({required String id, required int capacidadSimultanea, required int tiempoAnticipacionMinutos, required bool isConfigured, }) {
    return UpdateBusinessReservationConfigVariablesBuilder(dataConnect, id: id,capacidadSimultanea: capacidadSimultanea,tiempoAnticipacionMinutos: tiempoAnticipacionMinutos,isConfigured: isConfigured,);
  }
  
  
  CreateOrderReservationVariablesBuilder createOrderReservation ({required String orderId, required String businessId, required Timestamp scheduledAt, required int serviceDurationMinutos, required String serviceId, required Timestamp createdAt, }) {
    return CreateOrderReservationVariablesBuilder(dataConnect, orderId: orderId,businessId: businessId,scheduledAt: scheduledAt,serviceDurationMinutos: serviceDurationMinutos,serviceId: serviceId,createdAt: createdAt,);
  }
  
  
  DeleteOrderReservationVariablesBuilder deleteOrderReservation ({required String orderId, }) {
    return DeleteOrderReservationVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  UpsertVehicleBrandVariablesBuilder upsertVehicleBrand ({required String id, required String name, }) {
    return UpsertVehicleBrandVariablesBuilder(dataConnect, id: id,name: name,);
  }
  
  
  UpsertVehicleModelVariablesBuilder upsertVehicleModel ({required String id, required String brandId, required String name, required String category, }) {
    return UpsertVehicleModelVariablesBuilder(dataConnect, id: id,brandId: brandId,name: name,category: category,);
  }
  
  
  UpdateUserPhoneVariablesBuilder updateUserPhone ({required String telefono, }) {
    return UpdateUserPhoneVariablesBuilder(dataConnect, telefono: telefono,);
  }
  
  
  DeleteCurrentUserVariablesBuilder deleteCurrentUser () {
    return DeleteCurrentUserVariablesBuilder(dataConnect, );
  }
  
  
  CompleteOrderWithInvoiceOnlyVariablesBuilder completeOrderWithInvoiceOnly ({required String orderId, required String invoiceId, required String numeroUnico, required double subtotal, required double discount, required double tax, required double total, required PaymentMethod paymentMethod, required InvoiceStatus invoiceStatus, }) {
    return CompleteOrderWithInvoiceOnlyVariablesBuilder(dataConnect, orderId: orderId,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,);
  }
  
  
  CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder completeOrderWithPrepaidAndUpdateMetric ({required String orderId, required String orderIdStr, required String invoiceId, required String numeroUnico, required double subtotal, required double discount, required double tax, required double total, required PaymentMethod paymentMethod, required InvoiceStatus invoiceStatus, required String businessId, required double saldoPrepagoInicial, required double saldoPrepagoConsumido, required String historyId, required String serviceName, required double costoConsumido, required double saldoResultante, required String metricId, required int metricCantidad, required double metricTotalConsumido, }) {
    return CompleteOrderWithPrepaidAndUpdateMetricVariablesBuilder(dataConnect, orderId: orderId,orderIdStr: orderIdStr,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCantidad: metricCantidad,metricTotalConsumido: metricTotalConsumido,);
  }
  
  
  CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder completeOrderWithPrepaidAndCreateMetric ({required String orderId, required String orderIdStr, required String invoiceId, required String numeroUnico, required double subtotal, required double discount, required double tax, required double total, required PaymentMethod paymentMethod, required InvoiceStatus invoiceStatus, required String businessId, required double saldoPrepagoInicial, required double saldoPrepagoConsumido, required String historyId, required String serviceName, required double costoConsumido, required double saldoResultante, required String metricId, required double metricCostoUnitario, }) {
    return CompleteOrderWithPrepaidAndCreateMetricVariablesBuilder(dataConnect, orderId: orderId,orderIdStr: orderIdStr,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCostoUnitario: metricCostoUnitario,);
  }
  
  
  ConsumePrepaidAndUpdateMetricVariablesBuilder consumePrepaidAndUpdateMetric ({required String businessId, required double saldoPrepagoInicial, required double saldoPrepagoConsumido, required String historyId, required String orderId, required String serviceName, required double costoConsumido, required double saldoResultante, required String metricId, required int metricCantidad, required double metricTotalConsumido, }) {
    return ConsumePrepaidAndUpdateMetricVariablesBuilder(dataConnect, businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,orderId: orderId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCantidad: metricCantidad,metricTotalConsumido: metricTotalConsumido,);
  }
  
  
  ConsumePrepaidAndCreateMetricVariablesBuilder consumePrepaidAndCreateMetric ({required String businessId, required double saldoPrepagoInicial, required double saldoPrepagoConsumido, required String historyId, required String orderId, required String serviceName, required double costoConsumido, required double saldoResultante, required String metricId, required double metricCostoUnitario, }) {
    return ConsumePrepaidAndCreateMetricVariablesBuilder(dataConnect, businessId: businessId,saldoPrepagoInicial: saldoPrepagoInicial,saldoPrepagoConsumido: saldoPrepagoConsumido,historyId: historyId,orderId: orderId,serviceName: serviceName,costoConsumido: costoConsumido,saldoResultante: saldoResultante,metricId: metricId,metricCostoUnitario: metricCostoUnitario,);
  }
  
  
  ServerCreateOrderWithPendingPaymentVariablesBuilder serverCreateOrderWithPendingPayment ({required String businessId, required String clientId, required double price, required double costo, required String serviceName, required OrderType type, required PaymentMethod paymentMethod, }) {
    return ServerCreateOrderWithPendingPaymentVariablesBuilder(dataConnect, businessId: businessId,clientId: clientId,price: price,costo: costo,serviceName: serviceName,type: type,paymentMethod: paymentMethod,);
  }
  
  
  CreatePaymentProofVariablesBuilder createPaymentProof ({required String orderId, required String imageUrl, required double declaredAmount, required PaymentAccountType paymentAccountType, }) {
    return CreatePaymentProofVariablesBuilder(dataConnect, orderId: orderId,imageUrl: imageUrl,declaredAmount: declaredAmount,paymentAccountType: paymentAccountType,);
  }
  
  
  ServerUpdatePaymentProofStatusVariablesBuilder serverUpdatePaymentProofStatus ({required String id, required PaymentProofStatus status, required String reviewedBy, }) {
    return ServerUpdatePaymentProofStatusVariablesBuilder(dataConnect, id: id,status: status,reviewedBy: reviewedBy,);
  }
  
  
  ServerUpdatePaymentProofVariablesBuilder serverUpdatePaymentProof ({required String id, required String imageUrl, required double declaredAmount, required PaymentAccountType paymentAccountType, }) {
    return ServerUpdatePaymentProofVariablesBuilder(dataConnect, id: id,imageUrl: imageUrl,declaredAmount: declaredAmount,paymentAccountType: paymentAccountType,);
  }
  
  
  ServerUpdateOrderStatusVariablesBuilder serverUpdateOrderStatus ({required String orderId, required OrderStatus status, }) {
    return ServerUpdateOrderStatusVariablesBuilder(dataConnect, orderId: orderId,status: status,);
  }
  
  
  CreateSystemNotificationVariablesBuilder createSystemNotification ({required String userId, required String titulo, required String mensaje, }) {
    return CreateSystemNotificationVariablesBuilder(dataConnect, userId: userId,titulo: titulo,mensaje: mensaje,);
  }
  
  
  CompleteOrderWithTransferAndInvoiceVariablesBuilder completeOrderWithTransferAndInvoice ({required String orderId, required String invoiceId, required String numeroUnico, required double subtotal, required double discount, required double tax, required double total, required PaymentMethod paymentMethod, required InvoiceStatus invoiceStatus, }) {
    return CompleteOrderWithTransferAndInvoiceVariablesBuilder(dataConnect, orderId: orderId,invoiceId: invoiceId,numeroUnico: numeroUnico,subtotal: subtotal,discount: discount,tax: tax,total: total,paymentMethod: paymentMethod,invoiceStatus: invoiceStatus,);
  }
  
  
  CreateOrderLogVariablesBuilder createOrderLog ({required String orderId, required String actionType, }) {
    return CreateOrderLogVariablesBuilder(dataConnect, orderId: orderId,actionType: actionType,);
  }
  
  
  GetUsersVariablesBuilder getUsers () {
    return GetUsersVariablesBuilder(dataConnect, );
  }
  
  
  GetCurrentUserVariablesBuilder getCurrentUser () {
    return GetCurrentUserVariablesBuilder(dataConnect, );
  }
  
  
  GetBusinessByCodeVariablesBuilder getBusinessByCode ({required String code, }) {
    return GetBusinessByCodeVariablesBuilder(dataConnect, code: code,);
  }
  
  
  GetPendingEmployeeRequestsVariablesBuilder getPendingEmployeeRequests ({required String businessId, }) {
    return GetPendingEmployeeRequestsVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetAllBusinessesVariablesBuilder getAllBusinesses () {
    return GetAllBusinessesVariablesBuilder(dataConnect, );
  }
  
  
  GetClientOrdersVariablesBuilder getClientOrders () {
    return GetClientOrdersVariablesBuilder(dataConnect, );
  }
  
  
  GetBusinessOrdersVariablesBuilder getBusinessOrders ({required String businessId, }) {
    return GetBusinessOrdersVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetActiveEmployeesVariablesBuilder getActiveEmployees ({required String businessId, }) {
    return GetActiveEmployeesVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetBusinessServicesVariablesBuilder getBusinessServices ({required String businessId, }) {
    return GetBusinessServicesVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetMyVehiclesVariablesBuilder getMyVehicles () {
    return GetMyVehiclesVariablesBuilder(dataConnect, );
  }
  
  
  GetVehicleBrandsVariablesBuilder getVehicleBrands () {
    return GetVehicleBrandsVariablesBuilder(dataConnect, );
  }
  
  
  GetVehicleModelsByBrandVariablesBuilder getVehicleModelsByBrand ({required String brandId, }) {
    return GetVehicleModelsByBrandVariablesBuilder(dataConnect, brandId: brandId,);
  }
  
  
  GetActiveBusinessOrdersVariablesBuilder getActiveBusinessOrders ({required String businessId, }) {
    return GetActiveBusinessOrdersVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetEmployeeAvailabilityVariablesBuilder getEmployeeAvailability ({required String businessId, required String employeeId, }) {
    return GetEmployeeAvailabilityVariablesBuilder(dataConnect, businessId: businessId,employeeId: employeeId,);
  }
  
  
  GetBusinessHoursVariablesBuilder getBusinessHours ({required String businessId, }) {
    return GetBusinessHoursVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  SuperAdminGetBusinessesVariablesBuilder superAdminGetBusinesses () {
    return SuperAdminGetBusinessesVariablesBuilder(dataConnect, );
  }
  
  
  GetMyBusinessesVariablesBuilder getMyBusinesses () {
    return GetMyBusinessesVariablesBuilder(dataConnect, );
  }
  
  
  GetEmployeeHistoryOrdersPagedVariablesBuilder getEmployeeHistoryOrdersPaged ({required String businessId, required String employeeId, required int limit, required int offset, }) {
    return GetEmployeeHistoryOrdersPagedVariablesBuilder(dataConnect, businessId: businessId,employeeId: employeeId,limit: limit,offset: offset,);
  }
  
  
  GetClientHistoryOrdersPagedVariablesBuilder getClientHistoryOrdersPaged ({required int limit, required int offset, }) {
    return GetClientHistoryOrdersPagedVariablesBuilder(dataConnect, limit: limit,offset: offset,);
  }
  
  
  FindUserByPhoneVariablesBuilder findUserByPhone ({required String phone, }) {
    return FindUserByPhoneVariablesBuilder(dataConnect, phone: phone,);
  }
  
  
  GetClientInvoicesVariablesBuilder getClientInvoices () {
    return GetClientInvoicesVariablesBuilder(dataConnect, );
  }
  
  
  GetEmployeeInvoicesVariablesBuilder getEmployeeInvoices () {
    return GetEmployeeInvoicesVariablesBuilder(dataConnect, );
  }
  
  
  GetBusinessInvoicesVariablesBuilder getBusinessInvoices ({required String businessId, }) {
    return GetBusinessInvoicesVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetInvoiceByIdVariablesBuilder getInvoiceById ({required String id, }) {
    return GetInvoiceByIdVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetInvoicesByDateRangeVariablesBuilder getInvoicesByDateRange ({required String businessId, required Timestamp startDate, required Timestamp endDate, }) {
    return GetInvoicesByDateRangeVariablesBuilder(dataConnect, businessId: businessId,startDate: startDate,endDate: endDate,);
  }
  
  
  GetBusinessDetailsVariablesBuilder getBusinessDetails ({required String id, }) {
    return GetBusinessDetailsVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetUserNotificationsVariablesBuilder getUserNotifications ({required String userId, }) {
    return GetUserNotificationsVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  GetPrepaidHistoryVariablesBuilder getPrepaidHistory ({required String businessId, }) {
    return GetPrepaidHistoryVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetPrepaidServiceMetricsVariablesBuilder getPrepaidServiceMetrics ({required String businessId, }) {
    return GetPrepaidServiceMetricsVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetPrepaidServiceMetricByServiceNameVariablesBuilder getPrepaidServiceMetricByServiceName ({required String businessId, required String serviceName, }) {
    return GetPrepaidServiceMetricByServiceNameVariablesBuilder(dataConnect, businessId: businessId,serviceName: serviceName,);
  }
  
  
  GetOrderByIdVariablesBuilder getOrderById ({required String id, }) {
    return GetOrderByIdVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ServerGetOrderByIdVariablesBuilder serverGetOrderById ({required String id, }) {
    return ServerGetOrderByIdVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetPrepaidHistoryByOrderIdVariablesBuilder getPrepaidHistoryByOrderId ({required String orderId, }) {
    return GetPrepaidHistoryByOrderIdVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  GetBusinessReservationConfigVariablesBuilder getBusinessReservationConfig ({required String businessId, }) {
    return GetBusinessReservationConfigVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetActiveReservationsVariablesBuilder getActiveReservations ({required String businessId, }) {
    return GetActiveReservationsVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetReservationByOrderIdVariablesBuilder getReservationByOrderId ({required String orderId, }) {
    return GetReservationByOrderIdVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  GetBusinessReviewsVariablesBuilder getBusinessReviews ({required String businessId, }) {
    return GetBusinessReviewsVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetOrderReviewVariablesBuilder getOrderReview ({required String orderId, }) {
    return GetOrderReviewVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  GetGlobalAppRatingsVariablesBuilder getGlobalAppRatings () {
    return GetGlobalAppRatingsVariablesBuilder(dataConnect, );
  }
  
  
  GetOrderDetailsForPaymentVariablesBuilder getOrderDetailsForPayment ({required String orderId, }) {
    return GetOrderDetailsForPaymentVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  GetInvoiceByOrderIdVariablesBuilder getInvoiceByOrderId ({required String orderId, }) {
    return GetInvoiceByOrderIdVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  GetInvoiceDetailsForUrlVariablesBuilder getInvoiceDetailsForUrl ({required String invoiceId, }) {
    return GetInvoiceDetailsForUrlVariablesBuilder(dataConnect, invoiceId: invoiceId,);
  }
  
  
  CheckBusinessEmployeeAdminVariablesBuilder checkBusinessEmployeeAdmin ({required String businessId, required String employeeId, }) {
    return CheckBusinessEmployeeAdminVariablesBuilder(dataConnect, businessId: businessId,employeeId: employeeId,);
  }
  
  
  GetPaymentProofVariablesBuilder getPaymentProof ({required String orderId, }) {
    return GetPaymentProofVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  GetPendingTransferOrdersVariablesBuilder getPendingTransferOrders ({required String businessId, }) {
    return GetPendingTransferOrdersVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetTransferPaymentStatsVariablesBuilder getTransferPaymentStats ({required String businessId, }) {
    return GetTransferPaymentStatsVariablesBuilder(dataConnect, businessId: businessId,);
  }
  
  
  GetExpiredPendingTransferOrdersVariablesBuilder getExpiredPendingTransferOrders () {
    return GetExpiredPendingTransferOrdersVariablesBuilder(dataConnect, );
  }
  
  
  GetPendingPaymentProofsVariablesBuilder getPendingPaymentProofs () {
    return GetPendingPaymentProofsVariablesBuilder(dataConnect, );
  }
  
  
  GetOrderLogsVariablesBuilder getOrderLogs ({required String orderId, }) {
    return GetOrderLogsVariablesBuilder(dataConnect, orderId: orderId,);
  }
  
  
  SuperAdminGetCompletedOrdersVariablesBuilder superAdminGetCompletedOrders ({required Timestamp startOfMonth, required Timestamp endOfMonth, }) {
    return SuperAdminGetCompletedOrdersVariablesBuilder(dataConnect, startOfMonth: startOfMonth,endOfMonth: endOfMonth,);
  }
  
  
  SuperAdminGetCancelledPaidOrdersVariablesBuilder superAdminGetCancelledPaidOrders ({required Timestamp startOfMonth, required Timestamp endOfMonth, }) {
    return SuperAdminGetCancelledPaidOrdersVariablesBuilder(dataConnect, startOfMonth: startOfMonth,endOfMonth: endOfMonth,);
  }
  
  
  SuperAdminGetCancelledOrdersSummaryVariablesBuilder superAdminGetCancelledOrdersSummary ({required Timestamp startOfMonth, required Timestamp endOfMonth, }) {
    return SuperAdminGetCancelledOrdersSummaryVariablesBuilder(dataConnect, startOfMonth: startOfMonth,endOfMonth: endOfMonth,);
  }
  
  
  GetPendingElectronicOrdersVariablesBuilder getPendingElectronicOrders () {
    return GetPendingElectronicOrdersVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'example',
    'washgo',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:5000),
      storage: CacheStorage.memory,
    );
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
