import 'package:flutter/material.dart';

void showPopupMenu(BuildContext context, RelativeRect position) async {
  await showMenu(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        value: 1,
        child: Text("View"),
      ),
      PopupMenuItem(
        value: 2,
        child: Text("Edit"),
      ),
      PopupMenuItem(
        value: 3,
        child: Text("Delete"),
      ),
    ],
    elevation: 8.0,
  ).then((value) {
// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null

    if (value != null) print(value);
  });
}

//   _showPopupMenu(Offset offset) async {
//   double left = offset.dx;
//   double top = offset.dy;
//   await showMenu(
//   context: context,
//   position: RelativeRect.fromLTRB(left, top, 0, 0),
//   items: [
//     ...,
//   elevation: 8.0,
// );
//}
