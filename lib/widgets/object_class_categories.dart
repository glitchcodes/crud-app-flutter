import 'package:flutter/material.dart';

class ObjectClassCategories extends StatelessWidget {
  ObjectClassCategories({super.key});

  final objectClasses = [
    { 'icon': 'assets/images/safe-class.png', 'label': 'Safe' },
    { 'icon': 'assets/images/euclid-class.png', 'label': 'Euclid' },
    { 'icon': 'assets/images/keter-class.png', 'label': 'Keter' },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Object Classes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(objectClasses.length, (index) {
                  final item = objectClasses[index];

                  return Card(
                      child: InkWell(
                        onTap: () {},
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 8
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  item['icon'] as String,
                                  width: 40,
                                  height: 40,
                                ),
                                // Icon(
                                //   item['icon'] as IconData,
                                //   size: 34,
                                // ),
                                SizedBox(height: 6),
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                      fontSize: 16
                                  ),
                                )
                              ],
                            )
                        ),
                      )
                  );
                })
            ),
          ],
        )
    );
  }
}
