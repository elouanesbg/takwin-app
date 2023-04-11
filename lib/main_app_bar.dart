import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),
      actions: [
        Center(
          child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text(
                "شروح صوتية للعلوم الشرعية",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
