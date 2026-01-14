import 'package:flutter/material.dart';
import '../models/movimientoModel.dart';
import '../repositories/movimientos_repository.dart';
import 'formulario.dart';

class ListadoGestorScreen extends StatefulWidget {
  @override
  State<ListadoGestorScreen> createState() => _ListadoGestorScreenState();
}

class _ListadoGestorScreenState extends State<ListadoGestorScreen> {
  final repo = MovimientosRepository();
  List<Movimientomodel> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => loading = true);
    final list = await repo.getAll();
    setState(() {
      items = list;
      loading = false;
    });
  }

  Future<void> _onDelete(int id) async {
    await repo.delete(id);
    await _loadItems();
  }

  Future<void> _openForm([Movimientomodel? model]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovimientosFormScreen(),
        settings: RouteSettings(arguments: model),
      ),
    );
    await _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPadding = media.size.width * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),

      // ---------------- APPBAR MODERNO ----------------
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Movimientos',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ---------------- HEADER ----------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Text(
                'Control de ingresos y gastos',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 12),

            // ---------------- LISTADO ----------------
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay registros disponibles',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 12,
                          ),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final m = items[index];
                            return _item(context, m);
                          },
                        ),
            ),

            // ---------------- BOTONES ----------------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(
                          vertical: media.size.height * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(
                          vertical: media.size.height * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- ITEM ----------------
  Widget _item(BuildContext context, Movimientomodel m) {
    final isIngreso = m.tipo.toLowerCase().contains('ing');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICONO
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isIngreso
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIngreso ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIngreso ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(width: 12),

          // TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.categoria,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  m.descripcion ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // MONTO Y ACCIONES
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${m.monto?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isIngreso ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _openForm(m),
                    child: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () async {
                      if (m.id != null) await _onDelete(m.id!);
                    },
                    child: const Icon(Icons.delete, size: 20, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
