import 'package:flutter/material.dart';

class UniverseHubView extends StatelessWidget {
  const UniverseHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HighlightedText("Welcome to the SCP Foundation, researcher."),
            const SizedBox(height: 16),
            const Text(
              "It has likely been a difficult journey to find yourself where you are today, having to be scouted out by people you've never met before and invited to exams and interviews for a position you were never fully told of. We can imagine you already have a few questions, whether it be where you are, who is here with you, or why you were chosen to be here. Many of these questions we will not be able to answer. Some of those, we will.",
            ),
            const SizedBox(height: 16),
            const Text(
              "In the interest of not making new personnel go through their first several weeks guessing what each task force, site, and acronym actually stands for, we have compiled all the information you'd reasonably need (and can be given) into a single automated message, sent to every new recruit's personal inbox. We recommend going over these at your earliest convenience.",
            ),
            const SizedBox(height: 16),
            HighlightedText("Contents:"),
            const SizedBox(height: 8),
            BulletPoint(text: "About the SCP Foundation, our mission statement, a word from the Administrator, and other miscellaneous information."),
            BulletPoint(text: "Object Classes, a rundown of the anomaly classification system. Required reading for new researchers."),
            BulletPoint(text: "Security Clearance Levels. Violation is grounds for instant contract termination and amnesticization."),
            BulletPoint(text: "Foundation Facilities, explanations of your Site or Area designation."),
            BulletPoint(text: "Foundation Departments, subdivisions focusing on different research aspects."),
            BulletPoint(text: "Mobile Task Forces, specialized containment teams for different anomaly types."),
            BulletPoint(text: "The Personnel Dossier, a list of superiors, coworkers, and notable individuals (mostly redacted)."),
            BulletPoint(text: "Groups of Interest, organizations aware of the anomalous."),
            BulletPoint(text: "Locations of Interest, anomalous locations requiring diplomatic containment."),
            BulletPoint(text: "K-Class 'End of the World' Scenarios."),
            const SizedBox(height: 16),
            HighlightedText("Additional Resources for Junior Researchers:"),
            const SizedBox(height: 8),
            BulletPoint(text: "The Log of Anomalous Items — objects that don't currently warrant an SCP designation."),
            BulletPoint(text: "The Log of Extranormal Events — unusual events too sudden for proper Foundation intervention."),
            BulletPoint(text: "The Log of Unexplained Locations — locations needing only basic concealment."),
            const SizedBox(height: 16),
            HighlightedSentence(
              "If you have any more questions, ask your assigned senior researcher. Classified information may limit responses.",
            ),
            const SizedBox(height: 16),
            HighlightedText("Welcome again, recruit, and good luck."),
          ],
        ),
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
