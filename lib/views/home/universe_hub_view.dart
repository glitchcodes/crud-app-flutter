import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UniverseHubView extends StatelessWidget {
  const UniverseHubView({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center( // Center the content horizontally
      child: SingleChildScrollView(
        child: SizedBox( // Constrain the width
          width: 600, // You can adjust this value as needed
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'TERMINAL SESSION ID: [ERROR/OUT_OF_BOUND]',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'FROM: [AUTOMATED MESSAGE]',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'TO: Junior Researcher █████████',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2.0,
                  height: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Text(
                        'Welcome, New Recruit.',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This hub provides essential information to understand the SCP Foundation and its universe. Familiarize yourself with the following:',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Core Concepts:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildIndentedText('- Mission: Learn about the Foundation\'s goals: to Secure, Contain, and Protect.'),
                      _buildIndentedText('- Object Classes: Understand the classification system for anomalies (e.g., Safe, Euclid, Keter).'),
                      _buildIndentedText('- Security Clearance Levels: Know your access privileges within the Foundation.'),
                      const SizedBox(height: 24),
                      Text(
                        'Organizational Structure:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildIndentedText('- Facilities and Departments: Explore the various locations and divisions within the Foundation.'),
                      _buildIndentedText('- Mobile Task Forces (MTFs): Discover the specialized teams for handling specific threats.'),
                      _buildIndentedText('- Personnel Dossiers: Get familiar with key personnel within the Foundation.'),
                      const SizedBox(height: 24),
                      Text(
                        'Beyond the Basics:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildLinkTileWithIndent(
                        title: 'Groups of Interest (GoIs)',
                        url: 'https://scp-wiki.wikidot.com/groups-of-interest',
                        description: 'Learn about allied, neutral, and antagonistic organizations.',
                        indentation: 16.0,
                      ),
                      _buildLinkTileWithIndent(
                        title: 'Locations of Interest (LoIs)',
                        url: 'https://scp-wiki.wikidot.com/log-of-anomalous-locations',
                        description: 'Discover significant anomalous locations.',
                        indentation: 16.0,
                      ),
                      _buildLinkTileWithIndent(
                        title: 'K-Class "End of the World" Scenarios',
                        url: 'https://scp-wiki.wikidot.com/k-class-scenarios',
                        description: 'Understand potential existential threats.',
                        indentation: 16.0,
                      ),
                      _buildIndentedText('- Glossary of Terms: Familiarize yourself with common SCP Foundation terminology.'),
                      const SizedBox(height: 24),
                      Text(
                        'For Junior Researchers:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Further resources and guidelines for new researchers can be found on the SCP Wiki.',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Welcome to the Foundation.',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndentedText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildLinkTileWithIndent({
    required String title,
    required String url,
    required String description,
    double indentation = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: indentation, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => _launchUrl(url),
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  final String text;
  const HighlightedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Color(0xFFEDC30D),
      ),
    );
  }
}

class HighlightedSentence extends StatelessWidget {
  final String text;
  const HighlightedSentence(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Color(0xFFEDC30D),
      ),
    );
  }
}
