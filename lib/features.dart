import 'package:flutter/material.dart';
import 'package:synthai/colors.dart';

class FeaturesBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeaturesBox({
    super.key,
    required this.headerText,
    required this.descriptionText,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child:Padding(
        padding: const EdgeInsets.symmetric(vertical:20.0).copyWith(left:15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(right:20.0),
              child: Text(
                descriptionText,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                )
              ),
            )
          ],
        ),
      )
    );
  }
}