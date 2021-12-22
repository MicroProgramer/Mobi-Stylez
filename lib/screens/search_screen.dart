import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_searched_barbers.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_searched_posts.dart';
import 'package:firebase_auth_practice/widgets/custom_box_tab_bar_view.dart';
import 'package:firebase_auth_practice/widgets/custom_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin{
  String searchQuery = "";
  List<Post> posts = [];
  List<Barber> barbers = [];
  List<Widget> searchChildren = [];
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    searchChildren = [
      LayoutSearchedPosts(searchQuery: searchQuery),
      LayoutSearchedBarbers(searchQuery: searchQuery)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomInputField(
                    hint: "Search here",
                    prefix: Icon(Icons.search),
                    isPasswordField: false,
                    onChange: (value) {
                      setState(() {
                        searchQuery = value.toString();
                      });
                    },
                    keyboardType: TextInputType.name),
              ),
              Expanded(
                child: CustomBoxTabBarView(
                    tabs_length: 2,
                    tabs_titles_list: ["Posts", "Barbers"],
                    tabController: tabController,
                    tab_children_layouts: [
                      LayoutSearchedPosts(searchQuery: searchQuery.toLowerCase()),
                      LayoutSearchedBarbers(searchQuery: searchQuery.toLowerCase())
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
