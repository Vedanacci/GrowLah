import 'package:cloud_firestore/cloud_firestore.dart';

class SystemData {
  String name;
  String image;
  int pots;
  String type;
  List<double> size;
  String light;
  List<String> sensors;
  double price;
  String description;

  SystemData(this.name, this.image, this.pots, this.size, this.type,
      this.sensors, this.light, this.price, this.description);

  static String systemDescription =
      "This is a Hydroponics System. Hydroponics allow you to not only grow vertically, but increases the growth of produce. It also rather counterintuitively uses less water.";
  static List<SystemData> defaultData = [
    SystemData("System Lite", "image", 6, [158, 54, 54], "Aeroponics", [],
        "Outdoor", 49.99, systemDescription),
    SystemData("System Standard", "image", 24, [158, 54, 54], "Aeroponics", [],
        "Outdoor", 99.99, systemDescription),
    SystemData("System Pro", "image", 12, [158, 54, 54], "Aeroponics", [],
        "Outdoor", 149.99, systemDescription),
    SystemData("System Insane", "image", 36, [158, 54, 54], "Aeroponics", [],
        "Outdoor", 299.99, systemDescription)
  ];

  static Future<List<SystemData>> getSystems() async {
    List<SystemData> systemList = [];
    await FirebaseFirestore.instance
        .collectionGroup("Systems")
        .get()
        .then((feed) {
      feed.docs.forEach((element) {
        Map<String, dynamic> data = element.data();
        List<double> size = List<double>.from(data["size"]);
        List<String> sensors = List<String>.from(data["sensors"]);
        print(data);
        SystemData systemData = SystemData(
            data["name"],
            data["image"],
            data["pots"],
            size,
            data["type"],
            sensors,
            data["light"],
            data["price"],
            data["description"]);
        systemList.add(systemData);
      });
    });
    return systemList == [] ? defaultData : systemList;
  }

  Future<void> writeSystems() async {
    await FirebaseFirestore.instance
        .collection("Systems")
        .doc(name)
        .set({
          'name': name,
          'image': image,
          'pots': pots,
          'type': type,
          "size": size,
          "light": light,
          "sensors": sensors,
          "price": price,
          "description": description
        })
        .then((value) => print("System Added"))
        .catchError((error) => print("Failed to add system: $error"));
  }
}
