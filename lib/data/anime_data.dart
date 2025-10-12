import '/models/anime.dart';

final List<Anime> animeList = [
  // Menambahkan properti unik 'sourceMaterial' (String) di akhir
  Anime(
    "Jujutsu Kaisen",
    "MAPPA",
    2020,
    "assets/images/jujutsu_kaisen.jpg",
    "Yuji Itadori, seorang siswa SMA...",
    "Manga", // sourceMaterial
  ),
  Anime(
    "Attack on Titan",
    "Wit Studio & MAPPA",
    2013,
    "assets/images/attack_on_titan.jpg",
    "Di dunia di mana umat manusia hidup...",
    "Manga", // sourceMaterial
  ),
  Anime(
    "Demon Slayer: Kimetsu no Yaiba",
    "Ufotable",
    2019,
    "assets/images/demon_slayer.jpg",
    "Setelah keluarganya dibantai oleh iblis...",
    "Manga", // sourceMaterial
  ),
  Anime(
    "One Piece",
    "Toei Animation",
    1999,
    "assets/images/one_piece.jpg",
    "Monkey D. Luffy, seorang bocah lelaki...",
    "Manga", // sourceMaterial
  ),
  Anime(
    "Cyberpunk: Edgerunners",
    "Studio Trigger",
    2022,
    "assets/images/edgerunners.jpg", // Pastikan gambar ada
    "Seorang anak jalanan mencoba bertahan hidup di kota metropolis...",
    "Video Game", // sourceMaterial
  ),
];