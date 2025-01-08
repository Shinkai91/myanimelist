import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Light background color
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile image with a border and shadow
              const CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  'https://media.licdn.com/dms/image/v2/D5603AQErqZcvmeOZPg/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1723202187339?e=1738800000&v=beta&t=KvmoShUifdPs4KKsLttLVHEFm6qiTz4MXGDJCcztvtw',
                ),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              // Name with a bigger font and bold
              const Text(
                'Yosia Aser Camme',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 40, 53, 147),
                ),
              ),
              const SizedBox(height: 12),
              // Description text with better styling
              const Text(
                'Saya adalah seorang Frontend Developer dengan keahlian dalam React dan Mobile Developer yang andal menggunakan Flutter untuk membangun aplikasi lintas platform yang responsif dan ramah pengguna. '
                'Berbekal kemampuan di Google Cloud Platform (GCP), saya mengembangkan solusi berbasis cloud yang skalabel dan modern. Saya selalu antusias untuk belajar hal baru dan menghadapi tantangan, dengan komitmen memberikan solusi inovatif yang berdampak.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 24),
              // Row with buttons for GitHub and LinkedIn
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchURL('https://github.com/Shinkai91'),
                    icon: const FaIcon(FontAwesomeIcons.github,
                        color: Colors.white),
                    label: const Text(
                      'GitHub',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _launchURL('https://www.linkedin.com/in/yosiaac/'),
                    icon: const FaIcon(FontAwesomeIcons.linkedin,
                        color: Colors.white),
                    label: const Text(
                      'LinkedIn',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
