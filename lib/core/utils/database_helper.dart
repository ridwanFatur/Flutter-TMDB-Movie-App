import 'dart:async';
import 'package:tmdb_movie_app/core/utils/local_database_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalDatabase {
  static final LocalDatabase _singleton = LocalDatabase._();
  static LocalDatabase get instance => _singleton;
  Completer<Database>? _dbOpenCompleter;

  LocalDatabase._();

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, SembastConfig.kDatabaseName);
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
  }
}