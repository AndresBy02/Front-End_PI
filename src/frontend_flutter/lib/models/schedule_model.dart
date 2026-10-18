class ScheduleModel {
  final int id;
  final int weekday;
  final String opensAt;
  final String closesAt;
  final bool active;

  const ScheduleModel({
    required this.id,
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
    required this.active,
  });

  ScheduleModel copyWith({bool? active}) {
    return ScheduleModel(
      id: id,
      weekday: weekday,
      opensAt: opensAt,
      closesAt: closesAt,
      active: active ?? this.active,
    );
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: _parseInt(json['id_horario'] ?? json['id']),
      weekday: _parseInt(json['dia_semana']),
      opensAt: _parseTime(json['hora_apertura']),
      closesAt: _parseTime(json['hora_cierre']),
      active: json['activo'] == true,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _parseTime(dynamic value) {
    final time = value?.toString() ?? '';
    return time.length >= 5 ? time.substring(0, 5) : time;
  }
}
