import 'package:flutter/material.dart';
import 'package:personal_money_management/screens/home/screen_home.dart';

class Widget_BottomNavigationBar extends StatelessWidget {
  const Widget_BottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomePage.selectedIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          currentIndex: value,
          onTap: (value) {
            HomePage.selectedIndex.value = value;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'category')
          ],
        );
      },
    );
  }
}
