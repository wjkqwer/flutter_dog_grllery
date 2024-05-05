import 'package:flutter/material.dart';
import 'package:flutter_dog_gallery/http/network_repository.dart';
import 'package:flutter_dog_gallery/model/dog_image_entity.dart';
import 'package:flutter_dog_gallery/widget/loading_dialog.dart';
import 'package:flutter_dog_gallery/widget/tips_dialog.dart';

class DogsScreen extends StatefulWidget {
  const DogsScreen({super.key});

  @override
  State<DogsScreen> createState() => _DogsScreenState();
}

class _DogsScreenState extends State<DogsScreen> {
  DogImageEntity? _currentImage;

  @override
  void initState() {
    _requestOneImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dogs"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentImage != null) _buildImage(_currentImage!.url),
          Row(
            children: [
              const SizedBox(width: 20),
              _buildIconButton(
                  icon: "fav.png",
                  onPressed: () {
                    if (_currentImage != null) {
                      _addToFavorites(_currentImage!.id);
                    }
                  }),
              const Spacer(),
              _buildIconButton(
                  icon: "like.png",
                  onPressed: () {
                    if (_currentImage != null) {
                      _voteImage(_currentImage!.id, true);
                    }
                  }),
              _buildIconButton(
                  icon: "dislike.png",
                  onPressed: () {
                    if (_currentImage != null) {
                      _voteImage(_currentImage!.id, false);
                    }
                  }),
              const SizedBox(width: 20)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(url, fit: BoxFit.cover)));
  }

  Widget _buildIconButton(
      {required String icon, required VoidCallback onPressed}) {
    const iconSize = 25.0;
    return IconButton(
        icon: Image.asset(
          "images/$icon",
          width: iconSize,
          height: iconSize,
          color: const Color(0xff999999),
        ),
        onPressed: onPressed);
  }

  void _showLoading() {
    showDialog(
        context: context,
        builder: (context) {
          return LoadingDialog();
        });
  }

  void _hideLoading() {
    Navigator.of(context).pop();
  }

  void _showTip(String tips) {
    showDialog(
        context: context,
        builder: (context) {
          return TipsDialog(content: tips);
        });
  }

  void _requestOneImage() async {
    // _showLoading();
    final repository = NetworkRepository();
    final dogImageList = await repository.searchImages(limit: 1);
    // _hideLoading();
    if (dogImageList.isNotEmpty) {
      setState(() {
        _currentImage = dogImageList.first;
      });
    }
  }

  void _addToFavorites(String imageId) async {
    _showLoading();
    final repository = NetworkRepository();
    final result = await repository.addToFavorites(imageId: imageId);
    _hideLoading();
    _showTip(result ? "favorite success" : "favorite fail");
    if (result) {
      _requestOneImage();
    }
  }

  void _voteImage(String imageId, bool isVote) async {
    _showLoading();
    final repository = NetworkRepository();
    final result = await repository.voteImage(imageId: imageId, isVote: isVote);
    _hideLoading();
    if (result) {
      _showTip(isVote ? "zan success" : "cai success");
      _requestOneImage();
    } else {
      _showTip("operate fail");
    }
  }
}
