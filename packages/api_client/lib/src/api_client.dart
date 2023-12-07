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

/// Definition of a patch call used by this client.
typedef PatchCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a put call used by this client.
typedef PutCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a get call used by this client.
typedef GetCall = Future<http.Response> Function(
  Uri, {
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
    PutCall putCall = http.put,
    PatchCall patchCall = http.patch,
    GetCall getCall = http.get,
    bool realApiEnabled = false,
  })  : _base = Uri.parse(baseUrl),
        _post = postCall,
        _put = putCall,
        _patch = patchCall,
        _get = getCall,
        _realApiEnabled = realApiEnabled;

  final Uri _base;
  final PostCall _post;
  final PostCall _put;
  final PatchCall _patch;
  final GetCall _get;
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
    Map<String, String>? queryParameters,
  }) async {
    final response = await _post(
      _base,
      body: body,
      headers: _headers..addContentTypeJson(),
    );

    return response;
  }

  /// Sends a PATCH request to the specified [path] with the given [body].
  Future<http.Response> patch(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    final response = await _patch(
      _base.replace(
        path: path,
        queryParameters: queryParameters,
      ),
      body: body,
      headers: _headers..addContentTypeJson(),
    );

    return response;
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  Future<http.Response> put(
    String path, {
    Object? body,
  }) async {
    final response = await _put(
      _base.replace(path: path),
      body: body,
      headers: _headers..addContentTypeJson(),
    );

    return response;
  }

  /// Sends a GET request to the specified [path].
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _get(
      _base.replace(
        path: path,
        queryParameters: queryParameters,
      ),
      headers: _headers,
    );

    return response;
  }
}

extension on Map<String, String> {
  void addContentTypeJson() {
    addAll({HttpHeaders.contentTypeHeader: ContentType.json.value});
  }
}
