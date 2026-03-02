import 'package:flutter/material.dart';

class InfiniteScrollScreen extends StatefulWidget {
  const InfiniteScrollScreen({Key? key}) : super(key: key);

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  List<String> items = [];
  bool loading = false;
  bool allLoaded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });

    await Future.delayed(Duration(microseconds: 500));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "List Item ${index + items.length}");

    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infinite Scrolling"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (items.isNotEmpty) {
          return Stack(
            children: [
              ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index < items.length) {
                      return ListTile(
                        title: Text(items[index]),
                      );
                    } else {
                      return Container(
                        width: constraints.maxWidth,
                        height: 50,
                        child: Center(
                          child: Text("Nothing more to load"),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                    );
                  },
                  itemCount: items.length + (allLoaded ? 1 : 0)),
              if (loading) ...[
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: constraints.maxWidth,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ))
              ]
            ],
          );
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
