import 'package:flutter/material.dart';
import 'package:flutter_auth/components/appBarActionItems.dart';
import 'package:flutter_auth/components/header.dart';
import 'package:flutter_auth/components/infoCard.dart';
import 'package:flutter_auth/Screens/SideMenum/sidemenum.dart';
import 'package:flutter_auth/config/responsive.dart';
import 'package:flutter_auth/config/size_config.dart';
import 'package:flutter_auth/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Dashboardm extends StatelessWidget {
  final int userId;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  Dashboardm({Key? key, required this.userId }) : super(key: key);

  

 
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
     final sidemenuWidget = sidemenum(userId: userId);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 200, child: sidemenuWidget),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                onPressed: () {
                  _drawerKey.currentState?.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Color.fromARGB(255, 124, 185, 239),
                ),
              ),
              actions: [
                AppBarActionItems(userId: userId),
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
                flex: 5,
                child: sidemenuWidget,
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
                              icon: 'assets/credit-card.svg',
                              label: 'Les Managers',
                              amount: '50',
                            ),
                            InfoCard(
                              icon: 'assets/transfer.svg',
                              label: 'Les Clients',
                              amount: '150',
                            ),
                            InfoCard(
                              icon: 'assets/document.svg',
                              label: 'Réclamation',
                              amount: '200',
                            ),
                            InfoCard(
                              icon: 'assets/invoice.svg',
                              label: 'En Cours',
                              amount: '75',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        // Customize your calendar here
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.week: 'Week',
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          outsideDaysVisible: false,
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonTextStyle: TextStyle().copyWith(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        eventLoader: (date) {
                          // Provide a list of events (markers) for the specified date
                          // Return an empty list if there are no events
                          return [];
                        },
                      ),
                    ],
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
