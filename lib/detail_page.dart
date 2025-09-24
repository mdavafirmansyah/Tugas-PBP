import 'package:flutter/material.dart';
import 'models/donghua.dart';
import 'models/action_donghua.dart';
import 'models/romance_donghua.dart';

class DetailPage extends StatefulWidget {
  final Donghua item;

  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

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

                  // Info studio & tahun dengan ikon
                  Row(
                    children: [
                      const Icon(Icons.movie, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text("Studio: ${item.studio}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text("Tahun: ${item.year}",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),

                  const Divider(height: 32),

                  // Info tambahan sesuai tipe
                  if (item is ActionDonghua)
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blueAccent),
                        const SizedBox(width: 6),
                        Text("MC: ${item.mainCharacter}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    )
                  else if (item is RomanceDonghua)
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.pinkAccent),
                        const SizedBox(width: 6),
                        Text("Tema: ${item.theme}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),

                  const Divider(height: 32),

                  // Sinopsis expandable
                  const Text(
                    "Sinopsis",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    item.synopsis,
                    maxLines: isExpanded ? null : 3,
                    overflow:
                        isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    child: Text(isExpanded ? "Read Less" : "Read More"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
