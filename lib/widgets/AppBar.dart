import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/Colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final String? routeName;
  const MyAppBar({Key? key, this.title, this.actions, this.bottom, this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: appetitAppContainerColor,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          routeName == null ? Navigator.pop(context) : Navigator.pushReplacementNamed(context, routeName!);
        },
      ),
      actions: actions,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(color: context.iconColor, fontSize: 20),
            )
          : SizedBox.shrink(),
      bottom: bottom,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
