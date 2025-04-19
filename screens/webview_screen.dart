import 'package:flutter/material.dart';
import 'package:pingpass/widgets/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter.dev/showcase'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Flutter',
          showBackButton: false,
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: WebViewWidget(controller: _controller),
        ));
  }
}
