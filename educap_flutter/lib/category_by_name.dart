class CategoryByName {
  String nombre;

  CategoryByName({
    required this.nombre,
  });

  factory CategoryByName.fromJson(Map<String, dynamic> json) {
    return CategoryByName(
      nombre: json['nombre'],
    );
  }
}
