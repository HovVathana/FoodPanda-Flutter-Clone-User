import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';

class ProgressStepper extends StatelessWidget {
  final bool isProgess;
  final int activeStep;
  ProgressStepper({
    Key? key,
    required this.isProgess,
    required this.activeStep,
  }) : super(key: key);

  List<int> numbers = [
    1,
    2,
    3,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: 20,
                  height: 6,
                  color: activeStep >= 1 ? scheme.primary : Colors.grey[300],
                ),
              ),
              isProgess
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: activeStep >= 1 ? scheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 5,
                          color: activeStep >= 1
                              ? scheme.primary
                              : Colors.grey[200]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 12,
                            color: activeStep >= 1
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  width: 20,
                  height: 6,
                  color: activeStep >= 2 ? scheme.primary : Colors.grey[300],
                ),
              ),
              isProgess
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: activeStep >= 2 ? scheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 5,
                          color: activeStep >= 2
                              ? scheme.primary
                              : Colors.grey[200]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 12,
                            color: activeStep >= 2
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  width: 20,
                  height: 6,
                  color: activeStep >= 3 ? scheme.primary : Colors.grey[300],
                ),
              ),
              isProgess
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: activeStep >= 3 ? scheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 5,
                          color: activeStep >= 3
                              ? scheme.primary
                              : Colors.grey[200]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 12,
                            color: activeStep >= 3
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  width: 20,
                  height: 6,
                  color: activeStep > 3 ? scheme.primary : Colors.grey[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          isProgess
              ? Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Cart',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
