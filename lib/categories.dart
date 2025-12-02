import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  void _submitCategories() {}

  @override
  Widget build(BuildContext context) {
    List<String> leftCategories = [
      "Academic Fit",
      "Location & Environment",
      "Campus Life",
    ];

    List<String> rightCategories = [
      "Career Opportunities",
      "Cost & Financial Aid",
      "Size & Reputation",
    ];

    double buttonWidth = 150.0; // Set the fixed width for buttons

    return Scaffold(
      appBar: AppBar(title: const Text('Search by Criteria')),

      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...leftCategories.map((label) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        child: SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: _submitCategories,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF7fb480),
                              textStyle: TextStyle(fontSize: 12),
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            child: Text(label),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...rightCategories.map((label) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        child: SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: _submitCategories,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF7fb480),
                              textStyle: TextStyle(fontSize: 12),
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            child: Text(label),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),

            ElevatedButton(
              onPressed: _submitCategories,
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF7fb480),
                textStyle: TextStyle(fontSize: 12),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              ),
              child: const Text("Enter"),
            ),
            const SizedBox(width: 25, height: 10),
          ],
        ),
      ),
    );
  }
}
