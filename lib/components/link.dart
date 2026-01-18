import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatelessWidget {
    const Link({ super.key, required this.content, required this.href });
    final String content;
    final String href;

    @override
    Widget build(BuildContext context) {
        return TextButton(
            style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                minimumSize: WidgetStatePropertyAll(Size.zero)
            ),
            onPressed: () {
                launchUrl(Uri.parse(href));
            },
            child: Text(content, style: TextStyle(color: Colors.blue)),
        );
    }
}
