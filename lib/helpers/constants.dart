import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/enums/needed.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/interfaces/available_slots_listener.dart';
import 'package:firebase_auth_practice/interfaces/barber_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/barbers_change_listener.dart';
import 'package:firebase_auth_practice/interfaces/comment_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/post_info_listener.dart';
import 'package:firebase_auth_practice/interfaces/service_listener.dart';
import 'package:firebase_auth_practice/interfaces/user_data_change_listener.dart';
import 'package:firebase_auth_practice/models/barber.dart';
import 'package:firebase_auth_practice/models/comment.dart';
import 'package:firebase_auth_practice/models/follower.dart';
import 'package:firebase_auth_practice/models/like.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/models/registered_user.dart';
import 'package:firebase_auth_practice/models/report.dart';
import 'package:firebase_auth_practice/models/service.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
CollectionReference slotsRef = FirebaseFirestore.instance.collection("slots");
CollectionReference appointmentsRef =
    FirebaseFirestore.instance.collection("appointments");
CollectionReference barbersRef =
    FirebaseFirestore.instance.collection("barbers");
CollectionReference postsRef = FirebaseFirestore.instance.collection("posts");
CollectionReference postsRef2 = FirebaseFirestore.instance.collection("posts");

bool userSignedIn = false;
late RegisteredUser? mUser;
late String userMail;
String appName = "Mobi Stylez";
String googleAPIKey = "AIzaSyCp2I8VzxRNn4ls-1bPs1eGJDYDqxcimEM";
String test_image =
    "https://firebasestorage.googleapis.com/v0/b/beautician-barber-side-ishfaq.appspot.com/o/image2021-11-24%2012%3A20%3A40.683431?alt=media&token=07350641-6ea7-45fe-893b-1ff0a3d40ccf";
List<Barber> allBarbersList = [];
List<RegisteredUser> allUsersList = [];
Map<String, List<Follower>> allBarbersFollowers = Map();
LatLng? myLocationPoints = LatLng(0, 0);

void checkMySelf(String uid, UserDataChangeListener listener) async {
  var document = await usersRef.doc(uid);
  document.get().then((value) {
    print("meta data" + json.encode(value.data()));
    RegisteredUser object =
        RegisteredUser.fromMap(value.data() as Map<String, dynamic>);
    listener.dataReceived(object);
  });
}

void checkForUserInfo(String uid, UserDataChangeListener listener) async {
  var document = await usersRef.doc(uid);
  document.get().then((value) {
    print("meta data" + json.encode(value.data()));
    RegisteredUser object =
        RegisteredUser.fromMap(value.data() as Map<String, dynamic>);
    listener.dataReceived(object);
  });
}

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  final snackBar = new SnackBar(
    content: Text(message),
    backgroundColor: Color(0xFF505050),
    behavior: SnackBarBehavior.floating,
  );
  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

void openScreen(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void closeAllScreens(BuildContext context) {
  Navigator.popUntil(context, (route) => false);
}

bool isPhoneValid(String phone, BuildContext context, String country_code) {
  if (country_code.isEmpty) {
    showSnackBar("Re-select your phone country", context);
    return false;
  }
  if (phone.startsWith("0")) {
    showSnackBar("Do not include first 0 with in phone number", context);
    return false;
  }

  return true;
}

void showModalBottomSheetMenu(
    {required BuildContext context, required Widget content, double? height}) {
  showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return SafeArea(child: Container(height: height, child: content));
      });
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

Future<DateTime> selectDate(BuildContext context) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) selectedDate = picked;

  return selectedDate;
}

String convertTimeToText(int timestamp, String suffix) {
  String convTime = "";
  String prefix = "";

  try {
    DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    int second = dateTime1.difference(dateTime2).inSeconds;
    int minute = dateTime1.difference(dateTime2).inMinutes;
    int hour = dateTime1.difference(dateTime2).inHours;
    int day = dateTime1.difference(dateTime2).inDays;

    if (second < 60) {
      convTime = "${second}s $suffix";
    } else if (minute < 60) {
      convTime = "${minute}m $suffix";
    } else if (hour < 24) {
      convTime = "${hour} h $suffix";
    } else if (day >= 7) {
      if (day > 360) {
        convTime = "${day ~/ 360} y $suffix";
      } else if (day > 30) {
        convTime = "${day ~/ 30} mon $suffix";
      } else {
        convTime = "${day ~/ 7} w $suffix";
      }
    } else if (day < 7) {
      convTime = "${day} d $suffix";
    }
  } catch (e) {
    print(e.toString() + "------");
  }

  return convTime;
}

void fetchAllBarbers(BarbersChangeListener listener) {
  barbersRef.snapshots().listen((querySnapshot) {
    allBarbersList = [];
    print("barber Id ");

    for (var doc in querySnapshot.docs) {
      Barber barber = Barber.fromMap(doc.data() as Map<String, dynamic>);
      allBarbersList.add(barber);
      print("barber Id " + barber.barber_id);
      print("allBarbers: ${json.encode(doc.data())}");

      barbersRef
          .doc(barber.barber_id)
          .collection("followers")
          .snapshots()
          .listen((event) {
        List<Follower> followers = [];
        for (var x in event.docs) {
          Follower follower = Follower.fromMap(x.data());
          followers.add(follower);
        }

        String key = barber.barber_id;
        if (!allBarbersFollowers.containsKey(key)) {
          allBarbersFollowers.addAll({key: []});
        }
        allBarbersFollowers.update(key, (value) {
          value = followers.toList();
          return value;
        });
      });
    }
    listener.onBarbersChanged(allBarbersList);
  });
}

void fetchAllUsers() {
  usersRef.snapshots().listen((querySnapshot) {
    allUsersList = [];
    for (var doc in querySnapshot.docs) {
      RegisteredUser user =
          RegisteredUser.fromMap(doc.data() as Map<String, dynamic>);
      allUsersList.add(user);

      print("allUsers: ${json.encode(doc.data())}");
    }
  });
}

void listenPostInfoChanges(String postId, PostInfoListener postInfoListener) {
  postsRef
      .doc(postId)
      .collection("comments")
      .snapshots()
      .listen((querySnapshot) {
    List<Comment> comments = [];
    print("Comment: ${querySnapshot.docs[0].data()}");
    for (var doc in querySnapshot.docs) {
      print("Comment: ${doc.data()}");
      Comment comment = Comment.fromMap(doc.data());
      comments.add(comment);
    }
    postInfoListener.updatedCommentsListener(comments);
  });

  postsRef.doc(postId).collection("likes").snapshots().listen((querySnapshot) {
    List<Like> likes = [];
    for (var doc in querySnapshot.docs) {
      Like like = Like.fromMap(doc.data());
      likes.add(like);
    }
    postInfoListener.updatedLikesListener(likes);
  });

  postsRef
      .doc(postId)
      .collection("reports")
      .snapshots()
      .listen((querySnapshot) {
    List<Report> reports = [];
    for (var doc in querySnapshot.docs) {
      Report report = Report.fromMap(doc.data());
      reports.add(report);
    }
    postInfoListener.updatedReportsListener(reports);
  });

  postsRef
      .doc(postId)
      .collection("hiddenFor")
      .snapshots()
      .listen((querySnapshot) {
    List<String> hiddenUsers = [];
    for (var doc in querySnapshot.docs) {
      hiddenUsers.add(doc.data()['user_id'] as String);
    }
    postInfoListener.hiddenForUsers(hiddenUsers);
  });
}

void listenCommentInfoChanges(
    DocumentReference postRef, int comment_id, CommentInfoListener listener) {
  postRef
      .collection("comments")
      .doc("$comment_id")
      .collection("replies")
      .snapshots()
      .listen((querySnapshot) {
    List<Comment> replies = [];
    for (var doc in querySnapshot.docs) {
      print("comment_reply ${doc.data()}");
      Comment reply = Comment.fromMap(doc.data());
      replies.add(reply);
    }
    listener.commentRepliesListener(replies);
  });
}

void showOptionsDialog(
    {required BuildContext context,
    required String title,
    required List<String> actions,
    required Function(String selected) onSelected}) {
  List<Widget> options = [];
  for (String value in actions) {
    options.add(SimpleDialogOption(
      padding: EdgeInsets.all(15),
      child: Text(
        value,
        style: normal_h2Style,
      ),
      onPressed: () {
        onSelected(value);
        Navigator.pop(context);
      },
    ));
  }

  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(title),
      children: options,
    ),
  );
}

String getUserInfoById(String user_id, Needed needed) {
  for (RegisteredUser user in allUsersList) {
    if (user.user_id == user_id) {
      switch (needed) {
        case Needed.name:
          return user.firstName + user.lastName;
          break;
        case Needed.image_url:
          return user.image_url;
          break;
      }
    }
  }
  switch (needed) {
    case Needed.name:
      return "Unknown User";
      break;
    case Needed.image_url:
      return test_image;
      break;
  }
}

RegisteredUser? getUserById(String user_id) {
  for (RegisteredUser user in allUsersList) {
    if (user.user_id == user_id) {
      return user;
    }
  }
  return RegisteredUser(
      user_id: "user_id",
      firstName: "Unknown",
      lastName: "Unknown",
      email: "email",
      phone: "phone",
      password: "password",
      image_url: test_image,
      country_code: "country_code",
      notification_token: "notification_token",
      lastSeen: 0);
}

String getBarberInfoById(String barber_id, Needed needed) {
  for (Barber barber in allBarbersList) {
    if (barber.barber_id == barber_id) {
      switch (needed) {
        case Needed.name:
          return barber.firstName + ' ' + barber.lastName;
          break;
        case Needed.image_url:
          return barber.image_url;
          break;
      }
    }
  }
  switch (needed) {
    case Needed.name:
      return "Unknown User";
      break;
    case Needed.image_url:
      return test_image;
      break;
  }
}

int calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return (12742 * asin(sqrt(a))).toInt();
}

void checkForBarberInfo(String barber_id, BarberInfoListener listener) {
  var userQuery = FirebaseFirestore.instance
      .collection('barbers')
      .where('barberID', isEqualTo: barber_id)
      .limit(1);
  userQuery.snapshots().listen((data) {
    data.docChanges.forEach((change) {
      Barber barber = Barber.fromMap(change.doc.data() as Map<String, dynamic>);
      listener.onBarberInfoChanged(barber);
    });
  });

  var followQuery = FirebaseFirestore.instance
      .collection('barbers')
      .doc(barber_id)
      .collection("followers")
      .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .limit(1);
  followQuery.snapshots().listen((data) {
    listener.followedByMe(data.docs.length > 0);
  }).onError((error) {
    print("follow error $error");
  });

  barbersRef.doc(barber_id).collection("followers").snapshots().listen((event) {
    listener.onFollowersChanged(event.docs.length);
  });

  postsRef.where('barberID', isEqualTo: barber_id).snapshots().listen((event) {
    listener.onPostsCountChanged(event.docs.length);
  });
}

void checkForServiceInfo(String service_id, ServiceListener listener) {
  var userQuery = FirebaseFirestore.instance
      .collection('services')
      .where('service_id', isEqualTo: service_id)
      .limit(1);
  userQuery.snapshots().listen((data) {
    data.docChanges.forEach((change) {
      Service service =
          Service.fromMap(change.doc.data() as Map<String, dynamic>);
      listener.onServiceUpdated(service);
    });
  });
}

void getAvailableSlots(String barber_id, AvailableSlotsListener listener) {
  FirebaseFirestore.instance
      .collection("slots")
      .where('barber_id', isEqualTo: barber_id)
      .snapshots()
      .listen((snapshot) {
    List<Slot> slotsData = [];
    for (var doc in snapshot.docs) {
      Slot slot = Slot.fromMap(doc.data());
      if (slot.timestamp < DateTime.now().millisecondsSinceEpoch) {
        slot.available = false;
      }
      slotsData.add(slot);
    }
    print("total slots: ${slotsData.length}");

    Map<DateTime, List<Slot>> slotsMap = filterSlotsToMap(slotsData);
    listener.updatedSlots(slotsMap);
  });
}

Map<DateTime, List<Slot>> filterSlotsToMap(List<Slot> slotsData) {
  Map<DateTime, List<Slot>> finalMap = Map();

  for (Slot slot in slotsData) {
    int timestamp = slot.timestamp;
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    DateTime x = DateTime(date.year, date.month, date.day);

    if (!finalMap.containsKey(x)) {
      finalMap.addAll({x: []});
    }
    finalMap.update(x, (value) {
      value.add(slot);
      return value;
    });
  }

  return finalMap;
}
