import 'package:flutter/material.dart';

import '../../ApiService.dart';
import '../../constants.dart';
import '../../model/data.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/account/account_card.dart';
import '../../widgets/settings/setting_tile.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const id = '/accountPage';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<SummaryData> summaryDataFuture;

  @override
  void initState() {
    super.initState();
    summaryDataFuture = fetchSummaryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Column(
            children: [
              const CustomBackButton(title: 'Account'),
              FutureBuilder<SummaryData>(
                future: summaryDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    final totalCustomers = snapshot.data!.totalCustomers;
                    final totalSum = snapshot.data!.totalSum;
                    return AccountCard(
                      icon: Icons.book,
                      accountType: 'Customer',
                      paymentType: 'R',
                      amount: totalSum, // Dynamically fetched total sum
                      totalCustomers: totalCustomers, // Dynamically fetched total customers
                      totalSum: totalSum, // Dynamically fetched total sum
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  return CircularProgressIndicator(); // Loading state
                },
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: kHighLightColor),
                ),
                child: const SettingTile(
                  icon: Icons.download,
                  title: 'Download Backup',
                  hideDivider: true,
                ),
              ),
              // Add more widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}


