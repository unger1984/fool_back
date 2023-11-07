import 'package:fool_back/domain/entitities/message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String command,
    @Default({}) Map<String, dynamic> data,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  factory MessageModel.fromEntity(MessageEntity entity) => MessageModel(
        command: entity.command.toString(),
        data: entity.data,
      );

  MessageEntity toEntity() => MessageEntity(command: Command.fromString(command), data: data);
}
