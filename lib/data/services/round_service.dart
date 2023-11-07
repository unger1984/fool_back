import 'package:fool_back/domain/entitities/round_entity.dart';

abstract class RoundService {
  List<RoundEntity> get rounds;
  RoundEntity? create({String? title, int count = 2});
}
