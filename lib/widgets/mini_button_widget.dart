import 'package:flutter/material.dart';

class MiniButtonWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;
  const MiniButtonWidget(
      {Key? key,
      required this.label,
      required this.icon,
      required this.color,
      required this.onTap,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: enabled ? color : Colors.grey[300]!,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                icon,
                size: 18.0,
                color: Colors.white,
              )),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.0, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}
