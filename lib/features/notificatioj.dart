import 'package:flutter/material.dart';
import 'package:virtuo/helpers/commonWidgets.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Notification", context),
      body: Text("Notification"),
    );
  }
}
