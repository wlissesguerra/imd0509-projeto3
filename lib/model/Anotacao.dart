import 'package:flutter/cupertino.dart';
import 'dart:io';

class Anotacao extends ChangeNotifier {
  String text;
  List<File> images;

  Anotacao({
    required this.text,
    required this.images,
  });
}
