enum Command {
  auth('auth');

  final String _cmd;
  const Command(this._cmd);

  @override
  String toString() => _cmd;

  factory Command.fromString(String value) {
    switch (value) {
      case 'auth':
      default:
        return Command.auth;
    }
  }
}

class MessageEntity {
  final Command command;
  final Map<String, dynamic> data;

  const MessageEntity({required this.command, required this.data});
}
