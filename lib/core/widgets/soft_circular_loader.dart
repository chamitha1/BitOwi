import 'package:flutter/material.dart';

class SoftCircularLoader extends StatelessWidget {
  final Color color;

  const SoftCircularLoader({super.key, this.color = const Color(0xFF1D5DE5)});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
      ),
    );
  }
}
