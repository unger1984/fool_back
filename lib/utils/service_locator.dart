import 'dart:async';

import 'package:fool_back/data/datasources/config_source_env.dart';
import 'package:fool_back/data/services/session_service_ws.dart';
import 'package:fool_back/domain/datasources/config_source.dart';
import 'package:fool_back/domain/services/session_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class ServiceLocator {
  static final _logDB = Logger('DatabaseProvider');

  static Future<void> setupGetIt() async {
    final configSource = ConfigSourceEnv();

    // final dbSource = DBSourcePostgres(
    //   host: configSource.dbhost,
    //   port: configSource.dbport,
    //   dbname: configSource.dbname,
    //   username: configSource.dbuser,
    //   password: configSource.dbpassword,
    //   logger: configSource.dbdebug ? _logDB.finest : null,
    // );
    // await dbSource.open();

    // Sources
    GetIt.I.registerSingleton<ConfigSource>(configSource);

    // Services
    GetIt.I.registerSingleton<SessionService>(SessionServiceWs());
  }
}
