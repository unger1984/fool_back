import 'package:collection/collection.dart';
import 'package:fool_back/domain/entitities/client_session.dart';

abstract class SessionService {
  List<ClientSession> get sessions;
  ClientSession addClient(Object value);
  void disconnectClient(String uuid);

  void send(String uuid, String message) {
    sessions.firstWhereOrNull((itm) => itm.uuid == uuid)?.send(message);
  }
}
