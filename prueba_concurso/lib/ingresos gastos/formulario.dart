import 'package:flutter/material.dart';

import '../models/movimientoModel.dart';
import '../repositories/movimientos_repository.dart';

class MovimientosFormScreen extends StatefulWidget {
  const MovimientosFormScreen({super.key});

  @override
  State<MovimientosFormScreen> createState() => _MovimientosFormScreenState();
}

class _MovimientosFormScreenState extends State<MovimientosFormScreen> {
  final formMovimiento = GlobalKey<FormState>();

  final descripcionController = TextEditingController();
  final categoriaController = TextEditingController();
  final montoController = TextEditingController();
  final tipoController = TextEditingController();
  final fechaController = TextEditingController();

  Movimientomodel? movimiento;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      movimiento = args as Movimientomodel;
      descripcionController.text = movimiento!.descripcion ?? '';
      categoriaController.text = movimiento!.categoria ?? '';
      montoController.text = movimiento!.monto?.toString() ?? '';
      tipoController.text = movimiento!.tipo ?? '';
      fechaController.text = movimiento!.fecha ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = movimiento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar movimiento' : 'Formulario de Ingresos y Gastos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formMovimiento,
          child: Column(
            children: [

              // DESCRIPCIÓN
              TextFormField(
                controller: descripcionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese la descripción',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // CATEGORÍA
              TextFormField(
                controller: categoriaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La categoría es obligatoria';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Ingrese la categoría',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // MONTO
              TextFormField(
                controller: montoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El monto es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Monto',
                  hintText: 'Ingrese el monto',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // TIPO
              TextFormField(
                controller: tipoController,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  hintText: 'Ingreso o Gasto',
                  prefixIcon: Icon(Icons.swap_vert),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // FECHA
              TextFormField(
                controller: fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'DD/MM/AAAA',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 80),

              // BOTONES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (formMovimiento.currentState!.validate()) {
                          final repositorio = MovimientosRepository();
                          final movimiento = Movimientomodel(
                            descripcion: descripcionController.text,
                            categoria: categoriaController.text,
                            monto: double.parse(montoController.text),
                            tipo: tipoController.text,
                            fecha: fechaController.text,
                          );

                          if (esEditar) {
                            movimiento.id = this.movimiento!.id;
                            await repositorio.edit(movimiento);
                          } else {
                            await repositorio.create(movimiento);
                          }

                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Guardar', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  SizedBox(width: 5),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                      ),
                      child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
