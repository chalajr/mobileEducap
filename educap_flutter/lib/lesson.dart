class Lesson {
  int id;
  String titulo;
  String descripcion;
  String imagen;

  Lesson({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
    );
  }
}
