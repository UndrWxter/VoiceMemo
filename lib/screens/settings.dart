import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:notes/services/sharedPref.dart';

class SettingsPage extends StatefulWidget {
  final Function(Brightness brightness) changeTheme;

  const SettingsPage({
    Key? key, 
    required this.changeTheme,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String selectedTheme;

  @override
  void initState() {
    super.initState();
    selectedTheme = 'light';
  }

  @override
  Widget build(BuildContext context) {
    selectedTheme = Theme.of(context).brightness == Brightness.dark 
        ? 'dark' 
        : 'light';

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: const Icon(OMIcons.arrowBack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                  child: buildHeaderWidget(context),
                ),
                buildCardWidget(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'App Theme',
                        style: TextStyle(
                          fontFamily: 'ZillaSlab', 
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Radio<String>(
                            value: 'light',
                            groupValue: selectedTheme,
                            onChanged: handleThemeSelection,
                          ),
                          const Text(
                            'Light theme',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Radio<String>(
                            value: 'dark',
                            groupValue: selectedTheme,
                            onChanged: handleThemeSelection,
                          ),
                          const Text(
                            'Dark theme',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                buildCardWidget(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'About app',
                        style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Developed by'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Text(
                            'Roshan',
                            style: TextStyle(
                              fontFamily: 'ZillaSlab', 
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: OutlinedButton.icon(
                          icon: const Icon(OMIcons.link),
                          label: Text(
                            'GITHUB',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: openGitHub,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          'Made With'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              FlutterLogo(size: 40),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Flutter',
                                  style: TextStyle(
                                    fontFamily: 'ZillaSlab', 
                                    fontSize: 24,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCardWidget(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
          )
        ],
      ),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        'Settings',
        style: TextStyle(
          fontFamily: 'ZillaSlab',
          fontWeight: FontWeight.w700,
          fontSize: 36,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void handleThemeSelection(String? value) {
    if (value == null) return;
    
    setState(() {
      selectedTheme = value;
    });
    
    widget.changeTheme(
      value == 'light' ? Brightness.light : Brightness.dark,
    );
    setThemeInSharedPref(value);
  }

  Future<void> openGitHub() async {
    final Uri url = Uri.parse('https://www.github.com/roshanrahman');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
