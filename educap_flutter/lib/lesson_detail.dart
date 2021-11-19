class LessonDetail {
  int id;
  String titulo;
  String descripcion;
  String imagen;
  int category;

  LessonDetail({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.category,
  });

  factory LessonDetail.fromJson(Map<String, dynamic> json) {
    return LessonDetail(
        id: json['id'],
        titulo: json['titulo'],
        descripcion: json['descripcion'],
        imagen: json['imagen'],
        category: json['category']);
  }
}

class MyLessonArguments {
  final int id;
  MyLessonArguments(this.id);
}
