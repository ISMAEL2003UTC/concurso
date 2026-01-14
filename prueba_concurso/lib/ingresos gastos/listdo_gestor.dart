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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Listado de Ingresos y gastos'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Text(
                'Vea sus ingresos y gastos',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            SizedBox(height: 10),

            // LISTADO
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const Center(child: Text('No hay registros'))
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final m = items[index];
                            return _item(context, m);
                          },
                        ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF6B5CE7),
                        padding: EdgeInsets.symmetric(vertical: media.size.height * 0.018),
                      ),
                      child: const Text('Volver', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _openForm(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: media.size.height * 0.018),
                      ),
                      child: const Text('Agregar', style: TextStyle(color: Colors.white)),
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

  Widget _item(BuildContext context, Movimientomodel m) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.attach_money, color: Colors.white, size: 22),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.categoria, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text(m.descripcion ?? '', style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${m.monto?.toStringAsFixed(2) ?? '0.00'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _openForm(m),
                      child: Icon(Icons.edit, size: 20, color: Colors.blue),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        if (m.id != null) await _onDelete(m.id!);
                      },
                      child: Icon(Icons.delete, size: 20, color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
