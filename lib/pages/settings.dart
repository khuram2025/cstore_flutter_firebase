import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService.dart';
import '../constants.dart';
import '../model/data.dart';
import '../screens/authetication/login.dart';
import '../screens/authetication/sighun.dart';
import './settings/help.dart';
import './settings/share.dart';
import './settings/backup.dart';
import './settings/account.dart';
import './settings/profile.dart';
import './settings/language.dart';
import './settings/security.dart';
import './settings/subscription.dart';
import './settings/update_number.dart';
import './settings/find_defaulter.dart';

import '../widgets/settings/setting_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken != null) {
      var fetchedUserInfo = await fetchUserInfo(authToken);
      if (fetchedUserInfo != null) {
        setState(() {
          userInfo = fetchedUserInfo;
        });
      }
    } else {
      print('Auth token not found');
      // Handle the case when authToken is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Consumer<DataModel>(
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, ProfilePage.id),
                      child:  Row(
                        children: [
                          Hero(
                            tag: 'profile',
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180.0,
                                child: Text(
                                  userInfo != null ? 'User Name: ${userInfo!['name']}' : 'User Name',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                ),

                              ),
                              SizedBox(
                                width: 150.0,
                                child: Text(
                                  'Krishna Pearls & Jewllers',
                                  style: TextStyle(
                                    color: kSecondaryAccent,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Divider(
                      color: kHighLightColor,
                      height: 3,
                      thickness: 2.0,
                    ),
                    SettingTile(
                      onTap: () {},
                      icon: Icons.add,
                      title: 'Create New Business',
                    ),
                    SettingTile(
                      onTap: () => Navigator.pushNamed(context, AccountPage.id),
                      icon: Icons.account_circle,
                      title: 'Account',
                      hideDivider: true,
                    ),
                    const Divider(
                      color: kHighLightColor,
                      height: 3,
                      thickness: 2.0,
                    ),
                    const SizedBox(height: 15.0),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Expanded(
                      child: ListView(
                        children: [
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              SubscriptionPage.id,
                            ),
                            icon: Icons.stars,
                            title: 'OkCredit Subscription Plan',
                            subTitle:
                                'Unlimited SMS, Ad Free, Priority Customer Support',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              LanguagePage.id,
                            ),
                            icon: Icons.translate,
                            title: 'Language',
                            subTitle: value.selectedLanguage,
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              UpdateNumberPage.id,
                            ),
                            icon: Icons.numbers,
                            title: 'Update Mobile Number',
                            subTitle: '80XXXXX46',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              BackupPage.id,
                            ),
                            icon: Icons.cloud_done_rounded,
                            title: 'Backup',
                            subTitle: 'Sync info, recovery number',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              SecurityPage.id,
                            ),
                            icon: Icons.lock,
                            title: 'Security',
                            subTitle: 'App lock, PIN, password, sign out',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              HelpPage.id,
                            ),
                            icon: Icons.help,
                            title: 'Help',
                            subTitle: 'FAQs, contact us, privacy policy',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              FindDefaulterPage.id,
                            ),
                            icon: Icons.person_off,
                            title: 'Find Defaulter',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              SharePage.id,
                            ),
                            icon: Icons.share,
                            title: 'Share',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              LoginPage.id, // Replace with the ID or route name of your login page
                            ),
                            icon: Icons.login,
                            title: 'Login',
                          ),
                          SettingTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              SignupPage.id, // Replace with the ID or route name of your signup page
                            ),
                            icon: Icons.app_registration,
                            title: 'Signup',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }
}
