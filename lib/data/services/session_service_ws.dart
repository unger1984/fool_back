import 'package:fool_back/data/controllers/client_controller_impl.dart';
import 'package:fool_back/domain/controllers/client_controller.dart';
import 'package:fool_back/domain/services/session_service.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:uuid/uuid.dart';

class SessionServiceWs extends SessionService {
  final _uuid = Uuid();
  @override
  final clients = <ClientController>[];

  @override
  WebSocketSession addClient() {
    final client = ClientControllerImpl(uuid: _uuid.v4(), sessionService: this);
    clients.add(client);

    return client.webSocketSession;
  }

  @override
  void removeByUuid(String uuid) {
    final index = clients.indexWhere((element) => element.uuid == uuid);
    if (index >= 0) {
      clients.elementAt(index).dispose();
      clients.removeWhere((element) => element.uuid == uuid);
    }
  }
}
