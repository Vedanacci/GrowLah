import 'package:cloud_firestore/cloud_firestore.dart';

Future<PlantData> extractPlantData(String plantName) async {
  print("Extracting data");
  print(plantName);
  DocumentSnapshot plant = await FirebaseFirestore.instance
      .collection("PlantTypes")
      .doc(plantName)
      .get();
  return PlantData(plant["Name"], plant["Family"], plant["About"],
      plant["Humidity"], plant["Light"], plant["Temperature"]);
}

class PlantData {
  String name;
  String family;
  String humidty;
  String light;
  String temp;
  String about;

  PlantData(
      this.name, this.family, this.about, this.humidty, this.light, this.temp);
}
