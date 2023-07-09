import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takwin/controller/fav_controller.dart';

// ignore: must_be_immutable
class DownloadPage extends StatelessWidget {
  DownloadPage({super.key});
  FavController favController = Get.find();
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Text("سيتم إضافة خاصية التحميل في النسخ القادمة"),
      ),
    );
  }
}
