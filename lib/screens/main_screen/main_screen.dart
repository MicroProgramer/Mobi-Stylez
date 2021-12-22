import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/interfaces/user_data_change_listener.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_home.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_inbox.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_nearby_barbers.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_profile.dart';
import 'package:firebase_auth_practice/screens/main_screen/user_layouts/layout_upcoming_appointments.dart';
import 'package:firebase_auth_practice/screens/notifications_screen.dart';
import 'package:firebase_auth_practice/screens/search_screen.dart';
import 'package:firebase_auth_practice/screens/settings_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  int? defaultSelectedTab = 0;

  MainScreen({this.defaultSelectedTab});

  @override
  _MainScreenState createState() => _MainScreenState();
}

RegisteredUser _user = RegisteredUser(
    user_id: "user_id",
    firstName: "name",
    lastName: "name",
    email: "email",
    phone: "phone",
    password: "password",
    image_url: "image_url",
    country_code: "country_code",
    notification_token: "notification_token",
    lastSeen: 0);

class _MainScreenState extends State<MainScreen>
    implements UserDataChangeListener {
  int selectedLayoutIndex = 2;
  List<Widget> allLayouts = [
    LayoutInbox(),
    LayoutUpcomingAppointments(),
    LayoutHome(),
    LayoutNearbyBarbers(metersLimit: 80),
    LayoutProfile()
  ];

  var _bottomNavIndex = 0;
  late OverlayEntry entry;

  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Timer? timer;

  @override
  void initState() {
    updateToken();
    setState(() {
      selectedLayoutIndex = widget.defaultSelectedTab ?? 2;
      checkMySelf(FirebaseAuth.instance.currentUser!.uid, this);
      _fcm.setAutoInitEnabled(true);

      updateLastSeen();
      timer = Timer.periodic(Duration(minutes: 5), (Timer t) {
        updateLastSeen();
      });
    });

    entry = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedLayoutIndex != 2) {
          setState(() {
            selectedLayoutIndex = 2;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.red,
          index: selectedLayoutIndex,
          color: Colors.redAccent,
          items: [
            ImageIcon(
              AssetImage("assets/messenger.png"),
              color: Colors.white,
            ),
            ImageIcon(
              AssetImage("assets/calender.png"),
              color: Colors.white,
            ),
            ImageIcon(
              AssetImage("assets/home.png"),
              color: Colors.white,
            ),
            ImageIcon(
              AssetImage("assets/locator.png"),
              color: Colors.white,
            ),
            ImageIcon(
              AssetImage("assets/user.png"),
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedLayoutIndex = index;
            });
          },
        ),
        /*BottomNavigationBar(
          items: iconList,
          backgroundColor: Colors.red,
          selectedItemColor: Colors.white,
        ),*/
        /*BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.redAccent,
          notchMargin: 10.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: IconButton(

                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),*/
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationsScreen()));
                        },
                        icon: Icon(Icons.notifications_active_outlined)),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));
                        },
                        icon: Icon(Icons.search)),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Qwigley',
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 255, 128, 128),
                      ),
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: ImageIcon(
                        AssetImage("assets/locator.png"),
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          selectedLayoutIndex = 3;
                        });
                      },
                    ),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        openScreen(context, SettingsScreen());
                      },
                      icon: Icon(Icons.menu),
                    ),
                  ],
                ),
              ),
            ],
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          // leading: Row(
          //   children: [
          //     IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active_outlined)),
          //     IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active_outlined))
          //   ],
          // ),
          // actions: [
          //   IconButton(onPressed: (){}, icon: Icon(Icons.location_city_outlined)),
          // ],
        ),
        body: allLayouts[selectedLayoutIndex],
      ),
    );
  }

  @override
  void dataReceived(RegisteredUser? registeredUser) {
    mUser = registeredUser;
    _user = registeredUser!;

    // if (!registeredUser!.phone_verified) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => CodeSentScreen(phone: mUser!.phone)));
    // }

    setState(() {});
  }

  Future<void> updateToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token.toString().isNotEmpty && mUser != null) {
        mUser!.notification_token = token.toString();

        usersRef
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(mUser!.toMap());
      }
    }
  }

  void updateLastSeen() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"lastSeen": timestamp});
    print("updated lastseen $timestamp");
  }
}
