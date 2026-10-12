# SAICI - Sistema de Reserva de Espacios Universitarios (UCEVA)

Sistema integral de gestión, control de asistencia y reservas de laboratorios y salas académicas para la **Unidad Central del Valle del Cauca (UCEVA)**.

El proyecto está diseñado bajo una arquitectura desacoplada:
* **Backend:** Node.js, Express, PostgreSQL 16, JSON Web Tokens (JWT) y hashing criptográfico con Bcrypt.
* **Frontend:** Flutter & Dart (aplicación multiplataforma adaptada para Web y Móvil Android).

---

## 🚀 Puesta en Marcha Rápida (Para Nuevos Clones)

Si un compañero clona el repositorio, tiene dos formas de ejecutarlo:

### Opción A: Con Docker (Recomendada para todo el equipo) 🐳
No requiere instalar PostgreSQL ni Node.js manualmente.
1. Clona el repositorio y entra a la carpeta:
   ```bash
   git clone https://github.com/AndresBy02/Front-End_PI
   cd Front-End_PI
   ```
2. Levanta la base de datos (con tablas y horarios automáticos) y el backend con un solo comando:
   ```bash
   docker compose up -d
   ```
   *El backend estará listo y escuchando en:* `http://localhost:3000`

---

### Opción B: Ejecución Local Nativa (Sin Docker) 💻

#### 1. Configurar Base de Datos (PostgreSQL)
1. Abre tu cliente de PostgreSQL (pgAdmin / TablePlus / DBeaver).
2. Crea la base de datos: `saici_db`.
3. Ejecuta el archivo [`BD_Saici.sql`](./BD_Saici.sql) para crear las tablas, usuarios y horarios de atención.

#### 2. Configurar y Levantar el Backend (Node.js)
1. En la raíz del proyecto, copia las variables de entorno:
   ```powershell
   Copy-Item .env.example .env
   ```
2. Instala las dependencias:
   ```powershell
   npm install
   ```
3. Inicia el servidor:
   * **Modo desarrollo (Recomendado):**
     ```powershell
     npm run dev
     ```
     *(Usa `nodemon`: reinicia automáticamente el servidor cada vez que guardas un cambio en el código).*
   * **Modo producción simple:**
     ```powershell
     node src/server.js
     # o
     npm start
     ```
     *(Inicia el servidor directamente sin recarga automática).*

---

## 💻 Cómo Iniciar el Backend desde VS Code (Sin escribir comandos)

1. Abre la carpeta del proyecto en **Visual Studio Code**.
2. En la barra lateral izquierda, abre la pestaña de **NPM Scripts** (o presiona `Ctrl + Shift + P` y escribe `Run Task`).
3. Verás una lista con `dev`, `start`, `test`:
   - Haz clic en el botón de **Play ▶** al lado de **`dev`**.
4. Se abrirá una terminal interna ejecutando el servidor backend automáticamente.

---

## 📱 Ejecutar el Frontend (Flutter & Dart)

Abre una terminal y dirígete a la carpeta de Flutter:
```powershell
cd src/frontend_flutter
flutter pub get
```

### 1. En Navegador Web (Chrome / Edge)
```powershell
flutter run -d chrome
```
*También puedes fijar el puerto si lo deseas:* `flutter run -d chrome --web-port=8080`.

### 2. En Android Studio o Celular Físico
1. Abre la carpeta `src/frontend_flutter` en **Android Studio**.
2. Selecciona tu emulador o tu celular físico conectado por USB.
3. Presiona el botón verde de **Run (Play)** ▶.

> [!NOTE]
> La aplicación detecta automáticamente si corre en Web o en Android. En Android se conecta a la máquina host a través de `http://10.0.2.2:3000/api` y en Web mediante `http://localhost:3000/api`.

---

## 👥 Credenciales de Prueba del Sistema

La base de datos viene precargada con las siguientes cuentas de prueba:

| Rol | Correo Electrónico | Contraseña | Panel Destino |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin@uceva.edu.co` | `Admin123456!` | Panel Administrativo (`/admin/dashboard`) |
| **Laboratorio** | `laboratorio@uceva.edu.co` | `Lab123456!` | Panel de Encargado (`/lab/dashboard`) |
| **Estudiante / Egresado** | `estudiante.test@uceva.edu.co` | `Estudiante123!` | Panel de Estudiante (`/user/home`) |

*(También puedes registrar un usuario nuevo directamente desde el formulario de **"Regístrate aquí"**).*

---

## ⏰ Horarios de Atención Registrados

| Días | Horario de Apertura y Cierre |
| :--- | :--- |
| **Lunes a Viernes** | 07:00:00 a 22:00:00 |
| **Sábados** | 08:00:00 a 18:00:00 |

---

## 📁 Estructura del Repositorio

```text
Front-End_PI/
├── Dockerfile                   # Configuración para contenerizar el Backend
├── docker-compose.yml           # Orquestación de PostgreSQL + Backend en 1 comando
├── BD_Saici.sql                 # Script DDL/DML (Tablas, Semillas y Horarios)
├── .env.example                 # Plantilla de variables de entorno
├── package.json                 # Dependencias y scripts de Node.js
├── src/
│   ├── app.js                   # Configuración Express y middlewares
│   ├── server.js                # Entrada del servidor HTTP (Puerto 3000)
│   ├── config/db.js             # Pool de conexión a PostgreSQL
│   ├── modules/
│   │   ├── auth/                # Login, registro, perfil, cambio de clave
│   │   ├── reserva/             # Validaciones, horarios y reservas
│   │   └── laboratorios/        # Catálogo de laboratorios y espacios
│   └── frontend_flutter/        # APLICACIÓN FLUTTER MULTIPLATAFORMA
│       ├── pubspec.yaml         # Dependencias Flutter
│       ├── android/             # Configuración nativa Android / Gradle
│       └── lib/
│           ├── main.dart        # Entrada de Flutter
│           ├── services/        # ApiService con conexión dinámica a backend
│           └── screens/
│               ├── auth/        # Login y registro
│               ├── admin/       # Dashboard administrativo y gestión de reservas
│               ├── user/        # Reservas, catálogo y perfil de estudiante
│               └── lab/         # Dashboard del encargado de laboratorio
```
