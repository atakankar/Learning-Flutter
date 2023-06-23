class Remind {
  String title;
  String description;
  String startDate;
  String finishDate;
  int period;

  Remind({
    required this.title,
    required this.description,
    required this.startDate,
    required this.finishDate,
    required this.period,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'finishDate': finishDate,
      'period': period,
    };
  }

  factory Remind.fromJson(Map<String, dynamic> json) {
    return Remind(
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      finishDate: json['finishDate'],
      period: json['period'],
    );
  }
}
