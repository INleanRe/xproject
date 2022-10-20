class Doujin {
  final String ncode;
  final String author;
  final String desc;

  Doujin({
    required this.ncode,
    required this.author,
    required this.desc,

  });

  factory Doujin.fromJson(Map<String, dynamic> json) {
    return Doujin(
      ncode: json['ncode'],
      author: json['author'],
      desc: json['desc'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ncode': ncode,
      'author': author,
      'desc': desc,
    };
  }
}
