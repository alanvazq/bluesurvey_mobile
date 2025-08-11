class Survey {
  final String id;
  final String idUser;
  final String title;
  final String description;
  final List<dynamic> questions;

  Survey({
    required this.id,
    required this.idUser,
    required this.title,
    required this.description,
    required this.questions,
  });
}
