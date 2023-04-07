import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuo/features/quiz.dart';
import 'package:virtuo/helpers/commonWidgets.dart';

class Concepts extends StatefulWidget {
  const Concepts({Key? key}) : super(key: key);

  @override
  State<Concepts> createState() => _ConceptsState();
}

class _ConceptsState extends State<Concepts> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar("Concept Visualisation", context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    width * 0.02, width * 0.02, width * 0.02, width * 0.02),
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigo.shade50),
                ),
                child: Center(
                  child: Text(
                    "DNA ",
                    style: GoogleFonts.lato(
                        fontSize: height / 58,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4),
                  ),
                ),
              ),
              Text(
                " DNA or Deoxyribonucleic acid is a long, thread-like molecule that carries genetic information. It is present in almost all living organisms, including bacteria, plants, and animals.",
                style: customTextStyle(height),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "The structure of DNA is double-stranded, which means it consists of two strands of nucleotides that run parallel to each other and are held together by hydrogen bonds. The nucleotides are composed of three parts: a sugar molecule called deoxyribose, a phosphate group, and a nitrogenous base. There are four types of nitrogenous bases in DNA: adenine (A), thymine (T), guanine (G), and cytosine (C).",
                style: customTextStyle(height),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "DNA replication is the process by which DNA makes a copy of itself. This process is essential for cell division, growth, and repair. During replication, the two strands of DNA unwind and separate, and new nucleotides are added to each strand according to the base-pairing rule (A with T, and G with C). As a result, two identical copies of DNA are produced.",
                style: customTextStyle(height),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "In conclusion, DNA is a fundamental molecule that carries the genetic information of living organisms, and its structure and function play a critical role in the development, growth, and evolution of life.",
                style: customTextStyle(height),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: customAgreeButtonStyle(context),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VRVisualisation()));
                  },
                  child: Text(
                    "View Visualisation",
                    style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: height / 62),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    width * 0.02, width * 0.02, width * 0.02, width * 0.02),
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigo.shade50),
                ),
                child: Center(
                  child: Text(
                    "Take up a quick Quiz and Earn  a Streak now ",
                    style: GoogleFonts.lato(
                        fontSize: height / 58,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: customAgreeButtonStyle(context),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QuizPage()));
                  },
                  child: Text(
                    "Virtuo Quiz",
                    style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: height / 56),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle customTextStyle(height) {
    return GoogleFonts.openSans(
        fontSize: height / 64, fontWeight: FontWeight.w400, letterSpacing: 0.1);
  }
}

class VRVisualisation extends StatefulWidget {
  const VRVisualisation({Key? key}) : super(key: key);

  @override
  State<VRVisualisation> createState() => _VRVisualisationState();
}

class _VRVisualisationState extends State<VRVisualisation> {
  late UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;

  get onUnityMessage => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar("Virtuio VR Space", context),
        body: Card(
            margin: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              UnityWidget(
                onUnityCreated: onUnityCreated,

                // isARScene: true,
              ),
            ])));
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }
}
