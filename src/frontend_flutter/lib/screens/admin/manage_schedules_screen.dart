import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_layout.dart';

class ManageSchedulesScreen extends StatefulWidget {
  const ManageSchedulesScreen({super.key});

  @override
  State<ManageSchedulesScreen> createState() => _ManageSchedulesScreenState();
}

class _ManageSchedulesScreenState extends State<ManageSchedulesScreen> {
  final List<Map<String, dynamic>> schedules = [
    {'day': 'Lunes a Viernes', 'open': '07:00 a. m.', 'close': '09:00 p. m.', 'slots': '6 bloques de 2h', 'active': true},
    {'day': 'Sábados', 'open': '08:00 a. m.', 'close': '06:00 p. m.', 'slots': '5 bloques de 2h', 'active': true},
    {'day': 'Domingos y Festivos', 'open': '08:00 a. m.', 'close': '02:00 p. m.', 'slots': 'Solo Biblioteca', 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/admin/schedules',
      title: 'Gestionar Horarios Institucionales',
      subtitle: 'Configura las franjas horarias y días de disponibilidad para reservas',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
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
                  const Text('Franjas y Políticas de Horario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Modo demostración: nueva franja configurada')),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Nueva franja'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(140, 40)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.frameBg),
                  columns: const [
                    DataColumn(label: Text('Días')),
                    DataColumn(label: Text('Hora Apertura')),
                    DataColumn(label: Text('Hora Cierre')),
                    DataColumn(label: Text('Bloques Permitidos')),
                    DataColumn(label: Text('Estado')),
                  ],
                  rows: schedules.map((s) {
                    return DataRow(
                      cells: [
                        DataCell(Text(s['day'], style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(s['open'])),
                        DataCell(Text(s['close'])),
                        DataCell(Text(s['slots'])),
                        DataCell(
                          Switch(
                            value: s['active'],
                            activeTrackColor: AppColors.accentGreen,
                            onChanged: (val) {
                              setState(() => s['active'] = val);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
