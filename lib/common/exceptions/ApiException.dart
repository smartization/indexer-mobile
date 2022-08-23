class ApiException {
  String reason;
  String code;

  ApiException({required this.reason, required this.code});
}