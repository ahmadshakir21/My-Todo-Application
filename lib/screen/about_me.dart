import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({Key? key}) : super(key: key);

  launchURL(String urlargument) async {
    Uri uri = Uri.parse(urlargument);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                          color: Color(0xFF0B2E40),
                        )),
                    const SizedBox(
                      width: 90,
                    ),
                    Text(
                      "About Me",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0B2E40)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/photo_5199812254550311358_y.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Ahmad Shakir Khalid",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0B2E40)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Flutter Developer",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0B2E40)),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        launchURL(
                            "https://www.facebook.com/Ahmad.Shakir.Khalid");
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF4267B2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.facebook),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Facebook",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        launchURL(
                            "https://www.linkedin.com/in/ahmad-shakir-1a6a95226/");
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF0077b5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.linkedin),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "linked In",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        launchURL("https://twitter.com/ahmadshakir21");
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF1DA1F2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.twitter),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Twitter",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        launchURL("https://github.com/ahmadshakir21");
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF0B2E40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.github),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Github",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
              ])))),
    );
  }
}
