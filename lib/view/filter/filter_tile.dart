import 'package:flutter/material.dart';

class FilterTile extends StatelessWidget {
  final String title;
  final Function? onTap;
  const FilterTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 70,
            color: Colors.white.withOpacity(0.3),
            child: Row(
              children: <Widget>[
                Container(
                  color: const Color(0xFF234E70).withOpacity(0.5),
                  width: 70,
                  height: 70,
                  child: const Icon(Icons.category, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
