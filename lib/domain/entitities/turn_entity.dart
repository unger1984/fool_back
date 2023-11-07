import 'package:fool_back/domain/entitities/card_entity.dart';

enum TurnType {
  add('add'), // докинуть карты если взял
  attack('attack'), // аттака/отбой
  confirm('confirm'), // хорошо, взять недостающие карты
  take('take'); // беру

  final String _type;
  const TurnType(this._type);

  @override
  String toString() => _type;

  factory TurnType.fromString(String value) {
    switch (value) {
      case 'confirm':
        return confirm;
      case 'take':
        return take;
      case 'attack':
      default:
        return attack;
    }
  }
}

class TurnEntity {
  final TurnType type;
  final List<CardEntity>? cards;

  const TurnEntity({required this.type, this.cards});
}
