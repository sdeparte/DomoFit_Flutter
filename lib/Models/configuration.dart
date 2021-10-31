class Configuration {
  static const defaultBluetoothName = "HC-06";

  int id = 0;

  String bluetoothName;

  int volumeRemote;
  int numericalRemote;
  int directionalRemote;
  int colorRemote;
  int playerRemote;

  Configuration({
    this.bluetoothName = defaultBluetoothName,
    this.volumeRemote = 0,
    this.numericalRemote = 0,
    this.directionalRemote = 0,
    this.colorRemote = 0,
    this.playerRemote = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bluetoothName': bluetoothName,
      'volumeRemote': volumeRemote,
      'numericalRemote': numericalRemote,
      'directionalRemote': directionalRemote,
      'colorRemote': colorRemote,
      'playerRemote': playerRemote,
    };
  }

  static Configuration fromMap(Map<String, dynamic> map) {
    return Configuration(
      bluetoothName: map['bluetoothName'],
      volumeRemote: map['volumeRemote'],
      numericalRemote: map['numericalRemote'],
      directionalRemote: map['directionalRemote'],
      colorRemote: map['colorRemote'],
      playerRemote: map['playerRemote'],
    );
  }
}