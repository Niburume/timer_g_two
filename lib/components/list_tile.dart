import 'package:flutter/material.dart';

class ProjectListTile extends StatelessWidget {
  final String projectName;
  final String radius;
  final String totalHours;
  const ProjectListTile(
      {super.key, required this.projectName,
      required this.radius,
      required this.totalHours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            SizedBox(
              width: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(projectName),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(radius),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('total hours:'), Text(totalHours)],
        ),
        const Divider(
          thickness: 2,
        )
      ]),
    );
  }
}
