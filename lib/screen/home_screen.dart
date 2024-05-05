import 'package:flutter/material.dart';
import 'package:flutter_dog_gallery/screen/breeds_screen.dart';
import 'package:flutter_dog_gallery/screen/dogs_screen.dart';
import 'package:flutter_dog_gallery/screen/profile_screen.dart';
import 'package:flutter_dog_gallery/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _selectedTab = HomeTab.dogs;
  late PageController _controller; //late延迟初始化

  @override
  void initState() {
    _controller = PageController(initialPage: _selectedTab.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller, //控制页面切换
        onPageChanged: (value) {
          setState(() {
            _selectedTab = HomeTab.values[value];
          });
        },
        children: [DogsScreen(), BreedsScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            _HomeTabButton(
              icon: "home.png",
              label: "Dogs",
              value: HomeTab.dogs,
              selectedValue: _selectedTab,
              onTap: () {
                _switchTab(HomeTab.dogs);
              },
            ),
            _HomeTabButton(
              icon: "breed.png",
              label: "Breeds",
              value: HomeTab.breeds,
              selectedValue: _selectedTab,
              onTap: () {
                _switchTab(HomeTab.breeds);
              },
            ),
            _HomeTabButton(
              icon: "mine.png",
              label: "Profile",
              value: HomeTab.profile,
              selectedValue: _selectedTab,
              onTap: () {
                _switchTab(HomeTab.profile);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _switchTab(HomeTab tab) {
    if (tab == _selectedTab) return;
    _controller.animateToPage(tab.index,
        duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }
}

enum HomeTab { dogs, breeds, profile }

class _HomeTabButton extends StatelessWidget {
  final String icon;
  final String label;
  final HomeTab value;
  final HomeTab selectedValue;
  final VoidCallback onTap;

  const _HomeTabButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      required this.selectedValue,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    final color = isSelected ? tabActiveColor : tabInactiveColor;
    return Expanded(
      // flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset("images/$icon", width: 25, height: 25, color: color),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
