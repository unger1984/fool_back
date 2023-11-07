import 'package:fool_back/data/models/turn_model.dart';
import 'package:fool_back/domain/entitities/round_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'round_model.freezed.dart';
part 'round_model.g.dart';

@freezed
class RoundModel with _$RoundModel {
  const RoundModel._();

  const factory RoundModel({
    required String uuid,
    required int userCount,
    required String status,
    @Default([]) List<String> clientUuids,
    String? nextClientUuid,
    @Default([]) List<TurnModel> turns,
  }) = _RoundModel;

  factory RoundModel.fromJson(Map<String, dynamic> json) => _$RoundModelFromJson(json);
  factory RoundModel.fromEntity(RoundEntity entity) => RoundModel(
        uuid: entity.uuid,
        userCount: entity.userCount,
        status: entity.status.toString(),
        clientUuids: entity.clientUuids,
        nextClientUuid: entity.nextClientUuid,
        turns: entity.turns.map((itm) => TurnModel.fromEntity(itm)).toList(),
      );
  RoundEntity toEntity() => RoundEntity(
        uuid: uuid,
        userCount: userCount,
        status: RoundStatus.fromString(status),
        clientUuids: clientUuids,
        nextClientUuid: nextClientUuid,
        turns: turns.map((itm) => itm.toEntity()).toList(),
      );
}
