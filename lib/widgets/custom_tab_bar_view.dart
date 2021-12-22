import 'package:flutter/material.dart';

class CustomTabBarView extends StatefulWidget {
  int tabs_length;
  List<String> tabs_titles_list;
  TabController tabController;
  List<Widget> tab_children_layouts;

  CustomTabBarView(
      {required this.tabs_length,
      required this.tabs_titles_list,
      required this.tabController,
      required this.tab_children_layouts});

  @override
  _CustomTabBarViewState createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TabBar(
            // indicator: BoxDecoration(
            //     color: Colors.redAccent,
            //     borderRadius: BorderRadius.circular(50)),
            controller: widget.tabController,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.red,
            indicatorColor: Colors.red,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(5),
            tabs: getTabBarTitlesToTabs(widget.tabs_titles_list),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              controller: widget.tabController,
              children: widget.tab_children_layouts,
            ),
          ),
        )
      ],
    );
  }
}

List<Widget> getTabBarTitlesToTabs(List<String> tabBarTitles) {
  List<Tab> tabs = [];

  for (String title in tabBarTitles) {
    tabs.add(Tab(
      text: title,
    ));
  }

  return tabs;
}
