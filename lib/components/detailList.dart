import 'package:flutter/material.dart';
import 'package:flutter_auth/components/listTile.dart';
import 'package:flutter_auth/config/size_config.dart';
import 'package:flutter_auth/data.dart';
import 'package:flutter_auth/style/colors.dart';
import 'package:flutter_auth/style/style.dart';

class PaymentDetailList extends StatelessWidget {
  const PaymentDetailList({
     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
          BoxShadow(
            color: Colors.grey[400]?? Colors.grey,
            blurRadius: 15.0,
            offset: const Offset(
              10.0,
              15.0,
            ),
          )
        ]),
        child: Image.asset('assets/images/37004.png'),
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
              text: 'Recent Activities', size: 18, fontWeight: FontWeight.w800),
          PrimaryText(
            text: '02 Mar 2021',
            size: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.secondary,
          ),
        ],
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 2,
      ),
      Column(
        children: List.generate(
          recentActivities.length,
          (index) => PaymentListTile(
              icon: recentActivities[index]["icon"]!,
              label: recentActivities[index]["label"]!,
              amount: recentActivities[index]["amount"]!),
        ),
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
              text: 'Upcoming Reclamtion', size: 18, fontWeight: FontWeight.w800),
          PrimaryText(
            text: '02 Mar 2024',
            size: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.secondary,
          ),
        ],
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 2,
      ),
      Column(
        children: List.generate(
          upcoming.length,
          (index) => PaymentListTile(
              icon: upcoming[index]["icon"]!,
              label: upcoming[index]["label"]!,
              amount: upcoming[index]["amount"]!),
        ),
      ),
    ]);
  }
}
