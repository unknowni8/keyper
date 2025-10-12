import 'package:flutter/material.dart';
import 'package:keyper/l10n/l10n.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({required this.uri, super.key});

  /// The uri that can not be found.
  final String uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.pageNotFoundTitle)),
      body: Center(child: Text(context.l10n.pageNotFoundMessage(uri))),
    );
  }
}