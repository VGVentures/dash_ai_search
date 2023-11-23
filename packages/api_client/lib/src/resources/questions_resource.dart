import 'dart:convert';

import 'package:api_client/api_client.dart';

/// {@template questions_resource}
/// An api resource to get response to question from the VERTEX api
/// {@endtemplate}
class QuestionsResource {
  /// {@macro questions_resource}
  const QuestionsResource({
    required ApiClient apiClient,
    bool realApiEnabled = false,
  })  : _apiClient = apiClient,
        _realApiEnabled = realApiEnabled;

  final ApiClient _apiClient;
  final bool _realApiEnabled;

  /// Returns [VertexResponse] based on a query.
  ///
  Future<VertexResponse> getVertexResponse(String query) async {
    String body;
    if (_realApiEnabled) {
      final response = await _apiClient.get(
        // TODO(oscar): update with real API once is enabled
        // and add possible failures.
        'google.es',
        queryParameters: {
          'query': query,
        },
      );
      if (response.statusCode != 200) {
        throw ApiClientError(
          'GET getVertexResponse with query=$query '
          'returned status ${response.statusCode} '
          'with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
      body = response.body;
    } else {
      await Future<void>.delayed(const Duration(seconds: 1));
      body = jsonFile;
    }

    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return VertexResponse.fromJson(json);
    } catch (e) {
      throw ApiClientError(
        'GET getVertexResponse with query=$query '
        'returned invalid response "$body"',
        StackTrace.current,
      );
    }
  }
}

String jsonFile = '''
{
    "summary": "Flutter is a free and open source software development kit (SDK) from Google [1]. It's used to create beautiful, fast user experiences for mobile, web, and desktop applications [1]. Flutter works with existing code and is used by developers and organizations around the world [1]. [3]. Flutter is a fully open source project [3].",
    "total_size": 694,
    "attribution_token": "X_BeCgwI4tH4qgYQvqzHpwESJDY1NWQ3NjljLTAwMDAtMmYyYS1iZDUzLTg4M2QyNGY2MWNiNCIHR0VORVJJQyogjr6dFdSynRWmi-8XwvCeFcXL8xecho4iooaOIqOAlyI",
    "next_page_token": "QjYjFjNmRjMkNDO40yM1QmYtEmMmJTLwADMw0iY5YzNkVTN2QiGCopmOvNEGsKi6SOCMIBMxIgC",
    "documents": [
        {
            "id": "49e63c23-8376-440a-ac6e-98675fdd023e",
            "metadata": {
                "url": "https://api.flutter.dev/index.html",
                "title": "Flutter - Dart API docs",
                "tags": "missing",
                "keywords": null,
                "description": "Flutter API docs, for the Dart programming language.",
                "image_uri": null
            },
            "link": "https://api.flutter.dev/index.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-index-html.html",
            "snippets": [
                "inspector. dart:math Mathematical constants and functions, plus a random number generator. dart:typed_data Lists that efficiently handle fixed sized data (for&nbsp;..."
            ]
        },
        {
            "id": "af6dcbfb-f11b-443f-8af0-5bdcfcdd8102",
            "metadata": {
                "url": "https://api.flutter.dev/javadoc/io/flutter/embedding/engine/FlutterEngine.html",
                "title": "FlutterEngine",
                "tags": "missing",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/javadoc/io/flutter/embedding/engine/FlutterEngine.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-javadoc-io-flutter-embedding-engine-flutterengine-html.html",
            "snippets": [
                "to be notified of <b>Flutter</b> ... LocalizationPlugin getLocalizationPlugin() The LocalizationPlugin this <b>FlutterEngine</b> created. MouseCursorChannel&nbsp;..."
            ]
        },
        {
            "id": "2746919b-8bf2-4c5b-8289-742b533da9fa",
            "metadata": {
                "url": "https://api.flutter.dev/objcdoc/",
                "title": "Flutter  Reference",
                "tags": "mock",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/objcdoc/",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-objcdoc.html",
            "snippets": [
                "... <b>FlutterStandardMessageCodec FlutterStandardMethodCodec FlutterStandardReader FlutterStandardReaderWriter FlutterStandardTypedData FlutterStandardWriter</b>&nbsp;..."
            ]
        },
        {
            "id": "88318aee-2f63-456b-8ea0-1a5dd90b0ef3",
            "metadata": {
                "url": "https://api.flutter.dev/javadoc/io/flutter/app/package-summary.html",
                "title": "io.flutter.app",
                "tags": "fake",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/javadoc/io/flutter/app/package-summary.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-javadoc-io-flutter-app-package-summary-html.html",
            "snippets": []
        },
        {
            "id": "140f1ff5-9c62-4e4e-ba47-fcdb7c96de33",
            "metadata": {
                "url": "https://api.flutter.dev/objcdoc/Classes/FlutterEngine.html",
                "title": "FlutterEngine Class Reference",
                "tags": "missing",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/objcdoc/Classes/FlutterEngine.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-objcdoc-classes-flutterengine-html.html",
            "snippets": [
                "libraryURI: String?, initialRoute: String?) -&gt; Bool Parameters entrypoint The name of a top-level function from a Dart library. If this is&nbsp;..."
            ]
        },
        {
            "id": "57980044-93db-430a-a0dd-caacb6e0830c",
            "metadata": {
                "url": "https://api.flutter.dev/javadoc/io/flutter/embedding/android/FlutterActivity.html",
                "title": "FlutterActivity",
                "tags": "fake",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/javadoc/io/flutter/embedding/android/FlutterActivity.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-javadoc-io-flutter-embedding-android-flutteractivity-html.html",
            "snippets": [
                "FlutterFragment. If <b>Flutter</b> ... ACCOUNT_SERVICE, ACTIVITY_SERVICE, ALARM_SERVICE, APP_OPS_SERVICE, APP_SEARCH_SERVICE, APPWIDGET_SERVICE, AUDIO_SERVICE,&nbsp;..."
            ]
        },
        {
            "id": "f961196f-7a50-4296-9867-20d94d5c92f4",
            "metadata": {
                "url": "https://api.flutter.dev/objcdoc/Classes/FlutterViewController.html",
                "title": "FlutterViewController Class Reference",
                "tags": "unknown",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/objcdoc/Classes/FlutterViewController.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-objcdoc-classes-flutterviewcontroller-html.html",
            "snippets": [
                "... Swift init(coder aDecoder: NSCoder) -<b>setFlutterViewDidRenderCallback</b>: Registers a callback that will be invoked when the <b>Flutter</b> view has been rendered."
            ]
        },
        {
            "id": "70177a4a-78fd-4540-91d1-165f918cd4f4",
            "metadata": {
                "url": "https://api.flutter.dev/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html",
                "title": "FlutterPlugin",
                "tags": "unknown",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-javadoc-io-flutter-embedding-engine-plugins-flutterplugin-html.html",
            "snippets": [
                "your browser. Summary: Nested | Field | Constr | Method Detail: Field | Constr | Method. https api <b>flutter</b> dev javadoc io <b>flutter</b> embedding engine plugins&nbsp;..."
            ]
        },
        {
            "id": "3821e382-276d-43b7-8368-0f9f9b9268d0",
            "metadata": {
                "url": "https://api.flutter.dev/flutter/widgets/Navigator-class.html",
                "title": "Navigator class - widgets library - Dart API",
                "tags": "unknown",
                "keywords": null,
                "description": "API docs for the Navigator class from the widgets library, for the Dart programming language.",
                "image_uri": null
            },
            "link": "https://api.flutter.dev/flutter/widgets/Navigator-class.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-flutter-widgets-navigator-class-html.html",
            "snippets": [
                "pushed route&#39;s Future as described above. Callers can await the returned value to take an action when the route is popped, or to discover the route&#39;s value."
            ]
        },
        {
            "id": "c3cd5194-8da3-4809-a88a-cc4ad1026871",
            "metadata": {
                "url": "https://api.flutter.dev/objcdoc/Classes/FlutterAppDelegate.html",
                "title": "FlutterAppDelegate Class Reference",
                "tags": "fake",
                "keywords": null,
                "description": null,
                "image_uri": null
            },
            "link": "https://api.flutter.dev/objcdoc/Classes/FlutterAppDelegate.html",
            "doc_link": "gs://flutter-vertex-ai-demo-docs-v1/api-flutter-dev-objcdoc-classes-flutterappdelegate-html.html",
            "snippets": []
        }
    ]
}
''';
