import 'package:flutter/material.dart';

class CustomBoxTabBarView extends StatefulWidget {
  int tabs_length;
  List<String> tabs_titles_list;
  TabController tabController;
  List<Widget> tab_children_layouts;

  CustomBoxTabBarView(
      {required this.tabs_length,
      required this.tabs_titles_list,
      required this.tabController,
      required this.tab_children_layouts});

  @override
  _CustomBoxTabBarViewState createState() => _CustomBoxTabBarViewState();
}

class _CustomBoxTabBarViewState extends State<CustomBoxTabBarView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: TabBar(
            enableFeedback: true,
            indicator: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            controller: widget.tabController,
            unselectedLabelColor: Colors.grey[900],
            labelColor: Colors.red,
            indicatorColor: Colors.red,
            physics: BouncingScrollPhysics(),
            tabs: getTabBarTitlesToTabs(widget.tabs_titles_list),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[400],
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey,
              )
            ],
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
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
  }

  return tabs;
}
