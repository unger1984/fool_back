// ignore_for_file: prefer-static-class

import 'dart:isolate';

import 'package:args/args.dart';
import 'package:fool_back/domain/datasources/config_source.dart';
import 'package:fool_back/server.dart';
import 'package:fool_back/utils/logging.dart';
import 'package:fool_back/utils/service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:logging/logging.dart';

Future<void> main(List<String> arguments) async {
  // final info = (await Service.getInfo()).serverUri;
  // print(info);
  final parser = ArgParser()
    ..addOption('cluster', abbr: 'c', defaultsTo: '1')
    ..addFlag('production');
  final args = parser.parse(arguments);

  await ServiceLocator.setupGetIt();
  final config = GetIt.I<ConfigSource>();
  Logging.setupLogging(isDebug: config.debug);

  // подключение к БД
  // final conn = GetIt.I<DBSource>();

  // запуск миграций
  // final migration = Migrate(conn);
  // await migration.up();

  // парсим аргументы
  int cluster = int.parse(args['cluster']);

  // запускаем заданное число изолятов
  List<Future<Isolate>> isolates = <Future<Isolate>>[];
  for (int index = 0; index < cluster; index++) {
    isolates.add(createIsolate(index + 1));
  }
  // Это полный список запущенных изолятов.
  // ignore: move-variable-closer-to-its-usage
  List<Isolate> res = await Future.wait<Isolate>(isolates);

  // reloader.stop();

  if (config.debug) {
    HotReloader.logLevel = Level.OFF;
    await HotReloader.create(
      onAfterReload: (ctx) => () async {
        for (Isolate iso in res) {
          iso.kill();
        }
        for (int index = 0; index < cluster; index++) {
          isolates.add(createIsolate(index + 1));
        }
        res = await Future.wait(isolates);
      },
    );
  }
}

// Я не знаю что эта падла сюда передает!
// ignore: avoid-dynamic
void errorHandler(List<dynamic> pair) {
  // Я не знаю что эта падла сюда передает!
  // ignore: avoid-dynamic
  List<dynamic> isolateError = pair;
  Logger('IOERROR').shout(isolateError);
}

Future<Isolate> createIsolate(int num) {
  return Isolate.spawn(
    Server.run,
    [num],
    onError: RawReceivePort(errorHandler).sendPort,
  );
}
