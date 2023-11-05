import 'package:fool_back/domain/datasources/config_source.dart';
import 'package:fool_back/domain/datasources/pubsub_source.dart';
import 'package:logging/logging.dart';
import 'package:redis/redis.dart';

class Subscribtion {
  final Command command;
  final PubSub pubSub;

  const Subscribtion({required this.command, required this.pubSub});
}

class PubSubSourceRedis extends PubSubSource {
  static final _logger = Logger('PubSubSourceRedis');
  final ConfigSource _configSource;
  final _pubSubMap = <String, Subscribtion>{};
  Command? _sendCommand;

  PubSubSourceRedis({required ConfigSource configSource}) : _configSource = configSource;

  @override
  Future<void> test() async {
    try {
      _sendCommand ??= await RedisConnection().connect(_configSource.redisHost, _configSource.redisPort);
    } catch (exception, stack) {
      _logger.severe('send', exception, stack);
      rethrow;
    }
  }

  @override
  Future<void> send(String channel, String message) async {
    try {
      _sendCommand ??= await RedisConnection().connect(_configSource.redisHost, _configSource.redisPort);
      final cmd = _sendCommand;
      if (cmd == null) throw Exception('Not connected');
      await cmd.send_object(["PUBLISH", channel, message]);
    } catch (exception, stack) {
      _logger.severe('send', exception, stack);
    }
  }

  @override
  // Автор redis пакета недоработал (.
  // ignore: avoid-dynamic
  Future<void> subscribe(String channel, void Function(dynamic event) listener) async {
    try {
      final cmd = await RedisConnection().connect(_configSource.redisHost, _configSource.redisPort);
      final pubSub = PubSub(cmd);
      pubSub.subscribe([channel]);
      _pubSubMap[channel] = Subscribtion(command: cmd, pubSub: pubSub);
      pubSub.getStream().listen(listener);
    } catch (exception, stack) {
      _logger.severe('subscribe', exception, stack);
    }
  }

  @override
  Future<void> unsubscribe(String channel) async {
    try {
      if (_pubSubMap.containsKey(channel)) {
        final subscribtion = _pubSubMap[channel];
        if (subscribtion != null) {
          subscribtion.pubSub.unsubscribe([channel]);
          await subscribtion.command.get_connection().close();
          _pubSubMap.remove(channel);
        }
      }
    } catch (exception, stack) {
      _logger.severe('unsubscribe', exception, stack);
    }
  }
}
