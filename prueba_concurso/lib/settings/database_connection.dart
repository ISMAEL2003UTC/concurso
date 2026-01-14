import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' ;

class DatabaseConnection {
  //generando un constructor para el llamado 
  static final DatabaseConnection instance = DatabaseConnection.internal();
  factory DatabaseConnection()=>instance;
  //referencias internas 
  DatabaseConnection.internal();

  //crear un llamado de la libreria sqflite
  //Database es una clase propio de sqflite y lo trabajamos como un tipo de dato
  static Database? database;
  //función para crear la conexión ala base de datos
  Future<Database> get db async {
    if(database != null ) return database!; //retorna la conexion si ya existia una antes
    database = await inicializarDb();// inicializa la conexión en la función 
    return database!; // retorna la conexion con la nueva conexion 
  }
  Future<Database>inicializarDb() async {
    final rutaDb = await getDatabasesPath(); // /data/emulated/0/gestion <- ruta de prueba 
    final rutaFinal = join(rutaDb,'gestorGastos.db'); // /data/emulated/0/gestion/gestion.db <- ruta final

    return await openDatabase(rutaFinal,
    version: 1,
    onOpen: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    onCreate:(Database db , int version )async{
      // TABLA USUARIOS
      await db.execute('''
      CREATE TABLE movimientos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT,
        categoria TEXT NOT NULL,
        monto REAL NOT NULL,
        tipo TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
      ''');

    } );
  }

}
