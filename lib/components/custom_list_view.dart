import 'package:flutter/cupertino.dart';

typedef Widget EmptyBuilder(BuildContext context, Object error);
typedef Widget LoadingBuilder(BuildContext context);
typedef Widget ItemBuilder<T>(BuildContext context, T entry, int index);
typedef Future<List<T>> PageFuture<T>(bool isRefresh);

abstract class CustomListView<T> extends StatefulWidget {
  final PageFuture pageFuture;
  final EmptyBuilder emptyBuilder;
  final LoadingBuilder loadingBuilder;
  final ItemBuilder itemBuilder;

  CustomListView(
      {@required this.itemBuilder,
      @required this.pageFuture,
      Key key,
      this.emptyBuilder,
      this.loadingBuilder})
      : super(key: key);

  @override
  CustomListViewState<T> createState() => CustomListViewState<T>();
}

class CustomListViewState<T> extends State<CustomListView<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isInit = true;
  Future getFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _scrollController..addListener(_listener);
      getFuture = widget.pageFuture(true);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        getFuture = widget.pageFuture(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
