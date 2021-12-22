import 'package:firebase_auth_practice/models/comment.dart';
import 'package:firebase_auth_practice/models/like.dart';
import 'package:firebase_auth_practice/models/post.dart';
import 'package:firebase_auth_practice/models/report.dart';

class PostInfoListener {
  void updatedCommentsListener(List<Comment> comments) {}

  void updatedLikesListener(List<Like> likes) {}

  void updatedPostListener(Post post) {}

  void updatedReportsListener(List<Report> reports) {}

  void hiddenForUsers(List<String> users){}
}
