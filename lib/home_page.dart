import 'dart:io';
import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'data/donghua_data.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  final String email;

  const MyHomePage({super.key, required this.title, required this.email});

  void _showDeviceInfoDialog(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown';
    String deviceVersion = 'Unknown';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model; // e.g. "Pixel 7"
        deviceVersion = "Android ${androidInfo.version.release}";
        print('Running on ${androidInfo.model}');
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine!; // e.g. "iPhone15,2"
        deviceVersion = "iOS ${iosInfo.systemVersion}";
        print('Running on ${iosInfo.utsname.machine}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),

          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDeviceInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Login sebagai: $email",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: donghuaList.length,
              itemBuilder: (context, index) {
                final donghua = donghuaList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(item: donghua),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero animation
                        Hero(
                          tag: donghua.title,
                          child: Image.asset(
                            donghua.imagePath,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donghua.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                donghua.getInfo(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
