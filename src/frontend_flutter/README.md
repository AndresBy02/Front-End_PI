# SAICI · Frontend en Dart & Flutter (UCEVA)

Sistema de Administración, Información y Control de Reservas Universitarias de la **UCEVA** (Unidad Central del Valle del Cauca).

Migrado fielmente desde el prototipo HTML/CSS/JS a **Dart + Flutter**, preservando:
* **Identidad visual:** Colores institucionales UCEVA (`#123B22`, `#27823D`, `#E8F5E9`, `#8A5B06`).
* **Layout responsivo:** Marco de escritorio con Sidebar + Topbar y colapso inteligente a Drawer en dispositivos móviles.
* **Flujos funcionales completos:** Autenticación (con recuperación OTP), Usuario, Administración y Laboratorio.

---

## 📁 Estructura del Proyecto

```text
lib/
├── main.dart                          # Punto de entrada de la aplicación
├── core/
│   ├── constants/app_colors.dart      # Tokens de color exactos de styles.css
│   ├── theme/app_theme.dart           # ThemeData con Material 3 y tipografía Inter
│   └── routes/app_routes.dart         # Enrutamiento declarativo
├── models/
│   ├── user_model.dart                # Modelo de usuario y roles
│   ├── space_model.dart               # Modelo de espacios universitarios
│   ├── reservation_model.dart         # Modelo de reservas
│   └── attendance_model.dart          # Modelo de asistencia
├── services/
│   ├── mock_data_service.dart         # Servicio de datos demo interactivos
│   └── api_service.dart               # Cliente HTTP para backend Node/Express
├── widgets/
│   ├── app_layout.dart                # Layout responsivo (Sidebar + Topbar + Drawer)
│   ├── space_card.dart                # Tarjeta de espacio (catálogo y destacados)
│   ├── reservation_card.dart          # Tarjeta de reserva (con badges y acciones)
│   ├── status_badge.dart              # Badges de estado (Confirmada, Pendiente, etc.)
│   └── custom_text_field.dart         # Campos de texto accesibles con validación
└── screens/
    ├── auth/                          # Login, Registro Egresado, Recuperar, OTP y Cambio de Clave
    ├── user/                          # Inicio, Explorar, Detalle, Asistente de Reserva, Mis Reservas, Historial, Asistencia, Perfil
    ├── admin/                         # Dashboard, Gestión de Reservas, Espacios (CRUD), Horarios, Reportes, Usuarios
    └── lab/                           # Dashboard de Laboratorio, Reservas Asignadas
```

---

## 🚀 Cómo Ejecutar la Aplicación

### 1. Requisitos Previos
Asegúrate de tener instalado Flutter en tu sistema.
Para verificarlo:
```bash
flutter doctor
```

Si aún no tienes Flutter configurado en Windows:
```powershell
winget install Google.Flutter
```
*(O descarga el SDK desde https://docs.flutter.dev/get-started/install/windows y agrega la carpeta `bin` a las variables de entorno PATH).*

### 2. Obtener dependencias
Desde la carpeta `src/frontend_flutter`:
```bash
flutter pub get
```

### 3. Ejecutar en Navegador Web (Chrome) o Escritorio (Windows)
```bash
# Modo Web (recomendado para probar el diseño responsive de escritorio):
flutter run -d chrome

# Modo Windows Desktop:
flutter run -d windows

# Modo Móvil (si tienes un emulador de Android o dispositivo conectado):
flutter run
```

---

## 🔗 Conexión con el Backend Node.js / Express

El servicio `lib/services/api_service.dart` está preconfigurado para consumir los endpoints de tu backend ubicado en `src/modules/`:
* `POST /api/auth/login`
* `GET /api/reservas`
* `GET /api/laboratorios`

Por defecto, la aplicación incluye `MockDataService` con los datos de demostración en memoria, lo que permite interactuar completamente con todas las pantallas y formularios incluso si el backend no se encuentra iniciado.
