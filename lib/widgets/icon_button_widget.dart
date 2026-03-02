import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final String label;
  final Icon icon;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLocked;
  final bool isDev;
  final bool isUpdated;
  final bool isNew;
  final int notificationCount;
  const IconButtonWidget({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled = true,
    this.isLocked = false,
    this.isDev = false,
    this.isUpdated = false,
    this.isNew = false,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: enabled && !isLocked ? onTap : null,
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  enabled ? color : Colors.grey[300]!),
              elevation: MaterialStateProperty.all<double>(0.0),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(8.0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                          color: enabled ? color : Colors.grey[300]!)))),
          child: SizedBox(width: 36.0, height: 46.0, child: icon),
        ),
        Positioned(
          bottom: -18.0,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.0),
          ),
        ),
        if (isDev)
          Positioned(
            top: -4.0,
            right: -8.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5),
              decoration: BoxDecoration(
                  color:
                      Colors.orange.shade700, //  HexColor.fromHex("#287271"),
                  borderRadius: BorderRadius.circular(2.0)),
              child: const Text(
                "Dev",
                style: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
            ),
          ),
        if (isUpdated)
          Positioned(
            top: -4.0,
            right: -8.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5),
              decoration: BoxDecoration(
                  color:
                      Colors.orange.shade700, //  HexColor.fromHex("#287271"),
                  borderRadius: BorderRadius.circular(2.0)),
              child: const Text(
                "Updated",
                style: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
            ),
          ),
        if (isNew)
          Positioned(
            top: -4.0,
            right: -8.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5),
              decoration: BoxDecoration(
                  color: Colors.red.shade700, //  HexColor.fromHex("#287271"),
                  borderRadius: BorderRadius.circular(2.0)),
              child: const Text(
                "New",
                style: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
            ),
          ),
        if (notificationCount > 0)
          Positioned(
            top: -4.0,
            right: -8.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(14.0)),
              child: Text(
                notificationCount > 9 ? "9+" : notificationCount.toString(),
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ),
        if (isLocked)
          Positioned(
            top: -4.0,
            right: -12.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5),
              child: Icon(
                Icons.lock,
                size: 24.0,
                color: Colors.orange.shade500,
              ),
            ),
          ),
      ],
    );
  }
}
