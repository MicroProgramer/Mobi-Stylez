import 'package:firebase_auth_practice/models/barber.dart';

class BarberInfoListener {
  void onBarberInfoChanged(Barber barber) {}

  void onFollowersChanged(int followers) {}

  void followedByMe(bool followed) {}

  void onPostsCountChanged(int posts){}
}
