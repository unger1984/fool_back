class ClientSession {
  final String uuid;
  final bool online;
  final void Function(String message) send;
  final void Function() close;

  const ClientSession({required this.uuid, required this.send, required this.close, this.online = true});

  ClientSession copyWith({
    String? uuid,
    bool? online,
    void Function(String message)? send,
    void Function()? close,
  }) {
    return ClientSession(
      uuid: uuid ?? this.uuid,
      online: online ?? this.online,
      send: send ?? this.send,
      close: close ?? this.close,
    );
  }
}
