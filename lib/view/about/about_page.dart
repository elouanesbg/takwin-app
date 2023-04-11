import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});
  final Uri takwinUrl = Uri(scheme: 'https', host: 'takw.in', path: 'about');
  final Uri githubUrl =
      Uri(scheme: 'https', host: 'github.com', path: 'elouanesbg/takwin-app');

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SelectableText(
                "تم انشاء هذا التطبيق انطلاقا من المعلومات التي تم جمعها من موقع تكوين الراسخين ",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.5,
                    ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () async {
                    _launchInBrowser(takwinUrl);
                  },
                  child: Center(
                    child: Image.asset(
                      "assets/img/takwin.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
              SelectableText(
                "و الذي يهدف الى:",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.5,
                    ),
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
              ),
              SelectableText(
                "- رسم منهج للعلوم الشرعية التأصيلية.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      height: 1.5,
                    ),
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
              ),
              SelectableText(
                "- جمع مادة المنهج، من متون ومنظومات وشروح وحواشٍ مكتوبة، وكذلك شروح صوتية ومرئية. (تنبيه: اجتهدنا في اختيار المادة الصوتية والمرئية التي وضعناها، وما زلنا نحرر وننقح).",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      height: 1.5,
                    ),
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(
                height: 40,
              ),
              SelectableText(
                "هذا التطبيق مجاني و مفتوح المصدر ويمكن الاطلاع على الكود الخاص به على الرابط أدناه",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      height: 1.5,
                    ),
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GestureDetector(
                  onTap: () async {
                    _launchInBrowser(githubUrl);
                  },
                  child: Center(
                    child: Image.asset(
                      "assets/img/github.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
