import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuo/helpers/commonWidgets.dart';

class VirtualLabs extends StatelessWidget {
  const VirtualLabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(appLightBlue()),
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.9, height * 0.052)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.lightBlue.shade500),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(
          "Hire Now",
          style: GoogleFonts.openSans(
              fontSize: height / 52,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
      ),
      appBar: customAppBar("Virtual Lab", context),
      body: SingleChildScrollView(
          child: Column(children: [
        Image.asset("assets/images/virtualLab.jpeg"),
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
            child: Text(
              "We Provide Rental Services",
              style: GoogleFonts.openSans(
                  fontSize: height / 52, fontWeight: FontWeight.w600),
            )),
        SizedBox(
          height: 25,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.indigo.shade50),
          ),
          child: Column(
            children: [
              buildDataRow(
                  "VR Labs", "Monthly ₹400 , Yearly ₹4500", height, width),
              Divider(),
              buildDataRow(
                  "3D Labs", "Monthly ₹250 , Yearly ₹2750", height, width)
            ],
          ),
        )
      ])),
    );
  }
}

Widget buildDataRow(String title, String value, height, width) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: tableHeaderTextStyle(height),
          ),
        ),
        SizedBox(
          width: width * 0.008,
        ),
        Expanded(
          child: Text(value, style: tableTextStyle(height)),
        ),
      ],
    ),
  );
}

TextStyle tableTextStyle(height) {
  return GoogleFonts.openSans(
      fontWeight: FontWeight.w500,
      fontSize: height / 70,
      letterSpacing: 0.1,
      color: appBlack());
}

TextStyle tableHeaderTextStyle(height) {
  return GoogleFonts.openSans(
      fontWeight: FontWeight.w600,
      fontSize: height / 71,
      letterSpacing: 0.1,
      color: appBlack());
}
