import 'package:QuizzedGame/appLocalizations.dart';
import 'package:QuizzedGame/locator.dart';
import 'package:QuizzedGame/services/database.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:system_settings/system_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  final String userUID;
  final String lang;
  Settings({Key key, @required this.lang, @required this.userUID})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final dataBaseService = locator.get<DataBaseService>();
  bool _leadingSwitchValue = true;
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('Assets/appBar.png'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SettingsSection(
            title: AppLocalizations.of(context).translate('settings/first'),
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: AppLocalizations.of(context).translate('Lang'),
                leading: Icon(Icons.language),
                onTap: () {
                  SystemSettings.locale();
                },
              ),
              SettingsTile.switchTile(
                title: 'Light Mode / Dark Mode',
                leading: Icon(
                  _leadingSwitchValue == true
                      ? Icons.brightness_3
                      : Icons.brightness_7,
                ),
                switchValue: _leadingSwitchValue,
                onToggle: (bool value) {
                  setState(() {
                    _leadingSwitchValue = value;
                    AdaptiveTheme.of(context).toggleThemeMode();
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Feedback',
            tiles: [
              SettingsTile(
                title: 'Report a bug',
                leading: Icon(Icons.bug_report),
                onTap: () {
                  Alert(
                    context: context,
                    title: AppLocalizations.of(context)
                        .translate('settings/fourth'),
                    style: AlertStyle(
                      titleStyle: Theme.of(context).textTheme.bodyText2,
                    ),
                    content: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.bug_report),
                            labelText: AppLocalizations.of(context)
                                .translate('settings/second'),
                          ),
                          onChanged: (value) {
                            message = value;
                          },
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () {
                          Map<String, String> bugData = {
                            "userId": widget.userUID,
                            "message": message,
                          };
                          dataBaseService.addBug(bugData, widget.userUID);
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)
                                .translate('settings/fifth'),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.black87,
                            fontSize: 16.0,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('settings/third'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ).show();
                },
              ),
              SettingsTile(
                title: 'Enjoying the game ?',
                subtitle: 'Note it on Playstore',
                leading: Icon(Icons.star),
                onTap: () async {
                  // String url = 'https://www.linkedin.com/in/razifertani/';
                  // await launch(url);
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Contact the developer',
            tiles: [
              SettingsTile(
                title: 'Contact us',
                leading: Icon(Icons.developer_mode),
                onTap: () async {
                  // String url = 'tel:+216 58 116 113';
                  // String url = 'https://www.linkedin.com/in/razifertani/';
                  String url = ('mailto:razi.fertani@esprit.tn');
                  await launch(url);
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: buildConvexAppBar(
        context,
        4,
        widget.userUID,
        widget.lang,
      ),
    );
  }
}
