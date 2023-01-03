import 'package:flutter/material.dart';
import 'package:ui_component/ui_component.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LayoutPageState();
  }
}

class _LayoutPageState extends State<LayoutPage> {
  bool showBottomNavigationBar = true;
  bool showDrawer = false;
  EdgeInsets? bodyPadding;

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBar(title: const Text("布局框架")),
      body: Container(
        width: double.infinity,
        color: Colors.grey,
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("布局边距"),
              onPressed: () {
                setState(() {
                  bodyPadding =
                      bodyPadding == null ? const EdgeInsets.all(12) : null;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text("底部导航"),
              onPressed: () {
                setState(() {
                  showBottomNavigationBar = !showBottomNavigationBar;
                  bodyPadding = null;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text("抽屉菜单"),
              onPressed: () {
                setState(() {
                  showDrawer = !showDrawer;
                });
              },
            ),
          ],
        ),
      ),
      bodyPadding: bodyPadding,
      bottomNavigationBar: showBottomNavigationBar
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: "Message",
                  icon: Icon(Icons.message),
                ),
              ],
            )
          : null,
      drawer: showDrawer ? Container(color: Colors.black) : null,
    );
  }
}
