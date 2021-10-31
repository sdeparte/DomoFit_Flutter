class Connexion {
  String ipAddress;
  DateTime date;

  Connexion({
    required this.ipAddress,
    required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'ipAddress': ipAddress,
      'date': date.toString(),
    };
  }

  static Connexion fromMap(Map<String, dynamic> map) {
    return Connexion(
      ipAddress: map['ipAddress'],
      date: DateTime.parse(map['date']),
    );
  }
}