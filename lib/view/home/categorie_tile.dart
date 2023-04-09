import 'package:flutter/material.dart';
import 'package:takwin/model/category_model.dart';
import 'package:takwin/view/home/home_page.dart';

class CategorieTile extends StatelessWidget {
  final Category category;
  const CategorieTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          child: Card(
            color: const Color.fromARGB(255, 229, 235, 240),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF343A40),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0),
                    ),
                  ),
                  width: 20,
                  height: 73,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ListTile(
                    title: Hero(
                      tag: category.title,
                      child: Text(
                        category.title,
                      ),
                    ),
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
