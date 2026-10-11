import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/space_model.dart';
import '../../models/reservation_model.dart';
import '../../services/api_service.dart';
import '../../widgets/app_layout.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<SpaceModel> _spaces = [];
  List<ReservationModel> _reservas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      ApiService.fetchLaboratorios(),
      ApiService.fetchReservas(),
    ]);

    if (!mounted) return;
    setState(() {
      _spaces = results[0] as List<SpaceModel>;
      _reservas = results[1] as List<ReservationModel>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalReservas = _reservas.length;
    final activas = _reservas.where((r) => r.status.toLowerCase() == 'confirmada' || r.status.toLowerCase() == 'aprobada' || r.status.toLowerCase() == 'activa').length;
    final canceladas = _reservas.where((r) => r.status.toLowerCase() == 'cancelada' || r.status.toLowerCase() == 'rechazada').length;
    final tasaConfirmacion = totalReservas > 0 ? ((activas / totalReservas) * 100).toStringAsFixed(1) : '100.0';

    // Agrupar reservas por espacio
    final spaceCountMap = <String, int>{};
    for (final r in _reservas) {
      spaceCountMap[r.spaceName] = (spaceCountMap[r.spaceName] ?? 0) + 1;
    }

    return AppLayout(
      currentRoute: '/admin/reports',
      title: 'Estadísticas y Reportes',
      subtitle: 'Métricas de ocupación y cumplimiento de reservas en campus UCEVA',
      child: RefreshIndicator(
        onRefresh: _loadMetrics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: AppColors.primaryGreen),
                  ),
                )
              else ...[
                // Resumen de Métricas de Rendimiento
                Row(
                  children: [
                    _buildReportMetric(
                      'Tasa de Confirmación',
                      '$tasaConfirmacion%',
                      '$activas de $totalReservas reservas',
                      Icons.check_circle_outline,
                      AppColors.accentGreen,
                    ),
                    const SizedBox(width: 16),
                    _buildReportMetric(
                      'Total Reservas',
                      '$totalReservas',
                      'Registradas en el sistema',
                      Icons.calendar_month_outlined,
                      AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 16),
                    _buildReportMetric(
                      'Canceladas',
                      '$canceladas',
                      'Solicitudes declinadas',
                      Icons.cancel_outlined,
                      AppColors.amberText,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Top Espacios Más Solicitados
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
                      const Text(
                        'Espacios con Mayor Demanda',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textStrong),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ranking de ocupación basado en las solicitudes reales procesadas:',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      if (_spaces.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No hay espacios registrados en la base de datos.'),
                        )
                      else
                        for (final sp in _spaces) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${sp.icon} ${sp.name}',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    Text(
                                      '${spaceCountMap[sp.name] ?? 0} reservas registradas',
                                      style: const TextStyle(
                                        color: AppColors.accentGreenText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: totalReservas > 0
                                      ? (((spaceCountMap[sp.name] ?? 0) / totalReservas)).clamp(0.05, 1.0)
                                      : 0.1,
                                  backgroundColor: AppColors.surfaceBorder,
                                  color: AppColors.accentGreen,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ],
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportMetric(String title, String val, String subtitle, IconData icon, Color color) {
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
                Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textStrong)),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textStrong)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
