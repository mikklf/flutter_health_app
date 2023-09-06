import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:flutter_health_app/src/presentation/screens/survey_dashboard_screen/survey_dashboard_screen.dart';
import 'package:flutter_health_app/src/business_logic/cubit/tab_manager_cubit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<Widget> pages = <Widget>[
    const OverviewScreen(),
    const SurveyDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabManagerCubit, TabManagerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context),
          body: IndexedStack(
            index: state.selectedTab,
            children: pages,
          ),
          bottomNavigationBar: _bottomNavigationBar(context, state),
        );
      },
    );
  }

  BottomNavigationBar _bottomNavigationBar(BuildContext context, TabManagerState state) {
    return BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: state.selectedTab,
          onTap: (index) {
            context.read<TabManagerCubit>().changeTab(index);
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
