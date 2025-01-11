import 'package:flutter/material.dart';
import 'package:llm_project/screens/wrapper.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background Image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom Section
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "All LLMs in one place",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Click to start chatting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/wrapper');
                      },
                      icon: Icon(
                        Icons.arrow_forward_outlined,
                        size: 26, // Make the icon larger
                      ),
                      label: Text(
                        "Start Chatting",
                        style: TextStyle(fontSize: 18,color: Colors.black), // Larger font size for the label
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70, // Button color
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Larger padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
