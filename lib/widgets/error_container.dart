import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    super.key,
    this.width,
    this.height,
    this.message = 'An error occurred',
  });
  final double? width;
  final double? height;
  final String message;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/cat1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
}
