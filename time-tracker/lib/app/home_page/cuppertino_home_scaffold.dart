import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/tab_item/tab_item.dart';

class CuppertinoHomeScaffold extends StatelessWidget {
  CuppertinoHomeScaffold(
      {super.key,
      required this.currentTab,
      required this.onSelectTab,
      required this.widgetBuilders,
      required this.navigatorKeys,
    });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: [
        _buildItem(TabItem.jobs),
        _buildItem(TabItem.entries),
        _buildItem(TabItem.account),
      ], onTap: (index) => onSelectTab(TabItem.values[index])),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];

        return CupertinoTabView(
            navigatorKey: navigatorKeys[item],
            builder: (context) => widgetBuilders[item]!(context));
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(itemData?.icon, color: color),
      label: itemData?.title ?? '',
    );
  }
}
