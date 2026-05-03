class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<FieldError>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && dataParser != null
          ? dataParser(json['data'])
          : null,
      errors: json['errors'] != null
          ? (json['errors'] as List)
              .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class FieldError {
  final String field;
  final String message;

  FieldError({required this.field, required this.message});

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      field: json['field'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}
