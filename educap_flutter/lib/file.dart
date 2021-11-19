class Archivo {
  int orden;
  String titulo;
  String descripcion;
  String path;
  String lipo;

  Archivo({
    required this.orden,
    required this.titulo,
    required this.descripcion,
    required this.path,
    required this.lipo,
  });

  factory Archivo.fromJson(Map<String, dynamic> json) {
    return Archivo(
        orden: json['orden'],
        titulo: json['titulo'],
        descripcion: json['descripcion'],
        path: json['path'],
        lipo: json['lipo']);
  }
}
