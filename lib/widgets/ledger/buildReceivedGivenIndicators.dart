import 'package:flutter/material.dart';
import 'dart:math' as math; // Import dart:math for the min function

class ReceivedGivenIndicators extends StatelessWidget {
  final String totalBalance;
  const ReceivedGivenIndicators({
    Key? key,
    required this.totalBalance, // Accept totalBalance as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert totalBalance to a number and check if it's negative or positive
    final double balance = double.tryParse(totalBalance) ?? 0.0;
    final bool isNegative = balance < 0;

    // Define color based on the balance
    final Color primaryColor = isNegative ? Colors.red.shade700 : Colors.green.shade700;
    final Color backgroundColor = isNegative ? Colors.red.shade100 : Colors.green.shade100;
    final IconData arrowIcon = isNegative ? Icons.arrow_downward : Icons.arrow_upward;

    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate the available width after subtracting the horizontal padding
    double availableWidth = screenWidth - 20; // Adjusted for total padding

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: SizedBox(
          width: math.min(availableWidth, 300), // Use available width or max width of 300
          // Adjusted height to accommodate both rows comfortably
          height: 120,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(arrowIcon, color: primaryColor, size: 40),
                        SizedBox(width: 4),
                        Text('Rs.$totalBalance', style: TextStyle(color: primaryColor, fontSize: 30)),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color for the reminder box
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, color: primaryColor, size: 16),
                          SizedBox(width: 4),
                          Text('2 Apr', style: TextStyle(color: primaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconButton(Icons.message, "Whatsapp", primaryColor),
                    _iconButton(Icons.message, "Message", primaryColor),
                    _iconButton(Icons.call, "Call", primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: 4), // Gap between icon and text
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
