import 'package:flutter/material.dart';
import 'package:jomakase/home/home.dart';
import 'package:jomakase/login/login_page.dart';
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Layout extends StatelessWidget {
  final Widget? child;
  final String? title;

  const Layout({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: child,
    );
  }
}

class Layout2 extends StatelessWidget {
  final Widget? child;
  final String? title;

  const Layout2({super.key, this.child, this.title});

  @override
  Widget build(BuildContext context) {
    UserInfo user = context.read<UserInfo>();

    Future<void> logoutRequest() async {
      final url = Uri.parse("http://10.0.2.2:8080/logout1");
      final res = await http.post(url);
      Token tkProvider = context.read<Token>();
      tkProvider.clear();
      UserInfo userProvider = context.read<UserInfo>();
      userProvider.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false,
              );
            },
            icon: Icon(Icons.home),
          ),
          IconButton(
            onPressed: () async{
              logoutRequest();
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.account_circle, size: 70),
                radius: 20,
              ),
              accountName: Text(
                user.nickname!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                user.email!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.yellow),
              title: Text(
                '내 즐겨 찾기 목록',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.grey),
              title: Text(
                "내 정보 수정",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
