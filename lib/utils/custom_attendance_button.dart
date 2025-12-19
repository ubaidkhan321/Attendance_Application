import 'package:flutter/material.dart';

class CustomAttendanceButton extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final VoidCallback onTap;

  const CustomAttendanceButton({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // prevents overflow
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  count,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // prevents overflow
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
