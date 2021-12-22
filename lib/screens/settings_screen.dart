import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/helpers/utils.dart';
import 'package:firebase_auth_practice/screens/main_screen/main_screen.dart';
import 'package:firebase_auth_practice/screens/registration/authentication_screen.dart';
import 'package:firebase_auth_practice/screens/saved_items_screen.dart';
import 'package:firebase_auth_practice/widgets/custom_header_container_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController complaint_controller = TextEditingController();

  String myID = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController subject_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainerDesign(
      paddingTop: 0,
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // User card
            BigUserCard(
              cardColor: Colors.red,
              userName: "${(mUser!.firstName + " " + mUser!.lastName)}",

              userProfilePic: NetworkImage(mUser!.image_url),
              cardActionWidget: SettingsItem(
                icons: Icons.edit,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 50,
                  backgroundColor: Colors.yellow[600],
                ),
                title: "Modify",
                subtitle: "Tap to update your Profile",
                onTap: () {
                  closeAllScreens(context);
                  openScreen(
                      context,
                      MainScreen(
                        defaultSelectedTab: 4,
                      ));
                },
              ),
            ),
            // You can add a settings title
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {
                    openScreen(context, SavedItemsScreen());
                  },
                  icons: CupertinoIcons.pencil_outline,
                  iconStyle: IconStyle(),
                  title: 'Saved',
                  subtitle: "View saved items",
                ),
                SettingsItem(
                  onTap: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("Confirm Logout"),
                            content:
                                Text("Are you sure to logout from $appName?"),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(
                                  "Yes",
                                  style: normal_h2Style_bold,
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut().then((value) {
                                    closeAllScreens(context);
                                    openScreen(context, AuthenticationScreen());
                                  });
                                },
                                isDestructiveAction: true,
                              ),
                              CupertinoDialogAction(
                                child: Text(
                                  "No",
                                  style: normal_h2Style_bold,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                isDefaultAction: true,
                              ),
                            ],
                          );
                        });
                  },
                  icons: Icons.exit_to_app_rounded,
                  iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red),
                  title: "Logout",
                  subtitle: "Logout your account",
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "Policies",
              items: [
                SettingsItem(
                  onTap: () {
                    launchURL(
                        "https://www.websitepolicies.com/policies/view/6QJ5MRmq");
                  },
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'DMCA Policy',
                  subtitle: "Check terms and conditions",
                  // trailing: Switch.adaptive(
                  //   value: false,
                  //   onChanged: (value) {},
                  // ),
                ),
                SettingsItem(
                  onTap: () {
                    launchURL(
                        'https://www.websitepolicies.com/policies/view/ev9zZDqg');
                  },
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'Terms and Conditions',
                  subtitle: "Check terms and conditions",
                  // trailing: Switch.adaptive(
                  //   value: false,
                  //   onChanged: (value) {},
                  // ),
                ),
                SettingsItem(
                  onTap: () {
                    launchURL(
                        "https://www.websitepolicies.com/policies/view/o9HOm6BZ");
                  },
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'Refund Policy',
                  subtitle: "Learn more about refund policy",
                  // trailing: Switch.adaptive(
                  //   value: false,
                  //   onChanged: (value) {},
                  // ),
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "More",
              items: [
                SettingsItem(
                  onTap: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Facing Problem?'),
                            content: Card(
                              margin: EdgeInsets.only(top: 10),
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: subject_controller,
                                    decoration: InputDecoration(
                                        labelText: "Subject",
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide.none),
                                        contentPadding: EdgeInsets.all(10),
                                        fillColor: Colors.grey.shade50),
                                    maxLines: 1,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: TextField(
                                      controller: complaint_controller,
                                      decoration: InputDecoration(
                                          labelText: "Message",
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none),
                                          contentPadding: EdgeInsets.all(10),
                                          fillColor: Colors.grey.shade50),
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: Text("Send"),
                                onPressed: () {
                                  String complaint =
                                      complaint_controller.text.trim();
                                  String subject =
                                      subject_controller.text.trim();
                                  if (!complaint.isEmpty && !subject.isEmpty) {
                                    launchMail(
                                        toMailId: "help@mobistylez.com",
                                        subject: "${subject}",
                                        body: "${complaint}");

                                    Navigator.pop(context);
                                  } else {
                                    showSnackBar("Both fields Required", context);
                                  }
                                },
                                isDefaultAction: true,
                                isDestructiveAction: true,
                              ),
                            ],
                          );
                        });
                  },
                  icons: Icons.support_agent,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.blue,
                  ),
                  title: 'Customer Support',
                  subtitle: "Contact our support team",
                ),
                SettingsItem(
                  onTap: () {
                    launchURL(
                        "https://www.websitepolicies.com/policies/view/6QJ5MRmq");
                  },
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About Us',
                  subtitle: "Learn more about $appName",
                ),
                SettingsItem(
                  onTap: () {
                    launchURL(
                        "https://www.websitepolicies.com/policies/view/6QJ5MRmq");
                  },
                  icons: Icons.star,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.orange,
                  ),
                  title: 'Rate Us',
                  subtitle: "Tap to rate this app",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
