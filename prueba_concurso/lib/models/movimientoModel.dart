class Movimientomodel {
  int? id;
  String? descripcion;
  String categoria;
  double? monto;
  String tipo;
  String fecha;

  Movimientomodel({
    this.id,
    this.descripcion,
    required this.categoria,
    this.monto,
    required this.tipo,
    required this.fecha,
  });

  factory Movimientomodel.fromMap(Map<String, dynamic> data) {
    return Movimientomodel(
      id: data['id'] is int ? data['id'] as int : (data['id'] is num ? (data['id'] as num).toInt() : null),
      descripcion: data['descripcion'] as String?,
      categoria: data['categoria']?.toString() ?? '',
      monto: data['monto'] is num ? (data['monto'] as num).toDouble() : (data['monto'] != null ? double.tryParse(data['monto'].toString()) : null),
      tipo: data['tipo']?.toString() ?? '',
      fecha: data['fecha']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'tipo': tipo,
      'fecha': fecha,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Movimientomodel copyWith({
    int? id,
    String? descripcion,
    String? categoria,
    double? monto,
    String? tipo,
    String? fecha,
  }) {
    return Movimientomodel(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      monto: monto ?? this.monto,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  String toString() {
    return 'Movimientomodel{id: $id, descripcion: $descripcion, categoria: $categoria, monto: $monto, tipo: $tipo, fecha: $fecha}';
  }
}
