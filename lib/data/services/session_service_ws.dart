import 'package:fool_back/domain/entitities/client_session.dart';
import 'package:fool_back/domain/services/session_service.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:uuid/uuid.dart';

class SessionServiceWs extends SessionService {
  static final _logger = Logger('SessionServiceWs');
  final _uuid = Uuid();
  final _sessions = <ClientSession>[];

  @override
  ClientSession addClient(Object value) {
    final ws = value as WebSocketSession;
    final client = ClientSession(uuid: _uuid.v4(), send: (msg) => ws.send(msg), close: () => ws.close());
    _sessions.add(client);

    return client;
  }

  @override
  void disconnectClient(String uuid) {
    final index = _sessions.indexWhere((element) => element.uuid == uuid);
    if (index > -1) {
      _sessions[index] = _sessions.elementAt(index).copyWith(online: false);
    }
  }

  @override
  List<ClientSession> get sessions => _sessions;
}
