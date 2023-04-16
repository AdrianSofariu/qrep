import 'package:qrep/models/post.dart';

//class to use for building checklists
class ListItem {
  Post post;
  bool isChecked;

  ListItem({required this.post, required this.isChecked});
}
