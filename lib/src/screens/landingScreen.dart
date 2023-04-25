import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo2/src/constants/colors.dart';
import 'package:todo2/src/screens/home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/note.json', width: 250),
              Text(
                "Daily Notes",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Take Notes, reminders, set tartgers, collect resources, and secure privacy",
                  style: TextStyle(fontSize: 18, color: Colors.white60),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Start The App",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
