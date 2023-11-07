import 'dart:convert';

import 'package:fool_back/data/models/command_auth_model.dart';
import 'package:fool_back/data/models/message_model.dart';
import 'package:fool_back/domain/controllers/client_controller.dart';
import 'package:fool_back/domain/entitities/message_entity.dart';
import 'package:logging/logging.dart';
import 'package:shelf_plus/shelf_plus.dart';

class ClientControllerImpl extends ClientController {
  late final _logger = Logger('ClientControllerImpl $uuid');
  // В конструкторе.
  // ignore: avoid-late-keyword
  late WebSocketSession _webSocketSession;

  ClientControllerImpl({required super.sessionService, required super.uuid}) {
    _webSocketSession = WebSocketSession(
      onMessage: (__, message) => onMessage(jsonDecode(message)),
      onClose: (__) => onClose(),
      onError: (__, exception) {
        _logger.severe('onError', exception);
        onClose();
      },
      onOpen: (__) {
        send(MessageEntity(command: Command.auth, data: CommandAuthModel(uuid: uuid).toJson()));
      },
    );
  }

  WebSocketSession get webSocketSession => _webSocketSession;

  @override
  void dispose() {
    _webSocketSession.close();
  }

  @override
  void onMessage(Map<String, dynamic> msg) {
    try {
      final message = MessageModel.fromJson(msg).toEntity();
      switch (message.command) {
        case Command.auth:
          cmdAuth(CommandAuthModel.fromJson(message.data).toEntity());
          break;
      }
    } catch (exception, stack) {
      _logger.severe('onMessage', exception, stack);
    }
  }

  @override
  void send(MessageEntity message) {
    try {
      _webSocketSession.send(jsonEncode(MessageModel.fromEntity(message).toJson()));
    } catch (exception, stack) {
      _logger.severe('send', exception, stack);
    }
  }
}
