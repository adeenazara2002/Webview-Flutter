import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Important for platform views
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  String _url = "https://flutter.dev";

  @override
  void initState() {
    super.initState();
    // This is necessary for Android devices
    if (WebViewPlatform.instance == null) {
      WebViewPlatform.instance = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Example"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (String url) {
          setState(() {
            _url = url;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                _controller.loadUrl("https://flutter.dev");
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _controller.canGoBack().then((value) {
                  if (value) {
                    _controller.goBack();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                _controller.canGoForward().then((value) {
                  if (value) {
                    _controller.goForward();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
