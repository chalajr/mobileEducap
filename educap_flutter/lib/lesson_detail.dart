class LessonDetail {
  int id;
  String nombre;
  String descripcion;
  String imagen;
  int? categoriaPadre;

  LessonDetail({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    this.categoriaPadre,
  });

  factory LessonDetail.fromJson(Map<String, dynamic> json) {
    return LessonDetail(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        imagen: json['imagen'],
        categoriaPadre: json['categoriaPadre']);
  }
}
