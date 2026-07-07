# Configuración de Infraestructura: Monitoreo y Respaldos (WashGo)

Este directorio contiene las definiciones de Infraestructura como Código (IaC) en Terraform para implementar de forma automática y reproducible los puntos **6. MONITOREO Y ALERTAS** y **7. RESPALDOS DE BASE DE DATOS** de la auditoría de preparación para producción (*Production Readiness*).

---

## Contenido

1. **Monitoreo y Alertas (Sección 6)**: 
   - Creación de un presupuesto mensual en dólares estadounidense (USD) asignado al proyecto.
   - Envío de alertas de costos automáticas por correo electrónico a los administradores del proyecto al alcanzar los siguientes umbrales:
     - **50%** del presupuesto estimado.
     - **80%** del presupuesto estimado (alerta de atención preventiva).
     - **100%** del presupuesto estimado (alerta crítica de límite alcanzado).
     - **120%** del presupuesto estimado (alerta de sobrecosto).

2. **Respaldos de Base de Datos (Sección 7)**:
   - Configuración de respaldos automáticos diarios para la base de datos PostgreSQL gestionada en Google Cloud SQL.
   - Ejecución programada a las **03:00 UTC** (período de menor tráfico y actividad en Ecuador/América del Sur).
   - Activación de **Point-in-Time Recovery (PITR)** para permitir restaurar la base de datos a un segundo exacto en caso de fallos lógicos graves.
   - Política de retención de respaldos fijada en **30 copias de seguridad** y retención de logs de transacciones de **7 días**.
   - Activación de protección de eliminación (`deletion_protection = true`) en la instancia SQL para evitar pérdidas accidentales.

---

## Instrucciones de Despliegue con Terraform

### Requisitos Previos
1. Instalar [Terraform](https://developer.hashicorp.com/terraform/downloads).
2. Tener instalado y autenticado el [Google Cloud CLI](https://cloud.google.com/sdk/gcloud).
3. Asegurarse de contar con los permisos de Administrador de Facturación (`Billing Account Administrator`) y Administrador del Proyecto Cloud SQL.

### Pasos
1. Inicializar el directorio de Terraform:
   ```bash
   terraform init
   ```
2. Validar que la sintaxis y los recursos planificados sean correctos:
   ```bash
   terraform plan -var="project_id=TU_PROJECT_ID" -var="billing_account_id=TU_BILLING_ACCOUNT_ID"
   ```
3. Aplicar los cambios en la consola de Google Cloud:
   ```bash
   terraform apply -var="project_id=TU_PROJECT_ID" -var="billing_account_id=TU_BILLING_ACCOUNT_ID"
   ```

---

## Alternativa Manual (Desde Google Cloud Console)

Si prefieres realizar la configuración de manera interactiva a través del navegador web, sigue las siguientes guías de configuración paso a paso:

### 1. Monitoreo y Alertas de Presupuesto (Sección 6)
1. Ve a la consola de [Google Cloud Billing](https://console.cloud.google.com/billing).
2. Selecciona tu **Billing Account** activa.
3. En el menú lateral izquierdo, haz clic en **Presupuestos y alertas** (*Budgets & alerts*).
4. Haz clic en **Crear presupuesto** (*Create budget*).
5. Define un nombre descriptivo (ej. `washgo-presupuesto-produccion`).
6. Configura el alcance (*Scope*) seleccionando el proyecto de WashGo.
7. Establece el **Monto del presupuesto** (ej. `$100.00 USD` mensuales).
8. En la sección de **Reglas de activación**, define los porcentajes de consumo:
   - **50%**, **80%**, **100%** de los costos reales o proyectados.
9. En la sección **Acciones**, asegúrate de marcar la casilla para enviar notificaciones por correo electrónico a los administradores y usuarios de facturación.
10. Guarda la configuración.

### 2. Respaldos y PITR en Cloud SQL PostgreSQL (Sección 7)
1. Dirígete a la sección de [Cloud SQL Instances](https://console.cloud.google.com/sql/instances) en la consola de GCP.
2. Selecciona la instancia de PostgreSQL creada para Firebase Data Connect.
3. En la pestaña de navegación izquierda, selecciona **Configuración** (*Configuration*).
4. Haz clic en **Editar configuración** (*Edit configuration*).
5. Despliega la sección **Copias de seguridad** (*Backups*).
6. Activa las siguientes opciones:
   - **Copias de seguridad automáticas diarias** (*Automated backups*).
   - Define una hora de inicio conveniente (ej. `03:00` AM).
   - Marca la casilla **Habilitar recuperación en un momento dado (PITR)** (*Enable point-in-time recovery*). Esto registrará los logs de transacciones necesarias (`write-ahead logs` o WAL) para restauración a nivel de segundo.
7. En la política de retención de respaldos, selecciona conservar al menos **30** respaldos.
8. En la parte inferior, haz clic en **Guardar** para aplicar las políticas de respaldo.
