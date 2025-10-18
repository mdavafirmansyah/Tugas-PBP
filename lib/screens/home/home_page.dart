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
import 'package:flutter_animate/flutter_animate.dart';

/// Enum untuk mengatur jenis filter
enum FilterType { semua, anime, donghua }

/// 🏠 Halaman utama aplikasi
class MyHomePage extends StatefulWidget {
  final String title;
  final String email;

  const MyHomePage({super.key, required this.title, required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 🔹 Variabel untuk konten acak (gabungan anime & donghua)
  List<AnimasiSeries> _randomizedContentList = [];

  // 🔹 Controller untuk carousel banner
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 🔹 State untuk Filter & Search
  FilterType _selectedFilter = FilterType.semua;
  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // 🧩 Inisialisasi awal
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

    // Gabungkan semua konten dan acak
    _randomizedContentList = [...donghuaList, ...animeList]..shuffle();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 📱 Dialog Info Perangkat (Android/iOS)
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

  // 🔹 Widget Filter Chip (Semua / Anime / Donghua)
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
    // 🔹 Ambil semua konten
    final List<AnimasiSeries> allContentList = _randomizedContentList;
    final List<AnimasiSeries> top5Random = allContentList.take(5).toList();

    // 🔹 Filter konten berdasarkan pilihan
    List<AnimasiSeries> filteredList;
    if (_selectedFilter == FilterType.anime) {
      filteredList = allContentList.where((item) => item is Anime).toList();
    } else if (_selectedFilter == FilterType.donghua) {
      filteredList = allContentList.where((item) => item is Donghua).toList();
    } else {
      filteredList = allContentList;
    }

    // 🔹 Filter berdasarkan pencarian
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where(
            (item) =>
                item.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
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

      // 🌈 Background gradien agar konsisten dengan halaman detail
      body: Container(
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
                // 🧍 Info pengguna
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login sebagai: ${widget.email}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const Text(
                        "Rekomendasi Populer",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🎞️ Carousel Banner
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),

                      // 🔘 Indikator dots
                      Positioned(
                        bottom: 10,
                        child: Row(
                          children: List.generate(top5Random.length, (index) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
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
                    ],
                  ),
                ),

                // 🧾 Info box di bawah carousel
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.2),
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
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              top5Random[_currentPage].synopsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
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
                          backgroundColor: Colors.deepPurpleAccent,
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
                                url: item.trailerUrl,
                              ),
                            ),
                          );
                        },
                        child: const Text("Tonton"),
                      ),
                    ],
                  ),
                ),

                // 🧩 Filter kategori
                CategoryFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterSelected: (filter) {
                    setState(() => _selectedFilter = filter);
                  },
                ),

                const SizedBox(height: 16),

                // 🗂️ Grid konten
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
