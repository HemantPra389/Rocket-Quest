class Question {
  Question({
    required this.id,
    required this.question,
    required this.options,
  });

  int id;
  List<String> options;
  String question;
}
