import 'package:json_annotation/json_annotation.dart';

part 'update_request_status_model.g.dart';

@JsonSerializable()
class UpdateRequestStatusModel {
  final String status;
  final String? notes;

  const UpdateRequestStatusModel({required this.status, this.notes});

  factory UpdateRequestStatusModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateRequestStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRequestStatusModelToJson(this);
}
