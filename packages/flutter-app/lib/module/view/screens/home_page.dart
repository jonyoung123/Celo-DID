import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/view/screens/change_did.dart';
import 'package:flutter_celo_composer/module/view/screens/integrate_did.dart';
import 'package:flutter_celo_composer/module/view/screens/register_did.dart';
import 'package:flutter_celo_composer/module/view/screens/verify_did.dart';
import 'package:flutter_celo_composer/module/view/screens/view_did.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey actionKey = GlobalKey();
  int selectedIndex = 0;
  List<Widget> screens = <Widget>[
    const IntegrateCeloPage(),
    const RegisterDIdPage(),
  ];

  void _onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Celo DID',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
              key: actionKey,
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                    getWidgetBounds(actionKey),
                    Offset.zero & MediaQuery.of(context).size,
                  ),
                  items: <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'change',
                      enabled: false,
                      child: GestureDetector(
                        child: const Text(
                          'Change DID',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ChangeDIdPage()));
                        },
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'verify',
                      enabled: false,
                      child: GestureDetector(
                        child: const Text(
                          'Verify DID',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const VerifyDIdPage()));
                        },
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'check',
                      enabled: false,
                      child: GestureDetector(
                        child: const Text(
                          'View DID',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ViewDIdPage()));
                        },
                      ),
                    ),
                  ],
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Integration',
            icon: Icon(Icons.money),
          ),
          BottomNavigationBarItem(
            label: 'Register DID',
            icon: Icon(Icons.perm_identity),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        elevation: 12,
        showUnselectedLabels: true,
        onTap: _onTapped,
      ),
    );
  }

  Rect getWidgetBounds(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }
}
