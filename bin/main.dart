// ignore_for_file: prefer-static-class

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:fool_back/domain/datasources/config_source.dart';
import 'package:fool_back/domain/datasources/pubsub_source.dart';
import 'package:fool_back/server.dart';
import 'package:fool_back/utils/logging.dart';
import 'package:fool_back/utils/service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('cluster', abbr: 'c', defaultsTo: '1')
    ..addFlag('production');
  final args = parser.parse(arguments);

  await ServiceLocator.setupGetIt();
  final config = GetIt.I<ConfigSource>();
  Logging.setupLogging(isDebug: config.debug);

  // Проверим подключение Redis
  try {
    await GetIt.I<PubSubSource>().test();
  } catch (_) {
    exit(0);
  }

  Timer.periodic(Duration(seconds: 1), (timer) {
    unawaited(GetIt.I<PubSubSource>().send("test", '${DateFormat('ss').format(DateTime.now())}'));
  });

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

  if (config.debug) {
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

Future<Isolate> createIsolate(int numInstance) {
  return Isolate.spawn(
    Server.run,
    [numInstance],
    onError: RawReceivePort(errorHandler).sendPort,
  );
}
