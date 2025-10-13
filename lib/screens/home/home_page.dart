import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login/models/animasi_series.dart';
import 'package:login/models/anime.dart';
import 'package:login/models/donghua.dart';
import 'package:login/screens/home/componen/category_filter_chips.dart';
import 'package:login/screens/home/componen/gridview.dart';
import 'package:login/webview_page.dart';
import 'package:login/data/donghua_data.dart';
import 'package:login/data/anime_data.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum FilterType { semua, anime, donghua }

class MyHomePage extends StatefulWidget {
  final String title;
  final String email;

  const MyHomePage({super.key, required this.title, required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Duplicate declaration removed: FilterType _selectedFilter = FilterType.semua;
  // Controller dan state HANYA untuk carousel

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State untuk Filter & Search
  FilterType _selectedFilter = FilterType.semua;
  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        int next = _pageController.page!.round();
        if (_currentPage != next) {
          setState(() {
            _currentPage = next;
          });
        }
      }
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan info perangkat (tidak berubah)
  void _showDeviceInfoDialog(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown';
    String deviceVersion = 'Unknown';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
        deviceVersion = "Android ${androidInfo.version.release}";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine!;
        deviceVersion = "iOS ${iosInfo.systemVersion}";
      }
    } catch (e) {
      deviceName = "Gagal mendapatkan info";
      deviceVersion = e.toString();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Informasi Perangkat"),
        content: Text("Model: $deviceName\nSistem Operasi: $deviceVersion"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  //Buat widget untuk UI Filternya
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterChip("Semua", FilterType.semua),
          _buildFilterChip("Anime", FilterType.anime),
          _buildFilterChip("Donghua", FilterType.donghua),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, FilterType filterType) {
    final bool isSelected = _selectedFilter == filterType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterType;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.amber : Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 3,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AnimasiSeries> allContentList = [...donghuaList, ...animeList];
    final List<AnimasiSeries> top5Random = allContentList.take(5).toList();

    //Buat list baru berdasarkan filter yang dipilih
    List<AnimasiSeries> filteredList;
    if (_selectedFilter == FilterType.anime) {
      filteredList = allContentList.where((item) => item is Anime).toList();
    } else if (_selectedFilter == FilterType.donghua) {
      filteredList = allContentList.where((item) => item is Donghua).toList();
    } else {
      filteredList = allContentList; // Tipe 'semua'
    }
    // TAMBAHKAN INI: Logika untuk filter berdasarkan search query
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where(
            (item) =>
                item.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Tampilkan search bar atau judul berdasarkan state _isSearching
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true, // Langsung fokus ke search bar saat muncul
                decoration: const InputDecoration(
                  hintText: 'Cari judul...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              )
            : Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        actions: _isSearching
            ? [
                // Jika sedang mencari, tampilkan tombol 'X' untuk batal
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                    });
                  },
                ),
              ]
            : [
                // Jika tidak mencari, tampilkan tombol search dan info
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showDeviceInfoDialog(context),
                ),
              ],
      ),

      extendBodyBehindAppBar: true,
      body: Container(
        // 1. Menerapkan background gradien dari LoginPage
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header halaman
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login sebagai: ${widget.email}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Rekomendasi Populer",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- BAGIAN CAROUSEL BANNER UTAMA ---
                Container(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: top5Random.length,
                        itemBuilder: (context, index) {
                          final item = top5Random[index];
                          return Hero(
                            tag: 'popular-${item.title}',
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                      // Indikator Dot (posisi di kanan atas)
                      Positioned(
                        top: 10,
                        right: 16,
                        child: Row(
                          children: List.generate(top5Random.length, (index) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            );
                          }),
                        ),
                      ),
                      // Tombol Kiri (fungsi sudah diperbaiki)
                      Positioned(
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        ),
                      ),
                      // Tombol Kanan (fungsi sudah diperbaiki)
                      Positioned(
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- BAGIAN INFO BOX DI BAWAH CAROUSEL ---
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              top5Random[_currentPage].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              top5Random[_currentPage].synopsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final item = top5Random[_currentPage];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                title: "${item.title} Trailer",
                                url:
                                    "https://www.youtube.com/results?search_query=${item.title}+trailer",
                              ),
                            ),
                          );
                        },
                        child: const Text("Tonton"),
                      ),
                    ],
                  ),
                ),

                // --- BAGIAN SEMUA (GRIDVIEW) ---
                // Panggil dan tampilkan UI Filter di sini
                CategoryFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterSelected: (filter) {
                    setState(() => _selectedFilter = filter);
                  },
                ),

                const SizedBox(height: 16),

                // Panggil widget grid yang sudah dipisah
                ContentGridView(
                  items: filteredList,
                  listKey: _selectedFilter.toString() + _searchQuery,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
