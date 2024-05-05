import 'package:flutter/material.dart';

import '../http/network_repository.dart';
import '../model/breed.dart';
import '../model/dog_image_entity.dart';

class BreedDetailScreen extends StatefulWidget {
  final Breed breed;

  const BreedDetailScreen(this.breed, {super.key});

  @override
  State<BreedDetailScreen> createState() => _BreedDetailScreenState();
}

class _BreedDetailScreenState extends State<BreedDetailScreen> {
  final List<DogImageEntity> _images = [];

  @override
  void initState() {
    _initRequest();
    super.initState();
  }

  void _initRequest() async {
    final repository = NetworkRepository();
    final images =
        await repository.searchImages(limit: 10, breedId: widget.breed.id);
    if (!mounted) return;
    setState(() {
      _images.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breed Details"),
      ),
      body: Column(
        children: [
          _buildBanner(),
          _buildBottomPanel(),
          const Spacer(),
          _buildButton(),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
          height: 300,
          child: PageView(
            children: _images.map((image) => _buildImage(image)).toList(),
          )),
    );
  }

  Widget _buildImage(DogImageEntity image) {
    return Image.network(
      image.url,
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildBottomPanel() {
    final breed = widget.breed;
    return Align(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreedName(breed.name),
            _buildLabel("Temperament"),
            _buildInfo(breed.temperament ?? ""),
            _buildLabel("Age"),
            _buildInfo(breed.lifeSpan),
            _buildLabel("Use"),
            _buildInfo(breed.bredFor ?? "")
          ],
        ),
      ),
    );
  }

  Widget _buildBreedName(String name) {
    return Padding(
        padding: EdgeInsets.only(top: 15, left: 15),
        child: Text(name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)));
  }

  Widget _buildLabel(String label) {
    return Padding(
        padding: EdgeInsets.only(left: 15, top: 10),
        child: Text(label,
            style: TextStyle(fontSize: 18, color: Color(0xff333333))));
  }

  Widget _buildInfo(String info) {
    return Padding(
        padding: EdgeInsets.only(left: 15, top: 10),
        child: Text(info,
            style: TextStyle(fontSize: 18, color: Color(0xff333333))));
  }

  Widget _buildButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        onPressed: () {},
        child: Text("more"),
      ),
    );
  }
}
