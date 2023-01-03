import 'package:flutter/material.dart';
import 'package:ui_component/ui_component.dart';

class DividerPage extends StatelessWidget {
  const DividerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LineDivider(),
          const SpaceDivider(50),
          const LineDivider(dash: true),
          const SpaceDivider(50),
          const LineDivider(startIndent: 16),
          const SpaceDivider(50),
          const LineDivider(startIndent: 77, endIndent: 16),
          const SpaceDivider(50),
          SizedBox(
            height: 24,
            child: Row(
              children: const [
                Text("Text"),
                LineDivider(
                  direction: Axis.vertical,
                  indent: 4,
                  space: 20,
                ),
                Text("Text"),
                LineDivider(
                  direction: Axis.vertical,
                  indent: 4,
                  space: 20,
                  dash: true,
                ),
                Text("Text"),
              ],
            ),
          ),
          const SpaceDivider(50),
          const TextDivider(text: "Text", indent: 16),
          const SpaceDivider(50),
          const TextDivider(text: "Text", lineThickness: 0),
        ],
      ),
    );
  }
}
