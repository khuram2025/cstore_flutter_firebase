import 'package:flutter/material.dart';
import '../../ApiService.dart';
import '../../model/data.dart';

class LedgerSummary extends StatelessWidget {
  const LedgerSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SummaryData>(
      future: fetchSummaryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          return Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryBox(
                  title: "Rs ${snapshot.data!.totalSumReceived}",
                  subtitle: "You will Get",
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                ),
                SizedBox(width: 16,),
                _buildSummaryBox(
                  title: "Rs ${snapshot.data!.totalSumPaid}",
                  subtitle: "You will Pay",
                  icon: Icons.arrow_upward,
                  color: Colors.red,
                ),
              ],
            ),
          );
        } else {
          return Text("No data");
        }
      },
    );
  }

  Widget _buildSummaryBox({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
