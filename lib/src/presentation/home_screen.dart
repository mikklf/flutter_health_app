import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/constants.dart';
import 'package:flutter_health_app/src/logic/tab_manager_cubit.dart';


class HomeScreen extends StatelessWidget {
  final List<Widget> pages;

  const HomeScreen({super.key, required this.pages});


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

  BottomNavigationBar _bottomNavigationBar(
      BuildContext context, TabManagerState state) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
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
        Constants.appName,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
