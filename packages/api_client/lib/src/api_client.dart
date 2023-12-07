import 'dart:async';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;

/// {@template api_client_error}
/// Error throw when accessing api failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class ApiClientError implements Exception {
  /// {@macro api_client_error}
  ApiClientError(this.cause, this.stackTrace);

  /// Error cause.
  final dynamic cause;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() {
    return cause.toString();
  }
}

/// Definition of a post call used by this client.
typedef PostCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// {@template api_client}
/// Client to access the api.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required String baseUrl,
    PostCall postCall = http.post,
    bool realApiEnabled = false,
  })  : _base = Uri.parse(baseUrl),
        _post = postCall,
        _realApiEnabled = realApiEnabled;

  final Uri _base;
  final PostCall _post;
  final bool _realApiEnabled;

  Map<String, String> get _headers => {};

  /// Questions resource.
  late final QuestionsResource questionsResource = QuestionsResource(
    apiClient: this,
    realApiEnabled: _realApiEnabled,
  );

  /// Sends a POST request with the given [body].
  Future<http.Response> post({
    Object? body,
  }) async {
    final response = await _post(
      _base,
      body: body,
      headers: _headers..addContentTypeJson(),
    );

    return response;
  }
}

extension on Map<String, String> {
  void addContentTypeJson() {
    addAll({HttpHeaders.contentTypeHeader: ContentType.json.value});
  }
}
