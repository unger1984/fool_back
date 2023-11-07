import 'package:collection/collection.dart';
import 'package:fool_back/domain/controllers/client_controller.dart';
import 'package:fool_back/domain/entitities/message_entity.dart';
import 'package:shelf_plus/shelf_plus.dart';

abstract class SessionService {
  List<ClientController> get clients;
  WebSocketSession addClient();

  void send(String uuid, MessageEntity message) {
    clients.firstWhereOrNull((itm) => itm.uuid == uuid)?.send(message);
  }

  ClientController? getByUuid(String uuid) => clients.firstWhereOrNull((element) => element.uuid == uuid);
  void removeByUuid(String uuid);
}
