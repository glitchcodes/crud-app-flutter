import 'package:flutter/material.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  // Build method to create the FAQ view
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frequently Asked Questions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ExpandableFAQItem(
              question: 'What are "Classes" assigned to SCPs?',
              answer:
                  'SCP objects are assigned a "Class" based on the difficulty of their containment. Common classes include: \n\n Safe: Anomalies that are easily and safely contained. \n\n Euclid: Anomalies that require more resources to contain completely or where containment is not always reliable. \n\n Keter: Anomalies that are difficult to contain consistently or reliably, often posing a significant threat to humanity.',
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'What is the "O5 Council"?',
              answer:
                  'The O5 Council is a mysterious group of individuals who serve as the top-level administrative body of the SCP Foundation in the fictional universe. Their identities and the full extent of their authority are often shrouded in secrecy.',
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question:
                  'What does "Redacted" or blacked-out text mean in files?',
              answer:
                  'In the context of SCP Foundation documentation, text that is marked as "Redacted" or appears as black blocks indicates information that has been intentionally removed from the publicly accessible version of the file.',
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'What are "XK-Class End-of-the-World Scenarios"?',
              answer:
                  'XK-Class scenarios are a designation for catastrophic events that result in global annihilation or severe alteration of reality, often caused by particularly dangerous SCPs or events involving multiple anomalies.',
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'What is the "Mobile Task Force" (MTF)?',
              answer:
                  "Mobile Task Forces are specialized units within the SCP Foundation, composed of personnel drawn from across the Foundation's ranks. They are assembled to deal with specific kinds of threats or situations that exceed the capabilities of standard security personnel.",
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'What is the "Chaos Insurgency"?',
              answer:
                  "The Chaos Insurgency is a rogue faction that splintered from the SCP Foundation, often seeking to weaponize or exploit anomalies for their own purposes.",
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'Can I pet SCP-999 (The Tickle Monster)?',
              answer:
                  "Foundation regulations require a formal request for interaction. Physical contact typically induces intense euphoria and a sticky residue. Exercise caution; SCP-999's reactions can be overwhelming. Unauthorized attempts at petting are strongly discouraged.",
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'What happens to people who encounter SCPs?',
              answer:
                  "The Foundation's response to civilian encounters with SCPs varies depending on the situation. It can range from administering amnestics and releasing the individuals to more drastic measures if the anomaly poses a significant threat or if the individuals have been heavily compromised.",
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'Are all SCPs dangerous?',
              answer:
                  "No, not all SCPs are inherently dangerous. Some are simply unusual objects or entities that require containment to prevent their properties from becoming widely known or misused. Safe-class SCPs, for example, are generally considered easy to contain.",
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'How does the Foundation discover new SCPs?',
              answer:
                  "The Foundation has a global network of informants, researchers, and surveillance systems dedicated to identifying and tracking anomalous activity. Reports can come from various sources, both mundane and unusual.",
            ),
            SizedBox(height: 16.0),
            ExpandableFAQItem(
              question: 'What are memetics?',
              answer:
                  'In the context of the SCP Foundation, memetics refers to the study and application of anomalous information or ideas ("memes") that can spread and have dangerous effects simply through their transmission.',
            ),
          ],
        ),
      ),
    );
  }
}

// Constructor for FAQ boxes
class ExpandableFAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const ExpandableFAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<ExpandableFAQItem> createState() => _ExpandableFAQState();
}

// Styling for FAQ boxes
class _ExpandableFAQState extends State<ExpandableFAQItem> {
  bool _isExpanded = false; // Initial state (not expanded)
  double _collapsedHeight = 60.0; // Initial collapsed height
  double _expandedHeight = 240.0; // Expanded height

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access application theme

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: _isExpanded ? _expandedHeight : _collapsedHeight,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8.0),
          color: theme.colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question,
                overflow:
                    _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 8.0),
                Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  softWrap: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
