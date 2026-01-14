import '../models/movimientoModel.dart';
import '../settings/database_connection.dart';

class MovimientosRepository {
  final String tableName = 'movimientos';
  final database = DatabaseConnection();

  Future<int> create(Movimientomodel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  Future<int> edit(Movimientomodel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id=?',
      whereArgs: [data.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database.db;
    return await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<List<Movimientomodel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName);
    return response.map((e) => Movimientomodel.fromMap(e)).toList();
  }
}
