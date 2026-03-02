import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget(
      {Key? key,
      required this.imageBytes,
      this.isEdit = false,
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(bottom: 0, right: 0, child: buildEditIcon(color)),
        ],
      ),
    );
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: MemoryImage(imageBytes),
          fit: BoxFit.cover,
          width: 96,
          height: 96,
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => InkWell(
        onTap: onClicked,
        child: buildCircle(
          color: Colors.white,
          all: 2,
          child: buildCircle(
            color: color,
            all: 6,
            child: Icon(
              isEdit ? Icons.add_a_photo : Icons.edit,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );

  Widget buildCircle(
          {required Widget child, required double all, required Color color}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
