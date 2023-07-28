import 'package:flutter/material.dart';

class SpecialInstruction extends StatelessWidget {
  final TextEditingController instructionController;

  const SpecialInstruction({super.key, required this.instructionController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special instructions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Please let us know if you are allergic to anything or if we need to avoid anything',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            maxLength: 500,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            controller: instructionController,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'e.g. no mayo',
              counterStyle: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
