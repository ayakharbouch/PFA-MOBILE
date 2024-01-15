import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';



class AppBarActionItems extends StatelessWidget {
  final int userId;
  const AppBarActionItems({
     Key? key,  required this.userId 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
      
        SizedBox(width: 15),
        Row(children: [
          CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(
              'https://cdn.shopify.com/s/files/1/0045/5104/9304/t/27/assets/AC_ECOM_SITE_2020_REFRESH_1_INDEX_M2_THUMBS-V2-1.jpg?v=8913815134086573859',
            ),
          ),
           IconButton(
          icon: Icon(Icons.arrow_drop_down_outlined, color: Colors.black),
          onPressed: () {
            showLogoutDialog(context);
             },
           ),
        ]),
      ],
    );
  }
   void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)   =>  LoginScreen(userId : userId),
                 ),
    );  
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

