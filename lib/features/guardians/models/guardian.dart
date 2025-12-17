import 'package:hive/hive.dart';

part 'guardian.g.dart';

@HiveType(typeId: 3)
class Guardian {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String relation;

  const Guardian({
    required this.id, 
    required this.name, 
    required this.phoneNumber, 
    required this.relation
  });
}
