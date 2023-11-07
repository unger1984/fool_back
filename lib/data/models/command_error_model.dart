import 'package:fool_back/domain/entitities/command_error_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_error_model.freezed.dart';
part 'command_error_model.g.dart';

@freezed
class CommandErrorModel with _$CommandErrorModel {
  const CommandErrorModel._();

  const factory CommandErrorModel({required String error}) = _CommandErrorModel;

  factory CommandErrorModel.fromJson(Map<String, dynamic> json) => _$CommandErrorModelFromJson(json);
  factory CommandErrorModel.fromEntity(CommandErrorEntity entity)=>CommandErrorModel(error: entity.error);
  CommandErrorEntity toEntity() => CommandErrorEntity(error: error);
}
