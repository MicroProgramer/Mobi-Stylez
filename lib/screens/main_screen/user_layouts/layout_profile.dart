import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_change_password.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_profile_update.dart';
import 'package:firebase_auth_practice/widgets/custom_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutProfile extends StatefulWidget {
  @override
  _LayoutProfileState createState() => _LayoutProfileState();
}

class _LayoutProfileState extends State<LayoutProfile>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: CustomTabBarView(
          tabs_length: 2,
          tabs_titles_list: ["Profile Update", "Change Password"],
          tabController: TabController(length: 2, vsync: this),
          tab_children_layouts: [LayoutProfileUpdate(), LayoutChangePassword()],
        ),
      ),
    );
  }
}
