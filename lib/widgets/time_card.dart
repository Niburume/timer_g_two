import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  String value;
  String units;
  double fontSizeValue;
  double fontSizeUnits;
  double padding;
  Function onTap;
  TimeCard(
      {super.key,
      required this.value,
      required this.units,
      required this.onTap,
      this.padding = 8,
      this.fontSizeValue = 40,
      this.fontSizeUnits = 10});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        constraints: BoxConstraints(minWidth: fontSizeValue * 2),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                    fontSize: fontSizeValue,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey),
              ),
              Text(
                units,
                style: TextStyle(
                    fontSize: fontSizeUnits,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateCard extends StatelessWidget {
  String value;
  double fontSizeValue;
  double padding;
  DateCard(
      {super.key,
      required this.value,
      this.fontSizeValue = 15,
      this.padding = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          value,
          style: TextStyle(
              fontSize: fontSizeValue,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey),
        ),
      ),
    );
  }
}
