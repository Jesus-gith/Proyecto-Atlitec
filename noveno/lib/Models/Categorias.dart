class Categorias{
  final int id;
  final String nombre;
  Categorias(this.id, this.nombre);
  Categorias.fromJson(Map<String, dynamic> json)
      : id=json['id'],
        nombre=json['nombre'];
}