import 'package:flutter/material.dart';
import 'package:flutter_dog_gallery/model/dog_image_entity.dart';
import 'package:flutter_dog_gallery/screen/login_screen.dart';

import '../http/network_repository.dart';
import '../manager/user_manager.dart';
import '../theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

enum ProfileTab { favorites, likes }

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileTab _currentTab = ProfileTab.favorites;
  final List<DogImageEntity> _favoriteImages = [];
  final List<DogImageEntity> _likeImages = [];
  bool _isLogin = false;

  @override
  void initState() {
    _requestInit();
    super.initState();
  }

  void _requestInit() async {
    final repository = NetworkRepository();
    final favoriteImages = await repository.getFavoriteImage();
    _favoriteImages.addAll(favoriteImages.map((e) => e.image).toList());
    final voteImages = await repository.getVoteImage();
    _likeImages.addAll(voteImages
        .where((voteImage) => voteImage.value == 1)
        .map((e) => e.image)
        .toList());
    _isLogin = await UserManager().isLogin;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          if (_isLogin)
            TextButton(
                onPressed: () {
                  _loginOut();
                },
                child: Text("Login Out"))
        ],
      ),
      body: _isLogin ? _LoginedView() : _LoginView(),
    );
  }

  //已登录页面
  SizedBox _LoginedView() {
    return SizedBox(
      width: double.infinity,
      //直接设置crossAxisAlignment居中无效，因为Column组件默认和子组件宽度一致，所以当前宽度就是CircleAvatar的宽度,
      //需要设置外部添加SizedBox，然后添加width: double.infinity撑满全屏宽度
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
              backgroundImage: AssetImage("images/avatar.jpg"), radius: 40),
          const SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUserItemView(label: "图片", value: "121"),
              _buildUserItemView(label: "粉丝", value: "12k"),
              _buildUserItemView(label: "关注", value: "403")
            ],
          ),
          const SizedBox(height: 20),
          _buildTabBar(),
          Expanded(
            child: IndexedStack(
              index: _currentTab.index,
              children: [_buildFavoriteImages(), _buildLikeImages()],
            ),
          )
        ],
      ),
    );
  }

  Widget _LoginView() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: loginButtonBgColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              _goToLoginScreen();
            },
            child: Text("Login")),
      ),
    );
  }

  Widget _buildUserItemView({required String label, required String value}) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: userItemValueColor)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: userItemLabelColor))
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
        height: 40,
        color: Color(0xfff5f5f5),
        child: Row(
          children: [
            _buildTabBarItem(
                text: "121 收藏",
                isActive: _currentTab == ProfileTab.favorites,
                onTap: () {
                  _switchTab(ProfileTab.favorites);
                }),
            _buildTabBarItem(
                text: "231 喜欢",
                isActive: _currentTab == ProfileTab.likes,
                onTap: () {
                  _switchTab(ProfileTab.likes);
                }),
          ],
        ));
  }

  Widget _buildTabBarItem(
      {required String text,
      required bool isActive,
      required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(text,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.deepOrangeAccent : Colors.grey[600],
                ))));
  }

  Widget _buildFavoriteImages() {
    return ListView.builder(
        itemCount: _favoriteImages.length,
        itemBuilder: (context, index) {
          return _buildImageItem(image: _favoriteImages[index], space: 15);
        });
  }

  Widget _buildLikeImages() {
    return ListView.builder(
        itemCount: _likeImages.length,
        itemBuilder: (context, index) {
          return _buildImageItem(image: _likeImages[index], space: 15);
        });
  }

  Widget _buildImageItem({required DogImageEntity image, required int space}) {
    return Padding(
        padding: EdgeInsets.only(bottom: space.toDouble()),
        child: Image.network(image.url,
            fit: BoxFit.cover, width: double.infinity, height: 300));
  }

  void _switchTab(ProfileTab tab) {
    if (tab == _currentTab) return;
    setState(() {
      _currentTab = tab;
    });
  }

  void _goToLoginScreen() async {
    final isLogin =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    })) as bool?;
    if (isLogin == true) {
      setState(() {
        _isLogin = true;
      });
    }
  }

  void _loginOut() async {
    await UserManager().clearUserInfo();
    if (!mounted) return;
    setState(() {
      _isLogin = false;
    });
  }
}
