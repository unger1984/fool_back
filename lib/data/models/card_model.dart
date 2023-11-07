import 'package:fool_back/domain/entitities/card_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
class CardModel with _$CardModel {
  const CardModel._();

  const factory CardModel({required String suit, required int type}) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);
  factory CardModel.fromEntity(CardEntity entity) => CardModel(suit: entity.suit.toString(), type: entity.type.toInt());
  CardEntity toEntity() => CardEntity(suit: CardSuit.fromString(suit), type: CardType.fromInt(type));
}
