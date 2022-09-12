import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  String text;
  IconData icon;
  VoidCallback onClick;

  DrawerItems({required this.icon, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0.0, 0.0), //(x,y)
            blurRadius: 6.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Icon(icon, size: 30, color: const Color(0xFF244395)),
              const SizedBox(
                width: 15,
              ),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF244395)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
