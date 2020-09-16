import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin_example/constants.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String inputPin1 = "";
  String inputPin2 = "";
  String inputPin3 = "";
  String inputPin4 = "";
  int count = 0;
  String otpMatch = "";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding:
          EdgeInsets.fromLTRB(width / 12, height / 8, width / 10, height / 100),
      color: Colors.white,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: NetworkImage('http://142.93.217.138/Images/icon.png')),
      // gradient: LinearGradient(
      //   begin: Alignment.topRight,
      //   end: Alignment.bottomLeft,
      //   // stops: [0.1, 0.5, 0.7, 0.9],
      //   colors: [
      //     Colors.purple[300], Colors.purple[400],
      //     // Colors.orange[500],
      //     // Colors.orange[400],
      //     // Colors.orange[300],
      //     // Colors.orange[700],
      //   ],
      // ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          // padding: EdgeInsets.fromLTRB(10, 110, 10, 50),
          alignment: Alignment.center,
          child: Column(
            children: [
              // Text(
              //   "Ashutosh",
              //   style: TextStyle(fontSize: 40),
              // ),
              Image.network(
                'http://142.93.217.138/Images/icon.png',
                height: height / 8,
                width: width / 2,
              ),
              SizedBox(
                height: height / 100,
              ),
              pin(),

              numberKey(),
            ],
          ),
        ),
      ),
    );
  }

  pinStaring() {
    if (count == 1) {
      setState(() {
        inputPin1 = "*";
      });
    } else if (count == 2) {
      setState(() {
        inputPin2 = "*";
      });
    } else if (count == 3) {
      setState(() {
        inputPin3 = "*";
      });
    } else if (count == 4) {
      setState(() {
        inputPin4 = "*";
      });
    } else if (count == 0) {
      setState(() {
        inputPin1 = "";
        inputPin2 = "";
        inputPin3 = "";
        inputPin4 = "";
      });
    }
    if (otpMatch == "1234") {
      Navigator.of(context).pushNamed(homeScreen);
    }
  }

  Widget pin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PinEntries(
          onTap: () {},
          textData: Text(
            inputPin1,
            style: TextStyle(fontSize: 40),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        PinEntries(
          onTap: () {},
          textData: Text(
            inputPin2,
            style: TextStyle(fontSize: 40),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        PinEntries(
          onTap: () {},
          textData: Text(
            inputPin3,
            style: TextStyle(fontSize: 40),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        PinEntries(
          onTap: () {},
          textData: Text(
            inputPin4,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ],
    );
  }

  Widget numberKey() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "1";
                        print(otpMatch);
                        pinStaring();
                      },
                      textData: Text(
                        "1",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "4";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "4",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "";
                        print(otpMatch);
                        pinStaring();
                      },
                      textData: Text(
                        "7",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () => print("Back"),
                      textData: Text(
                        "",
                        style: TextStyle(fontSize: 40),
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Column(
                children: [
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "2";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "2",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "5";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "5",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "8";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "8",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "0";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "0",
                        style: TextStyle(fontSize: 40),
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Column(
                children: [
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "3";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "3",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "6";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "6",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count++;
                        otpMatch = otpMatch + "9";
                        pinStaring();
                        print(otpMatch);
                      },
                      textData: Text(
                        "9",
                        style: TextStyle(fontSize: 40),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  CircleButton(
                      onTap: () {
                        count = 0;
                        pinStaring();
                        otpMatch = "";
                        print(otpMatch);
                        //add System.pop()
                      },
                      textData: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 24),
                      )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Text textData;

  const CircleButton({Key key, this.onTap, this.textData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 85.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: new BoxDecoration(
          // color: Colors.orange,
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   // stops: [0, 0.5, 0.7, 0.9],
          //   colors: [
          //     Colors.orange[500],
          //     Colors.orange[400],
          //     Colors.orange[300],
          //     Colors.orange[700],
          //   ],
          // ),
          shape: BoxShape.circle,
        ),
        child: textData,
      ),
    );
  }
}

class PinEntries extends StatelessWidget {
  final GestureTapCallback onTap;
  final Text textData;

  const PinEntries({Key key, this.onTap, this.textData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 65.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: new BoxDecoration(
          // color: Colors.green[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25),
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   // stops: [0.1, 0.5, 0.7, 0.9],
          //   colors: [
          //     Colors.purple, Colors.purple[200],
          //     // Colors.orange[500],
          //     // Colors.orange[400],
          //     // Colors.orange[300],
          //     // Colors.orange[700],
          //   ],
          // ),
        ),
        child: textData,
      ),
    );
  }
}
