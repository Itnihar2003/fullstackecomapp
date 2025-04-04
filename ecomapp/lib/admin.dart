import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class adminpannel extends StatefulWidget {
  const adminpannel({super.key});

  @override
  State<adminpannel> createState() => _adminpannelState();
}

class _adminpannelState extends State<adminpannel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onHttpError: (HttpResponseError error) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse('http://10.0.2.2:8000/brand//'))),
    );
  }
}
