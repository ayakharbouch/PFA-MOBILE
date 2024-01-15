import 'package:flutter/material.dart';
import 'package:flutter_auth/components/appBarActionItems.dart';
import 'package:flutter_auth/components/barChart.dart';
import 'package:flutter_auth/components/header.dart';
import 'package:flutter_auth/components/historyTable.dart';
import 'package:flutter_auth/components/infoCard.dart';
import 'package:flutter_auth/components/detailList.dart';
import 'package:flutter_auth/components/sideMenu.dart';
import 'package:flutter_auth/config/responsive.dart';
import 'package:flutter_auth/config/size_config.dart';
import 'package:flutter_auth/style/colors.dart';
import 'package:flutter_auth/style/style.dart';

class Dashboard extends StatelessWidget {
   final int userId;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  Dashboard({Key? key, required this.userId }) : super(key: key);
  // Add this line

  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu(userId: userId)),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    _drawerKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu, color: Color.fromARGB(255, 124, 185, 239))),
              actions: [
                AppBarActionItems(userId : userId),
              ],
            )
          : PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 3,
                child: SideMenu(userId: userId),
              ),
            Expanded(
                flex: 10,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 4,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              InfoCard(
                                  icon: 'assets/images/credit-card.svg',
                                  label: 'Les Managers',
                                  amount: '50'),
                              InfoCard(
                                  icon: 'assets/images/transfer.svg',
                                  label: 'Les Clients',
                                  amount: '150'),
                              InfoCard(
                                  icon: 'assets/images/document.svg',
                                  label: 'Réclamation',
                                  amount: '200'),
                              InfoCard(
                                  icon: 'assets/images/invoice.svg',
                                  label: 'En Cours',
                                  amount: '75'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(
                                  text: 'Réclamations',
                                  size: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondary,
                                ),
                                PrimaryText(
                                    text: 'Par Client',
                                    size: 30,
                                    fontWeight: FontWeight.w800),
                              ],
                            ),
                            PrimaryText(
                              text: 'Past 30 DAYS',
                              size: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Container(
                          height: 180,
                          child: BarChartCopmponent(),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                                text: 'Liste des nouveau clients',
                                size: 30,
                                fontWeight: FontWeight.w800),
                            PrimaryText(
                              text: 'Pour les derniers mois',
                              size: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        HistoryTable(),
                        if (!Responsive.isDesktop(context)) PaymentDetailList()
                      ],
                    ),
                  ),
                )),
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 4,
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight,
                    decoration: BoxDecoration(color: AppColors.secondaryBg),
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        children: [
                          AppBarActionItems(userId : userId),
                          PaymentDetailList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
