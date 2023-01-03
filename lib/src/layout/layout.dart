import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  Layout({
    Key? key,
    this.appBar,
    this.body,
    EdgeInsets? bodyPadding,
    this.bottomNavigationBar,
    this.drawer,
    this.drawerEdgeDragWidth,
  })  : bodyPadding = bodyPadding ??
            EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
                bottom: bottomNavigationBar == null ? 0 : 16),
        super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsets? bodyPadding;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final double? drawerEdgeDragWidth;

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: appBar,
      body: _buildBody(),
      bottomNavigationBar: bottomNavigationBar,
      drawer:
          drawer == null ? null : SizedBox(width: drawerWidth, child: drawer),
    );
  }

  Widget? _buildBody() {
    if (this.body == null) return null;
    Widget body = DefaultTextStyle.merge(
        child: this.body!, style: const TextStyle(height: 1.4));
    if (bodyPadding == null) return body;
    return Padding(padding: bodyPadding!, child: body);
  }
}
