import 'package:flutter/material.dart';
import 'package:login/webview_page.dart';
import 'package:login/models/animasi_series.dart';
import 'package:login/models/anime.dart';
import 'package:login/models/donghua.dart';
import 'package:easy_stars/easy_stars.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final AnimasiSeries item;

  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isExpanded = false;
  double _rating = 0.0;

  // Helper method untuk membuat kolom info
  Widget _buildInfoColumn(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  // <-- WIDGET HELPER BARU untuk menampilkan info unik -->
  Widget _buildUniqueInfoWidget(AnimasiSeries item) {
    IconData iconData = Icons.info_outline;
    String title = "Info Tambahan";
    String value = "N/A";

    if (item is Donghua) {
      iconData = item.is3D ? Icons.threed_rotation : Icons.layers;
      title = "Format";
      value = item.is3D ? "3D" : "2D";
    } else if (item is Anime) {
      iconData = Icons.book;
      title = "Sumber Adaptasi";
      value = item.source;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildInfoColumn(iconData, title, value)],
    );
  }

  // 🟣 Widget untuk menampilkan genres
  Widget _buildGenreChips(List<String> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: -8,
      children: genres
          .map(
            (genre) => Chip(
              label: Text(genre),
              backgroundColor: Colors.black.withOpacity(0.3),
              labelStyle: const TextStyle(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final formattedYear = DateFormat.y().format(
      DateTime(item.year), 
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        // Container untuk gradien background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ], // Warna gradien dari LoginPage
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: CustomScrollView(
          slivers: [
            // --- Bagian Header dengan Hero ---
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                // Menambahkan tombol kembali secara eksplisit
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),

              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: widget.item.title,
                      child: Image.asset(item.imagePath, fit: BoxFit.cover),
                ),
                 // Overlay gelap agar teks terlihat jelas
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // KONTEN DETAIL
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_filled),
                          label: const Text("Tonton Trailer"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
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
                        ),
                      ),
                    ],
                  ),
                ),

                // Bagian Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(Icons.movie, "Studio", item.studio),
                      _buildInfoColumn(
                        Icons.calendar_today,
                        "Tahun",
                        item.year.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(
                  height: 32,
                  thickness: 1,
                  color: Colors.white24,
                  indent: 16,
                  endIndent: 16,
                ),

                //  Menampilkan Info Unik
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildUniqueInfoWidget(item), // Panggil helper widget
                ),

                // 🔹 Tampilkan Genre (jika tersedia)
                if (item.genres.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Genres",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildGenreChips(item.genres),
                      ],
                    ),
                  ),

                const Divider(height: 32),

                // Rating bintang
                EasyStarsRating(
                  initialRating: 4.0,
                  animationConfig: StarAnimationConfig.scale,
                  filledColor: Colors.yellow,
                  onRatingChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Sinopsis expandable
                GFAccordion(
                  title: 'Sinopsis',
                  content: item.synopsis,
                  collapsedIcon: const Icon(Icons.add),
                  expandedIcon: const Icon(Icons.remove),
                  titleBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  contentBorderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
