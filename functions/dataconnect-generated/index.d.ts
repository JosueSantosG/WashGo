import { ConnectorConfig, DataConnect, OperationOptions, ExecuteOperationResponse } from 'firebase-admin/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;

export enum BusinessStatus {
  PENDING_APPROVAL = "PENDING_APPROVAL",
  APPROVED = "APPROVED",
  REJECTED = "REJECTED",
}
export enum EmployeeStatus {
  UNASSIGNED = "UNASSIGNED",
  PENDING = "PENDING",
  ACTIVE = "ACTIVE",
  REJECTED = "REJECTED",
}
export enum InvoiceStatus {
  PENDING = "PENDING",
  GENERATED = "GENERATED",
  FAILED = "FAILED",
}
export enum OrderStatus {
  PENDIENTE_PAGO = "PENDIENTE_PAGO",
  EN_COLA = "EN_COLA",
  ACEPTADO = "ACEPTADO",
  EN_CAMINO = "EN_CAMINO",
  EN_SERVICIO = "EN_SERVICIO",
  COMPLETADO = "COMPLETADO",
  CANCELADO = "CANCELADO",
}
export enum OrderType {
  LOCAL = "LOCAL",
  DELIVERY = "DELIVERY",
}
export enum PaymentMethod {
  PAYPAL = "PAYPAL",
  CASH = "CASH",
}
export enum ServiceType {
  LOCAL = "LOCAL",
  DOMICILIO = "DOMICILIO",
}
export enum UserRole {
  CLIENTE = "CLIENTE",
  EMPLEADO = "EMPLEADO",
  ADMINISTRADOR = "ADMINISTRADOR",
  SUPER_ADMIN = "SUPER_ADMIN",
}

export interface AcceptOrderData {
  order_update?: {
    id: UUIDString;
  };
}

export interface AcceptOrderVariables {
  orderId: UUIDString;
  employeeId: string;
}

export interface AddVehicleData {
  vehicle_insert: {
    id: UUIDString;
  };
}

export interface AddVehicleVariables {
  modelId: UUIDString;
  plate?: string | null;
}

export interface ApproveEmployeeRequestData {
  employeeRequest_update?: {
    id: UUIDString;
  };
    user_update?: {
      id: string;
    };
      businessEmployee_insert: {
        id: UUIDString;
      };
}

export interface ApproveEmployeeRequestVariables {
  requestId: UUIDString;
  employeeId: string;
  businessId: UUIDString;
}

export interface BusinessEmployee_Key {
  id: UUIDString;
  __typename?: 'BusinessEmployee_Key';
}

export interface BusinessHour_Key {
  id: UUIDString;
  __typename?: 'BusinessHour_Key';
}

export interface BusinessReservationConfig_Key {
  id: UUIDString;
  __typename?: 'BusinessReservationConfig_Key';
}

export interface Business_Key {
  id: UUIDString;
  __typename?: 'Business_Key';
}

export interface CheckBusinessEmployeeAdminData {
  businessEmployees: ({
    id: UUIDString;
  } & BusinessEmployee_Key)[];
    user?: {
      roles: UserRole[];
    };
}

export interface CheckBusinessEmployeeAdminVariables {
  businessId: UUIDString;
  employeeId: string;
}

export interface CompleteOrderWithInvoiceOnlyData {
  order_update?: {
    id: UUIDString;
  };
    invoice_insert: {
      id: UUIDString;
    };
}

export interface CompleteOrderWithInvoiceOnlyVariables {
  orderId: UUIDString;
  observations?: string | null;
  invoiceUrl?: string | null;
  invoiceId: UUIDString;
  numeroUnico: string;
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  paymentMethod: PaymentMethod;
  invoiceStatus: InvoiceStatus;
}

export interface CompleteOrderWithPrepaidAndCreateMetricData {
  order_update?: {
    id: UUIDString;
  };
    invoice_insert: {
      id: UUIDString;
    };
      business_update?: {
        id: UUIDString;
      };
        prepaidHistory_insert: {
          id: UUIDString;
        };
          prepaidServiceMetric_insert: {
            id: UUIDString;
          };
}

export interface CompleteOrderWithPrepaidAndCreateMetricVariables {
  orderId: UUIDString;
  orderIdStr: string;
  observations?: string | null;
  invoiceUrl?: string | null;
  invoiceId: UUIDString;
  numeroUnico: string;
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  paymentMethod: PaymentMethod;
  invoiceStatus: InvoiceStatus;
  businessId: UUIDString;
  saldoPrepagoInicial: number;
  saldoPrepagoConsumido: number;
  historyId: UUIDString;
  serviceName: string;
  costoConsumido: number;
  saldoResultante: number;
  metricId: UUIDString;
  metricCostoUnitario: number;
}

export interface CompleteOrderWithPrepaidAndUpdateMetricData {
  order_update?: {
    id: UUIDString;
  };
    invoice_insert: {
      id: UUIDString;
    };
      business_update?: {
        id: UUIDString;
      };
        prepaidHistory_insert: {
          id: UUIDString;
        };
          prepaidServiceMetric_update?: {
            id: UUIDString;
          };
}

export interface CompleteOrderWithPrepaidAndUpdateMetricVariables {
  orderId: UUIDString;
  orderIdStr: string;
  observations?: string | null;
  invoiceUrl?: string | null;
  invoiceId: UUIDString;
  numeroUnico: string;
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  paymentMethod: PaymentMethod;
  invoiceStatus: InvoiceStatus;
  businessId: UUIDString;
  saldoPrepagoInicial: number;
  saldoPrepagoConsumido: number;
  historyId: UUIDString;
  serviceName: string;
  costoConsumido: number;
  saldoResultante: number;
  metricId: UUIDString;
  metricCantidad: number;
  metricTotalConsumido: number;
}

export interface ConsumePrepaidAndCreateMetricData {
  business_update?: {
    id: UUIDString;
  };
    prepaidHistory_insert: {
      id: UUIDString;
    };
      prepaidServiceMetric_insert: {
        id: UUIDString;
      };
}

export interface ConsumePrepaidAndCreateMetricVariables {
  businessId: UUIDString;
  saldoPrepagoInicial: number;
  saldoPrepagoConsumido: number;
  historyId: UUIDString;
  orderId: string;
  serviceName: string;
  costoConsumido: number;
  saldoResultante: number;
  metricId: UUIDString;
  metricCostoUnitario: number;
}

export interface ConsumePrepaidAndUpdateMetricData {
  business_update?: {
    id: UUIDString;
  };
    prepaidHistory_insert: {
      id: UUIDString;
    };
      prepaidServiceMetric_update?: {
        id: UUIDString;
      };
}

export interface ConsumePrepaidAndUpdateMetricVariables {
  businessId: UUIDString;
  saldoPrepagoInicial: number;
  saldoPrepagoConsumido: number;
  historyId: UUIDString;
  orderId: string;
  serviceName: string;
  costoConsumido: number;
  saldoResultante: number;
  metricId: UUIDString;
  metricCantidad: number;
  metricTotalConsumido: number;
}

export interface CreateBusinessData {
  business_insert: {
    id: UUIDString;
  };
    user_update?: {
      id: string;
    };
}

export interface CreateBusinessHourData {
  businessHour_insert: {
    id: UUIDString;
  };
}

export interface CreateBusinessHourVariables {
  businessId: UUIDString;
  diaDeLaSemana: number;
  horaApertura?: string | null;
  horaCierre?: string | null;
  esDiaDescanso: boolean;
}

export interface CreateBusinessReservationConfigData {
  businessReservationConfig_insert: {
    id: UUIDString;
  };
}

export interface CreateBusinessReservationConfigVariables {
  businessId: UUIDString;
  capacidadSimultanea: number;
  tiempoAnticipacionMinutos: number;
  isConfigured: boolean;
}

export interface CreateBusinessVariables {
  id: UUIDString;
  nombre: string;
  ruc: string;
  businessCode: string;
  descripcion?: string | null;
  telefono?: string | null;
  latitud?: number | null;
  longitud?: number | null;
}

export interface CreateInvoiceData {
  invoice_insert: {
    id: UUIDString;
  };
}

export interface CreateInvoiceItemData {
  invoiceItem_insert: {
    id: UUIDString;
  };
}

export interface CreateInvoiceItemVariables {
  invoiceId: UUIDString;
  serviceName: string;
  quantity: number;
  unitPrice: number;
  total: number;
}

export interface CreateInvoiceVariables {
  id: UUIDString;
  orderId: UUIDString;
  numeroUnico: string;
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  paymentMethod: PaymentMethod;
  invoiceStatus: InvoiceStatus;
  pdfUrl?: string | null;
}

export interface CreateNotificationData {
  notification_insert: {
    id: UUIDString;
  };
}

export interface CreateNotificationVariables {
  userId: string;
  titulo: string;
  mensaje: string;
}

export interface CreateOrderData {
  order_insert: {
    id: UUIDString;
  };
}

export interface CreateOrderReservationData {
  orderReservation_insert: {
    id: UUIDString;
  };
}

export interface CreateOrderReservationVariables {
  orderId: UUIDString;
  businessId: UUIDString;
  scheduledAt: TimestampString;
  serviceDurationMinutos: number;
  serviceId: UUIDString;
  createdAt: TimestampString;
}

export interface CreateOrderVariables {
  businessId: UUIDString;
  price: number;
  costo: number;
  serviceName: string;
  type: OrderType;
  paymentMethod: PaymentMethod;
  observations?: string | null;
}

export interface CreatePrepaidHistoryData {
  prepaidHistory_insert: {
    id: UUIDString;
  };
}

export interface CreatePrepaidHistoryVariables {
  businessId: UUIDString;
  orderId: string;
  serviceName: string;
  costoConsumido: number;
  saldoResultante: number;
}

export interface CreatePrepaidServiceMetricData {
  prepaidServiceMetric_insert: {
    id: UUIDString;
  };
}

export interface CreatePrepaidServiceMetricVariables {
  businessId: UUIDString;
  serviceName: string;
  costoUnitario: number;
  cantidad: number;
  totalConsumido: number;
}

export interface CreateReviewData {
  review_insert: {
    id: UUIDString;
  };
}

export interface CreateReviewVariables {
  orderId: UUIDString;
  businessId: UUIDString;
  employeeId?: string | null;
  calificacion: number;
  comentario?: string | null;
  appCalificacion?: number | null;
  appComentario?: string | null;
}

export interface CreateServiceData {
  service_insert: {
    id: UUIDString;
  };
}

export interface CreateServiceVariables {
  businessId: UUIDString;
  nombre: string;
  descripcion?: string | null;
  precioPequeno: number;
  precioMediano: number;
  precioGrande: number;
  precioMoto: number;
  duracionMinutos: number;
  tipo: ServiceType;
}

export interface CreateWalkInOrderData {
  order_insert: {
    id: UUIDString;
  };
}

export interface CreateWalkInOrderVariables {
  businessId: UUIDString;
  clientId: string;
  price: number;
  costo: number;
  serviceName: string;
  type: OrderType;
  paymentMethod: PaymentMethod;
  observations?: string | null;
}

export interface CreateWalkInUserData {
  user_insert: {
    id: string;
  };
}

export interface CreateWalkInUserVariables {
  id: string;
  nombreCompleto: string;
  telefono: string;
  email: string;
}

export interface DeleteBusinessHoursData {
  businessHour_deleteMany: number;
}

export interface DeleteBusinessHoursVariables {
  businessId: UUIDString;
}

export interface DeleteCurrentUserData {
  user_delete?: {
    id: string;
  };
}

export interface DeleteOrderReservationData {
  orderReservation_deleteMany: number;
}

export interface DeleteOrderReservationVariables {
  orderId: UUIDString;
}

export interface DeleteServiceData {
  service_delete?: {
    id: UUIDString;
  };
}

export interface DeleteServiceVariables {
  id: UUIDString;
}

export interface DeleteVehicleData {
  vehicle_delete?: {
    id: UUIDString;
  };
}

export interface DeleteVehicleVariables {
  id: UUIDString;
}

export interface EmployeeRequest_Key {
  id: UUIDString;
  __typename?: 'EmployeeRequest_Key';
}

export interface FindUserByPhoneData {
  users: ({
    id: string;
    nombreCompleto: string;
    telefono?: string | null;
    email: string;
  } & User_Key)[];
}

export interface FindUserByPhoneVariables {
  phone: string;
}

export interface GetActiveBusinessOrdersData {
  orders: ({
    id: UUIDString;
    price: number;
    costo: number;
    serviceName?: string | null;
    observations?: string | null;
    type: OrderType;
    paymentMethod: PaymentMethod;
    status: OrderStatus;
    client: {
      id: string;
      nombreCompleto: string;
    } & User_Key;
      employee?: {
        id: string;
        nombreCompleto: string;
      } & User_Key;
        service?: {
          id: UUIDString;
          duracionMinutos: number;
        } & Service_Key;
  } & Order_Key)[];
}

export interface GetActiveBusinessOrdersVariables {
  businessId: UUIDString;
}

export interface GetActiveEmployeesData {
  businessEmployees: ({
    id: UUIDString;
    employee: {
      id: string;
      nombreCompleto: string;
      email: string;
      telefono?: string | null;
      fotoPerfil?: string | null;
    } & User_Key;
      estadoDisponibilidad: boolean;
      joinedAt: TimestampString;
  } & BusinessEmployee_Key)[];
}

export interface GetActiveEmployeesVariables {
  businessId: UUIDString;
}

export interface GetActiveReservationsData {
  orderReservations: ({
    orderId: UUIDString;
    businessId: UUIDString;
    scheduledAt: TimestampString;
    serviceDurationMinutos: number;
    serviceId: UUIDString;
    createdAt: TimestampString;
  })[];
}

export interface GetActiveReservationsVariables {
  businessId: UUIDString;
}

export interface GetAllBusinessesData {
  businesses: ({
    id: UUIDString;
    nombre: string;
    businessCode: string;
    status: BusinessStatus;
    descripcion?: string | null;
    telefono?: string | null;
    latitud?: number | null;
    longitud?: number | null;
    owner: {
      nombreCompleto: string;
    };
      businessHours_on_business: ({
        diaDeLaSemana: number;
        horaApertura?: string | null;
        horaCierre?: string | null;
        esDiaDescanso: boolean;
      })[];
        services_on_business: ({
          precioPequeno: number;
          precioMediano: number;
          precioGrande: number;
          precioMoto: number;
          activo?: boolean | null;
          precioPendiente: boolean;
        })[];
          reviews_on_business: ({
            calificacion: number;
          })[];
  } & Business_Key)[];
}

export interface GetBusinessByCodeData {
  businesses: ({
    id: UUIDString;
    nombre: string;
    descripcion?: string | null;
  } & Business_Key)[];
}

export interface GetBusinessByCodeVariables {
  code: string;
}

export interface GetBusinessDetailsData {
  business?: {
    id: UUIDString;
    nombre: string;
    ruc: string;
    descripcion?: string | null;
    telefono?: string | null;
    saldoPrepagoInicial: number;
    saldoPrepagoConsumido: number;
  } & Business_Key;
}

export interface GetBusinessDetailsVariables {
  id: UUIDString;
}

export interface GetBusinessHoursData {
  businessHours: ({
    id: UUIDString;
    diaDeLaSemana: number;
    horaApertura?: string | null;
    horaCierre?: string | null;
    esDiaDescanso: boolean;
  } & BusinessHour_Key)[];
}

export interface GetBusinessHoursVariables {
  businessId: UUIDString;
}

export interface GetBusinessInvoicesData {
  invoices: ({
    id: UUIDString;
    numeroUnico: string;
    fechaEmision: TimestampString;
    subtotal: number;
    discount: number;
    tax: number;
    total: number;
    paymentMethod: PaymentMethod;
    invoiceStatus: InvoiceStatus;
    generatedAt?: TimestampString | null;
    pdfUrl?: string | null;
    order: {
      id: UUIDString;
      price: number;
      serviceName?: string | null;
      paymentMethod: PaymentMethod;
      status: OrderStatus;
      client: {
        nombreCompleto: string;
        email: string;
        telefono?: string | null;
      };
        employee?: {
          nombreCompleto: string;
          telefono?: string | null;
        };
    } & Order_Key;
      invoiceItems_on_invoice: ({
        id: UUIDString;
        serviceName: string;
        quantity: number;
        unitPrice: number;
        total: number;
      } & InvoiceItem_Key)[];
  } & Invoice_Key)[];
}

export interface GetBusinessInvoicesVariables {
  businessId: UUIDString;
  limit?: number | null;
  offset?: number | null;
  employeeId?: string | null;
  startDate?: TimestampString | null;
  endDate?: TimestampString | null;
  paymentMethod?: PaymentMethod | null;
  status?: InvoiceStatus | null;
  searchQuery?: string | null;
}

export interface GetBusinessOrdersData {
  orders: ({
    id: UUIDString;
    price: number;
    costo: number;
    serviceName?: string | null;
    observations?: string | null;
    type: OrderType;
    paymentMethod: PaymentMethod;
    status: OrderStatus;
    client: {
      id: string;
      nombreCompleto: string;
      fotoPerfil?: string | null;
      telefono?: string | null;
    } & User_Key;
      employee?: {
        id: string;
        nombreCompleto: string;
        fotoPerfil?: string | null;
        telefono?: string | null;
      } & User_Key;
  } & Order_Key)[];
}

export interface GetBusinessOrdersVariables {
  businessId: UUIDString;
}

export interface GetBusinessReservationConfigData {
  businessReservationConfigs: ({
    id: UUIDString;
    capacidadSimultanea: number;
    tiempoAnticipacionMinutos: number;
    isConfigured: boolean;
    updatedAt: TimestampString;
  } & BusinessReservationConfig_Key)[];
}

export interface GetBusinessReservationConfigVariables {
  businessId: UUIDString;
}

export interface GetBusinessReviewsData {
  reviews: ({
    id: UUIDString;
    calificacion: number;
    comentario?: string | null;
    fechaCreacion: TimestampString;
    employee?: {
      id: string;
      nombreCompleto: string;
    } & User_Key;
  } & Review_Key)[];
}

export interface GetBusinessReviewsVariables {
  businessId: UUIDString;
}

export interface GetBusinessServicesData {
  services: ({
    id: UUIDString;
    nombre: string;
    descripcion?: string | null;
    precioPequeno: number;
    precioMediano: number;
    precioGrande: number;
    precioMoto: number;
    precioOwnerPequeno: number;
    precioOwnerMediano: number;
    precioOwnerGrande: number;
    precioOwnerMoto: number;
    precioPendiente: boolean;
    costo: number;
    duracionMinutos: number;
    fotoUrl?: string | null;
    tipo: ServiceType;
    activo?: boolean | null;
  } & Service_Key)[];
}

export interface GetBusinessServicesVariables {
  businessId: UUIDString;
}

export interface GetClientHistoryOrdersPagedData {
  orders: ({
    id: UUIDString;
    price: number;
    costo: number;
    serviceName?: string | null;
    observations?: string | null;
    type: OrderType;
    paymentMethod: PaymentMethod;
    status: OrderStatus;
    invoiceUrl?: string | null;
    business: {
      id: UUIDString;
      nombre: string;
      latitud?: number | null;
      longitud?: number | null;
    } & Business_Key;
      employee?: {
        id: string;
        nombreCompleto: string;
        fotoPerfil?: string | null;
        telefono?: string | null;
      } & User_Key;
        review_on_order?: {
          id: UUIDString;
          calificacion: number;
          comentario?: string | null;
        } & Review_Key;
  } & Order_Key)[];
}

export interface GetClientHistoryOrdersPagedVariables {
  limit: number;
  offset: number;
}

export interface GetClientInvoicesData {
  invoices: ({
    id: UUIDString;
    numeroUnico: string;
    fechaEmision: TimestampString;
    subtotal: number;
    discount: number;
    tax: number;
    total: number;
    paymentMethod: PaymentMethod;
    invoiceStatus: InvoiceStatus;
    generatedAt?: TimestampString | null;
    pdfUrl?: string | null;
    order: {
      id: UUIDString;
      price: number;
      serviceName?: string | null;
      paymentMethod: PaymentMethod;
      status: OrderStatus;
      business: {
        nombre: string;
      };
        employee?: {
          nombreCompleto: string;
          telefono?: string | null;
        };
    } & Order_Key;
      invoiceItems_on_invoice: ({
        id: UUIDString;
        serviceName: string;
        quantity: number;
        unitPrice: number;
        total: number;
      } & InvoiceItem_Key)[];
  } & Invoice_Key)[];
}

export interface GetClientInvoicesVariables {
  limit?: number | null;
  offset?: number | null;
  startDate?: TimestampString | null;
  endDate?: TimestampString | null;
  paymentMethod?: PaymentMethod | null;
  status?: InvoiceStatus | null;
  searchQuery?: string | null;
}

export interface GetClientOrdersData {
  orders: ({
    id: UUIDString;
    price: number;
    costo: number;
    serviceName?: string | null;
    observations?: string | null;
    type: OrderType;
    paymentMethod: PaymentMethod;
    status: OrderStatus;
    invoiceUrl?: string | null;
    business: {
      id: UUIDString;
      nombre: string;
      latitud?: number | null;
      longitud?: number | null;
      telefono?: string | null;
    } & Business_Key;
      employee?: {
        id: string;
        nombreCompleto: string;
        fotoPerfil?: string | null;
        telefono?: string | null;
      } & User_Key;
        review_on_order?: {
          id: UUIDString;
          calificacion: number;
          comentario?: string | null;
        } & Review_Key;
  } & Order_Key)[];
}

export interface GetCurrentUserData {
  user?: {
    id: string;
    nombreCompleto: string;
    email: string;
    roles: UserRole[];
    fotoPerfil?: string | null;
    telefono?: string | null;
    fechaCreacion: TimestampString;
    employeeStatus: EmployeeStatus;
    currentBusiness?: {
      id: UUIDString;
      nombre: string;
      ruc: string;
      businessCode: string;
      descripcion?: string | null;
      telefono?: string | null;
      latitud?: number | null;
      longitud?: number | null;
      status: BusinessStatus;
      saldoPrepagoInicial: number;
      saldoPrepagoConsumido: number;
    } & Business_Key;
  } & User_Key;
}

export interface GetEmployeeAvailabilityData {
  businessEmployees: ({
    id: UUIDString;
    estadoDisponibilidad: boolean;
  } & BusinessEmployee_Key)[];
}

export interface GetEmployeeAvailabilityVariables {
  businessId: UUIDString;
  employeeId: string;
}

export interface GetEmployeeHistoryOrdersPagedData {
  orders: ({
    id: UUIDString;
    price: number;
    costo: number;
    serviceName?: string | null;
    observations?: string | null;
    type: OrderType;
    paymentMethod: PaymentMethod;
    status: OrderStatus;
    client: {
      id: string;
      nombreCompleto: string;
      fotoPerfil?: string | null;
      telefono?: string | null;
    } & User_Key;
      employee?: {
        id: string;
        nombreCompleto: string;
        fotoPerfil?: string | null;
        telefono?: string | null;
      } & User_Key;
  } & Order_Key)[];
}

export interface GetEmployeeHistoryOrdersPagedVariables {
  businessId: UUIDString;
  employeeId: string;
  limit: number;
  offset: number;
}

export interface GetEmployeeInvoicesData {
  invoices: ({
    id: UUIDString;
    numeroUnico: string;
    fechaEmision: TimestampString;
    subtotal: number;
    discount: number;
    tax: number;
    total: number;
    paymentMethod: PaymentMethod;
    invoiceStatus: InvoiceStatus;
    generatedAt?: TimestampString | null;
    pdfUrl?: string | null;
    order: {
      id: UUIDString;
      price: number;
      serviceName?: string | null;
      paymentMethod: PaymentMethod;
      status: OrderStatus;
      observations?: string | null;
      business: {
        nombre: string;
      };
        client: {
          nombreCompleto: string;
          email: string;
          telefono?: string | null;
        };
    } & Order_Key;
      invoiceItems_on_invoice: ({
        id: UUIDString;
        serviceName: string;
        quantity: number;
        unitPrice: number;
        total: number;
      } & InvoiceItem_Key)[];
  } & Invoice_Key)[];
}

export interface GetEmployeeInvoicesVariables {
  limit?: number | null;
  offset?: number | null;
  startDate?: TimestampString | null;
  endDate?: TimestampString | null;
  paymentMethod?: PaymentMethod | null;
  status?: InvoiceStatus | null;
  searchQuery?: string | null;
}

export interface GetGlobalAppRatingsData {
  reviews: ({
    id: UUIDString;
    appCalificacion?: number | null;
    appComentario?: string | null;
    fechaCreacion: TimestampString;
  } & Review_Key)[];
}

export interface GetInvoiceByIdData {
  invoice?: {
    id: UUIDString;
    numeroUnico: string;
    fechaEmision: TimestampString;
    subtotal: number;
    discount: number;
    tax: number;
    total: number;
    paymentMethod: PaymentMethod;
    invoiceStatus: InvoiceStatus;
    generatedAt?: TimestampString | null;
    pdfUrl?: string | null;
    order: {
      id: UUIDString;
      price: number;
      serviceName?: string | null;
      paymentMethod: PaymentMethod;
      status: OrderStatus;
      observations?: string | null;
      clientId: string;
      employeeId?: string | null;
      business: {
        id: UUIDString;
        nombre: string;
        ruc: string;
        descripcion?: string | null;
        owner: {
          id: string;
        } & User_Key;
      } & Business_Key;
        client: {
          nombreCompleto: string;
          email: string;
          telefono?: string | null;
        };
          employee?: {
            nombreCompleto: string;
            telefono?: string | null;
          };
    } & Order_Key;
      invoiceItems_on_invoice: ({
        id: UUIDString;
        serviceName: string;
        quantity: number;
        unitPrice: number;
        total: number;
      } & InvoiceItem_Key)[];
  } & Invoice_Key;
}

export interface GetInvoiceByIdVariables {
  id: UUIDString;
}

export interface GetInvoiceByOrderIdData {
  invoices: ({
    id: UUIDString;
    invoiceStatus: InvoiceStatus;
    pdfUrl?: string | null;
  } & Invoice_Key)[];
}

export interface GetInvoiceByOrderIdVariables {
  orderId: UUIDString;
}

export interface GetInvoiceDetailsForUrlData {
  invoice?: {
    pdfUrl?: string | null;
    order: {
      clientId: string;
      employeeId?: string | null;
      business: {
        id: UUIDString;
        owner: {
          id: string;
        } & User_Key;
      } & Business_Key;
    };
  };
}

export interface GetInvoiceDetailsForUrlVariables {
  invoiceId: UUIDString;
}

export interface GetInvoicesByDateRangeData {
  invoices: ({
    id: UUIDString;
    numeroUnico: string;
    fechaEmision: TimestampString;
    subtotal: number;
    discount: number;
    tax: number;
    total: number;
    paymentMethod: PaymentMethod;
    invoiceStatus: InvoiceStatus;
    generatedAt?: TimestampString | null;
    pdfUrl?: string | null;
    order: {
      id: UUIDString;
      price: number;
      serviceName?: string | null;
      paymentMethod: PaymentMethod;
      status: OrderStatus;
      client: {
        nombreCompleto: string;
      };
    } & Order_Key;
      invoiceItems_on_invoice: ({
        id: UUIDString;
        serviceName: string;
        quantity: number;
        unitPrice: number;
        total: number;
      } & InvoiceItem_Key)[];
  } & Invoice_Key)[];
}

export interface GetInvoicesByDateRangeVariables {
  businessId: UUIDString;
  startDate: TimestampString;
  endDate: TimestampString;
}

export interface GetMyBusinessesData {
  businesses: ({
    id: UUIDString;
    nombre: string;
    ruc: string;
    businessCode: string;
    status: BusinessStatus;
    descripcion?: string | null;
    telefono?: string | null;
    saldoPrepagoInicial: number;
    saldoPrepagoConsumido: number;
    latitud?: number | null;
    longitud?: number | null;
  } & Business_Key)[];
}

export interface GetMyVehiclesData {
  vehicles: ({
    id: UUIDString;
    plate?: string | null;
    model: {
      id: UUIDString;
      name: string;
      category: string;
      brand: {
        id: UUIDString;
        name: string;
      } & VehicleBrand_Key;
    } & VehicleModel_Key;
  } & Vehicle_Key)[];
}

export interface GetOrderByIdData {
  order?: {
    id: UUIDString;
    business: {
      id: UUIDString;
      nombre: string;
      saldoPrepagoInicial: number;
      saldoPrepagoConsumido: number;
      owner: {
        id: string;
      } & User_Key;
    } & Business_Key;
      costo: number;
      serviceName?: string | null;
      status: OrderStatus;
      observations?: string | null;
      price: number;
      paymentMethod: PaymentMethod;
      type: OrderType;
      client: {
        id: string;
        nombreCompleto: string;
        telefono?: string | null;
        email: string;
      } & User_Key;
        employee?: {
          id: string;
          nombreCompleto: string;
        } & User_Key;
  } & Order_Key;
}

export interface GetOrderByIdVariables {
  id: UUIDString;
}

export interface GetOrderDetailsForPaymentData {
  order?: {
    id: UUIDString;
    clientId: string;
    status: OrderStatus;
    price: number;
    serviceName?: string | null;
    business: {
      id: UUIDString;
      nombre: string;
      owner: {
        id: string;
      } & User_Key;
    } & Business_Key;
  } & Order_Key;
}

export interface GetOrderDetailsForPaymentVariables {
  orderId: UUIDString;
}

export interface GetOrderReviewData {
  reviews: ({
    id: UUIDString;
    calificacion: number;
    comentario?: string | null;
    appCalificacion?: number | null;
    appComentario?: string | null;
    fechaCreacion: TimestampString;
  } & Review_Key)[];
}

export interface GetOrderReviewVariables {
  orderId: UUIDString;
}

export interface GetPendingEmployeeRequestsData {
  employeeRequests: ({
    id: UUIDString;
    user: {
      id: string;
      nombreCompleto: string;
      email: string;
    } & User_Key;
      createdAt: TimestampString;
  } & EmployeeRequest_Key)[];
}

export interface GetPendingEmployeeRequestsVariables {
  businessId: UUIDString;
}

export interface GetPrepaidHistoryByOrderIdData {
  prepaidHistories: ({
    id: UUIDString;
    business: {
      owner: {
        id: string;
      } & User_Key;
    };
  } & PrepaidHistory_Key)[];
}

export interface GetPrepaidHistoryByOrderIdVariables {
  orderId: string;
}

export interface GetPrepaidHistoryData {
  prepaidHistories: ({
    id: UUIDString;
    orderId: string;
    serviceName: string;
    costoConsumido: number;
    saldoResultante: number;
    fecha: TimestampString;
  } & PrepaidHistory_Key)[];
}

export interface GetPrepaidHistoryVariables {
  businessId: UUIDString;
}

export interface GetPrepaidServiceMetricByServiceNameData {
  prepaidServiceMetrics: ({
    id: UUIDString;
    serviceName: string;
    costoUnitario: number;
    cantidad: number;
    totalConsumido: number;
  } & PrepaidServiceMetric_Key)[];
}

export interface GetPrepaidServiceMetricByServiceNameVariables {
  businessId: UUIDString;
  serviceName: string;
}

export interface GetPrepaidServiceMetricsData {
  prepaidServiceMetrics: ({
    id: UUIDString;
    serviceName: string;
    costoUnitario: number;
    cantidad: number;
    totalConsumido: number;
  } & PrepaidServiceMetric_Key)[];
}

export interface GetPrepaidServiceMetricsVariables {
  businessId: UUIDString;
}

export interface GetReservationByOrderIdData {
  orderReservations: ({
    orderId: UUIDString;
    businessId: UUIDString;
    scheduledAt: TimestampString;
    serviceDurationMinutos: number;
    serviceId: UUIDString;
    createdAt: TimestampString;
    business: {
      owner: {
        id: string;
      } & User_Key;
    };
      order: {
        clientId: string;
      };
  })[];
}

export interface GetReservationByOrderIdVariables {
  orderId: UUIDString;
}

export interface GetUserNotificationsData {
  notifications: ({
    id: UUIDString;
    titulo: string;
    mensaje: string;
    leida: boolean;
    fechaCreacion: TimestampString;
  } & Notification_Key)[];
}

export interface GetUserNotificationsVariables {
  userId: string;
}

export interface GetUsersData {
  users: ({
    id: string;
    nombreCompleto: string;
    email: string;
    roles: UserRole[];
  } & User_Key)[];
}

export interface GetVehicleBrandsData {
  vehicleBrands: ({
    id: UUIDString;
    name: string;
  } & VehicleBrand_Key)[];
}

export interface GetVehicleModelsByBrandData {
  vehicleModels: ({
    id: UUIDString;
    name: string;
    category: string;
  } & VehicleModel_Key)[];
}

export interface GetVehicleModelsByBrandVariables {
  brandId: UUIDString;
}

export interface InvoiceItem_Key {
  id: UUIDString;
  __typename?: 'InvoiceItem_Key';
}

export interface Invoice_Key {
  id: UUIDString;
  __typename?: 'Invoice_Key';
}

export interface MarkNotificationAsReadData {
  notification_update?: {
    id: UUIDString;
  };
}

export interface MarkNotificationAsReadVariables {
  id: UUIDString;
}

export interface Notification_Key {
  id: UUIDString;
  __typename?: 'Notification_Key';
}

export interface OrderReservation_Key {
  id: UUIDString;
  __typename?: 'OrderReservation_Key';
}

export interface Order_Key {
  id: UUIDString;
  __typename?: 'Order_Key';
}

export interface PrepaidHistory_Key {
  id: UUIDString;
  __typename?: 'PrepaidHistory_Key';
}

export interface PrepaidServiceMetric_Key {
  id: UUIDString;
  __typename?: 'PrepaidServiceMetric_Key';
}

export interface RejectEmployeeRequestData {
  employeeRequest_update?: {
    id: UUIDString;
  };
    user_update?: {
      id: string;
    };
}

export interface RejectEmployeeRequestVariables {
  requestId: UUIDString;
  employeeId: string;
}

export interface RequestEmployeeAccessData {
  user_update?: {
    id: string;
  };
    employeeRequest_insert: {
      id: UUIDString;
    };
}

export interface RequestEmployeeAccessVariables {
  businessId: UUIDString;
}

export interface RescheduleOrderData {
  order_update?: {
    id: UUIDString;
  };
}

export interface RescheduleOrderVariables {
  orderId: UUIDString;
  observations: string;
}

export interface Review_Key {
  id: UUIDString;
  __typename?: 'Review_Key';
}

export interface Service_Key {
  id: UUIDString;
  __typename?: 'Service_Key';
}

export interface SuperAdminApproveServicePriceData {
  service_update?: {
    id: UUIDString;
  };
}

export interface SuperAdminApproveServicePriceVariables {
  id: UUIDString;
  precioAprobadoPequeno: number;
  precioAprobadoMediano: number;
  precioAprobadoGrande: number;
  precioAprobadoMoto: number;
}

export interface SuperAdminGetBusinessesData {
  businesses: ({
    id: UUIDString;
    nombre: string;
    ruc: string;
    businessCode: string;
    status: BusinessStatus;
    descripcion?: string | null;
    telefono?: string | null;
    latitud?: number | null;
    longitud?: number | null;
    saldoPrepagoInicial: number;
    saldoPrepagoConsumido: number;
    owner: {
      id: string;
      nombreCompleto: string;
    } & User_Key;
      services_on_business: ({
        id: UUIDString;
        nombre: string;
        descripcion?: string | null;
        precioPequeno: number;
        precioMediano: number;
        precioGrande: number;
        precioMoto: number;
        precioOwnerPequeno: number;
        precioOwnerMediano: number;
        precioOwnerGrande: number;
        precioOwnerMoto: number;
        precioPendiente: boolean;
        costo: number;
        duracionMinutos: number;
        tipo: ServiceType;
        activo?: boolean | null;
      } & Service_Key)[];
  } & Business_Key)[];
}

export interface SuperAdminUpdateBusinessPrepaidData {
  business_update?: {
    id: UUIDString;
  };
}

export interface SuperAdminUpdateBusinessPrepaidVariables {
  id: UUIDString;
  saldoPrepagoInicial: number;
  saldoPrepagoConsumido: number;
}

export interface SuperAdminUpdateBusinessStatusData {
  business_update?: {
    id: UUIDString;
  };
}

export interface SuperAdminUpdateBusinessStatusVariables {
  id: UUIDString;
  status: BusinessStatus;
}

export interface SwitchCurrentBusinessData {
  user_update?: {
    id: string;
  };
}

export interface SwitchCurrentBusinessVariables {
  businessId: UUIDString;
}

export interface ToggleServiceActiveData {
  service_update?: {
    id: UUIDString;
  };
}

export interface ToggleServiceActiveVariables {
  id: UUIDString;
  activo: boolean;
}

export interface UpdateBusinessData {
  business_update?: {
    id: UUIDString;
  };
}

export interface UpdateBusinessPrepaidBalanceData {
  business_update?: {
    id: UUIDString;
  };
}

export interface UpdateBusinessPrepaidBalanceVariables {
  id: UUIDString;
  saldoPrepagoInicial: number;
  saldoPrepagoConsumido: number;
}

export interface UpdateBusinessReservationConfigData {
  businessReservationConfig_update?: {
    id: UUIDString;
  };
}

export interface UpdateBusinessReservationConfigVariables {
  id: UUIDString;
  capacidadSimultanea: number;
  tiempoAnticipacionMinutos: number;
  isConfigured: boolean;
}

export interface UpdateBusinessVariables {
  id: UUIDString;
  nombre: string;
  ruc: string;
  descripcion?: string | null;
  telefono?: string | null;
  latitud?: number | null;
  longitud?: number | null;
}

export interface UpdateEmployeeAvailabilityData {
  businessEmployee_update?: {
    id: UUIDString;
  };
}

export interface UpdateEmployeeAvailabilityVariables {
  id: UUIDString;
  estadoDisponibilidad: boolean;
}

export interface UpdateInvoicePdfData {
  invoice_update?: {
    id: UUIDString;
  };
}

export interface UpdateInvoicePdfVariables {
  id: UUIDString;
  pdfUrl?: string | null;
  invoiceStatus: InvoiceStatus;
}

export interface UpdateOrderCompletionData {
  order_update?: {
    id: UUIDString;
  };
}

export interface UpdateOrderCompletionVariables {
  orderId: UUIDString;
  observations?: string | null;
  invoiceUrl?: string | null;
}

export interface UpdateOrderStatusData {
  order_update?: {
    id: UUIDString;
  };
}

export interface UpdateOrderStatusVariables {
  orderId: UUIDString;
  status: OrderStatus;
}

export interface UpdatePrepaidServiceMetricData {
  prepaidServiceMetric_update?: {
    id: UUIDString;
  };
}

export interface UpdatePrepaidServiceMetricVariables {
  id: UUIDString;
  cantidad: number;
  totalConsumido: number;
}

export interface UpdateServiceData {
  service_update?: {
    id: UUIDString;
  };
}

export interface UpdateServiceDetailsData {
  service_update?: {
    id: UUIDString;
  };
}

export interface UpdateServiceDetailsVariables {
  id: UUIDString;
  nombre: string;
  descripcion?: string | null;
  duracionMinutos: number;
  tipo: ServiceType;
}

export interface UpdateServiceVariables {
  id: UUIDString;
  nombre: string;
  descripcion?: string | null;
  precioPequeno: number;
  precioMediano: number;
  precioGrande: number;
  precioMoto: number;
  duracionMinutos: number;
  tipo: ServiceType;
}

export interface UpdateUserPhoneData {
  user_update?: {
    id: string;
  };
}

export interface UpdateUserPhoneVariables {
  telefono: string;
}

export interface UpdateVehicleData {
  vehicle_update?: {
    id: UUIDString;
  };
}

export interface UpdateVehicleVariables {
  id: UUIDString;
  modelId: UUIDString;
  plate?: string | null;
}

export interface UpsertUserData {
  user_upsert: {
    id: string;
  };
}

export interface UpsertUserVariables {
  email: string;
  nombreCompleto: string;
  roles: UserRole[];
  employeeStatus?: EmployeeStatus | null;
  telefono?: string | null;
  fotoPerfil?: string | null;
}

export interface UpsertVehicleBrandData {
  vehicleBrand_upsert: {
    id: UUIDString;
  };
}

export interface UpsertVehicleBrandVariables {
  id: UUIDString;
  name: string;
}

export interface UpsertVehicleModelData {
  vehicleModel_upsert: {
    id: UUIDString;
  };
}

export interface UpsertVehicleModelVariables {
  id: UUIDString;
  brandId: UUIDString;
  name: string;
  category: string;
}

export interface User_Key {
  id: string;
  __typename?: 'User_Key';
}

export interface VehicleBrand_Key {
  id: UUIDString;
  __typename?: 'VehicleBrand_Key';
}

export interface VehicleModel_Key {
  id: UUIDString;
  __typename?: 'VehicleModel_Key';
}

export interface Vehicle_Key {
  id: UUIDString;
  __typename?: 'Vehicle_Key';
}

/** Generated Node Admin SDK operation action function for the 'UpsertUser' Mutation. Allow users to execute without passing in DataConnect. */
export function upsertUser(dc: DataConnect, vars: UpsertUserVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpsertUserData>>;
/** Generated Node Admin SDK operation action function for the 'UpsertUser' Mutation. Allow users to pass in custom DataConnect instances. */
export function upsertUser(vars: UpsertUserVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpsertUserData>>;

/** Generated Node Admin SDK operation action function for the 'RequestEmployeeAccess' Mutation. Allow users to execute without passing in DataConnect. */
export function requestEmployeeAccess(dc: DataConnect, vars: RequestEmployeeAccessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<RequestEmployeeAccessData>>;
/** Generated Node Admin SDK operation action function for the 'RequestEmployeeAccess' Mutation. Allow users to pass in custom DataConnect instances. */
export function requestEmployeeAccess(vars: RequestEmployeeAccessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<RequestEmployeeAccessData>>;

/** Generated Node Admin SDK operation action function for the 'ApproveEmployeeRequest' Mutation. Allow users to execute without passing in DataConnect. */
export function approveEmployeeRequest(dc: DataConnect, vars: ApproveEmployeeRequestVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ApproveEmployeeRequestData>>;
/** Generated Node Admin SDK operation action function for the 'ApproveEmployeeRequest' Mutation. Allow users to pass in custom DataConnect instances. */
export function approveEmployeeRequest(vars: ApproveEmployeeRequestVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ApproveEmployeeRequestData>>;

/** Generated Node Admin SDK operation action function for the 'RejectEmployeeRequest' Mutation. Allow users to execute without passing in DataConnect. */
export function rejectEmployeeRequest(dc: DataConnect, vars: RejectEmployeeRequestVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<RejectEmployeeRequestData>>;
/** Generated Node Admin SDK operation action function for the 'RejectEmployeeRequest' Mutation. Allow users to pass in custom DataConnect instances. */
export function rejectEmployeeRequest(vars: RejectEmployeeRequestVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<RejectEmployeeRequestData>>;

/** Generated Node Admin SDK operation action function for the 'CreateBusiness' Mutation. Allow users to execute without passing in DataConnect. */
export function createBusiness(dc: DataConnect, vars: CreateBusinessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateBusinessData>>;
/** Generated Node Admin SDK operation action function for the 'CreateBusiness' Mutation. Allow users to pass in custom DataConnect instances. */
export function createBusiness(vars: CreateBusinessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateBusinessData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateBusiness' Mutation. Allow users to execute without passing in DataConnect. */
export function updateBusiness(dc: DataConnect, vars: UpdateBusinessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateBusinessData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateBusiness' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateBusiness(vars: UpdateBusinessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateBusinessData>>;

/** Generated Node Admin SDK operation action function for the 'CreateOrder' Mutation. Allow users to execute without passing in DataConnect. */
export function createOrder(dc: DataConnect, vars: CreateOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateOrderData>>;
/** Generated Node Admin SDK operation action function for the 'CreateOrder' Mutation. Allow users to pass in custom DataConnect instances. */
export function createOrder(vars: CreateOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateOrderData>>;

/** Generated Node Admin SDK operation action function for the 'AcceptOrder' Mutation. Allow users to execute without passing in DataConnect. */
export function acceptOrder(dc: DataConnect, vars: AcceptOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<AcceptOrderData>>;
/** Generated Node Admin SDK operation action function for the 'AcceptOrder' Mutation. Allow users to pass in custom DataConnect instances. */
export function acceptOrder(vars: AcceptOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<AcceptOrderData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateOrderStatus' Mutation. Allow users to execute without passing in DataConnect. */
export function updateOrderStatus(dc: DataConnect, vars: UpdateOrderStatusVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateOrderStatusData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateOrderStatus' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateOrderStatus(vars: UpdateOrderStatusVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateOrderStatusData>>;

/** Generated Node Admin SDK operation action function for the 'RescheduleOrder' Mutation. Allow users to execute without passing in DataConnect. */
export function rescheduleOrder(dc: DataConnect, vars: RescheduleOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<RescheduleOrderData>>;
/** Generated Node Admin SDK operation action function for the 'RescheduleOrder' Mutation. Allow users to pass in custom DataConnect instances. */
export function rescheduleOrder(vars: RescheduleOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<RescheduleOrderData>>;

/** Generated Node Admin SDK operation action function for the 'CreateService' Mutation. Allow users to execute without passing in DataConnect. */
export function createService(dc: DataConnect, vars: CreateServiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateServiceData>>;
/** Generated Node Admin SDK operation action function for the 'CreateService' Mutation. Allow users to pass in custom DataConnect instances. */
export function createService(vars: CreateServiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateServiceData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateService' Mutation. Allow users to execute without passing in DataConnect. */
export function updateService(dc: DataConnect, vars: UpdateServiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateServiceData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateService' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateService(vars: UpdateServiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateServiceData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateServiceDetails' Mutation. Allow users to execute without passing in DataConnect. */
export function updateServiceDetails(dc: DataConnect, vars: UpdateServiceDetailsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateServiceDetailsData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateServiceDetails' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateServiceDetails(vars: UpdateServiceDetailsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateServiceDetailsData>>;

/** Generated Node Admin SDK operation action function for the 'SuperAdminApproveServicePrice' Mutation. Allow users to execute without passing in DataConnect. */
export function superAdminApproveServicePrice(dc: DataConnect, vars: SuperAdminApproveServicePriceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminApproveServicePriceData>>;
/** Generated Node Admin SDK operation action function for the 'SuperAdminApproveServicePrice' Mutation. Allow users to pass in custom DataConnect instances. */
export function superAdminApproveServicePrice(vars: SuperAdminApproveServicePriceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminApproveServicePriceData>>;

/** Generated Node Admin SDK operation action function for the 'DeleteService' Mutation. Allow users to execute without passing in DataConnect. */
export function deleteService(dc: DataConnect, vars: DeleteServiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteServiceData>>;
/** Generated Node Admin SDK operation action function for the 'DeleteService' Mutation. Allow users to pass in custom DataConnect instances. */
export function deleteService(vars: DeleteServiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteServiceData>>;

/** Generated Node Admin SDK operation action function for the 'ToggleServiceActive' Mutation. Allow users to execute without passing in DataConnect. */
export function toggleServiceActive(dc: DataConnect, vars: ToggleServiceActiveVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ToggleServiceActiveData>>;
/** Generated Node Admin SDK operation action function for the 'ToggleServiceActive' Mutation. Allow users to pass in custom DataConnect instances. */
export function toggleServiceActive(vars: ToggleServiceActiveVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ToggleServiceActiveData>>;

/** Generated Node Admin SDK operation action function for the 'CreateBusinessHour' Mutation. Allow users to execute without passing in DataConnect. */
export function createBusinessHour(dc: DataConnect, vars: CreateBusinessHourVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateBusinessHourData>>;
/** Generated Node Admin SDK operation action function for the 'CreateBusinessHour' Mutation. Allow users to pass in custom DataConnect instances. */
export function createBusinessHour(vars: CreateBusinessHourVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateBusinessHourData>>;

/** Generated Node Admin SDK operation action function for the 'AddVehicle' Mutation. Allow users to execute without passing in DataConnect. */
export function addVehicle(dc: DataConnect, vars: AddVehicleVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<AddVehicleData>>;
/** Generated Node Admin SDK operation action function for the 'AddVehicle' Mutation. Allow users to pass in custom DataConnect instances. */
export function addVehicle(vars: AddVehicleVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<AddVehicleData>>;

/** Generated Node Admin SDK operation action function for the 'DeleteVehicle' Mutation. Allow users to execute without passing in DataConnect. */
export function deleteVehicle(dc: DataConnect, vars: DeleteVehicleVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteVehicleData>>;
/** Generated Node Admin SDK operation action function for the 'DeleteVehicle' Mutation. Allow users to pass in custom DataConnect instances. */
export function deleteVehicle(vars: DeleteVehicleVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteVehicleData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateVehicle' Mutation. Allow users to execute without passing in DataConnect. */
export function updateVehicle(dc: DataConnect, vars: UpdateVehicleVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateVehicleData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateVehicle' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateVehicle(vars: UpdateVehicleVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateVehicleData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateEmployeeAvailability' Mutation. Allow users to execute without passing in DataConnect. */
export function updateEmployeeAvailability(dc: DataConnect, vars: UpdateEmployeeAvailabilityVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateEmployeeAvailabilityData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateEmployeeAvailability' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateEmployeeAvailability(vars: UpdateEmployeeAvailabilityVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateEmployeeAvailabilityData>>;

/** Generated Node Admin SDK operation action function for the 'DeleteBusinessHours' Mutation. Allow users to execute without passing in DataConnect. */
export function deleteBusinessHours(dc: DataConnect, vars: DeleteBusinessHoursVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteBusinessHoursData>>;
/** Generated Node Admin SDK operation action function for the 'DeleteBusinessHours' Mutation. Allow users to pass in custom DataConnect instances. */
export function deleteBusinessHours(vars: DeleteBusinessHoursVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteBusinessHoursData>>;

/** Generated Node Admin SDK operation action function for the 'SuperAdminUpdateBusinessStatus' Mutation. Allow users to execute without passing in DataConnect. */
export function superAdminUpdateBusinessStatus(dc: DataConnect, vars: SuperAdminUpdateBusinessStatusVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminUpdateBusinessStatusData>>;
/** Generated Node Admin SDK operation action function for the 'SuperAdminUpdateBusinessStatus' Mutation. Allow users to pass in custom DataConnect instances. */
export function superAdminUpdateBusinessStatus(vars: SuperAdminUpdateBusinessStatusVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminUpdateBusinessStatusData>>;

/** Generated Node Admin SDK operation action function for the 'SwitchCurrentBusiness' Mutation. Allow users to execute without passing in DataConnect. */
export function switchCurrentBusiness(dc: DataConnect, vars: SwitchCurrentBusinessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SwitchCurrentBusinessData>>;
/** Generated Node Admin SDK operation action function for the 'SwitchCurrentBusiness' Mutation. Allow users to pass in custom DataConnect instances. */
export function switchCurrentBusiness(vars: SwitchCurrentBusinessVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SwitchCurrentBusinessData>>;

/** Generated Node Admin SDK operation action function for the 'CreateWalkInUser' Mutation. Allow users to execute without passing in DataConnect. */
export function createWalkInUser(dc: DataConnect, vars: CreateWalkInUserVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateWalkInUserData>>;
/** Generated Node Admin SDK operation action function for the 'CreateWalkInUser' Mutation. Allow users to pass in custom DataConnect instances. */
export function createWalkInUser(vars: CreateWalkInUserVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateWalkInUserData>>;

/** Generated Node Admin SDK operation action function for the 'CreateWalkInOrder' Mutation. Allow users to execute without passing in DataConnect. */
export function createWalkInOrder(dc: DataConnect, vars: CreateWalkInOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateWalkInOrderData>>;
/** Generated Node Admin SDK operation action function for the 'CreateWalkInOrder' Mutation. Allow users to pass in custom DataConnect instances. */
export function createWalkInOrder(vars: CreateWalkInOrderVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateWalkInOrderData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateOrderCompletion' Mutation. Allow users to execute without passing in DataConnect. */
export function updateOrderCompletion(dc: DataConnect, vars: UpdateOrderCompletionVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateOrderCompletionData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateOrderCompletion' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateOrderCompletion(vars: UpdateOrderCompletionVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateOrderCompletionData>>;

/** Generated Node Admin SDK operation action function for the 'CreateInvoice' Mutation. Allow users to execute without passing in DataConnect. */
export function createInvoice(dc: DataConnect, vars: CreateInvoiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateInvoiceData>>;
/** Generated Node Admin SDK operation action function for the 'CreateInvoice' Mutation. Allow users to pass in custom DataConnect instances. */
export function createInvoice(vars: CreateInvoiceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateInvoiceData>>;

/** Generated Node Admin SDK operation action function for the 'CreateInvoiceItem' Mutation. Allow users to execute without passing in DataConnect. */
export function createInvoiceItem(dc: DataConnect, vars: CreateInvoiceItemVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateInvoiceItemData>>;
/** Generated Node Admin SDK operation action function for the 'CreateInvoiceItem' Mutation. Allow users to pass in custom DataConnect instances. */
export function createInvoiceItem(vars: CreateInvoiceItemVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateInvoiceItemData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateInvoicePdf' Mutation. Allow users to execute without passing in DataConnect. */
export function updateInvoicePdf(dc: DataConnect, vars: UpdateInvoicePdfVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateInvoicePdfData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateInvoicePdf' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateInvoicePdf(vars: UpdateInvoicePdfVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateInvoicePdfData>>;

/** Generated Node Admin SDK operation action function for the 'CreateReview' Mutation. Allow users to execute without passing in DataConnect. */
export function createReview(dc: DataConnect, vars: CreateReviewVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateReviewData>>;
/** Generated Node Admin SDK operation action function for the 'CreateReview' Mutation. Allow users to pass in custom DataConnect instances. */
export function createReview(vars: CreateReviewVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateReviewData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateBusinessPrepaidBalance' Mutation. Allow users to execute without passing in DataConnect. */
export function updateBusinessPrepaidBalance(dc: DataConnect, vars: UpdateBusinessPrepaidBalanceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateBusinessPrepaidBalanceData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateBusinessPrepaidBalance' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateBusinessPrepaidBalance(vars: UpdateBusinessPrepaidBalanceVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateBusinessPrepaidBalanceData>>;

/** Generated Node Admin SDK operation action function for the 'SuperAdminUpdateBusinessPrepaid' Mutation. Allow users to execute without passing in DataConnect. */
export function superAdminUpdateBusinessPrepaid(dc: DataConnect, vars: SuperAdminUpdateBusinessPrepaidVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminUpdateBusinessPrepaidData>>;
/** Generated Node Admin SDK operation action function for the 'SuperAdminUpdateBusinessPrepaid' Mutation. Allow users to pass in custom DataConnect instances. */
export function superAdminUpdateBusinessPrepaid(vars: SuperAdminUpdateBusinessPrepaidVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminUpdateBusinessPrepaidData>>;

/** Generated Node Admin SDK operation action function for the 'CreateNotification' Mutation. Allow users to execute without passing in DataConnect. */
export function createNotification(dc: DataConnect, vars: CreateNotificationVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateNotificationData>>;
/** Generated Node Admin SDK operation action function for the 'CreateNotification' Mutation. Allow users to pass in custom DataConnect instances. */
export function createNotification(vars: CreateNotificationVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateNotificationData>>;

/** Generated Node Admin SDK operation action function for the 'MarkNotificationAsRead' Mutation. Allow users to execute without passing in DataConnect. */
export function markNotificationAsRead(dc: DataConnect, vars: MarkNotificationAsReadVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<MarkNotificationAsReadData>>;
/** Generated Node Admin SDK operation action function for the 'MarkNotificationAsRead' Mutation. Allow users to pass in custom DataConnect instances. */
export function markNotificationAsRead(vars: MarkNotificationAsReadVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<MarkNotificationAsReadData>>;

/** Generated Node Admin SDK operation action function for the 'CreatePrepaidHistory' Mutation. Allow users to execute without passing in DataConnect. */
export function createPrepaidHistory(dc: DataConnect, vars: CreatePrepaidHistoryVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreatePrepaidHistoryData>>;
/** Generated Node Admin SDK operation action function for the 'CreatePrepaidHistory' Mutation. Allow users to pass in custom DataConnect instances. */
export function createPrepaidHistory(vars: CreatePrepaidHistoryVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreatePrepaidHistoryData>>;

/** Generated Node Admin SDK operation action function for the 'CreatePrepaidServiceMetric' Mutation. Allow users to execute without passing in DataConnect. */
export function createPrepaidServiceMetric(dc: DataConnect, vars: CreatePrepaidServiceMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreatePrepaidServiceMetricData>>;
/** Generated Node Admin SDK operation action function for the 'CreatePrepaidServiceMetric' Mutation. Allow users to pass in custom DataConnect instances. */
export function createPrepaidServiceMetric(vars: CreatePrepaidServiceMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreatePrepaidServiceMetricData>>;

/** Generated Node Admin SDK operation action function for the 'UpdatePrepaidServiceMetric' Mutation. Allow users to execute without passing in DataConnect. */
export function updatePrepaidServiceMetric(dc: DataConnect, vars: UpdatePrepaidServiceMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdatePrepaidServiceMetricData>>;
/** Generated Node Admin SDK operation action function for the 'UpdatePrepaidServiceMetric' Mutation. Allow users to pass in custom DataConnect instances. */
export function updatePrepaidServiceMetric(vars: UpdatePrepaidServiceMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdatePrepaidServiceMetricData>>;

/** Generated Node Admin SDK operation action function for the 'CreateBusinessReservationConfig' Mutation. Allow users to execute without passing in DataConnect. */
export function createBusinessReservationConfig(dc: DataConnect, vars: CreateBusinessReservationConfigVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateBusinessReservationConfigData>>;
/** Generated Node Admin SDK operation action function for the 'CreateBusinessReservationConfig' Mutation. Allow users to pass in custom DataConnect instances. */
export function createBusinessReservationConfig(vars: CreateBusinessReservationConfigVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateBusinessReservationConfigData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateBusinessReservationConfig' Mutation. Allow users to execute without passing in DataConnect. */
export function updateBusinessReservationConfig(dc: DataConnect, vars: UpdateBusinessReservationConfigVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateBusinessReservationConfigData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateBusinessReservationConfig' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateBusinessReservationConfig(vars: UpdateBusinessReservationConfigVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateBusinessReservationConfigData>>;

/** Generated Node Admin SDK operation action function for the 'CreateOrderReservation' Mutation. Allow users to execute without passing in DataConnect. */
export function createOrderReservation(dc: DataConnect, vars: CreateOrderReservationVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateOrderReservationData>>;
/** Generated Node Admin SDK operation action function for the 'CreateOrderReservation' Mutation. Allow users to pass in custom DataConnect instances. */
export function createOrderReservation(vars: CreateOrderReservationVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreateOrderReservationData>>;

/** Generated Node Admin SDK operation action function for the 'DeleteOrderReservation' Mutation. Allow users to execute without passing in DataConnect. */
export function deleteOrderReservation(dc: DataConnect, vars: DeleteOrderReservationVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteOrderReservationData>>;
/** Generated Node Admin SDK operation action function for the 'DeleteOrderReservation' Mutation. Allow users to pass in custom DataConnect instances. */
export function deleteOrderReservation(vars: DeleteOrderReservationVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteOrderReservationData>>;

/** Generated Node Admin SDK operation action function for the 'UpsertVehicleBrand' Mutation. Allow users to execute without passing in DataConnect. */
export function upsertVehicleBrand(dc: DataConnect, vars: UpsertVehicleBrandVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpsertVehicleBrandData>>;
/** Generated Node Admin SDK operation action function for the 'UpsertVehicleBrand' Mutation. Allow users to pass in custom DataConnect instances. */
export function upsertVehicleBrand(vars: UpsertVehicleBrandVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpsertVehicleBrandData>>;

/** Generated Node Admin SDK operation action function for the 'UpsertVehicleModel' Mutation. Allow users to execute without passing in DataConnect. */
export function upsertVehicleModel(dc: DataConnect, vars: UpsertVehicleModelVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpsertVehicleModelData>>;
/** Generated Node Admin SDK operation action function for the 'UpsertVehicleModel' Mutation. Allow users to pass in custom DataConnect instances. */
export function upsertVehicleModel(vars: UpsertVehicleModelVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpsertVehicleModelData>>;

/** Generated Node Admin SDK operation action function for the 'UpdateUserPhone' Mutation. Allow users to execute without passing in DataConnect. */
export function updateUserPhone(dc: DataConnect, vars: UpdateUserPhoneVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateUserPhoneData>>;
/** Generated Node Admin SDK operation action function for the 'UpdateUserPhone' Mutation. Allow users to pass in custom DataConnect instances. */
export function updateUserPhone(vars: UpdateUserPhoneVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<UpdateUserPhoneData>>;

/** Generated Node Admin SDK operation action function for the 'DeleteCurrentUser' Mutation. Allow users to execute without passing in DataConnect. */
export function deleteCurrentUser(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteCurrentUserData>>;
/** Generated Node Admin SDK operation action function for the 'DeleteCurrentUser' Mutation. Allow users to pass in custom DataConnect instances. */
export function deleteCurrentUser(options?: OperationOptions): Promise<ExecuteOperationResponse<DeleteCurrentUserData>>;

/** Generated Node Admin SDK operation action function for the 'CompleteOrderWithInvoiceOnly' Mutation. Allow users to execute without passing in DataConnect. */
export function completeOrderWithInvoiceOnly(dc: DataConnect, vars: CompleteOrderWithInvoiceOnlyVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CompleteOrderWithInvoiceOnlyData>>;
/** Generated Node Admin SDK operation action function for the 'CompleteOrderWithInvoiceOnly' Mutation. Allow users to pass in custom DataConnect instances. */
export function completeOrderWithInvoiceOnly(vars: CompleteOrderWithInvoiceOnlyVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CompleteOrderWithInvoiceOnlyData>>;

/** Generated Node Admin SDK operation action function for the 'CompleteOrderWithPrepaidAndUpdateMetric' Mutation. Allow users to execute without passing in DataConnect. */
export function completeOrderWithPrepaidAndUpdateMetric(dc: DataConnect, vars: CompleteOrderWithPrepaidAndUpdateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CompleteOrderWithPrepaidAndUpdateMetricData>>;
/** Generated Node Admin SDK operation action function for the 'CompleteOrderWithPrepaidAndUpdateMetric' Mutation. Allow users to pass in custom DataConnect instances. */
export function completeOrderWithPrepaidAndUpdateMetric(vars: CompleteOrderWithPrepaidAndUpdateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CompleteOrderWithPrepaidAndUpdateMetricData>>;

/** Generated Node Admin SDK operation action function for the 'CompleteOrderWithPrepaidAndCreateMetric' Mutation. Allow users to execute without passing in DataConnect. */
export function completeOrderWithPrepaidAndCreateMetric(dc: DataConnect, vars: CompleteOrderWithPrepaidAndCreateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CompleteOrderWithPrepaidAndCreateMetricData>>;
/** Generated Node Admin SDK operation action function for the 'CompleteOrderWithPrepaidAndCreateMetric' Mutation. Allow users to pass in custom DataConnect instances. */
export function completeOrderWithPrepaidAndCreateMetric(vars: CompleteOrderWithPrepaidAndCreateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CompleteOrderWithPrepaidAndCreateMetricData>>;

/** Generated Node Admin SDK operation action function for the 'ConsumePrepaidAndUpdateMetric' Mutation. Allow users to execute without passing in DataConnect. */
export function consumePrepaidAndUpdateMetric(dc: DataConnect, vars: ConsumePrepaidAndUpdateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ConsumePrepaidAndUpdateMetricData>>;
/** Generated Node Admin SDK operation action function for the 'ConsumePrepaidAndUpdateMetric' Mutation. Allow users to pass in custom DataConnect instances. */
export function consumePrepaidAndUpdateMetric(vars: ConsumePrepaidAndUpdateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ConsumePrepaidAndUpdateMetricData>>;

/** Generated Node Admin SDK operation action function for the 'ConsumePrepaidAndCreateMetric' Mutation. Allow users to execute without passing in DataConnect. */
export function consumePrepaidAndCreateMetric(dc: DataConnect, vars: ConsumePrepaidAndCreateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ConsumePrepaidAndCreateMetricData>>;
/** Generated Node Admin SDK operation action function for the 'ConsumePrepaidAndCreateMetric' Mutation. Allow users to pass in custom DataConnect instances. */
export function consumePrepaidAndCreateMetric(vars: ConsumePrepaidAndCreateMetricVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<ConsumePrepaidAndCreateMetricData>>;

/** Generated Node Admin SDK operation action function for the 'GetUsers' Query. Allow users to execute without passing in DataConnect. */
export function getUsers(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetUsersData>>;
/** Generated Node Admin SDK operation action function for the 'GetUsers' Query. Allow users to pass in custom DataConnect instances. */
export function getUsers(options?: OperationOptions): Promise<ExecuteOperationResponse<GetUsersData>>;

/** Generated Node Admin SDK operation action function for the 'GetCurrentUser' Query. Allow users to execute without passing in DataConnect. */
export function getCurrentUser(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetCurrentUserData>>;
/** Generated Node Admin SDK operation action function for the 'GetCurrentUser' Query. Allow users to pass in custom DataConnect instances. */
export function getCurrentUser(options?: OperationOptions): Promise<ExecuteOperationResponse<GetCurrentUserData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessByCode' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessByCode(dc: DataConnect, vars: GetBusinessByCodeVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessByCodeData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessByCode' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessByCode(vars: GetBusinessByCodeVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessByCodeData>>;

/** Generated Node Admin SDK operation action function for the 'GetPendingEmployeeRequests' Query. Allow users to execute without passing in DataConnect. */
export function getPendingEmployeeRequests(dc: DataConnect, vars: GetPendingEmployeeRequestsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPendingEmployeeRequestsData>>;
/** Generated Node Admin SDK operation action function for the 'GetPendingEmployeeRequests' Query. Allow users to pass in custom DataConnect instances. */
export function getPendingEmployeeRequests(vars: GetPendingEmployeeRequestsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPendingEmployeeRequestsData>>;

/** Generated Node Admin SDK operation action function for the 'GetAllBusinesses' Query. Allow users to execute without passing in DataConnect. */
export function getAllBusinesses(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetAllBusinessesData>>;
/** Generated Node Admin SDK operation action function for the 'GetAllBusinesses' Query. Allow users to pass in custom DataConnect instances. */
export function getAllBusinesses(options?: OperationOptions): Promise<ExecuteOperationResponse<GetAllBusinessesData>>;

/** Generated Node Admin SDK operation action function for the 'GetClientOrders' Query. Allow users to execute without passing in DataConnect. */
export function getClientOrders(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetClientOrdersData>>;
/** Generated Node Admin SDK operation action function for the 'GetClientOrders' Query. Allow users to pass in custom DataConnect instances. */
export function getClientOrders(options?: OperationOptions): Promise<ExecuteOperationResponse<GetClientOrdersData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessOrders' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessOrders(dc: DataConnect, vars: GetBusinessOrdersVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessOrdersData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessOrders' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessOrders(vars: GetBusinessOrdersVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessOrdersData>>;

/** Generated Node Admin SDK operation action function for the 'GetActiveEmployees' Query. Allow users to execute without passing in DataConnect. */
export function getActiveEmployees(dc: DataConnect, vars: GetActiveEmployeesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetActiveEmployeesData>>;
/** Generated Node Admin SDK operation action function for the 'GetActiveEmployees' Query. Allow users to pass in custom DataConnect instances. */
export function getActiveEmployees(vars: GetActiveEmployeesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetActiveEmployeesData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessServices' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessServices(dc: DataConnect, vars: GetBusinessServicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessServicesData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessServices' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessServices(vars: GetBusinessServicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessServicesData>>;

/** Generated Node Admin SDK operation action function for the 'GetMyVehicles' Query. Allow users to execute without passing in DataConnect. */
export function getMyVehicles(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetMyVehiclesData>>;
/** Generated Node Admin SDK operation action function for the 'GetMyVehicles' Query. Allow users to pass in custom DataConnect instances. */
export function getMyVehicles(options?: OperationOptions): Promise<ExecuteOperationResponse<GetMyVehiclesData>>;

/** Generated Node Admin SDK operation action function for the 'GetVehicleBrands' Query. Allow users to execute without passing in DataConnect. */
export function getVehicleBrands(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetVehicleBrandsData>>;
/** Generated Node Admin SDK operation action function for the 'GetVehicleBrands' Query. Allow users to pass in custom DataConnect instances. */
export function getVehicleBrands(options?: OperationOptions): Promise<ExecuteOperationResponse<GetVehicleBrandsData>>;

/** Generated Node Admin SDK operation action function for the 'GetVehicleModelsByBrand' Query. Allow users to execute without passing in DataConnect. */
export function getVehicleModelsByBrand(dc: DataConnect, vars: GetVehicleModelsByBrandVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetVehicleModelsByBrandData>>;
/** Generated Node Admin SDK operation action function for the 'GetVehicleModelsByBrand' Query. Allow users to pass in custom DataConnect instances. */
export function getVehicleModelsByBrand(vars: GetVehicleModelsByBrandVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetVehicleModelsByBrandData>>;

/** Generated Node Admin SDK operation action function for the 'GetActiveBusinessOrders' Query. Allow users to execute without passing in DataConnect. */
export function getActiveBusinessOrders(dc: DataConnect, vars: GetActiveBusinessOrdersVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetActiveBusinessOrdersData>>;
/** Generated Node Admin SDK operation action function for the 'GetActiveBusinessOrders' Query. Allow users to pass in custom DataConnect instances. */
export function getActiveBusinessOrders(vars: GetActiveBusinessOrdersVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetActiveBusinessOrdersData>>;

/** Generated Node Admin SDK operation action function for the 'GetEmployeeAvailability' Query. Allow users to execute without passing in DataConnect. */
export function getEmployeeAvailability(dc: DataConnect, vars: GetEmployeeAvailabilityVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetEmployeeAvailabilityData>>;
/** Generated Node Admin SDK operation action function for the 'GetEmployeeAvailability' Query. Allow users to pass in custom DataConnect instances. */
export function getEmployeeAvailability(vars: GetEmployeeAvailabilityVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetEmployeeAvailabilityData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessHours' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessHours(dc: DataConnect, vars: GetBusinessHoursVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessHoursData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessHours' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessHours(vars: GetBusinessHoursVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessHoursData>>;

/** Generated Node Admin SDK operation action function for the 'SuperAdminGetBusinesses' Query. Allow users to execute without passing in DataConnect. */
export function superAdminGetBusinesses(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminGetBusinessesData>>;
/** Generated Node Admin SDK operation action function for the 'SuperAdminGetBusinesses' Query. Allow users to pass in custom DataConnect instances. */
export function superAdminGetBusinesses(options?: OperationOptions): Promise<ExecuteOperationResponse<SuperAdminGetBusinessesData>>;

/** Generated Node Admin SDK operation action function for the 'GetMyBusinesses' Query. Allow users to execute without passing in DataConnect. */
export function getMyBusinesses(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetMyBusinessesData>>;
/** Generated Node Admin SDK operation action function for the 'GetMyBusinesses' Query. Allow users to pass in custom DataConnect instances. */
export function getMyBusinesses(options?: OperationOptions): Promise<ExecuteOperationResponse<GetMyBusinessesData>>;

/** Generated Node Admin SDK operation action function for the 'GetEmployeeHistoryOrdersPaged' Query. Allow users to execute without passing in DataConnect. */
export function getEmployeeHistoryOrdersPaged(dc: DataConnect, vars: GetEmployeeHistoryOrdersPagedVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetEmployeeHistoryOrdersPagedData>>;
/** Generated Node Admin SDK operation action function for the 'GetEmployeeHistoryOrdersPaged' Query. Allow users to pass in custom DataConnect instances. */
export function getEmployeeHistoryOrdersPaged(vars: GetEmployeeHistoryOrdersPagedVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetEmployeeHistoryOrdersPagedData>>;

/** Generated Node Admin SDK operation action function for the 'GetClientHistoryOrdersPaged' Query. Allow users to execute without passing in DataConnect. */
export function getClientHistoryOrdersPaged(dc: DataConnect, vars: GetClientHistoryOrdersPagedVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetClientHistoryOrdersPagedData>>;
/** Generated Node Admin SDK operation action function for the 'GetClientHistoryOrdersPaged' Query. Allow users to pass in custom DataConnect instances. */
export function getClientHistoryOrdersPaged(vars: GetClientHistoryOrdersPagedVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetClientHistoryOrdersPagedData>>;

/** Generated Node Admin SDK operation action function for the 'FindUserByPhone' Query. Allow users to execute without passing in DataConnect. */
export function findUserByPhone(dc: DataConnect, vars: FindUserByPhoneVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<FindUserByPhoneData>>;
/** Generated Node Admin SDK operation action function for the 'FindUserByPhone' Query. Allow users to pass in custom DataConnect instances. */
export function findUserByPhone(vars: FindUserByPhoneVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<FindUserByPhoneData>>;

/** Generated Node Admin SDK operation action function for the 'GetClientInvoices' Query. Allow users to execute without passing in DataConnect. */
export function getClientInvoices(dc: DataConnect, vars?: GetClientInvoicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetClientInvoicesData>>;
/** Generated Node Admin SDK operation action function for the 'GetClientInvoices' Query. Allow users to pass in custom DataConnect instances. */
export function getClientInvoices(vars?: GetClientInvoicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetClientInvoicesData>>;

/** Generated Node Admin SDK operation action function for the 'GetEmployeeInvoices' Query. Allow users to execute without passing in DataConnect. */
export function getEmployeeInvoices(dc: DataConnect, vars?: GetEmployeeInvoicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetEmployeeInvoicesData>>;
/** Generated Node Admin SDK operation action function for the 'GetEmployeeInvoices' Query. Allow users to pass in custom DataConnect instances. */
export function getEmployeeInvoices(vars?: GetEmployeeInvoicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetEmployeeInvoicesData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessInvoices' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessInvoices(dc: DataConnect, vars: GetBusinessInvoicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessInvoicesData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessInvoices' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessInvoices(vars: GetBusinessInvoicesVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessInvoicesData>>;

/** Generated Node Admin SDK operation action function for the 'GetInvoiceById' Query. Allow users to execute without passing in DataConnect. */
export function getInvoiceById(dc: DataConnect, vars: GetInvoiceByIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoiceByIdData>>;
/** Generated Node Admin SDK operation action function for the 'GetInvoiceById' Query. Allow users to pass in custom DataConnect instances. */
export function getInvoiceById(vars: GetInvoiceByIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoiceByIdData>>;

/** Generated Node Admin SDK operation action function for the 'GetInvoicesByDateRange' Query. Allow users to execute without passing in DataConnect. */
export function getInvoicesByDateRange(dc: DataConnect, vars: GetInvoicesByDateRangeVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoicesByDateRangeData>>;
/** Generated Node Admin SDK operation action function for the 'GetInvoicesByDateRange' Query. Allow users to pass in custom DataConnect instances. */
export function getInvoicesByDateRange(vars: GetInvoicesByDateRangeVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoicesByDateRangeData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessDetails' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessDetails(dc: DataConnect, vars: GetBusinessDetailsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessDetailsData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessDetails' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessDetails(vars: GetBusinessDetailsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessDetailsData>>;

/** Generated Node Admin SDK operation action function for the 'GetUserNotifications' Query. Allow users to execute without passing in DataConnect. */
export function getUserNotifications(dc: DataConnect, vars: GetUserNotificationsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetUserNotificationsData>>;
/** Generated Node Admin SDK operation action function for the 'GetUserNotifications' Query. Allow users to pass in custom DataConnect instances. */
export function getUserNotifications(vars: GetUserNotificationsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetUserNotificationsData>>;

/** Generated Node Admin SDK operation action function for the 'GetPrepaidHistory' Query. Allow users to execute without passing in DataConnect. */
export function getPrepaidHistory(dc: DataConnect, vars: GetPrepaidHistoryVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidHistoryData>>;
/** Generated Node Admin SDK operation action function for the 'GetPrepaidHistory' Query. Allow users to pass in custom DataConnect instances. */
export function getPrepaidHistory(vars: GetPrepaidHistoryVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidHistoryData>>;

/** Generated Node Admin SDK operation action function for the 'GetPrepaidServiceMetrics' Query. Allow users to execute without passing in DataConnect. */
export function getPrepaidServiceMetrics(dc: DataConnect, vars: GetPrepaidServiceMetricsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidServiceMetricsData>>;
/** Generated Node Admin SDK operation action function for the 'GetPrepaidServiceMetrics' Query. Allow users to pass in custom DataConnect instances. */
export function getPrepaidServiceMetrics(vars: GetPrepaidServiceMetricsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidServiceMetricsData>>;

/** Generated Node Admin SDK operation action function for the 'GetPrepaidServiceMetricByServiceName' Query. Allow users to execute without passing in DataConnect. */
export function getPrepaidServiceMetricByServiceName(dc: DataConnect, vars: GetPrepaidServiceMetricByServiceNameVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidServiceMetricByServiceNameData>>;
/** Generated Node Admin SDK operation action function for the 'GetPrepaidServiceMetricByServiceName' Query. Allow users to pass in custom DataConnect instances. */
export function getPrepaidServiceMetricByServiceName(vars: GetPrepaidServiceMetricByServiceNameVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidServiceMetricByServiceNameData>>;

/** Generated Node Admin SDK operation action function for the 'GetOrderById' Query. Allow users to execute without passing in DataConnect. */
export function getOrderById(dc: DataConnect, vars: GetOrderByIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetOrderByIdData>>;
/** Generated Node Admin SDK operation action function for the 'GetOrderById' Query. Allow users to pass in custom DataConnect instances. */
export function getOrderById(vars: GetOrderByIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetOrderByIdData>>;

/** Generated Node Admin SDK operation action function for the 'GetPrepaidHistoryByOrderId' Query. Allow users to execute without passing in DataConnect. */
export function getPrepaidHistoryByOrderId(dc: DataConnect, vars: GetPrepaidHistoryByOrderIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidHistoryByOrderIdData>>;
/** Generated Node Admin SDK operation action function for the 'GetPrepaidHistoryByOrderId' Query. Allow users to pass in custom DataConnect instances. */
export function getPrepaidHistoryByOrderId(vars: GetPrepaidHistoryByOrderIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPrepaidHistoryByOrderIdData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessReservationConfig' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessReservationConfig(dc: DataConnect, vars: GetBusinessReservationConfigVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessReservationConfigData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessReservationConfig' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessReservationConfig(vars: GetBusinessReservationConfigVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessReservationConfigData>>;

/** Generated Node Admin SDK operation action function for the 'GetActiveReservations' Query. Allow users to execute without passing in DataConnect. */
export function getActiveReservations(dc: DataConnect, vars: GetActiveReservationsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetActiveReservationsData>>;
/** Generated Node Admin SDK operation action function for the 'GetActiveReservations' Query. Allow users to pass in custom DataConnect instances. */
export function getActiveReservations(vars: GetActiveReservationsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetActiveReservationsData>>;

/** Generated Node Admin SDK operation action function for the 'GetReservationByOrderId' Query. Allow users to execute without passing in DataConnect. */
export function getReservationByOrderId(dc: DataConnect, vars: GetReservationByOrderIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetReservationByOrderIdData>>;
/** Generated Node Admin SDK operation action function for the 'GetReservationByOrderId' Query. Allow users to pass in custom DataConnect instances. */
export function getReservationByOrderId(vars: GetReservationByOrderIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetReservationByOrderIdData>>;

/** Generated Node Admin SDK operation action function for the 'GetBusinessReviews' Query. Allow users to execute without passing in DataConnect. */
export function getBusinessReviews(dc: DataConnect, vars: GetBusinessReviewsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessReviewsData>>;
/** Generated Node Admin SDK operation action function for the 'GetBusinessReviews' Query. Allow users to pass in custom DataConnect instances. */
export function getBusinessReviews(vars: GetBusinessReviewsVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetBusinessReviewsData>>;

/** Generated Node Admin SDK operation action function for the 'GetOrderReview' Query. Allow users to execute without passing in DataConnect. */
export function getOrderReview(dc: DataConnect, vars: GetOrderReviewVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetOrderReviewData>>;
/** Generated Node Admin SDK operation action function for the 'GetOrderReview' Query. Allow users to pass in custom DataConnect instances. */
export function getOrderReview(vars: GetOrderReviewVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetOrderReviewData>>;

/** Generated Node Admin SDK operation action function for the 'GetGlobalAppRatings' Query. Allow users to execute without passing in DataConnect. */
export function getGlobalAppRatings(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetGlobalAppRatingsData>>;
/** Generated Node Admin SDK operation action function for the 'GetGlobalAppRatings' Query. Allow users to pass in custom DataConnect instances. */
export function getGlobalAppRatings(options?: OperationOptions): Promise<ExecuteOperationResponse<GetGlobalAppRatingsData>>;

/** Generated Node Admin SDK operation action function for the 'GetOrderDetailsForPayment' Query. Allow users to execute without passing in DataConnect. */
export function getOrderDetailsForPayment(dc: DataConnect, vars: GetOrderDetailsForPaymentVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetOrderDetailsForPaymentData>>;
/** Generated Node Admin SDK operation action function for the 'GetOrderDetailsForPayment' Query. Allow users to pass in custom DataConnect instances. */
export function getOrderDetailsForPayment(vars: GetOrderDetailsForPaymentVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetOrderDetailsForPaymentData>>;

/** Generated Node Admin SDK operation action function for the 'GetInvoiceByOrderId' Query. Allow users to execute without passing in DataConnect. */
export function getInvoiceByOrderId(dc: DataConnect, vars: GetInvoiceByOrderIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoiceByOrderIdData>>;
/** Generated Node Admin SDK operation action function for the 'GetInvoiceByOrderId' Query. Allow users to pass in custom DataConnect instances. */
export function getInvoiceByOrderId(vars: GetInvoiceByOrderIdVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoiceByOrderIdData>>;

/** Generated Node Admin SDK operation action function for the 'GetInvoiceDetailsForUrl' Query. Allow users to execute without passing in DataConnect. */
export function getInvoiceDetailsForUrl(dc: DataConnect, vars: GetInvoiceDetailsForUrlVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoiceDetailsForUrlData>>;
/** Generated Node Admin SDK operation action function for the 'GetInvoiceDetailsForUrl' Query. Allow users to pass in custom DataConnect instances. */
export function getInvoiceDetailsForUrl(vars: GetInvoiceDetailsForUrlVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetInvoiceDetailsForUrlData>>;

/** Generated Node Admin SDK operation action function for the 'CheckBusinessEmployeeAdmin' Query. Allow users to execute without passing in DataConnect. */
export function checkBusinessEmployeeAdmin(dc: DataConnect, vars: CheckBusinessEmployeeAdminVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CheckBusinessEmployeeAdminData>>;
/** Generated Node Admin SDK operation action function for the 'CheckBusinessEmployeeAdmin' Query. Allow users to pass in custom DataConnect instances. */
export function checkBusinessEmployeeAdmin(vars: CheckBusinessEmployeeAdminVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CheckBusinessEmployeeAdminData>>;

