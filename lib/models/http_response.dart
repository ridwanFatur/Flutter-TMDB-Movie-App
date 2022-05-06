class HTTPResponse {
  final String? message;
  final bool isSuccessful;
  final dynamic data;
  final int? responseCode;

  HTTPResponse({
    this.message,
    required this.isSuccessful,
    this.data,
    this.responseCode,
  });

  Map<String, dynamic> toMap() => {
        "message": message,
        "isSuccessful": isSuccessful,
        "data": data,
        "responseCode": responseCode,
      };
}
