import 'package:fool_back/data/models/card_model.dart';
import 'package:fool_back/domain/entitities/turn_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'turn_model.freezed.dart';
part 'turn_model.g.dart';

@freezed
class TurnModel with _$TurnModel {
  const TurnModel._();

  const factory TurnModel({required String type, List<CardModel>? cards}) = _TurnModel;

  factory TurnModel.fromJson(Map<String, dynamic> json) => _$TurnModelFromJson(json);
  factory TurnModel.fromEntity(TurnEntity entity) => TurnModel(
        type: entity.type.toString(),
        cards: entity.cards?.map((itm) => CardModel.fromEntity(itm)).toList(),
      );
  TurnEntity toEntity() => TurnEntity(
        type: TurnType.fromString(type),
        cards: cards?.map((itm) => itm.toEntity()).toList(),
      );
}
