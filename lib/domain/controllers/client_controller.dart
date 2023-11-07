import 'package:fool_back/domain/entitities/command_auth_entity.dart';
import 'package:fool_back/domain/entitities/message_entity.dart';
import 'package:fool_back/domain/services/session_service.dart';

abstract class ClientController {
  String uuid;
  final SessionService _sessionService;
  DateTime? offline;

  ClientController({
    required SessionService sessionService,
    required this.uuid,
  }) : _sessionService = sessionService;

  void onClose() {
    offline = DateTime.now();
  }

  void dispose();
  void onMessage(Map<String, dynamic> msg);
  void send(MessageEntity message);

  void cmdAuth(CommandAuthEntity auth) {
    final old = _sessionService.getByUuid(auth.uuid);
    if (old != null) {
      _sessionService.removeByUuid(old.uuid);
      // TODO скопировать игру.
    }
    uuid = auth.uuid;
  }
}
