import 'package:flutter/material.dart';
import 'package:jomakase/home/home.dart';
import 'package:jomakase/login/login_page.dart';
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:jomakase/public_file/settings_page.dart';
import 'package:jomakase/public_file/edit_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:jomakase/public_file/api_service.dart'; // ApiService import

class Layout extends StatelessWidget {
  final Widget? child;
  final String? title;

  const Layout({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "", style: TextStyle(color: onPrimaryColor)),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: onPrimaryColor), // 아이콘 색상 설정
      ),
      body: child,
    );
  }
}

class Layout2 extends StatelessWidget {
  final Widget? child;
  final String? title;
  final FloatingActionButton? floatingActionButton; // New property

  const Layout2({super.key, this.child, this.title, this.floatingActionButton}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    UserInfo user = context.read<UserInfo>();
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '', style: TextStyle(color: onPrimaryColor)),
        backgroundColor: primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: onPrimaryColor),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false,
              );
            },
            icon: Icon(Icons.home, color: onPrimaryColor),
          ),
          IconButton(
            onPressed: () async {
              await ApiService.logout(); // ApiService.logout 호출
              Token tkProvider = context.read<Token>();
              tkProvider.clear();
              UserInfo userProvider = context.read<UserInfo>();
              userProvider.clear();
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout, color: onPrimaryColor),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).canvasColor, // 배경색을 테마에 맞게
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primaryColor), // 테마 primaryColor 사용
              currentAccountPicture: CircleAvatar(
                backgroundColor: onPrimaryColor, // 아이콘 배경색
                child: Icon(Icons.account_circle, size: 70, color: primaryColor), // 아이콘 색상
              ),
              accountName: Text(
                user.nickname!,
                style: TextStyle(fontWeight: FontWeight.bold, color: onPrimaryColor), // 텍스트 색상
              ),
              accountEmail: Text(
                user.email!,
                style: TextStyle(fontWeight: FontWeight.bold, color: onPrimaryColor.withOpacity(0.8)), // 텍스트 색상
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: accentColor), // 강조 색상 사용
              title: Text(
                '앱 설정',
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              trailing: Icon(Icons.arrow_forward, color: Theme.of(context).iconTheme.color),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Theme.of(context).textTheme.bodyLarge?.color), // primaryColor 사용
              title: Text(
                "내 정보 수정",
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              trailing: Icon(Icons.arrow_forward, color: Theme.of(context).iconTheme.color),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
            )
          ],
        ),
      ),
      body: child,
      floatingActionButton: floatingActionButton, // Pass the new property to Scaffold
    );
  }
}
