import '../../core/utils/id_gen.dart';

class Dish {
  final String id;
  final String name;
  final bool selected;
  final DateTime createdAt;

  const Dish({
    required this.id,
    required this.name,
    required this.selected,
    required this.createdAt,
  });

  factory Dish.create({required String name, bool selected = true}) {
    return Dish(
      id: IdGen.newId(),
      name: name,
      selected: selected,
      createdAt: DateTime.now(),
    );
  }

  Dish copyWith({String? name, bool? selected}) {
    return Dish(
      id: id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'selected': selected,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as String,
      name: json['name'] as String,
      selected: json['selected'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Dish && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
