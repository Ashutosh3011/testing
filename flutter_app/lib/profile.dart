import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Database/services.dart';
import 'constants.dart';
import './widgets/custom_shape.dart';
import './widgets/customappbar.dart';
import './widgets/responsive_ui.dart';
import './widgets/textformfield.dart';
import 'package:email_validator/email_validator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class BloodGroup {
  int id;
  String name;

  BloodGroup(this.id, this.name);

  static List<BloodGroup> getBloodGroups() {
    return <BloodGroup>[
      BloodGroup(1, 'Blood Group'),
      BloodGroup(2, 'A -ve'),
      BloodGroup(3, 'A +ve'),
      BloodGroup(4, 'B -ve'),
      BloodGroup(5, 'B +ve'),
      BloodGroup(6, 'AB -ve'),
      BloodGroup(7, 'AB +ve'),
      BloodGroup(8, 'O -ve'),
      BloodGroup(9, 'O +ve'),
    ];
  }
}

class Gender {
  int id;
  String name;

  Gender(this.id, this.name);

  static List<Gender> getGenders() {
    return <Gender>[
      Gender(1, 'Gender'),
      Gender(2, 'Male'),
      Gender(3, 'Female'),
    ];
  }
  
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  File _image;
  DateTime _date;
  SharedPreferences _sharedPreferences;
  int data = 0;

  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;
  Contact _contact1;
  Contact _contact2;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bloodTypeController = TextEditingController();

  Future<Null> getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => _image = image);
    print("_image: $image");
  }

  List<BloodGroup> _bloodGroups = BloodGroup.getBloodGroups();
  List<DropdownMenuItem<BloodGroup>> _dropdownMenuBloodItems;
  BloodGroup _selectedBloodGroup;

  List<Gender> _gender = Gender.getGenders();
  List<DropdownMenuItem<Gender>> _dropdownMenuItems;
  Gender _selectedGender;

  String mobile,
      fname,
      lname,
      email,
      gender,
      blood,
      dob,
      econt1,
      econt2,
      econt3,
      imageString;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_gender);
    _selectedGender = _dropdownMenuItems[0].value;

    _dropdownMenuBloodItems = buildDropdownMenuBloodItems(_bloodGroups);
    _selectedBloodGroup = _dropdownMenuBloodItems[0].value;
    initializeSharedPref();
    super.initState();
  }

  void initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    mobile = _sharedPreferences.getString('mobile') ?? null;
    fname = _sharedPreferences.getString('fname') ?? null;
    lname = _sharedPreferences.getString('lname') ?? null;
    email = _sharedPreferences.getString('email') ?? null;
    gender = _sharedPreferences.getString('gender') ?? null;
    blood = _sharedPreferences.getString('blood') ?? null;
    dob = _sharedPreferences.getString('dob') ?? null;
    econt1 = _sharedPreferences.getString('econt1') ?? null;
    econt2 = _sharedPreferences.getString('econt2') ?? null;
    econt3 = _sharedPreferences.getString('econt3') ?? null;
    imageString = _sharedPreferences.getString('image') ?? null;
    // data = _sharedPreferences.getInt('value') ?? 0;
    print("Data = $data");
  }

  List<DropdownMenuItem<BloodGroup>> buildDropdownMenuBloodItems(
      List bloodGroups) {
    List<DropdownMenuItem<BloodGroup>> items = List();
    for (BloodGroup bloodGroup in bloodGroups) {
      items.add(DropdownMenuItem(
        value: bloodGroup,
        child: Text(bloodGroup.name),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<Gender>> buildDropdownMenuItems(List genders) {
    List<DropdownMenuItem<Gender>> items = List();
    for (Gender gender in genders) {
      items.add(
        DropdownMenuItem(
          value: gender,
          child: Text(gender.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Gender selectedGender) {
    setState(() {
      _selectedGender = selectedGender;
      print(_selectedGender.name);
    });
  }

  onChangeDropdownBloodItem(BloodGroup selectedBloodGroup) {
    setState(() {
      _selectedBloodGroup = selectedBloodGroup;
      print(_selectedBloodGroup.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:
                  large ? _height / 8 : (medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height:
                  large ? _height / 12 : (medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            child: CircleAvatar(
              child: ClipOval(
                child: Center(
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.orange[200],
                        )
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                ),
              ),
              radius: 75,
              backgroundColor: Colors.white,
            ),
            onTap: () {
              getImage();
            },
          ),
        )
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            genderFormField(),
            SizedBox(height: _height / 60.0),
            bloodGroupTextFormField(),
            SizedBox(height: _height / 60.0),
            dobTextFormField(),
            SizedBox(height: _height / 60.0),
            emergencyContact(),
            SizedBox(height: _height / 60.0),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
      textEditingController: firstNameController,
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
        keyboardType: TextInputType.text,
        icon: Icons.person,
        hint: "Last Name",
        textEditingController: lastNameController);
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
      textEditingController: emailController,
    );
  }

  Widget genderFormField() {
    
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: Center(
        heightFactor: 1.2,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: _width / 25,
            ),
            Icon(
              Icons.supervised_user_circle,
              color: Colors.orange[200],
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                iconEnabledColor: Colors.white,
                style: TextStyle(color: Colors.black54, fontSize: 16),
                value: _selectedGender,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bloodGroupTextFormField() {
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: Center(
        heightFactor: 1.2,
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
              width: 10,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                iconEnabledColor: Colors.white,
                style: TextStyle(color: Colors.black54, fontSize: 16),
                value: _selectedBloodGroup,
                items: _dropdownMenuBloodItems,
                onChanged: onChangeDropdownBloodItem,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dobTextFormField() {
    return Container(
      height: 58,
      width: 340,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 10), // changes position of shadow
            ),
          ]),
      child: Center(
        heightFactor: 50,
        child: GestureDetector(
            child: Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Icon(
                    Icons.date_range,
                    color: Colors.orange[200],
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  (_date == null
                      ? 'Date Of Birth'
                      : DateFormat("dd-MM-yyyy").format(_date).toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2021))
                  .then((date) {
                _date = date;
                TextStyle(color: Colors.green);
              });
            }),
      ),
    );
  }

  Widget emergencyContact() {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: 58,
              width: 340,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 10), // changes position of shadow
                    ),
                  ]),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5.0),
                  IconButton(
                    icon: Icon(
                      Icons.contact_phone,
                      color: Colors.orange[200],
                    ),
                    onPressed: () async {
                      Contact contact = await _contactPicker.selectContact();
                      setState(() {
                        _contact = contact;
                      });
                    },
                  ),
                  Expanded(
                      child: Text(
                          _contact == null
                              ? "Select Emergency Contact"
                              : _contact.fullName +
                                  ": " +
                                  _contact.phoneNumber.number,
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54))),
                ],
              ),
            ),
            onTap: () async {
              Contact contact = await _contactPicker.selectContact();
              setState(() {
                _contact = contact;
              });
            },
          ),
          SizedBox(
            height: _height / 60.0,
          ),
          GestureDetector(
            child: Container(
              height: 58,
              width: 340,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 10), // changes position of shadow
                    ),
                  ]),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5.0),
                  IconButton(
                    icon: Icon(
                      Icons.contact_phone,
                      color: Colors.orange[200],
                    ),
                    onPressed: () async {
                      Contact contact = await _contactPicker.selectContact();
                      setState(() {
                        _contact1 = contact;
                      });
                    },
                  ),
                  Expanded(
                      child: Text(
                          _contact1 == null
                              ? "Select Emergency Contact"
                              : _contact1.fullName +
                                  ": " +
                                  _contact1.phoneNumber.number,
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54))),
                ],
              ),
            ),
            onTap: () async {
              Contact contact = await _contactPicker.selectContact();
              setState(() {
                _contact1 = contact;
              });
            },
          ),
          SizedBox(
            height: _height / 60.0,
          ),
          GestureDetector(
            child: Container(
              height: 58,
              width: 340,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 10), // changes position of shadow
                    ),
                  ]),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5.0),
                  IconButton(
                    icon: Icon(
                      Icons.contact_phone,
                      color: Colors.orange[200],
                    ),
                    onPressed: () async {
                      Contact contact = await _contactPicker.selectContact();
                      setState(() {
                        _contact2 = contact;
                      });
                    },
                  ),
                  Expanded(
                      child: Text(
                          _contact2 == null
                              ? "Select Emergency Contact"
                              : _contact2.fullName +
                                  ": " +
                                  _contact2.phoneNumber.number,
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54))),
                ],
              ),
            ),
            onTap: () async {
              Contact contact2 = await _contactPicker.selectContact();
              setState(() {
                _contact2 = contact2;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        validate();
        print("Routing to your account");
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: large ? _width / 4 : (medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: large ? 14 : (medium ? 12 : 10)),
        ),
      ),
    );
  }

  void validate() {
    if (firstNameController.text.length == 0 ||
        lastNameController.text.length == 0 ||
        emailController.text.length == 0 ||
        _selectedGender.name == "Gender" ||
        _selectedBloodGroup.name == "Blood Group" ||
        EmailValidator.validate(emailController.text) == false ||
        // dob == null ||
        _contact == null ||
        _contact1 == null ||
        _contact2 == null ||
        _image == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                "Hey there...",
                style: TextStyle(fontSize: 18),
              ),
              content: Text(
                "Please fill all the details",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      String dob = DateFormat("dd-MM-yyyy").format(_date).toString();
      String eCont1 = _contact.fullName + ": " + _contact.phoneNumber.number;
      String eCont2 = _contact1.fullName + ": " + _contact1.phoneNumber.number;
      String eCont3 = _contact2.fullName + ": " + _contact2.phoneNumber.number;

      print("Mobile Number : " + mobile);
      print("First Name : " + firstNameController.text);
      print("Last Name : " + lastNameController.text);
      print("Email : " + emailController.text);
      print("Gender : " + _selectedGender.name);
      print("Blood Group : " + _selectedBloodGroup.name);
      print("dob: " + dob);
      print("e_cont1 :" + eCont1);
      print("e_cont2 :" + eCont2);
      print("e_cont3 :" + eCont3);
      PostServices.addEmployee(
              mobile,
              firstNameController.text,
              lastNameController.text,
              emailController.text,
              _selectedGender.name,
              _selectedBloodGroup.name,
              dob,
              eCont1,
              eCont2,
              eCont3)
          .then((result) {
        if ('success' == result) {
          print("Added Employees to Database");
        }
      });

      var imgString = base64Encode(_image.readAsBytesSync());
      _sharedPreferences.setString('image', imgString);
      print(imgString);

      _sharedPreferences.setString('email', emailController.text);
      _sharedPreferences.setString('fname', firstNameController.text);
      _sharedPreferences.setString('lname', lastNameController.text);
      _sharedPreferences.setString('gender', _selectedGender.name);
      _sharedPreferences.setString('blood', _selectedBloodGroup.name);
      _sharedPreferences.setString('dob', dob);
      _sharedPreferences.setString('econt1', eCont1);
      _sharedPreferences.setString('econt2', eCont2);
      _sharedPreferences.setString('econt3', eCont3);

      // MobileServices.addMobile(mobileNumber);

      Navigator.of(context).pushNamed(profileDisplay);
    }
  }
}
