import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  TabItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Jons', icon: Icons.work),
    TabItem.entries: TabItemData(title: 'Entries', icon: Icons.view_headline),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}
