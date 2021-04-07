import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grow_lah/model/extractImage.dart';

class ProductData {
  String name;
  String image;
  List<double> size;
  double price;
  String description;
  int quantity;
  int productType;

  static String test(ProductData data) {
    print("Product Data");
    print(data.name);
    return data.name;
  }
}

class SensorData extends ProductData {
  String name;
  String image;
  double price;
  String description;
  int quantity;

  final productType = 3;

  SensorData(this.name, this.image, this.price, this.description,
      {this.quantity});

  static String systemDescription = "IOT Sensors help to monitor and track";

  static List<SensorData> defaultData = [
    SensorData("PH Sensor", "image.png", 49.99, systemDescription),
  ];

  static Future<List<SensorData>> getSeeds() async {
    List<SensorData> sensorList = [];
    await FirebaseFirestore.instance
        .collectionGroup("Sensors")
        .get()
        .then((feed) async {
      await Future.forEach(feed.docs, (element) async {
        Map<String, dynamic> data = element.data();
        print(data);
        String image = data["image"];
        String urlImage = await FirebaseStorage.instance
            .ref("/Products/" + image)
            .getDownloadURL();
        SensorData sensorData = SensorData(
          data["name"],
          urlImage,
          data["price"].toDouble(),
          data["description"],
        );
        sensorList.add(sensorData);
      });
    });
    return sensorList == [] ? defaultData : sensorList;
  }

  Future<void> writeSeeds() async {
    await FirebaseFirestore.instance
        .collection("Sensors")
        .doc(name)
        .set({
          'name': name,
          'image': image,
          "size": size,
          "price": price,
          "description": description
        })
        .then((value) => print("Sensor Added"))
        .catchError((error) => print("Failed to add Sensor: $error"));
  }
}

class SeedData extends ProductData {
  String name;
  String image;
  String plantImage;
  List<double> size;
  double price;
  String description;
  int quantity;

  final productType = 3;

  SeedData(this.name, this.image, this.size, this.price, this.description,
      this.plantImage,
      {this.quantity});

  static String systemDescription =
      "An old time favorite, the Heirloom Black-Seeded Simpson is considered by many to be the #1 leaf lettuce variety. This variety is among the easiest of the leaf lettuce cultivars to grow, and it produces strong yields from seed. In addition to its delicious and complex taste, it is also a steady grower even in warmer climates.";
  static List<SeedData> defaultData = [
    SeedData(
        "Seed 1", "image", [158, 54, 54], 49.99, systemDescription, "image"),
    SeedData(
        "Seed 2", "image", [158, 54, 54], 99.99, systemDescription, "image"),
    SeedData(
        "Seed 3", "image", [158, 54, 54], 149.99, systemDescription, "image"),
    SeedData(
        "Seed 4", "image", [158, 54, 54], 299.99, systemDescription, "image")
  ];

  static Future<List<SeedData>> getSeeds() async {
    List<SeedData> seedList = [];
    await FirebaseFirestore.instance
        .collectionGroup("Seeds")
        .get()
        .then((feed) async {
      await Future.forEach(feed.docs, (element) async {
        Map<String, dynamic> data = element.data();
        List<double> size = [];
        for (dynamic sizeIn in data["size"]) {
          size.add(sizeIn.toDouble());
        }
        print(data);
        String image = data["image"];
        String urlImage = await FirebaseStorage.instance
            .ref("/Products/" + image)
            .getDownloadURL();
        String plantimage = data["plantImage"];
        String urlPlant = await FirebaseStorage.instance
            .ref("/Produce/" + plantimage)
            .getDownloadURL();
        SeedData nutrientData = SeedData(data["name"], urlImage, size,
            data["price"].toDouble(), data["description"], urlPlant);
        seedList.add(nutrientData);
      });
    });
    return seedList == [] ? defaultData : seedList;
  }

  Future<void> writeSeeds() async {
    await FirebaseFirestore.instance
        .collection("Seeds")
        .doc(name)
        .set({
          'name': name,
          'image': image,
          'plantImage': plantImage,
          "size": size,
          "price": price,
          "description": description
        })
        .then((value) => print("Seed Added"))
        .catchError((error) => print("Failed to add Seed: $error"));
  }
}

class NutrientData extends ProductData {
  String name;
  String image;
  String type;
  List<double> size;
  double price;
  String description;
  int quantity;

  final productType = 2;

  NutrientData(this.name, this.image, this.size, this.price, this.description,
      {this.quantity, this.type});

  static String systemDescription =
      "The benefits of hydrogen peroxide (H2O2) for a garden can be useful for any kind of a garden, and any method of gardening. Hydrogen peroxide is great for plants that are planted in the ground, and it’s also great for plants in containers. it is useful in hydroponic gardens, raised beds, and greenhouses.";
  static List<NutrientData> defaultData = [
    NutrientData(
        "Nutrient 1", "image", [158, 54, 54], 49.99, systemDescription),
    NutrientData(
        "Nutrient 2", "image", [158, 54, 54], 99.99, systemDescription),
    NutrientData(
        "Nutrient 3", "image", [158, 54, 54], 149.99, systemDescription),
    NutrientData(
        "Nutrient 4", "image", [158, 54, 54], 299.99, systemDescription)
  ];

  static Future<List<NutrientData>> getNutrients() async {
    List<NutrientData> nutrientList = [];
    await FirebaseFirestore.instance
        .collectionGroup("Nutrients")
        .get()
        .then((feed) async {
      await Future.forEach(feed.docs, (element) async {
        Map<String, dynamic> data = element.data();
        List<double> size = [];
        for (dynamic sizeIn in data["size"]) {
          size.add(sizeIn.toDouble());
        }
        print(data);
        String image = data["image"];
        String urlImage = await FirebaseStorage.instance
            .ref("/Products/" + image)
            .getDownloadURL();
        NutrientData nutrientData = NutrientData(data["name"], urlImage, size,
            data["price"].toDouble(), data["description"]);
        nutrientList.add(nutrientData);
      });
    });
    return nutrientList == [] ? defaultData : nutrientList;
  }

  Future<void> writeNutrients() async {
    await FirebaseFirestore.instance
        .collection("Nutrients")
        .doc(name)
        .set({
          'name': name,
          'image': image,
          "size": size,
          "price": price,
          "description": description
        })
        .then((value) => print("Nutrient Added"))
        .catchError((error) => print("Failed to add Nutrient: $error"));
  }
}

class SystemData extends ProductData {
  String name;
  String image;
  int pots;
  String type;
  List<double> size;
  String light;
  List<String> sensors;
  double price;
  String description;
  int quantity;

  final productType = 1;

  SystemData(this.name, this.image, this.pots, this.size, this.type,
      this.sensors, this.light, this.price, this.description,
      {this.quantity});

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

  static SystemData empty = SystemData("", "", 0, [], "", [], "", 0, "");

  static Future<List<SystemData>> getSystems() async {
    List<SystemData> systemList = [];
    await FirebaseFirestore.instance
        .collectionGroup("Systems")
        .get()
        .then((feed) async {
      await Future.forEach(feed.docs, (element) async {
        Map<String, dynamic> data = element.data();
        List<double> size = [];
        for (dynamic sizeIn in data["size"]) {
          size.add(sizeIn.toDouble());
        }
        List<String> sensors = List<String>.from(data["sensors"]);
        String image = data["image"];
        String urlImage = await FirebaseStorage.instance
            .ref("/Products/" + image)
            .getDownloadURL();
        print(data);
        print("DownloadURL");
        print(urlImage);
        SystemData systemData = SystemData(
            data["name"],
            urlImage,
            data["pots"],
            size,
            data["type"],
            sensors,
            data["light"],
            data["price"],
            data["description"]);
        systemList.add(systemData);
      });
      print("Done");
      print(systemList);
      //return systemList == [] ? defaultData : systemList;
    });
    print("DoneFinal");
    print(systemList);
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

class CartData {
  static Future<List<ProductData>> getSystems() async {
    print("In");
    List<ProductData> productList = [];
    List<String> cartData;
    User user = FirebaseAuth.instance.currentUser;
    print(user.uid);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get()
        .then((userInfo) async {
      Map<String, dynamic> mapCartdata = userInfo.data()["Cart"];
      print(mapCartdata);
      var mapData = mapCartdata.keys.toList();
      print("Map Data");
      print(mapData);
      cartData = List<String>.from(mapData);

      for (var item in List<String>.from(mapData)) {
        if (mapCartdata[item] == 0) {
          cartData.remove(item);
        }
      }

      print(cartData);
      print("Cart Data");

      List<ProductData> allData =
          List<ProductData>.from(await SystemData.getSystems());
      allData.addAll(await NutrientData.getNutrients());
      allData.addAll(await SeedData.getSeeds());

      for (String item in cartData) {
        for (ProductData product in allData) {
          if (product.name == item) {
            product.quantity = mapCartdata[item];
            productList.add(product);
            break;
          }
        }
        if (item == "Custom") {
          print(item);
          print(mapCartdata[item]);
          List<dynamic> customItems = mapCartdata[item];
          print(customItems);
          for (var item2 in customItems) {
            print(item2);
            Map<String, dynamic> listItem = item2;
            ProductData product = ProductData();
            product.name = listItem["name"];
            product.image = listItem['image'];
            product.image = await FirebaseStorage.instance
                .ref("/Products/" + product.image)
                .getDownloadURL();
            product.quantity = listItem['qty'];
            product.price = listItem['price'].toDouble();
            productList.add(product);
            print(listItem);
            print(listItem["name"]);
          }
          print("Custom");
          print(customItems);
        }
      }
      if (productList.isEmpty) {
        productList = List<ProductData>.from(SystemData.defaultData);
        productList.addAll(NutrientData.defaultData);
        productList.addAll(SeedData.defaultData);
      }
    });

    return productList;
  }
}
