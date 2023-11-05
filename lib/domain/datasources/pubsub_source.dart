abstract class PubSubSource {
  Future<void> test();
  Future<void> send(String channel, String message);
  // Автор redis пакета недоработал (.
  // ignore: avoid-dynamic
  Future<void> subscribe(String channel, void Function(dynamic event) listener);
  Future<void> unsubscribe(String channel);
}
