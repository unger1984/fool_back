import 'package:fool_back/domain/entitities/command_auth_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_auth_model.freezed.dart';
part 'command_auth_model.g.dart';

@freezed
class CommandAuthModel with _$CommandAuthModel {
  const CommandAuthModel._();

  const factory CommandAuthModel({required String uuid}) = _CommandAuthModel;

  factory CommandAuthModel.fromJson(Map<String, dynamic> json) => _$CommandAuthModelFromJson(json);

  factory CommandAuthModel.fromEntity(CommandAuthEntity entity) => CommandAuthModel(uuid: entity.uuid);

  CommandAuthEntity toEntity() => CommandAuthEntity(uuid: uuid);
}
