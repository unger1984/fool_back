// ignore_for_file: prefer-static-class

import 'dart:async';
import 'dart:io';

import 'package:fool_back/domain/datasources/config_source.dart';
import 'package:fool_back/domain/entitities/client_session.dart';
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

  static WebSocketSession get _wsHandler {
    final _sessionService = GetIt.I<SessionService>();
    // Определяется при подключении.
    // ignore: avoid-late-keyword
    late ClientSession client;

    return WebSocketSession(
      onOpen: (ws) {
        client = _sessionService.addClient(ws);
      },
      onClose: (ws) {
        _sessionService.disconnectClient(client.uuid);
      },
      onMessage: (ws, message) {
        _logger.fine(client.uuid, message);
        _sessionService.send(client.uuid, "OK");
      },
    );
  }

  static Handler _init(int instanceNum) {
    final app = Router().plus;
    app.use(loggerMiddleware(instanceNum));
    app.get('/ws', () => _wsHandler);

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
      defaultShared: true,
    ));

    _logger.info(
      '[$num] Serving at ${config.debug ? 'https' : 'http'}://${config.host}:${config.port}',
    );
  }
}
