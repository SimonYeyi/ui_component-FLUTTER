import 'package:flutter/material.dart';

typedef ErrorWidgetBuilder = Function(
    BuildContext context, String message, VoidCallback refresh);

@immutable
class LoadingViewer extends StatefulWidget {
  final LoadingViewerController? controller;
  final WidgetBuilder contentBuilder;
  final WidgetBuilder? loadingBuilder;
  final ErrorWidgetBuilder? errorBuilder;
  final ErrorWidgetBuilder? networkErrorBuilder;
  final WidgetBuilder? emptyBuilder;
  final bool keepAlive;

  const LoadingViewer(
      {super.key,
      required this.contentBuilder,
      this.loadingBuilder,
      this.errorBuilder,
      this.networkErrorBuilder,
      this.emptyBuilder,
      this.controller,
      this.keepAlive = false});

  @override
  State<StatefulWidget> createState() {
    return _LoadingViewerState();
  }
}

class _LoadingViewerState extends State<LoadingViewer>
    with AutomaticKeepAliveClientMixin {
  late LoadingViewerController _controller;
  bool _contentBuilt = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? LoadingViewerController();
    _controller.showLoadingView();
    _controller._setState = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final type = _controller._type;

    Widget? view;
    switch (type) {
      case _LoadingViewerType.content:
        view = widget.contentBuilder.call(context);
        break;
      case _LoadingViewerType.loading:
        view = widget.loadingBuilder?.call(context) ??
            _textWidget(LoadingViewerController._default_text_laoding);
        break;
      case _LoadingViewerType.error:
        view = widget.errorBuilder
                ?.call(context, _controller._errorMsg, _controller.refresh) ??
            _textWidget(_controller._errorMsg);
        break;
      case _LoadingViewerType.networkError:
        const msg = LoadingViewerController._default_text_netwrok_error;
        view = widget.networkErrorBuilder
                ?.call(context, msg, _controller.refresh) ??
            widget.errorBuilder?.call(context, msg, _controller.refresh) ??
            _textWidget(msg);
        break;
      case _LoadingViewerType.empty:
        view = widget.emptyBuilder?.call(context) ??
            _textWidget(LoadingViewerController._default_text_empty);
        break;
    }

    assert(view != null);

    final contentBuilt = _contentBuilt;

    if (type == _LoadingViewerType.loading && contentBuilt) {
      view = Stack(children: [
        widget.contentBuilder(context),
        view!,
      ]);
    } else {
      _contentBuilt = false;
    }

    if (type == _LoadingViewerType.content) {
      _contentBuilt = true;
    } else if (type == _LoadingViewerType.error ||
        type == _LoadingViewerType.networkError) {
      view = GestureDetector(onTap: _controller.refresh, child: view);
    }

    return view!;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  Widget _textWidget(String text) {
    return Center(child: Text(text));
  }
}

class LoadingViewerController {
  static const String _default_text_laoding = "Loading...";
  static const String _default_text_error = "Error";
  static const String _default_text_netwrok_error = "Network error";
  static const String _default_text_empty = "No data";
  _LoadingViewerType _type = _LoadingViewerType.content;
  String _errorMsg = _default_text_error;
  VoidCallback? _refresh;
  VoidCallback? _setState;

  void showContentView() {
    if (_type == _LoadingViewerType.content) return;
    _type = _LoadingViewerType.content;
    _notifyUpdate();
  }

  void showLoadingView() {
    if (_type == _LoadingViewerType.loading) return;
    _type = _LoadingViewerType.loading;
    _notifyUpdate();
  }

  void showErrorView(String errorMsg) {
    if (_type == _LoadingViewerType.error && _errorMsg == errorMsg) return;
    _errorMsg = errorMsg;
    _type = _LoadingViewerType.error;
    _notifyUpdate();
  }

  void showNetworkErrorView() {
    if (_type == _LoadingViewerType.networkError) return;
    _type = _LoadingViewerType.networkError;
    _notifyUpdate();
  }

  void showEmptyView() {
    if (_type == _LoadingViewerType.empty) return;
    _type = _LoadingViewerType.empty;
    _notifyUpdate();
  }

  void _notifyUpdate() => _setState?.call();

  void setRefreshListener(VoidCallback refresh) => _refresh = refresh;

  void refresh() {
    showLoadingView();
    _refresh?.call();
  }
}

enum _LoadingViewerType {
  content,
  loading,
  error,
  networkError,
  empty,
}
