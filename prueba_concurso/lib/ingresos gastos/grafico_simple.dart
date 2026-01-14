import 'package:flutter/material.dart';
import '../repositories/movimientos_repository.dart';

class GraficoSimple extends StatefulWidget {
  const GraficoSimple({Key? key}) : super(key: key);

  @override
  State<GraficoSimple> createState() => _GraficoSimpleState();
}

class _GraficoSimpleState extends State<GraficoSimple> {
  final repo = MovimientosRepository();
  double ingresos = 0;
  double gastos = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  Future<void> _loadTotals() async {
    setState(() => loading = true);
    final list = await repo.getAll();
    double ing = 0, gas = 0;
    for (final m in list) {
      final amt = m.monto ?? 0;
      final tipo = m.tipo.toLowerCase();
      if (tipo.contains('ing') || tipo == 'ingreso' || tipo == 'income') {
        ing += amt;
      } else {
        gas += amt;
      }
    }
    setState(() {
      ingresos = ing;
      gastos = gas;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),

      // ---------------- APPBAR MODERNO ----------------
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Resumen Financiero',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ---------------- TARJETAS RESUMEN ----------------
                    Row(
                      children: [
                        _infoCard(
                          titulo: "Ingresos",
                          valor: ingresos,
                          icono: Icons.trending_up,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 14),
                        _infoCard(
                          titulo: "Gastos",
                          valor: gastos,
                          icono: Icons.trending_down,
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ---------------- CONTENEDOR DEL GRÁFICO ----------------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Comparativa",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AspectRatio(
                            aspectRatio: 1.6,
                            child: CustomPaint(
                              painter: _TwoBarChartPainter(ingresos, gastos),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _legend(Colors.green, 'Ingresos'),
                              const SizedBox(width: 18),
                              _legend(Colors.red, 'Gastos'),
                            ],
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

  // ---------------- TARJETA RESUMEN ----------------
  Widget _infoCard({
    required String titulo,
    required double valor,
    required IconData icono,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${valor.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- LEYENDA ----------------
  static Widget _legend(Color c, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

// ===================== TU PAINTER ORIGINAL (NO MODIFICADO) =====================

class _TwoBarChartPainter extends CustomPainter {
  final double ingresos;
  final double gastos;
  _TwoBarChartPainter(this.ingresos, this.gastos);

  @override
  void paint(Canvas canvas, Size size) {
    final paintAxis = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.0;
    final left = 40.0;
    final bottom = size.height - 20;

    canvas.drawLine(Offset(left, 10), Offset(left, bottom), paintAxis);
    canvas.drawLine(Offset(left, bottom), Offset(size.width - 10, bottom), paintAxis);

    final maxVal = (ingresos > gastos ? ingresos : gastos);
    final safeMax = maxVal > 0 ? maxVal : 1.0;

    final n = 2;
    final availableWidth = size.width - left - 20;
    final gap = availableWidth / (n * 1.5);
    final barWidth = gap;
    final spacing = gap * 0.5;

    final paintIngresos = Paint()..color = Colors.green;
    final paintGastos = Paint()..color = Colors.red;

    final values = [ingresos, gastos];
    for (var i = 0; i < n; i++) {
      final x = left + spacing + i * (barWidth + spacing);
      final barHeight = (values[i] / safeMax) * (bottom - 20 - 10);
      final rect = Rect.fromLTWH(x, bottom - barHeight, barWidth, barHeight);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
      canvas.drawRRect(rrect, i == 0 ? paintIngresos : paintGastos);

      // Valor
      final tp = TextPainter(
        text: TextSpan(
          text: '\$${values[i].toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.black87, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + (barWidth - tp.width) / 2, bottom - barHeight - tp.height - 6));

      // Label
      final label = i == 0 ? 'Ingresos' : 'Gastos';
      final tpLabel = TextPainter(
        text: TextSpan(text: label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: barWidth * 2);
      tpLabel.paint(canvas, Offset(x + (barWidth - tpLabel.width) / 2, bottom + 6));
    }

    // Eje Y
    final tp0 = TextPainter(
      text: const TextSpan(text: '0', style: TextStyle(color: Colors.black54, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp0.paint(canvas, Offset(left - tp0.width - 6, bottom - tp0.height / 2));

    final tpMax = TextPainter(
      text: TextSpan(text: safeMax.toStringAsFixed(0), style: const TextStyle(color: Colors.black54, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )..layout();
    tpMax.paint(canvas, Offset(left - tpMax.width - 6, 10 - tpMax.height / 2));
  }

  @override
  bool shouldRepaint(covariant _TwoBarChartPainter oldDelegate) =>
      oldDelegate.ingresos != ingresos || oldDelegate.gastos != gastos;
}
