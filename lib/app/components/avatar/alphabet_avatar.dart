import 'package:flutter/material.dart';

class AlphabetAvatar extends StatelessWidget {
  final String firstname;
  final String? lastName;
  final double size;

  const AlphabetAvatar({super.key, required this.firstname, this.lastName, this.size = 50.0});

  Color _getColorFromLetter(String letter) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
      Colors.deepOrange,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
      Colors.deepPurple,
      Colors.amber,
      Colors.lime,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.yellow,
      Colors.blueGrey,
      Colors.grey,
      Colors.black,
    ];

    final index = (letter.codeUnitAt(0) - 65) % colors.length;
    return colors[index.abs()];
  }

  String _getInitials() {
    final first = firstname.trim();
    final last = lastName?.trim();

    if (first.isEmpty) return "";

    if (last != null && last.isNotEmpty) {
      return "${first[0]}${last[0]}".toUpperCase();
    }

    return (first.length >= 2 ? first.substring(0, 2) : first.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials();
    final bgColor = initials.isNotEmpty ? _getColorFromLetter(initials[0]) : Colors.grey;

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor.withValues(alpha: 0.2)),
      child: Text(
        initials,
        style: TextStyle(color: bgColor, fontWeight: FontWeight.bold, fontSize: size * 0.4),
      ),
    );
  }
}
