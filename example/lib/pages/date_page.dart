import 'package:flutter/material.dart';
import 'package:ui_component/ui_component.dart';

class DatePage extends StatelessWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          DateText("2022-09-29 15:22:04"),
          DateText("2022-09-29 15:22:04", missYear: true, missSecond: true),
          DateText("2022-09-29 15:22:04", onlyDate: true),
          DateText("2022-09-29 15:22:04", onlyDate: true, missYear: true),
          DateText("2022-09-29 15:22:04", onlyTime: true),
          DateText("2022-09-29 15:22:04", onlyTime: true, missSecond: true),
          DateText("2022-09-29 15:22:04", missYear: true),
          DateText("2022-09-29 15:22:04", missSecond: true),
          DateText(
            "2022-09-29 15:22:04",
            pattern: "yyyy-MM-dd HH:mm:ss",
          ),
          DateText(
            "2022-09-29 15:22:04",
            relative: true,
          ),
        ],
      ),
    );
  }
}
