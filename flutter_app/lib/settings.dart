import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './localdata.dart';
import './constants.dart';
import 'home.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(),
    );
  }
}

class TriggerOption {
  int id;
  String name;
  static String standard = "2x VolumeUp + 1x VolumeDown";

  TriggerOption(this.id, this.name);

  static List<TriggerOption> getTriggerOption() {
    return <TriggerOption>[
      TriggerOption(1, standard),
      TriggerOption(2, 'Custom Trigger'),
    ];
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // List<int> triggerSequence = List();

  SharedPreferences _sharedPreferences;
  String fname = "";
  String lname = "";
  String imageString = "";
  Image imageFromPreferences;
  bool triggerSwitch = true;
  int dropDownValue = 0;

  List<TriggerOption> _triggerOptions = TriggerOption.getTriggerOption();
  List<DropdownMenuItem<TriggerOption>> _dropdownMenuTriggerOptionItems;
  TriggerOption _selectedTriggerOption;

  @override
  void initState() {
    super.initState();

    initializeSharedPref();

    print("initcheck = $dropDownValue");
    _dropdownMenuTriggerOptionItems =
        buildDropdownMenuTriggerOptionItems(_triggerOptions);
  }

  void initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    fname = _sharedPreferences.getString('fname') ?? null;
    lname = _sharedPreferences.getString('lname') ?? null;
    dropDownValue = _sharedPreferences.getInt('dropdown');
    triggerSwitch = _sharedPreferences.getBool('triggerSwitch') ?? null;
    imageString = _sharedPreferences.getString('image') ?? null;
    imageFromPreferences = Image.memory(base64Decode(imageString));
    print("Data = $fname $triggerSwitch");

    if (triggerSwitch == null) {
      triggerSwitch = true;
      _sharedPreferences.setBool('triggerSwitch', true);
    }

    setState(() {
      if (dropDownValue == null) {
        dropDownValue = 0;
        _selectedTriggerOption = _dropdownMenuTriggerOptionItems[0].value;
        print(
            "Errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrooooooooooooooooooooooor");
      } else {
        _selectedTriggerOption =
            _dropdownMenuTriggerOptionItems[dropDownValue].value;
      }
    });
  }

  List<DropdownMenuItem<TriggerOption>> buildDropdownMenuTriggerOptionItems(
      List triggerOptions) {
    List<DropdownMenuItem<TriggerOption>> items = List();
    for (TriggerOption triggerOption in triggerOptions) {
      items.add(DropdownMenuItem(
        value: triggerOption,
        child: Text(triggerOption.name),
      ));
    }
    return items;
  }

  onChangeDropdownTriggerOptionItem(TriggerOption selectedTriggerOption) {
    setState(() {
      _selectedTriggerOption = selectedTriggerOption;
      print(_selectedTriggerOption.name);
      if (_selectedTriggerOption.id == 1) {
        String fileContents = "1,1,2";
        LocalData.saveToFile(fileContents);

        _sharedPreferences.setInt('dropdown', 0);
      }
      if (_selectedTriggerOption.id == 2) {
        print("Custom Trigger Selected");
        _sharedPreferences.setInt('dropdown', 1);
        Navigator.of(context).pushNamed(customTriggerScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.orange[200]])),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.pinkAccent,
            Colors.orange[200],
          ])),
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 64, 10, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    profilePicture(),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        // "",
                        fname + " " + lname,
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                ListTile(
                    title: new Text("Home"),
                    onTap: () {
                      if (dropDownValue == 0) {
                        String fileContents = "1,1,2";
                        LocalData.saveToFile(fileContents);
                      }

                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }),
                new ListTile(
                    title: new Text("Profile"),
                    onTap: () {
                      Navigator.of(context).pushNamed(profileDisplay);
                    }),
              ],
            ),
          ),
        ),
      ),
      body: Column(children: <Widget>[
        Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Trigger",
                  style: TextStyle(fontSize: 22),
                ),
                trailing: Switch(
                  value: triggerSwitch,
                  onChanged: (value) {
                    setState(() {
                      triggerSwitch = value;
                      _sharedPreferences.setBool('triggerSwitch', value);
                      print(triggerSwitch);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              triggerSelect(),
            ],
          ),
        )
      ]),
    );
  }

  Widget profilePicture() {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        child: CircleAvatar(
          child: ClipOval(
            child: Center(
                child: imageFromPreferences == null
                    ? Icon(
                        Icons.add_a_photo,
                        color: Colors.orange[200],
                        size: 20,
                      )
                    : CircleAvatar(
                        radius: 30.0,
                        child: imageFromPreferences,
                        // backgroundImage: imageFromPreferences,
                        backgroundColor: Colors.transparent,
                      )

                // Image.file(
                //     image,
                //     fit: BoxFit.cover,
                //     width: MediaQuery.of(context).size.width,
                //   ),
                ),
          ),
          radius: 30,
          backgroundColor: Colors.white,
        ),
        onTap: () {
          // getImage();
        },
      ),
    );
  }

  Widget triggerSelect() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child: Center(
        heightFactor: 1.5,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 18,
            ),
            Icon(
              Icons.colorize,
              color: Colors.orange[200],
            ),
            SizedBox(
              width: 20,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                iconEnabledColor: Colors.white,
                style: TextStyle(color: Colors.black54, fontSize: 16),
                value: _selectedTriggerOption,
                items: _dropdownMenuTriggerOptionItems,
                onChanged: onChangeDropdownTriggerOptionItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
