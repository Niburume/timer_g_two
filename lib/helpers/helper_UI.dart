import 'package:flutter/cupertino.dart';

SizedBox verticalSpace(double value, BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * value,
  );
}

SizedBox horizontalSpace(double value, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * value,
  );
}
