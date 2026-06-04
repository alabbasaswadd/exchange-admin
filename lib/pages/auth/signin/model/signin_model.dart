import 'package:json_annotation/json_annotation.dart';

part 'signin_model.g.dart';

@JsonSerializable()
class SigninModel {
  final String? id;
  final String? token;
  final String? email;
  final String? password;

  SigninModel({this.id, this.token, this.email, this.password});

  factory SigninModel.fromJson(Map<String, dynamic> json) {
    return _$SigninModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SigninModelToJson(this);
  }
}
