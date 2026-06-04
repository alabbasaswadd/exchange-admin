import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/auth/signin/api/signin_api_service.dart';
import 'package:exchange_admin/pages/auth/signin/model/signin_request_model.dart';
import 'package:exchange_admin/pages/auth/signin/model/signin_response_model.dart';

class SigninApi extends BaseApi {
  final SigninApiService _apiService;

  SigninApi(this._apiService);

  // Future<ApiResult<SigninResponseModel>> signin(
  //   SigninRequestModel request,
  // ) async {
  //   try {
  //     final response = await _apiService.signin(request);
  //     return ApiResult.success(response);
  //   } catch (e) {
  //     return ApiResult.failure(
  //       ErrorModel(message: ApiError.fromException(e), errors: {}),
  //     );
  //   }
  // }

  Future<ApiResult<SigninResponseModel>> signin(
    SigninRequestModel request,
  ) async {
    return execute(request: () => _apiService.signin(request));
  }
}
