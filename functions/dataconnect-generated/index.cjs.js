const { validateAdminArgs } = require('firebase-admin/data-connect');

const BusinessStatus = {
  PENDING_APPROVAL: "PENDING_APPROVAL",
  APPROVED: "APPROVED",
  REJECTED: "REJECTED",
}
exports.BusinessStatus = BusinessStatus;

const EmployeeStatus = {
  UNASSIGNED: "UNASSIGNED",
  PENDING: "PENDING",
  ACTIVE: "ACTIVE",
  REJECTED: "REJECTED",
}
exports.EmployeeStatus = EmployeeStatus;

const InvoiceStatus = {
  PENDING: "PENDING",
  GENERATED: "GENERATED",
  FAILED: "FAILED",
}
exports.InvoiceStatus = InvoiceStatus;

const OrderStatus = {
  PENDIENTE_PAGO: "PENDIENTE_PAGO",
  EN_COLA: "EN_COLA",
  ACEPTADO: "ACEPTADO",
  EN_CAMINO: "EN_CAMINO",
  EN_SERVICIO: "EN_SERVICIO",
  COMPLETADO: "COMPLETADO",
  CANCELADO: "CANCELADO",
}
exports.OrderStatus = OrderStatus;

const OrderType = {
  LOCAL: "LOCAL",
  DELIVERY: "DELIVERY",
}
exports.OrderType = OrderType;

const PaymentAccountType = {
  GUAYAQUIL: "GUAYAQUIL",
  PICHINCHA: "PICHINCHA",
}
exports.PaymentAccountType = PaymentAccountType;

const PaymentMethod = {
  PAYPAL: "PAYPAL",
  CASH: "CASH",
  TRANSFERENCIA_BANCARIA: "TRANSFERENCIA_BANCARIA",
  PAYPHONE: "PAYPHONE",
}
exports.PaymentMethod = PaymentMethod;

const PaymentProofStatus = {
  PENDING: "PENDING",
  APPROVED: "APPROVED",
  REJECTED: "REJECTED",
}
exports.PaymentProofStatus = PaymentProofStatus;

const ServiceType = {
  LOCAL: "LOCAL",
  DOMICILIO: "DOMICILIO",
}
exports.ServiceType = ServiceType;

const UserRole = {
  CLIENTE: "CLIENTE",
  EMPLEADO: "EMPLEADO",
  ADMINISTRADOR: "ADMINISTRADOR",
  SUPER_ADMIN: "SUPER_ADMIN",
}
exports.UserRole = UserRole;

const connectorConfig = {
  connector: 'example',
  serviceId: 'washgo',
  location: 'us-central1'
};
exports.connectorConfig = connectorConfig;

function getUsers(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetUsers', undefined, inputOpts);
}
exports.getUsers = getUsers;

function getCurrentUser(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetCurrentUser', undefined, inputOpts);
}
exports.getCurrentUser = getCurrentUser;

function getBusinessByCode(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessByCode', inputVars, inputOpts);
}
exports.getBusinessByCode = getBusinessByCode;

function getPendingEmployeeRequests(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPendingEmployeeRequests', inputVars, inputOpts);
}
exports.getPendingEmployeeRequests = getPendingEmployeeRequests;

function getAllBusinesses(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetAllBusinesses', undefined, inputOpts);
}
exports.getAllBusinesses = getAllBusinesses;

function getClientOrders(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetClientOrders', undefined, inputOpts);
}
exports.getClientOrders = getClientOrders;

function getBusinessOrders(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessOrders', inputVars, inputOpts);
}
exports.getBusinessOrders = getBusinessOrders;

function getActiveEmployees(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetActiveEmployees', inputVars, inputOpts);
}
exports.getActiveEmployees = getActiveEmployees;

function getBusinessServices(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessServices', inputVars, inputOpts);
}
exports.getBusinessServices = getBusinessServices;

function getMyVehicles(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetMyVehicles', undefined, inputOpts);
}
exports.getMyVehicles = getMyVehicles;

function getVehicleBrands(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetVehicleBrands', undefined, inputOpts);
}
exports.getVehicleBrands = getVehicleBrands;

function getVehicleModelsByBrand(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetVehicleModelsByBrand', inputVars, inputOpts);
}
exports.getVehicleModelsByBrand = getVehicleModelsByBrand;

function getActiveBusinessOrders(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetActiveBusinessOrders', inputVars, inputOpts);
}
exports.getActiveBusinessOrders = getActiveBusinessOrders;

function getEmployeeAvailability(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetEmployeeAvailability', inputVars, inputOpts);
}
exports.getEmployeeAvailability = getEmployeeAvailability;

function getBusinessHours(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessHours', inputVars, inputOpts);
}
exports.getBusinessHours = getBusinessHours;

function superAdminGetBusinesses(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('SuperAdminGetBusinesses', undefined, inputOpts);
}
exports.superAdminGetBusinesses = superAdminGetBusinesses;

function getMyBusinesses(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetMyBusinesses', undefined, inputOpts);
}
exports.getMyBusinesses = getMyBusinesses;

function getEmployeeHistoryOrdersPaged(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetEmployeeHistoryOrdersPaged', inputVars, inputOpts);
}
exports.getEmployeeHistoryOrdersPaged = getEmployeeHistoryOrdersPaged;

function getClientHistoryOrdersPaged(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetClientHistoryOrdersPaged', inputVars, inputOpts);
}
exports.getClientHistoryOrdersPaged = getClientHistoryOrdersPaged;

function findUserByPhone(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('FindUserByPhone', inputVars, inputOpts);
}
exports.findUserByPhone = findUserByPhone;

function getClientInvoices(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, false);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetClientInvoices', inputVars, inputOpts);
}
exports.getClientInvoices = getClientInvoices;

function getEmployeeInvoices(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, false);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetEmployeeInvoices', inputVars, inputOpts);
}
exports.getEmployeeInvoices = getEmployeeInvoices;

function getBusinessInvoices(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessInvoices', inputVars, inputOpts);
}
exports.getBusinessInvoices = getBusinessInvoices;

function getInvoiceById(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetInvoiceById', inputVars, inputOpts);
}
exports.getInvoiceById = getInvoiceById;

function getInvoiceByIdAdmin(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetInvoiceByIdAdmin', inputVars, inputOpts);
}
exports.getInvoiceByIdAdmin = getInvoiceByIdAdmin;

function getInvoicesByDateRange(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetInvoicesByDateRange', inputVars, inputOpts);
}
exports.getInvoicesByDateRange = getInvoicesByDateRange;

function getBusinessDetails(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessDetails', inputVars, inputOpts);
}
exports.getBusinessDetails = getBusinessDetails;

function getUserNotifications(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetUserNotifications', inputVars, inputOpts);
}
exports.getUserNotifications = getUserNotifications;

function getPrepaidHistory(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPrepaidHistory', inputVars, inputOpts);
}
exports.getPrepaidHistory = getPrepaidHistory;

function getPrepaidServiceMetrics(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPrepaidServiceMetrics', inputVars, inputOpts);
}
exports.getPrepaidServiceMetrics = getPrepaidServiceMetrics;

function getPrepaidServiceMetricByServiceName(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPrepaidServiceMetricByServiceName', inputVars, inputOpts);
}
exports.getPrepaidServiceMetricByServiceName = getPrepaidServiceMetricByServiceName;

function getOrderById(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetOrderById', inputVars, inputOpts);
}
exports.getOrderById = getOrderById;

function serverGetOrderById(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('ServerGetOrderById', inputVars, inputOpts);
}
exports.serverGetOrderById = serverGetOrderById;

function getPrepaidHistoryByOrderId(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPrepaidHistoryByOrderId', inputVars, inputOpts);
}
exports.getPrepaidHistoryByOrderId = getPrepaidHistoryByOrderId;

function getBusinessReservationConfig(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessReservationConfig', inputVars, inputOpts);
}
exports.getBusinessReservationConfig = getBusinessReservationConfig;

function getActiveReservations(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetActiveReservations', inputVars, inputOpts);
}
exports.getActiveReservations = getActiveReservations;

function getReservationByOrderId(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetReservationByOrderId', inputVars, inputOpts);
}
exports.getReservationByOrderId = getReservationByOrderId;

function getBusinessReviews(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetBusinessReviews', inputVars, inputOpts);
}
exports.getBusinessReviews = getBusinessReviews;

function getOrderReview(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetOrderReview', inputVars, inputOpts);
}
exports.getOrderReview = getOrderReview;

function getGlobalAppRatings(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetGlobalAppRatings', undefined, inputOpts);
}
exports.getGlobalAppRatings = getGlobalAppRatings;

function getOrderDetailsForPayment(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetOrderDetailsForPayment', inputVars, inputOpts);
}
exports.getOrderDetailsForPayment = getOrderDetailsForPayment;

function getInvoiceByOrderId(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetInvoiceByOrderId', inputVars, inputOpts);
}
exports.getInvoiceByOrderId = getInvoiceByOrderId;

function getInvoiceDetailsForUrl(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetInvoiceDetailsForUrl', inputVars, inputOpts);
}
exports.getInvoiceDetailsForUrl = getInvoiceDetailsForUrl;

function checkBusinessEmployeeAdmin(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('CheckBusinessEmployeeAdmin', inputVars, inputOpts);
}
exports.checkBusinessEmployeeAdmin = checkBusinessEmployeeAdmin;

function getPaymentProof(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPaymentProof', inputVars, inputOpts);
}
exports.getPaymentProof = getPaymentProof;

function getPendingTransferOrders(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPendingTransferOrders', inputVars, inputOpts);
}
exports.getPendingTransferOrders = getPendingTransferOrders;

function getTransferPaymentStats(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetTransferPaymentStats', inputVars, inputOpts);
}
exports.getTransferPaymentStats = getTransferPaymentStats;

function getExpiredPendingTransferOrders(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetExpiredPendingTransferOrders', undefined, inputOpts);
}
exports.getExpiredPendingTransferOrders = getExpiredPendingTransferOrders;

function getPendingPaymentProofs(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, false);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPendingPaymentProofs', inputVars, inputOpts);
}
exports.getPendingPaymentProofs = getPendingPaymentProofs;

function getOrderLogs(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetOrderLogs', inputVars, inputOpts);
}
exports.getOrderLogs = getOrderLogs;

function superAdminGetCompletedOrders(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('SuperAdminGetCompletedOrders', inputVars, inputOpts);
}
exports.superAdminGetCompletedOrders = superAdminGetCompletedOrders;

function superAdminGetCancelledPaidOrders(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('SuperAdminGetCancelledPaidOrders', inputVars, inputOpts);
}
exports.superAdminGetCancelledPaidOrders = superAdminGetCancelledPaidOrders;

function superAdminGetCancelledOrdersSummary(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('SuperAdminGetCancelledOrdersSummary', inputVars, inputOpts);
}
exports.superAdminGetCancelledOrdersSummary = superAdminGetCancelledOrdersSummary;

function getPendingElectronicOrders(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeQuery('GetPendingElectronicOrders', undefined, inputOpts);
}
exports.getPendingElectronicOrders = getPendingElectronicOrders;

function upsertUser(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpsertUser', inputVars, inputOpts);
}
exports.upsertUser = upsertUser;

function requestEmployeeAccess(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('RequestEmployeeAccess', inputVars, inputOpts);
}
exports.requestEmployeeAccess = requestEmployeeAccess;

function approveEmployeeRequest(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ApproveEmployeeRequest', inputVars, inputOpts);
}
exports.approveEmployeeRequest = approveEmployeeRequest;

function rejectEmployeeRequest(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('RejectEmployeeRequest', inputVars, inputOpts);
}
exports.rejectEmployeeRequest = rejectEmployeeRequest;

function createBusiness(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateBusiness', inputVars, inputOpts);
}
exports.createBusiness = createBusiness;

function updateBusiness(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateBusiness', inputVars, inputOpts);
}
exports.updateBusiness = updateBusiness;

function createOrder(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateOrder', inputVars, inputOpts);
}
exports.createOrder = createOrder;

function acceptOrder(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('AcceptOrder', inputVars, inputOpts);
}
exports.acceptOrder = acceptOrder;

function updateOrderStatus(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateOrderStatus', inputVars, inputOpts);
}
exports.updateOrderStatus = updateOrderStatus;

function updateOrderPaymentMethodAndStatus(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateOrderPaymentMethodAndStatus', inputVars, inputOpts);
}
exports.updateOrderPaymentMethodAndStatus = updateOrderPaymentMethodAndStatus;

function rescheduleOrder(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('RescheduleOrder', inputVars, inputOpts);
}
exports.rescheduleOrder = rescheduleOrder;

function createService(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateService', inputVars, inputOpts);
}
exports.createService = createService;

function updateService(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateService', inputVars, inputOpts);
}
exports.updateService = updateService;

function updateServiceDetails(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateServiceDetails', inputVars, inputOpts);
}
exports.updateServiceDetails = updateServiceDetails;

function superAdminApproveServicePrice(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('SuperAdminApproveServicePrice', inputVars, inputOpts);
}
exports.superAdminApproveServicePrice = superAdminApproveServicePrice;

function deleteService(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('DeleteService', inputVars, inputOpts);
}
exports.deleteService = deleteService;

function toggleServiceActive(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ToggleServiceActive', inputVars, inputOpts);
}
exports.toggleServiceActive = toggleServiceActive;

function createBusinessHour(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateBusinessHour', inputVars, inputOpts);
}
exports.createBusinessHour = createBusinessHour;

function addVehicle(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('AddVehicle', inputVars, inputOpts);
}
exports.addVehicle = addVehicle;

function deleteVehicle(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('DeleteVehicle', inputVars, inputOpts);
}
exports.deleteVehicle = deleteVehicle;

function updateVehicle(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateVehicle', inputVars, inputOpts);
}
exports.updateVehicle = updateVehicle;

function updateEmployeeAvailability(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateEmployeeAvailability', inputVars, inputOpts);
}
exports.updateEmployeeAvailability = updateEmployeeAvailability;

function deleteBusinessHours(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('DeleteBusinessHours', inputVars, inputOpts);
}
exports.deleteBusinessHours = deleteBusinessHours;

function superAdminUpdateBusinessStatus(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('SuperAdminUpdateBusinessStatus', inputVars, inputOpts);
}
exports.superAdminUpdateBusinessStatus = superAdminUpdateBusinessStatus;

function switchCurrentBusiness(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('SwitchCurrentBusiness', inputVars, inputOpts);
}
exports.switchCurrentBusiness = switchCurrentBusiness;

function createWalkInUser(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateWalkInUser', inputVars, inputOpts);
}
exports.createWalkInUser = createWalkInUser;

function createWalkInOrder(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateWalkInOrder', inputVars, inputOpts);
}
exports.createWalkInOrder = createWalkInOrder;

function updateOrderCompletion(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateOrderCompletion', inputVars, inputOpts);
}
exports.updateOrderCompletion = updateOrderCompletion;

function createInvoice(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateInvoice', inputVars, inputOpts);
}
exports.createInvoice = createInvoice;

function createInvoiceItem(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateInvoiceItem', inputVars, inputOpts);
}
exports.createInvoiceItem = createInvoiceItem;

function updateInvoicePdf(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateInvoicePdf', inputVars, inputOpts);
}
exports.updateInvoicePdf = updateInvoicePdf;

function createReview(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateReview', inputVars, inputOpts);
}
exports.createReview = createReview;

function updateBusinessPrepaidBalance(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateBusinessPrepaidBalance', inputVars, inputOpts);
}
exports.updateBusinessPrepaidBalance = updateBusinessPrepaidBalance;

function superAdminUpdateBusinessPrepaid(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('SuperAdminUpdateBusinessPrepaid', inputVars, inputOpts);
}
exports.superAdminUpdateBusinessPrepaid = superAdminUpdateBusinessPrepaid;

function createNotification(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateNotification', inputVars, inputOpts);
}
exports.createNotification = createNotification;

function markNotificationAsRead(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('MarkNotificationAsRead', inputVars, inputOpts);
}
exports.markNotificationAsRead = markNotificationAsRead;

function createPrepaidHistory(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreatePrepaidHistory', inputVars, inputOpts);
}
exports.createPrepaidHistory = createPrepaidHistory;

function createPrepaidServiceMetric(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreatePrepaidServiceMetric', inputVars, inputOpts);
}
exports.createPrepaidServiceMetric = createPrepaidServiceMetric;

function updatePrepaidServiceMetric(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdatePrepaidServiceMetric', inputVars, inputOpts);
}
exports.updatePrepaidServiceMetric = updatePrepaidServiceMetric;

function createBusinessReservationConfig(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateBusinessReservationConfig', inputVars, inputOpts);
}
exports.createBusinessReservationConfig = createBusinessReservationConfig;

function updateBusinessReservationConfig(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateBusinessReservationConfig', inputVars, inputOpts);
}
exports.updateBusinessReservationConfig = updateBusinessReservationConfig;

function createOrderReservation(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateOrderReservation', inputVars, inputOpts);
}
exports.createOrderReservation = createOrderReservation;

function deleteOrderReservation(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('DeleteOrderReservation', inputVars, inputOpts);
}
exports.deleteOrderReservation = deleteOrderReservation;

function upsertVehicleBrand(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpsertVehicleBrand', inputVars, inputOpts);
}
exports.upsertVehicleBrand = upsertVehicleBrand;

function upsertVehicleModel(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpsertVehicleModel', inputVars, inputOpts);
}
exports.upsertVehicleModel = upsertVehicleModel;

function updateUserPhone(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('UpdateUserPhone', inputVars, inputOpts);
}
exports.updateUserPhone = updateUserPhone;

function deleteCurrentUser(dcOrOptions, options) {
  const { dc: dcInstance, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrOptions, options, undefined);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('DeleteCurrentUser', undefined, inputOpts);
}
exports.deleteCurrentUser = deleteCurrentUser;

function completeOrderWithInvoiceOnly(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CompleteOrderWithInvoiceOnly', inputVars, inputOpts);
}
exports.completeOrderWithInvoiceOnly = completeOrderWithInvoiceOnly;

function completeOrderWithPrepaidAndUpdateMetric(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CompleteOrderWithPrepaidAndUpdateMetric', inputVars, inputOpts);
}
exports.completeOrderWithPrepaidAndUpdateMetric = completeOrderWithPrepaidAndUpdateMetric;

function completeOrderWithPrepaidAndCreateMetric(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CompleteOrderWithPrepaidAndCreateMetric', inputVars, inputOpts);
}
exports.completeOrderWithPrepaidAndCreateMetric = completeOrderWithPrepaidAndCreateMetric;

function consumePrepaidAndUpdateMetric(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ConsumePrepaidAndUpdateMetric', inputVars, inputOpts);
}
exports.consumePrepaidAndUpdateMetric = consumePrepaidAndUpdateMetric;

function consumePrepaidAndCreateMetric(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ConsumePrepaidAndCreateMetric', inputVars, inputOpts);
}
exports.consumePrepaidAndCreateMetric = consumePrepaidAndCreateMetric;

function serverCreateOrderWithPendingPayment(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ServerCreateOrderWithPendingPayment', inputVars, inputOpts);
}
exports.serverCreateOrderWithPendingPayment = serverCreateOrderWithPendingPayment;

function createPaymentProof(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreatePaymentProof', inputVars, inputOpts);
}
exports.createPaymentProof = createPaymentProof;

function serverUpdatePaymentProofStatus(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ServerUpdatePaymentProofStatus', inputVars, inputOpts);
}
exports.serverUpdatePaymentProofStatus = serverUpdatePaymentProofStatus;

function serverUpdatePaymentProof(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ServerUpdatePaymentProof', inputVars, inputOpts);
}
exports.serverUpdatePaymentProof = serverUpdatePaymentProof;

function serverUpdateOrderStatus(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('ServerUpdateOrderStatus', inputVars, inputOpts);
}
exports.serverUpdateOrderStatus = serverUpdateOrderStatus;

function createSystemNotification(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateSystemNotification', inputVars, inputOpts);
}
exports.createSystemNotification = createSystemNotification;

function completeOrderWithTransferAndInvoice(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CompleteOrderWithTransferAndInvoice', inputVars, inputOpts);
}
exports.completeOrderWithTransferAndInvoice = completeOrderWithTransferAndInvoice;

function createOrderLog(dcOrVarsOrOptions, varsOrOptions, options) {
  const { dc: dcInstance, vars: inputVars, options: inputOpts} = validateAdminArgs(connectorConfig, dcOrVarsOrOptions, varsOrOptions, options, true, true);
  dcInstance.useGen(true);
  return dcInstance.executeMutation('CreateOrderLog', inputVars, inputOpts);
}
exports.createOrderLog = createOrderLog;

