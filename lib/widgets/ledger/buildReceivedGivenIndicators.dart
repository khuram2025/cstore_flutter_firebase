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
              color: Colors.green.shade100,
              border: Border.all(color: Colors.green.shade700),
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
                        Icon(Icons.arrow_upward, color: Colors.green.shade700, size: 40),
                        SizedBox(width: 4),
                        Text('Rs.$totalBalance', style: TextStyle(color: Colors.green.shade700, fontSize: 30)),
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
                          Icon(Icons.calendar_today, color: Colors.green.shade700, size: 16),
                          SizedBox(width: 4),
                          Text('2 Apr', style: TextStyle(color: Colors.green.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconButton(Icons.message, "Whatsapp", Colors.green.shade700),
                    _iconButton(Icons.message, "Message", Colors.green.shade700),
                    _iconButton(Icons.call, "Call", Colors.green.shade700),
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
