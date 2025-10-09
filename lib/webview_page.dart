import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      // ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setNavigationDelegate(
      //   NavigationDelegate(
      //     onProgress: (int progress) {
      //       setState(() {
      //         loadingPercentage = progress;
      //       });
      //     },
      //     onPageStarted: (String url) {
      //       setState(() {
      //         loadingPercentage = 0;
      //       });
      //     },
      //     onPageFinished: (String url) {
      //       setState(() {
      //         loadingPercentage = 100;
      //       });
      //     },
      //     onWebResourceError: (WebResourceError error) {
      //       // Anda bisa menampilkan pesan error di sini jika perlu
      //       debugPrint('''
      //         Page resource error:
      //           code: ${error.errorCode}
      //           description: ${error.description}
      //           errorType: ${error.errorType}
      //           isForMainFrame: ${error.isForMainFrame}
      //       ''');
      //     },
      //     onNavigationRequest: (NavigationRequest request) {
      //       if (request.url.startsWith('https://www.youtube.com/')) {
      //         debugPrint('Blocking navigation to ${request.url}');
      //         return NavigationDecision.prevent;
      //       }
      //       debugPrint('Allowing navigation to ${request.url}');
      //       return NavigationDecision.navigate;
      //     },
      //   ),
      // )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(value: loadingPercentage / 100.0),
        ],
      ),
    );
  }
}
