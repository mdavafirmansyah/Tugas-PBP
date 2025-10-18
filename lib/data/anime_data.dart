import '/models/anime.dart';

final List<Anime> animeList = [
  // Menambahkan properti unik 'sourceMaterial' (String) di akhir
  Anime(
    "Jujutsu Kaisen",
    "MAPPA",
    2020,
    "assets/images/jujutsu_kaisen.jpg",
    "Yuji Itadori, seorang siswa SMA...",
    ["Action, Adventure, Fantasy"],
    "Manga", // sourceMaterial
    "https://www.youtube.com/watch?v=pkKu9hLT-t8", 
  ),
  Anime(
    "Attack on Titan",
    "Wit Studio & MAPPA",
    2013,
    "assets/images/attack_on_titan.jpg",
    "Di dunia di mana umat manusia hidup...",
     ["Action", "Drama", "Fantasy", "Mystery"],
    "Manga", // sourceMaterial
    "https://www.youtube.com/watch?v=-TUdNmIrkQI", 
  ),
  Anime(
    "Demon Slayer: Kimetsu no Yaiba",
    "Ufotable",
    2019,
    "assets/images/demon_slayer.jpg",
    "Setelah keluarganya dibantai oleh iblis...",
    ["Action", "Adventure", "Supernatural"],
    "Manga", // sourceMaterial
    "https://www.youtube.com/watch?v=VQGCKyvzIM4", 
  ),
  Anime(
    "One Piece",
    "Toei Animation",
    1999,
    "assets/images/one_piece.jpg",
    "Monkey D. Luffy, seorang bocah lelaki...",
    ["Action", "Adventure", "Comedy", "Fantasy"],
    "Manga", // sourceMaterial
    "https://www.youtube.com/watch?v=2QjJMT554Bc", 
  ),
  Anime(
    "Naruto Shippuden",
    "Pierrot",
    2007,
    "assets/images/naruto.jpg", 
    " Naruto Uzumaki, adalah seorang ninja remaja yang keras dan hiperaktif yang terus-menerus mencari persetujuan dan pengakuan, serta menjadi Hokage, yang diakui sebagai pemimpin dan ninja terkuat di desa.",
    ["Action, Adventure, Fantasy"],
    "https://youtu.be/22R0j8UKRzY?si=d_uMyCxDhJdL_kF7",
    "Manga", // sourceMaterial
  ),
];