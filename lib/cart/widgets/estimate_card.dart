import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';

class EstimateCard extends StatelessWidget {
  final int remainingTime;
  const EstimateCard({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/delivery.png',
            height: 95,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated delivery',
                style: TextStyle(
                  color: Colors.grey[700]!,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'ASAP (${remainingTime} min)',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Change',
                style: TextStyle(
                  fontSize: 15,
                  color: scheme.primary,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
