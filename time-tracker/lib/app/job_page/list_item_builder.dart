import 'package:flutter/material.dart';
import 'package:my_app/app/job_page/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({super.key, this.snapshot, this.itemBuilder});

  final AsyncSnapshot<List<T>>? snapshot;
  final ItemWidgetBuilder<T>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    print(snapshot);
    if (snapshot!.hasData) {
      final List<T> items = snapshot?.data as List<T>;
      print('items ${items}');
      if (items.isNotEmpty) {
        return _buildList(items, key);
      } else {
        return const EmptyContent();
      }
    } else if (snapshot!.hasError) {
      print(snapshot?.error);
      return const EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t load items right now');
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items, key) {
    return  ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder!(context, items[index]),
    );
  }
}
