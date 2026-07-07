# WashGo

WashGo es una aplicación móvil y web desarrollada con **Flutter** para la gestión y reserva de servicios de lavandería a domicilio. Utiliza **Firebase** como backend local (Auth, Storage, Functions, Hosting y Data Connect con PostgreSQL/PGLite).

Este documento te guiará para configurar y ejecutar el proyecto desde cero en cualquier computadora.

---

## 🛠 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente en tu máquina:

1. **Flutter SDK**: [Guía de instalación](https://docs.flutter.dev/get-started/install).
2. **Node.js** (versión LTS recomendada): [Descargar Node.js](https://nodejs.org/).
3. **Java Development Kit (JDK)**: Requerido para poder ejecutar los emuladores de Firebase.
4. **Firebase CLI**: Instálalo ejecutando en tu terminal:
   ```bash
   npm install -g firebase-tools
   ```
5. **Git**: [Descargar Git](https://git-scm.com/).

---

## 🚀 Guía de Configuración Rápida

Sigue estos pasos para clonar y ejecutar el proyecto localmente:

### Paso 1: Clonar el Repositorio
Abre tu terminal y clona este proyecto:
```bash
git clone https://github.com/JosueSantosG/WashGo.git
cd WashGo
```

### Paso 2: Configurar las Variables de Entorno `.env`
El archivo `.env` original contiene credenciales sensibles y está excluido de Git. Debes crearlo manualmente:

1. **En la raíz del proyecto (para Flutter):**
   * Copia el archivo de ejemplo:
     ```bash
     cp .env.example .env
     ```
   * Abre el archivo `.env` recién creado y completa las credenciales de tu cuenta de PayPal Developer (Client ID y Client Secret).

2. **En la carpeta de Cloud Functions:**
   * Dirígete a la carpeta `functions/`.
   * Copia el archivo de ejemplo:
     ```bash
     cp functions/.env.local.example functions/.env.local
     ```
   * Configura las mismas credenciales de PayPal correspondientes al entorno.

---

### Paso 3: Instalar Dependencias

1. **Dependencias de Flutter:**
   En la raíz del proyecto, ejecuta:
   ```bash
   flutter pub get
   ```

2. **Dependencias de Cloud Functions:**
   Dirígete a la carpeta `functions/` e instala las librerías de Node.js:
   ```bash
   cd functions
   npm install
   cd ..
   ```

---

### Paso 4: Iniciar los Emuladores de Firebase
Los emuladores locales levantan la base de datos (Data Connect con PostgreSQL local), la autenticación de usuarios, el almacenamiento de imágenes y las Cloud Functions.

En la raíz del proyecto, ejecuta:
```bash
npx firebase-tools emulators:start --project washgo-app-8392
```

* **Nota sobre datos de prueba:** Si tienes datos guardados localmente y quieres exportarlos al salir para que no se pierdan, puedes usar:
  ```bash
  npx firebase-tools emulators:start --project washgo-app-8392 --import=firebase-export --export-on-exit=firebase-export
  ```

---

### Paso 5: Ejecutar la Aplicación
Una vez que los emuladores estén en ejecución, abre otra terminal y corre el proyecto Flutter en el navegador (Chrome):

```bash
flutter run -d chrome --dart-define-from-file=.env
```

---

## 📂 Estructura Principal del Proyecto

* `lib/`: Código fuente de la aplicación Flutter.
  * `features/`: Módulos de la app (autenticación, dashboard de clientes, dashboard de dueños/empleados, facturación, etc.).
  * `shared/`: Componentes y widgets reutilizables.
* `dataconnect/`: Configuración y esquemas GraphQL de Firebase Data Connect para la base de datos PostgreSQL.
* `functions/`: Cloud Functions escritas en Javascript/Node.js para procesos de backend (ej. llamadas a APIs de pago como PayPal).
* `public/`: Contenido estático y callbacks para redirecciones (Hosting).
