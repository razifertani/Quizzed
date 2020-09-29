import 'package:QuizzedGame/appLocalizations.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:QuizzedGame/widgets/widgets.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:system_settings/system_settings.dart';

class Settings extends StatefulWidget {
  final String userUID;
  final String lang;
  Settings({Key key, @required this.lang, @required this.userUID})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLoading = false;
  String userUID;
  bool _leadingSwitchValue = true;

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
                leading: Icon(Icons.fingerprint),
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
            title: 'Section',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {},
              ),
              SettingsTile.switchTile(
                title: 'Light Mode / Dark Mode',
                leading: Icon(Icons.fingerprint),
                switchValue: _leadingSwitchValue,
                onToggle: (bool value) {
                  setState(() {
                    value == true ? value = false : value = true;
                    AdaptiveTheme.of(context).toggleThemeMode();
                  });
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
