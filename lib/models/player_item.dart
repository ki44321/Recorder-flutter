class PlayerItem {
  PlayerItem({this.title, this.fileName});

  final String title;
  final String fileName;

  String get path => "sounds/$fileName";
}
