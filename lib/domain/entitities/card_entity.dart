enum CardSuit {
  clubs('clubs'), // трефы/крести
  diamonds('diamonds'), // бубны
  hearts('hearts'), // червы
  spades('spades'); // пики

  final String _suit;
  const CardSuit(this._suit);

  @override
  String toString() => _suit;

  factory CardSuit.fromString(String val) {
    switch (val) {
      case 'clubs':
        return clubs;
      case 'diamonds':
        return diamonds;
      case 'hearts':
        return hearts;
      case 'spades':
      default:
        return spades;
    }
  }
}

enum CardType {
  card10(10),
  card2(2),
  card3(3),
  card4(4),
  card5(5),
  card6(6),
  card7(7),
  card8(8),
  card9(9),
  cardAce(14),
  cardJack(11),
  cardKing(13),
  cardQueen(12);

  final int _type;
  const CardType(this._type);

  @override
  String toString() => _type.toString();

  int toInt() => _type;

  factory CardType.fromInt(int value) {
    switch (value) {
      case 14:
        return cardAce;
      case 13:
        return cardKing;
      case 12:
        return cardQueen;
      case 11:
        return cardJack;
      case 10:
        return card10;
      case 9:
        return card9;
      case 8:
        return card8;
      case 7:
        return card7;
      case 6:
        return card6;
      case 5:
        return card5;
      case 4:
        return card4;
      case 3:
        return card3;
      case 2:
      default:
        return card2;
    }
  }
}

class CardEntity {
  final CardSuit suit;
  final CardType type;

  const CardEntity({required this.suit, required this.type});

  static List<CardEntity> get generateFull {
    final res = <CardEntity>[];
    final suits = [CardSuit.clubs, CardSuit.diamonds, CardSuit.hearts, CardSuit.spades];
    for (final suit in suits) {
      for (int type = 2; type <= 14; type++) {
        res.add(CardEntity(suit: suit, type: CardType.fromInt(type)));
      }
    }
    res.shuffle();
    res.shuffle();
    res.shuffle();

    return res;
  }

  static List<CardEntity> get generateSmall {
    final res = <CardEntity>[];
    final suits = [CardSuit.clubs, CardSuit.diamonds, CardSuit.hearts, CardSuit.spades];
    for (final suit in suits) {
      for (int type = 6; type <= 14; type++) {
        res.add(CardEntity(suit: suit, type: CardType.fromInt(type)));
      }
    }
    res.shuffle();
    res.shuffle();
    res.shuffle();

    return res;
  }
}
