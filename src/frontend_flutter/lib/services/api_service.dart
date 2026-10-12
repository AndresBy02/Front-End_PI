import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/reservation_model.dart';
import '../models/space_model.dart';
import '../models/user_model.dart';
import 'auth_session_service.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000/api';
    } catch (_) {}
    return 'http://localhost:3000/api';
  }

  static Map<String, String> _headers({bool needsAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (needsAuth) {
      final token = AuthSessionService().token;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static String _extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is Map) {
        if (data.containsKey('mensaje')) return data['mensaje'].toString();
        if (data.containsKey('error')) return data['error'].toString();
        if (data.containsKey('message')) return data['message'].toString();
      }
    } catch (_) {}

    switch (response.statusCode) {
      case 400:
        return 'Solicitud inválida. Revisa los datos ingresados.';
      case 401:
        return 'Credenciales incorrectas o sesión no autorizada.';
      case 403:
        return 'Acceso denegado: no tienes permisos para esta función.';
      case 404:
        return 'Recurso no encontrado en el servidor.';
      case 409:
        return 'Conflicto: ya existe un registro con esos datos.';
      case 500:
        return 'Error interno del servidor. Por favor intenta más tarde.';
      default:
        return 'Error inesperado del servidor (Código ${response.statusCode}).';
    }
  }

  // ==========================================
  // AUTENTICACIÓN & USUARIOS
  // ==========================================

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers(needsAuth: false),
        body: jsonEncode({
          'email': email.trim(),
          'contrasena': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final token = data['token'] as String;
        final user = UserModel.fromJson(data['usuario']);

        await AuthSessionService().saveSession(token, user);

        return {
          'success': true,
          'token': token,
          'usuario': user,
        };
      } else {
        return {
          'success': false,
          'error': _extractErrorMessage(response),
        };
      }
    } catch (e) {
      // Modo de prueba / demostración sin backend activo
      final cleanEmail = email.trim().toLowerCase();
      UserModel? demoUser;

      if (cleanEmail.startsWith('admin') || cleanEmail == 'admin@uceva.edu.co') {
        demoUser = const UserModel(
          id: 1,
          nombres: 'Administrador',
          apellidos: 'Principal UCEVA',
          correo: 'admin@uceva.edu.co',
          telefono: '3000000001',
          tipo: 'Administrativo',
          rol: 'ADMINISTRADOR',
        );
      } else if (cleanEmail.startsWith('lab') || cleanEmail == 'laboratorio@uceva.edu.co') {
        demoUser = const UserModel(
          id: 2,
          nombres: 'Coordinador',
          apellidos: 'Laboratorios UCEVA',
          correo: 'laboratorio@uceva.edu.co',
          telefono: '3000000002',
          tipo: 'Docente',
          rol: 'LABORATORIO',
        );
      } else if (cleanEmail.contains('@')) {
        demoUser = UserModel(
          id: 3,
          nombres: 'Estudiante',
          apellidos: 'UCEVA',
          correo: cleanEmail,
          telefono: '3001234567',
          tipo: 'ESTUDIANTE',
          rol: 'USUARIO',
        );
      }

      if (demoUser != null) {
        const demoToken = 'demo_token_uceva_2026';
        await AuthSessionService().saveSession(demoToken, demoUser);
        return {
          'success': true,
          'token': demoToken,
          'usuario': demoUser,
        };
      }

      return {
        'success': false,
        'error': 'No se pudo conectar con el servidor. Verifica las credenciales ingresadas.',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String nombres,
    required String apellidos,
    required String email,
    required String telefono,
    required String contrasena,
    required String confirmarContrasena,
    required String tipoUsuario,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers(needsAuth: false),
        body: jsonEncode({
          'nombres': nombres.trim(),
          'apellidos': apellidos.trim(),
          'email': email.trim().toLowerCase(),
          'telefono': telefono.trim(),
          'contrasena': contrasena,
          'confirmarContrasena': confirmarContrasena,
          'tipo_usuario': tipoUsuario.trim().toUpperCase(),
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'mensaje': data['mensaje'] ?? 'Usuario registrado exitosamente',
        };
      } else {
        return {
          'success': false,
          'error': _extractErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión con el backend. Verifica que el servidor esté activo.',
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String nombres,
    required String apellidos,
    required String telefono,
    String? email,
  }) async {
    try {
      final body = <String, dynamic>{
        'nombres': nombres.trim(),
        'apellidos': apellidos.trim(),
        'telefono': telefono.trim(),
      };
      if (email != null && email.trim().isNotEmpty) {
        body['email'] = email.trim().toLowerCase();
      }

      final response = await http.put(
        Uri.parse('$baseUrl/auth/perfil'),
        headers: _headers(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final updated = UserModel.fromJson(data['usuario']);
        await AuthSessionService().updateCurrentUser(updated);
        return {'success': true, 'usuario': updated};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error al actualizar perfil en el servidor.'};
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String contrasenaActual,
    required String nuevaContrasena,
    required String confirmarContrasena,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/cambiar-password'),
        headers: _headers(),
        body: jsonEncode({
          'contrasenaActual': contrasenaActual,
          'nuevaContrasena': nuevaContrasena,
          'confirmarContrasena': confirmarContrasena,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'mensaje': data['mensaje'] ?? 'Contraseña actualizada exitosamente',
        };
      } else {
        return {
          'success': false,
          'error': _extractErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión al cambiar contraseña.',
      };
    }
  }

  static Future<List<UserModel>> fetchUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/usuarios'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data.isNotEmpty) {
          return data.map((u) => UserModel.fromJson(u)).toList();
        }
      }
      return _demoUsuarios();
    } catch (_) {
      return _demoUsuarios();
    }
  }

  // ==========================================
  // LABORATORIOS / ESPACIOS
  // ==========================================

  static Future<List<SpaceModel>> fetchLaboratorios() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laboratorios'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data.isNotEmpty) {
          return data.map((item) {
            final idLab = item['id_laboratorio']?.toString() ?? '';
            return SpaceModel(
              id: idLab,
              name: item['nombre'] ?? '',
              type: 'Laboratorio',
              location: item['ubicacion'] ?? 'Campus UCEVA',
              capacity: item['capacidad'] is int ? item['capacidad'] : int.tryParse(item['capacidad']?.toString() ?? '20') ?? 20,
              resources: 'Equipos y conectividad de laboratorio',
              availability: (item['estado'] ?? '').toString().toUpperCase() == 'DISPONIBLE' ? 'Disponible' : 'Ocupado',
              status: item['estado'] ?? 'Disponible',
              schedule: 'Lunes a viernes, 8:00 a. m. – 6:00 p. m.',
              icon: '💻',
            );
          }).toList();
        }
      }
      return _demoLaboratorios();
    } catch (_) {
      return _demoLaboratorios();
    }
  }

  static Future<Map<String, dynamic>> createLaboratorio({
    required String nombre,
    required String ubicacion,
    required String estado,
    required int capacidad,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/laboratorios'),
        headers: _headers(),
        body: jsonEncode({
          'nombre': nombre.trim(),
          'ubicacion': ubicacion.trim(),
          'estado': estado.trim().toUpperCase(),
          'capacidad': capacidad,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión con el backend.'};
    }
  }

  static Future<Map<String, dynamic>> updateLaboratorio({
    required String id,
    required String nombre,
    required String ubicacion,
    required String estado,
    required int capacidad,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/laboratorios/$id'),
        headers: _headers(),
        body: jsonEncode({
          'nombre': nombre.trim(),
          'ubicacion': ubicacion.trim(),
          'estado': estado.trim().toUpperCase(),
          'capacidad': capacidad,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión con el backend.'};
    }
  }

  static Future<Map<String, dynamic>> deleteLaboratorio(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/laboratorios/$id'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión con el backend.'};
    }
  }

  // ==========================================
  // RESERVAS
  // ==========================================

  static Future<List<ReservationModel>> fetchReservas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reservas'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final dynamic raw = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = raw is List ? raw : [raw];
        if (data.isNotEmpty) {
          return data.map((item) {
            final idRes = item['id_reserva'] is int ? item['id_reserva'] : int.tryParse(item['id_reserva']?.toString() ?? '0') ?? 0;
            final labNombre = item['laboratorio'] ?? item['nombre'] ?? 'Laboratorio';
            final solicitante = (item['nombres'] != null && item['apellidos'] != null)
                ? '${item['nombres']} ${item['apellidos']}'
                : null;
            final horaIni = item['hora_inicio']?.toString().substring(0, 5) ?? '08:00';
            final horaFin = item['hora_fin']?.toString().substring(0, 5) ?? '10:00';

            return ReservationModel(
              id: idRes,
              spaceName: labNombre,
              date: item['fecha']?.toString().split('T')[0] ?? '',
              startTime: horaIni,
              endTime: horaFin,
              status: item['estado'] ?? 'PENDIENTE',
              purpose: 'Actividad académica',
              userName: solicitante,
            );
          }).toList();
        }
      }
      return _demoReservas();
    } catch (_) {
      return _demoReservas();
    }
  }

  static Future<Map<String, dynamic>> createReserva({
    required int idLaboratorio,
    required String fecha, // YYYY-MM-DD
    required String horaInicio, // HH:MM
    required String horaFin, // HH:MM
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reservas'),
        headers: _headers(),
        body: jsonEncode({
          'id_laboratorio': idLaboratorio,
          'fecha': fecha,
          'horaInicio': horaInicio,
          'horaFin': horaFin,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión al crear reserva.'};
    }
  }

  static Future<Map<String, dynamic>> cancelReserva(int idReserva) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/reservas/$idReserva'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión al cancelar reserva.'};
    }
  }

  static Future<Map<String, dynamic>> updateEstadoReserva(int idReserva, String nuevoEstado) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/reservas/$idReserva/estado'),
        headers: _headers(),
        body: jsonEncode({'estado': nuevoEstado.toUpperCase()}),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': _extractErrorMessage(response)};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión al actualizar estado.'};
    }
  }

  // ==========================================
  // DATOS DE PRUEBA / MOCK (MODO OFFLINE)
  // ==========================================

  static List<UserModel> _demoUsuarios() {
    return const [
      UserModel(id: 1, nombres: 'Administrador', apellidos: 'Principal UCEVA', correo: 'admin@uceva.edu.co', telefono: '3000000001', tipo: 'Administrativo', rol: 'ADMINISTRADOR'),
      UserModel(id: 2, nombres: 'Coordinador', apellidos: 'Laboratorios UCEVA', correo: 'laboratorio@uceva.edu.co', telefono: '3000000002', tipo: 'Docente', rol: 'LABORATORIO'),
      UserModel(id: 3, nombres: 'Estudiante', apellidos: 'UCEVA', correo: 'estudiante@uceva.edu.co', telefono: '3101112233', tipo: 'ESTUDIANTE', rol: 'USUARIO'),
      UserModel(id: 4, nombres: 'Laura', apellidos: 'Gómez Ruiz', correo: 'laura.ejemplo@uceva.edu.co', telefono: '3102223344', tipo: 'EGRESADO', rol: 'USUARIO'),
      UserModel(id: 5, nombres: 'Andrés', apellidos: 'Pérez Franco', correo: 'andres.ejemplo@uceva.edu.co', telefono: '3103334455', tipo: 'ESTUDIANTE', rol: 'USUARIO'),
    ];
  }

  static List<SpaceModel> _demoLaboratorios() {
    return const [
      SpaceModel(
        id: '1',
        name: 'Laboratorio de Redes y Telecomunicaciones',
        type: 'Laboratorio',
        location: 'Edificio de Ingeniería - Bloque B Piso 2',
        capacity: 30,
        resources: 'Switches Cisco, Routers, Racks de cableado estructurado',
        availability: 'Disponible',
        status: 'Disponible',
        schedule: 'Lunes a viernes, 8:00 a. m. – 6:00 p. m.',
        icon: '🌐',
      ),
      SpaceModel(
        id: '2',
        name: 'Laboratorio de Desarrollo de Software',
        type: 'Laboratorio',
        location: 'Bloque C - Aula 204',
        capacity: 25,
        resources: 'PCs Core i7, 32GB RAM, IDEs y monitores duales',
        availability: 'Disponible',
        status: 'Disponible',
        schedule: 'Lunes a sábado, 7:00 a. m. – 9:00 p. m.',
        icon: '💻',
      ),
      SpaceModel(
        id: '3',
        name: 'Sala de Cómputo Especializado 301',
        type: 'Sala de Cómputo',
        location: 'Bloque A - Piso 3',
        capacity: 35,
        resources: 'Equipos para diseño CAD y simulación de circuitos',
        availability: 'Disponible',
        status: 'Disponible',
        schedule: 'Lunes a viernes, 8:00 a. m. – 8:00 p. m.',
        icon: '🖥️',
      ),
      SpaceModel(
        id: '4',
        name: 'Laboratorio de Robótica y Automatización',
        type: 'Laboratorio',
        location: 'Centro de Innovación - Lab 1',
        capacity: 20,
        resources: 'Brazos robóticos, Kits Arduino, PLC Siemens',
        availability: 'Disponible',
        status: 'Disponible',
        schedule: 'Lunes a viernes, 8:00 a. m. – 5:00 p. m.',
        icon: '🤖',
      ),
      SpaceModel(
        id: '5',
        name: 'Biblioteca Central - Sala de Estudio Grupal',
        type: 'Biblioteca',
        location: 'Bloque Central - Piso 2',
        capacity: 12,
        resources: 'Pantalla interactiva, pizarra acrílica y Wi-Fi institucional',
        availability: 'Disponible',
        status: 'Disponible',
        schedule: 'Lunes a sábado, 7:00 a. m. – 7:00 p. m.',
        icon: '📚',
      ),
    ];
  }

  static List<ReservationModel> _demoReservas() {
    return const [
      ReservationModel(
        id: 101,
        spaceName: 'Laboratorio de Desarrollo de Software',
        date: '2026-10-15',
        startTime: '08:00',
        endTime: '10:00',
        status: 'CONFIRMADA',
        purpose: 'Práctica de Programación Avanzada',
        userName: 'Carlos Andrés Pérez',
      ),
      ReservationModel(
        id: 102,
        spaceName: 'Laboratorio de Redes y Telecomunicaciones',
        date: '2026-10-16',
        startTime: '10:00',
        endTime: '12:00',
        status: 'PENDIENTE',
        purpose: 'Configuración de VLANs y Routers',
        userName: 'Laura Gómez Ruiz',
      ),
      ReservationModel(
        id: 103,
        spaceName: 'Sala de Cómputo Especializado 301',
        date: '2026-10-18',
        startTime: '14:00',
        endTime: '16:00',
        status: 'CONFIRMADA',
        purpose: 'Taller de Modelado 3D',
        userName: 'Julián Torres Vega',
      ),
    ];
  }
}
