import 'package:fool_back/domain/entitities/turn_entity.dart';

enum RoundStatus {
  active('active'),
  done('done'),
  wait('wait');

  final String _status;
  const RoundStatus(this._status);

  @override
  String toString() => _status;

  factory RoundStatus.fromString(String value) {
    switch (value) {
      case 'active':
        return active;
      case 'done':
        return done;
      case 'wait':
      default:
        return wait;
    }
  }
}

class RoundEntity {
  final String uuid;
  final int userCount;
  final RoundStatus status;
  final List<String> clientUuids;
  final String? nextClientUuid;
  final List<TurnEntity> turns;

  const RoundEntity({
    required this.uuid,
    required this.userCount,
    required this.status,
    this.clientUuids = const [],
    this.nextClientUuid,
    this.turns = const [],
  });

  RoundEntity copyWith({
    String? uuid,
    int? userCount,
    RoundStatus? status,
    List<String>? clientUuids,
    String? nextClientUuid,
    List<TurnEntity>? turns,
  }) {
    return RoundEntity(
      uuid: uuid ?? this.uuid,
      userCount: userCount ?? this.userCount,
      status: status ?? this.status,
      clientUuids: clientUuids ?? this.clientUuids,
      nextClientUuid: nextClientUuid ?? this.nextClientUuid,
      turns: turns ?? this.turns,
    );
  }
}
