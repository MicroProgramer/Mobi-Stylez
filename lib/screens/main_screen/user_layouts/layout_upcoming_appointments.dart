import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_list_upcoming_appointments.dart';
import 'package:firebase_auth_practice/widgets/custom_box_tab_bar_view.dart';
import 'package:flutter/material.dart';

import 'layout_list_past_appointments.dart';

class LayoutUpcomingAppointments extends StatefulWidget {
  const LayoutUpcomingAppointments({Key? key}) : super(key: key);

  @override
  _LayoutUpcomingAppointmentsState createState() =>
      _LayoutUpcomingAppointmentsState();
}

class _LayoutUpcomingAppointmentsState extends State<LayoutUpcomingAppointments>
    with TickerProviderStateMixin {
  List<Widget> tabsList = [
    LayoutListUpcomingAppointments(),
    LayoutListPastAppointments(),
  ];
  late TabController controller;
  List<String> tabsTitles = ["Upcoming", "Past"];
  String title = "Upcoming Request details";

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    controller.addListener(_handleSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                title,
                style: grey_h2Style,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: CustomBoxTabBarView(
                  tabs_length: tabsList.length,
                  tabs_titles_list: tabsTitles,
                  tabController: controller,
                  tab_children_layouts: tabsList),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSelection() {
    print("index ${controller.index}");
    int index = controller.index;
    setState(() {
      if (index == 0) {
        title = "Upcoming Request details";
      } else {
        title = "Client History";
      }
    });
  }
}
