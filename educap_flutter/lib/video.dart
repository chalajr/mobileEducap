class Video {
  int id;
  String titulo;
  String descripcion;
  String link;

  Video({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.link,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      link: json['link'],
    );
  }
}
