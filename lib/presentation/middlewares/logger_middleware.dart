// ignore_for_file: prefer-static-class

import 'package:logging/logging.dart';
import 'package:shelf_plus/shelf_plus.dart';

Middleware loggerMiddleware(int instanceNum) => (Handler innerHandler) {
      return (Request request) async {
        final start = DateTime.now();
        final inner = innerHandler(request);
        final innerResponse = inner is Future ? await inner : inner;
        final time = DateTime.now().difference(start).inMilliseconds;
        Logger('server').fine('[$instanceNum] ${request.method} ${request.requestedUri} ${time}ms');

        return innerResponse;
      };
    };
