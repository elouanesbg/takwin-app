class BookModel {
  String imgAssetPath;
  String title;
  String description;
  String categorie;
  int rating;

  BookModel(
      {required this.title,
      required this.description,
      required this.categorie,
      required this.rating,
      required this.imgAssetPath});
}
