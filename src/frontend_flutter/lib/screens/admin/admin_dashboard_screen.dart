import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/reservation_model.dart';
import '../../models/space_model.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../widgets/app_layout.dart';
import '../../widgets/status_badge.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  List<ReservationModel> _reservas = [];
  List<SpaceModel> _spaces = [];
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    final results = await Future.wait([
      ApiService.fetchReservas(),
      ApiService.fetchLaboratorios(),
      ApiService.fetchUsuarios(),
    ]);

    if (!mounted) return;

    setState(() {
      _reservas = results[0] as List<ReservationModel>;
      _spaces = results[1] as List<SpaceModel>;
      _users = results[2] as List<UserModel>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingReservations = _reservas.where((r) => r.status.toUpperCase() == 'PENDIENTE').toList();

    return AppLayout(
      currentRoute: '/admin/dashboard',
      title: 'Panel Administrativo SAICI',
      subtitle: 'Administración UCEVA (vista de control general)',
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPIs
                    Row(
                      children: [
                        _buildKpiCard('Total Reservas', '${_reservas.length}', Icons.calendar_today, AppColors.accentGreen),
                        const SizedBox(width: 16),
                        _buildKpiCard('Pendientes por Aprobar', '${pendingReservations.length}', Icons.pending_actions, AppColors.amberText),
                        const SizedBox(width: 16),
                        _buildKpiCard('Espacios Registrados', '${_spaces.length}', Icons.meeting_room, AppColors.primaryGreen),
                        const SizedBox(width: 16),
                        _buildKpiCard('Usuarios Totales', '${_users.length}', Icons.people, const Color(0xFF1565C0)),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Acciones Rápidas
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Accesos de Gestión', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _buildQuickAction(context, 'Gestionar Reservas', Icons.assignment, '/admin/reservations'),
                              const SizedBox(width: 12),
                              _buildQuickAction(context, 'Gestionar Espacios', Icons.room_preferences, '/admin/spaces'),
                              const SizedBox(width: 12),
                              _buildQuickAction(context, 'Configurar Horarios', Icons.schedule, '/admin/schedules'),
                              const SizedBox(width: 12),
                              _buildQuickAction(context, 'Ver Reportes', Icons.bar_chart, '/admin/reports'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Solicitudes Pendientes
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Solicitudes Pendientes de Revisión en BD',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textStrong),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, '/admin/reservations'),
                                child: const Text('Ver todas las reservas', style: TextStyle(color: AppColors.accentGreenText)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (pendingReservations.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text('No hay solicitudes pendientes en este momento.', style: TextStyle(color: AppColors.textMuted)),
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(AppColors.frameBg),
                                columns: const [
                                  DataColumn(label: Text('Espacio')),
                                  DataColumn(label: Text('Fecha y Hora')),
                                  DataColumn(label: Text('Solicitante')),
                                  DataColumn(label: Text('Motivo')),
                                  DataColumn(label: Text('Estado')),
                                ],
                                rows: pendingReservations.map((r) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(r.spaceName, style: const TextStyle(fontWeight: FontWeight.w600))),
                                      DataCell(Text('${r.date} (${r.startTime} – ${r.endTime})')),
                                      DataCell(Text(r.userName ?? 'Estudiante')),
                                      DataCell(Text(r.purpose ?? 'Académico')),
                                      DataCell(StatusBadge(status: r.status)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildKpiCard(String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(val, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textStrong)),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, String route) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, route),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.frameBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.accentGreenText, size: 22),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textStrong),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
