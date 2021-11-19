class Category {
  int id;
  String nombre;
  String descripcion;
  String imagen;
  int? categoriaPadre;

  Category({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    this.categoriaPadre,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      categoriaPadre: json['categoriaPadre'],
    );
  }
}

class CategoryArguments {
  final int id;
  CategoryArguments(this.id);
}
