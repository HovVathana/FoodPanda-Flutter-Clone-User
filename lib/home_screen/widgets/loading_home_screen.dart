import 'package:flutter/material.dart';
import 'package:foodpanda_user/widgets/skeleton_skimming.dart';

class LoadingHomeScreen extends StatelessWidget {
  const LoadingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonSkimming(width: 150, height: 15),
                SizedBox(height: 10),
                SkeletonSkimming(width: 200, height: 10),
                SizedBox(height: 7),
                SkeletonSkimming(width: 180, height: 10),
                SizedBox(height: 50),
                SkeletonSkimming(width: double.infinity, height: 70),
                SizedBox(height: 20),
                SkeletonSkimming(width: double.infinity, height: 150),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: SkeletonSkimming(
                            width: double.infinity, height: 300)),
                    SizedBox(width: 15),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonSkimming(width: double.infinity, height: 200),
                        SizedBox(height: 15),
                        SkeletonSkimming(width: double.infinity, height: 85),
                      ],
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
