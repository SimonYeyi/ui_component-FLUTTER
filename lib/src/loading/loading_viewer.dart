import 'package:flutter/material.dart';

typedef ErrorWidgetBuilder = Function(
    BuildContext context, VoidCallback refresh);

@immutable
class LoadingViewer extends StatefulWidget {
  final LoadingViewerController? controller;
  final bool isLoading;
  final WidgetBuilder contentBuilder;
  final WidgetBuilder? loadingBuilder;
  final ErrorWidgetBuilder? errorBuilder;
  final ErrorWidgetBuilder? networkErrorBuilder;
  final WidgetBuilder? emptyBuilder;

  const LoadingViewer({
    required this.isLoading,
    required this.contentBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.networkErrorBuilder,
    this.emptyBuilder,
    this.controller,
    Key? key,
  }) : super(key: key);

  const LoadingViewer.loading({
    this.isLoading = true,
    required this.contentBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.networkErrorBuilder,
    this.emptyBuilder,
    this.controller,
    Key? key,
  }) : super(key: key);

  const LoadingViewer.content({
    this.isLoading = false,
    required this.contentBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.networkErrorBuilder,
    this.emptyBuilder,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingViewerState();
  }
}

class _LoadingViewerState extends State<LoadingViewer> {
  late LoadingViewerController _controller;
  bool _contentBuilt = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? LoadingViewerController();
    if (widget.isLoading) _controller.showLoadingView();
    _controller._setState = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final type = _controller._type;

    Widget? view;
    switch (type) {
      case _LoadingViewerType.content:
        view = widget.contentBuilder.call(context);
        break;
      case _LoadingViewerType.loading:
        view = widget.loadingBuilder?.call(context) ?? Container();
        break;
      case _LoadingViewerType.error:
        view = widget.errorBuilder?.call(context, _onRefresh) ?? Container();
        break;
      case _LoadingViewerType.networkError:
        view = widget.networkErrorBuilder?.call(context, _onRefresh) ??
            Container();
        break;
      case _LoadingViewerType.empty:
        view = widget.emptyBuilder?.call(context) ?? Container();
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

    if (type == _LoadingViewerType.content) _contentBuilt = true;

    return view!;
  }

  VoidCallback get _onRefresh => _controller._refresh ?? () {};
}

class LoadingViewerController {
  _LoadingViewerType _type = _LoadingViewerType.content;
  String? _errorMsg;
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

  void showErrorView([String? errorMsg]) {
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
}

enum _LoadingViewerType {
  content,
  loading,
  error,
  networkError,
  empty,
}
