import 'package:flutter/material.dart';
import 'package:login/webview_page.dart';
import 'models/donghua.dart';
import 'models/action_donghua.dart';
import 'models/romance_donghua.dart';
import 'package:easy_stars/easy_stars.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Donghua item;

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
        Icon(icon, color: Colors.grey.shade600, size: 28),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final formattedYear = DateFormat.y().format(
      DateTime(item.year), // kalau year = 2017 → 2017
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
                background: Hero(
                  // Memindahkan Hero ke sini
                  tag: widget.item.title, // Tag Hero harus unik dan konsisten
                  child: Image.asset(item.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),

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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  title: "${item.title} Trailer",
                                  url:
                                      "https://www.youtube.com/results?search_query=${item.title}+trailer", // URL sementara
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Bagian Info yang Rapi
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

                const Divider(height: 32, indent: 16, endIndent: 16),

                // Info tambahan sesuai tipe
                if (item is ActionDonghua)
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blueAccent),
                      const SizedBox(width: 6),
                      Text(
                        "MC: ${item.mainCharacter}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                else if (item is RomanceDonghua)
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.pinkAccent),
                      const SizedBox(width: 6),
                      Text(
                        "Tema: ${item.theme}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                const Divider(height: 32),

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
