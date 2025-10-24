import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FilledButton(onPressed: () {
            
          }, child: const Text("Submit")),
          TextFormField(
            forceErrorText: "Hello error text",
          ),
        ],
      ),
    );
  }
}
