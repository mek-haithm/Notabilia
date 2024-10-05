import 'package:flutter/material.dart';
import 'package:notabilia/shared/constants/colors.dart';
import 'package:notabilia/shared/constants/text_styles.dart';

class MyBottomNavBar extends StatefulWidget {
  final List<Widget> screens;
  final List<IconData> icons;
  final List<String> labels;
  final int initialIndex;

  const MyBottomNavBar({
    super.key,
    required this.screens,
    required this.icons,
    required this.labels,
    this.initialIndex = 0,
  });

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: widget.screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: _buildNavigationItems(),
            selectedItemColor: kMainColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: kBackground,
            selectedLabelStyle: kSelectedLabelStyle(context),
            unselectedLabelStyle: kUnselectedLabelStyle(context),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return List.generate(
      widget.screens.length,
      (index) => BottomNavigationBarItem(
        icon: Icon(
          widget.icons[index],
          color: _currentIndex == index ? kMainColor : Colors.grey,
        ),
        label: widget.labels[index],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }
}
