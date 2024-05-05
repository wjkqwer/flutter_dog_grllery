import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../http/network_repository.dart';
import '../model/breed.dart';
import 'breed_detail_screen.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  int _pageNumber = 1;
  int _pageSize = 10;
  final List<Breed> _breeds = [];
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  //用于监听下拉加载更多
  final _scrollController = ScrollController();

  @override
  void initState() {
    _init();
    _requestBreed(_pageNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Breeds"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshList();
          },
          child: Column(children: [
            _buildGridview(),
            if (_isLoadingMore)
              Container(
                height: 80,
                alignment: Alignment.center,
                child: const Text("loading..."),
              ),
            if (!_hasMore)
              Container(
                height: 80,
                alignment: Alignment.center,
                child: const Text("no more"),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildGridview() {
    return Expanded(
      child: MasonryGridView.count(
          controller: _scrollController,
          crossAxisCount: 2,
          itemCount: _breeds.length,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: (context, index) {
            return _buildBreedItem(_breeds[index]);
          }),
    );
  }

  Widget _buildBreedItem(Breed breed) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BreedDetailScreen(breed);
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _roundImage(breed.image.url),
          const SizedBox(height: 5),
          Text(breed.name,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          Text(breed.bredFor == null ? "empty" : breed.bredFor!,
              style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _roundImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Stack(
        //Stack布局，类似FrameLayout
        children: [
          Image.network(url),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {},
                icon: Image.asset("images/fav.png", width: 18, height: 18)),
          )
        ],
      ),
    );
  }

  void _init() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void _loadMore() async {
    if (_isRefreshing || _isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final networkRepository = NetworkRepository();
    final breeds = await networkRepository.getBreeds(
        pageNumber: _pageNumber + 1, pageSize: _pageSize);
    setState(() {
      _breeds.addAll(breeds);
      _hasMore = breeds.length >= _pageSize;
      _pageNumber++;
      _isLoadingMore = false;
    });
  }

  void _requestBreed(int pageNumber) async {
    final repository = NetworkRepository();
    final breeds =
        await repository.getBreeds(pageNumber: pageNumber, pageSize: _pageSize);
    if(!mounted) return; //判断页面已销毁，就不加载
    setState(() {
      _breeds.addAll(breeds);
    });
  }

  Future<void> _refreshList() async {
    if (_isRefreshing || _isLoadingMore) return;
    _pageNumber = 1;
    setState(() {
      _isRefreshing = true;
      _breeds.clear();
    });
    _requestBreed(_pageNumber);
    setState(() {
      _isRefreshing = false;
    });
  }
}
