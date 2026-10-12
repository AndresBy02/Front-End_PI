# SAICI - Sistema de Reserva de Espacios Universitarios (UCEVA)

Sistema integral de gestión, control de asistencia y reservas de laboratorios y salas académicas para la **Unidad Central del Valle del Cauca (UCEVA)**.

El proyecto está diseñado bajo una arquitectura desacoplada:
* **Backend:** Node.js, Express, PostgreSQL, JSON Web Tokens (JWT) y hashing criptográfico irreversible con Bcrypt.
* **Frontend:** Flutter & Dart (aplicación multiplataforma con diseño responsivo, adaptada para Web, Tablet y Móvil).

---

## 📋 Requisitos Previos y Aplicaciones Necesarias

Para ejecutar el proyecto en tu máquina local asegúrate de tener instalado:

1. **[Node.js](https://nodejs.org/)** (versión 18.x o superior LTS).
2. **[Flutter SDK](https://docs.flutter.dev/get-started/install)** (versión 3.20+ o superior con canal `stable`).
3. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** (recomendado para levantar PostgreSQL) **o** [PostgreSQL instalado localmente](https://www.postgresql.org/download/).
4. **Cliente de Base de Datos Visual (Opcional pero muy útil):**
   * [TablePlus](https://tableplus.com/) *(muy recomendado, ligero y rápido)*
   * [pgAdmin 4](https://www.pgadmin.org/) o [DBeaver](https://dbeaver.io/)
5. **Navegador Web:** Microsoft Edge o Google Chrome (para ejecutar la app en modo Web).
6. **[Visual Studio Code](https://code.visualstudio.com/)** con las extensiones recomendadas:
   * *Flutter* y *Dart*
   * *PostgreSQL* o *Database Client*

---

## 🔒 Archivos Excluidos por Seguridad (`.gitignore`)

Por directrices estrictas de seguridad institucional y protección de datos, los siguientes archivos **NO se encuentran en el repositorio de Git** y deben tenerse en cuenta:

| Archivo / Carpeta | ¿Por qué está ignorado? | ¿Qué debes hacer si clonas el proyecto? |
| :--- | :--- | :--- |
| **`.env`** | Contiene credenciales maestras de base de datos, contraseñas y la firma secreta de JWT. | **Debes crearlo manualmente** duplicando `.env.example` (ver paso más abajo). |
| **`node_modules/`** | Paquetes y librerías externas de Node.js. | Se descargan automáticamente ejecutando `npm install`. |
| **`.dart_tool/` y `build/`** | Binarios compilados y perfiles temporales de Flutter. | Se regeneran solos con `flutter pub get` y `flutter run`. |
| **Cookies y Perfiles Web** | (`chrome-device/`, `Cookies`, etc.) | Se excluyen por privacidad para no filtrar sesiones ni contraseñas del navegador. |

---

## 🚀 Guía de Instalación y Ejecución Paso a Paso

### 1. Configurar la Base de Datos (PostgreSQL)

Tienes dos alternativas para tener la base de datos lista:

#### Opción A: Usando Docker (Recomendada)
Si tienes Docker Desktop abierto, abre una terminal de PowerShell y ejecuta:

```powershell
docker run --name postgres-cursos -e POSTGRES_USER=devdb -e POSTGRES_PASSWORD=a1b2c3d4 -e POSTGRES_DB=saici -p 5432:5432 -d postgres:15-alpine
```

*(Si el contenedor ya fue creado anteriormente, solo necesitas iniciarlo con `docker start postgres-cursos`).*

#### Opción B: Usando PostgreSQL nativo (Instalado en tu PC)
Si tienes PostgreSQL instalado localmente como servicio de Windows:
1. Asegúrate de que el servicio esté corriendo en el puerto `5432`.
2. Crea una base de datos llamada `saici` con un usuario y contraseña correspondientes.

---

### 2. Cargar las Tablas y Datos Iniciales (`BD_Saici.sql`)

El archivo [`BD_Saici.sql`](./BD_Saici.sql) ubicado en la raíz del proyecto contiene todas las tablas, restricciones de integridad, roles y registros iniciales.

#### Desde TablePlus:
1. Abre **TablePlus** y crea una nueva conexión a **PostgreSQL**:
   * **Host:** `localhost` o `127.0.0.1`
   * **Port:** `5432`
   * **User:** `devdb`
   * **Password:** `a1b2c3d4`
   * **Database:** `saici`
2. Presiona **Test** y luego **Connect**.
3. Haz clic en el botón **SQL** (o presiona `Ctrl + E`), abre el contenido del archivo [`BD_Saici.sql`](./BD_Saici.sql) y dale clic a **Run Current** (o `Ctrl + Enter`).

#### Desde PowerShell con Docker:
```powershell
Get-Content BD_Saici.sql | docker exec -i postgres-cursos psql -U devdb -d saici
```

---

### 3. Configurar y Ejecutar el Backend (Node.js)

1. En la raíz del proyecto (`Pi Sexto/backend_PI`), crea tu archivo `.env` basándote en `.env.example`:
   * Puedes copiarlo en PowerShell:
     ```powershell
     Copy-Item .env.example .env
     ```
   * Verifica que las variables coincidan con tu base de datos:
     ```env
     PORT=3000
     DB_HOST=localhost
     DB_PORT=5432
     DB_NAME=saici
     DB_USER=devdb
     DB_PASSWORD=a1b2c3d4
     JWT_SECRET=saici_super_secret_jwt_token_2026_uceva
     EMAIL_USER=soporte@uceva.edu.co
     EMAIL_PASS=tu_clave_de_aplicacion
     ```

2. Instala las dependencias del backend:
   ```powershell
   npm install
   ```

3. Ejecuta la suite de pruebas de seguridad y roles para validar que todo funcione correctamente:
   ```powershell
   npm test
   ```
   *(Deberás ver 15 pruebas pasando al 100% en verde).*

4. Inicia el servidor backend:
   ```powershell
   npm start
   # o en modo desarrollo con recarga automática:
   npm run dev
   ```
   *El servidor responderá en:* `http://localhost:3000`

---

### 4. Ejecutar el Frontend (Flutter & Dart)

Abre una **segunda terminal** (mantén el backend corriendo en la primera) y dirígete a la carpeta del frontend:

1. Entra a la carpeta de Flutter:
   ```powershell
   cd src/frontend_flutter
   ```

2. Descarga las dependencias y paquetes de Dart:
   ```powershell
   flutter pub get
   ```

3. Comprueba que no existan errores de análisis o linter:
   ```powershell
   flutter analyze
   ```

4. Ejecuta la aplicación en Microsoft Edge o Google Chrome:
   ```powershell
   # Para ejecutar en Microsoft Edge:
   flutter run -d edge

   # Para ejecutar en Google Chrome:
   flutter run -d chrome
   ```

5. **Comandos útiles durante la ejecución en consola:**
   * Presiona `r` para realizar **Hot Reload** (recarga rápida de cambios visuales).
   * Presiona `R` para realizar **Hot Restart** (reinicio completo del estado de la app).
   * Presiona `q` para detener la aplicación.

---

## 👥 Credenciales de Acceso del Sistema (Semillas)

La base de datos viene precargada con las siguientes cuentas de prueba seguras (hasheadas con `bcrypt`):

| Rol | Correo Electrónico | Contraseña | Panel Destino |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin@uceva.edu.co` | `Admin123456!` | Panel Administrativo (`/admin/dashboard`) |
| **Laboratorio** | `laboratorio@uceva.edu.co` | `Lab123456!` | Panel de Encargado (`/lab/dashboard`) |
| **Estudiante / Egresado** | Puedes registrar un usuario nuevo directamente desde el formulario de **"Registrarse"** en la pantalla de inicio. | Contraseña elegida (mín. 8 caracteres) | Panel de Estudiante (`/user/home`) |

---

## 📁 Estructura del Proyecto

```text
backend_PI/
├── BD_Saici.sql                 # Script DDL/DML de PostgreSQL (Tablas y Semillas)
├── .env.example                 # Plantilla de variables de entorno (pública)
├── .env                         # Variables de entorno reales (IGNORADO en Git)
├── .gitignore                   # Reglas maestras de exclusión de Git
├── package.json                 # Dependencias y scripts del Backend
├── src/
│   ├── app.js                   # Configuración de Express, CORS y Middlewares
│   ├── server.js                # Punto de entrada del servidor Node.js
│   ├── config/                  # Conexión a PostgreSQL (pg Pool)
│   ├── modules/
│   │   ├── auth/                # Login, registro, perfil, cambio de contraseña, roles
│   │   ├── reserva/             # Gestión y estados de solicitudes de reserva
│   │   └── laboratorio/         # Gestión de laboratorios y espacios físicos
│   └── frontend_flutter/        # PROYECTO COMPLETO EN FLUTTER / DART
│       ├── pubspec.yaml         # Dependencias de Flutter (http, shared_preferences, etc.)
│       ├── lib/
│       │   ├── main.dart        # Punto de entrada de la aplicación Flutter
│       │   ├── core/            # Temas, colores institucionales y constantes
│       │   ├── models/          # Modelos de datos (User, Space, Reservation)
│       │   ├── services/        # ApiService (conexión HTTP con backend) y Sesión
│       │   ├── widgets/         # Componentes reutilizables (AppLayout, Cards, Badges)
│       │   └── screens/         # Pantallas divididas por rol:
│       │       ├── auth/        # Login y registro
│       │       ├── user/        # Home estudiante, catálogo, reservas, perfil
│       │       ├── admin/       # Dashboard administrativo, usuarios, reportes
│       │       └── lab/         # Dashboard y reservas asignadas a laboratorio
└── test/
    └── verify_security_and_roles.js # Suite de pruebas de seguridad, tokens y bcrypt
```

---

## 🛠️ Preguntas Frecuentes y Solución de Problemas

#### 1. ¿Qué hago si obtengo el error `ECONNREFUSED 127.0.0.1:5432`?
Significa que PostgreSQL no está corriendo o que el contenedor de Docker está apagado. Ejecuta en terminal:
```powershell
docker start postgres-cursos
```
y verifica con `docker ps` que el puerto `5432` esté escuchando.

#### 2. ¿Cómo cambio mi contraseña desde la aplicación?
Inicia sesión con cualquier usuario, dirígete a la sección **Perfil** en el menú lateral, completa el bloque **Seguridad y Cambio de Contraseña** ingresando tu contraseña actual y la nueva de mínimo 8 caracteres. El backend validará el hash con Bcrypt y lo actualizará de inmediato en PostgreSQL.

#### 3. ¿El diseño se adapta a pantallas de celular o tablet?
Sí. Todas las pantallas cuentan con arquitectura adaptativa utilizando `LayoutBuilder`, `Wrap` y scroll horizontal en tablas de datos. No se producirán errores visuales de desbordamiento (`RenderFlex overflow`).
