class ApiConstants {
  static const String apiBaseUrl =
      "https://shamcash.runasp.net/currency-exchange-api/api/";

  static const String signin = "User/Auth/login";

  // Exchange Rates
  static const String exchangeRates = "v1/ExchangeRate";
  static const String exchangeRateActive = "v1/ExchangeRate/Active";
  static const String exchangeRateById = "v1/ExchangeRate/{id}";

  // Currencies
  static const String currencies = "v1/Currency";
  static const String currencyById = "v1/Currency/{id}";

  // Exchange Requests
  static const String exchangeRequests = "v1/ExchangeRequest";
  static const String exchangeRequestById = "v1/ExchangeRequest/{id}";
  static const String exchangeRequestStatus = "v1/ExchangeRequest/{id}/Status";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
