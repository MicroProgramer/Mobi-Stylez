import 'package:firebase_auth_practice/screens/registration/reset_password/reset_with_email_layout.dart';
import 'package:firebase_auth_practice/screens/registration/reset_password/reset_with_phone_layout.dart';
import 'package:firebase_auth_practice/widgets/custom_tab_bar_view.dart';
import 'package:firebase_auth_practice/widgets/header_container_design.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return HeaderContainerDesign(
      child: Container(
        margin: EdgeInsets.only(top: 25, left: 10, right: 10),
        child: CustomTabBarView(
          tabs_titles_list: ["Email", "Phone"],
          tab_children_layouts: [ResetPassWithEmail(), ResetPassWithPhone()],
          tabController: TabController(length: 2, vsync: this),
          tabs_length: 2,
        ),
      ),
    );
  }
}
