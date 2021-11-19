class File {
  int orden;
  String titulo;
  String descripcion;
  String path;
  String lipo;

  File({
    required this.orden,
    required this.titulo,
    required this.descripcion,
    required this.path,
    required this.lipo,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
        orden: json['orden'],
        titulo: json['titulo'],
        descripcion: json['descripcion'],
        path: json['path'],
        lipo: json['lipo']);
  }
}
