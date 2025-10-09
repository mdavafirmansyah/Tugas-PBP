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

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
     final formattedYear = DateFormat.y().format(
      DateTime(item.year), // kalau year = 2017 → 2017
    );

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan rounded bawah
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.asset(
                item.imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            // Konten detail
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                   SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_filled),
                      label: const Text("Tonton Trailer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Navigasi ke WebViewPage saat ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              title: "${item.title} Trailer",
                              url: "https://www.youtube.com/results?search_query=${item.title}+trailer",
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Info studio & tahun dengan ikon
                  Row(
                    children: [
                      const Icon(Icons.movie, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Studio: ${item.studio}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Tahun: $formattedYear",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
