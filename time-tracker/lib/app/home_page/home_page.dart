import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/account/account.dart';
import 'package:my_app/app/entries/entries.dart';
import 'package:my_app/app/home_page/cuppertino_home_scaffold.dart';
import 'package:my_app/app/job_page/job_page.dart';
import 'package:my_app/app/tab_item/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  void _select(TabItem item) {
    if (item == _currentTab) {
      // pop to first route
      navigatorKeys[item]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = item;
      });
    }
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => const JobPage(),
      TabItem.entries: (_) => EntriesPage.create(context),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CuppertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
      navigatorKeys: navigatorKeys,
    );
  }
}
