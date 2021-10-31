class Button {
  String remotePartIdent;
  String buttonIdent;
  String? custumText;
  String commande;

  Button({
    required this.remotePartIdent,
    required this.buttonIdent,
    this.custumText,
    required this.commande
  });

  Map<String, dynamic> toMap() {
    return {
      'remotePartIdent': remotePartIdent,
      'buttonIdent': buttonIdent,
      'custumText': custumText,
      'commande': commande,
    };
  }

  static Button fromMap(Map<String, dynamic> map) {
    return Button(
      remotePartIdent: map['remotePartIdent'],
      buttonIdent: map['buttonIdent'],
      custumText: map['custumText'],
      commande: map['commande'],
    );
  }
}