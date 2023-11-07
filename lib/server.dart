// ignore_for_file: prefer-static-class

import 'dart:async';
import 'dart:io';

import 'package:fool_back/domain/datasources/config_source.dart';
import 'package:fool_back/domain/services/session_service.dart';
import 'package:fool_back/presentation/middlewares/logger_middleware.dart';
import 'package:fool_back/utils/logging.dart';
import 'package:fool_back/utils/service_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/shelf_plus.dart';

class Server {
  static final _logger = Logger('Server');
  static const serverKey = 'cert/key.pem';
  static const certificateChain = 'cert/chain.pem';

  static Handler _init(int instanceNum) {
    final sessionService = GetIt.I<SessionService>();

    final app = Router().plus;
    app.use(loggerMiddleware(instanceNum));
    app.get('/ws', () => sessionService.addClient());

    return app.call;
  }

  // Тут вообще передают всякое
  // ignore: avoid-dynamic
  static void run(List<dynamic> args) async {
    await ServiceLocator.setupGetIt();
    final config = GetIt.I<ConfigSource>();
    Logging.setupLogging(isDebug: config.debug);
    final instanceNum = (args.firstOrNull ?? 0) as int;

    // подключаем SSL сертификаты для локалхост
    SecurityContext? serverContext;
    if (config.debug) {
      serverContext = SecurityContext();
      serverContext.useCertificateChainBytes(await File(certificateChain).readAsBytes());
      serverContext.usePrivateKey(serverKey);
    }

    unawaited(shelfRun(
      () => _init(instanceNum),
      defaultBindAddress: config.host,
      defaultBindPort: config.port,
      securityContext: serverContext,
      // defaultShared: true,
    ));

    _logger.info(
      '[$num] Serving at ${config.debug ? 'https' : 'http'}://${config.host}:${config.port}',
    );
  }
}
