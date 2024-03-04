import 'package:flutter/material.dart';
import '../../constants.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.color,
    required this.name,
    required this.amount,
    required this.remarks, // Now used for total balance
    required this.type,
    required this.date,
    required this.openingBalance, // New field for opening balance
    this.onTap,
  });

  final int color;
  final String name;
  final String amount;
  final String remarks; // Total balance
  final String type;
  final String date;
  final String openingBalance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the total balance
    final bool isBalancePositive = double.parse(remarks) >= 0;
    final Color balanceColor = isBalancePositive ? Colors.green : Colors.red;

    // Format balance to always show as a positive number
    final String formattedBalance = (double.parse(remarks)).abs().toStringAsFixed(2);

    String displayNameInitial = name.isNotEmpty ? name[0] : '#';
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0.0),
            visualDensity: const VisualDensity(horizontal: -2),
            leading: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Color(color),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  displayNameInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rs.$formattedBalance', // Shows total balance formatted as positive
                    style: TextStyle(
                      color: balanceColor, // Color based on positive or negative balance
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: "Opening Balance: ₹$amount", style: TextStyle(color: Colors.grey.shade600)), // Show opening balance
                        TextSpan(
                          text: ' $type added on ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(text: date),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: kHighLightColor,
            height: 5,
          )
        ],
      ),
    );
  }
}
