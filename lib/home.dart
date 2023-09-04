import 'package:flutter/material.dart';
import 'package:flutter_health_app/src/providers/tab_manager.dart';
import 'package:flutter_health_app/src/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/screens/survey_screen/survey_screen.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<Widget> pages = <Widget>[
    const OverviewScreen(),
    const SurveyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(
      builder: (context, tabManager, child) {
        return Scaffold(
          appBar: _appBar(context),
          body: IndexedStack(
            index: tabManager.selectedTab,
            children: pages,
          ),
          bottomNavigationBar: _bottomNavigationBar(context, tabManager),
        );
      },
    );
  }

  BottomNavigationBar _bottomNavigationBar(BuildContext context, TabManager tabManager) {
    return BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: tabManager.selectedTab,
          onTap: (index) {
            tabManager.goToTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Surveys',
            )
          ],
        );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
          title: Text(
            'Mobile Health App',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
  }
}
