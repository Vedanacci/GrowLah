import 'package:grow_lah/utils/common_strings.dart';

class OnBoardingModel {
  int id;
  String content;

  OnBoardingModel(this.id, this.content);
}

class OnBoardingList {
  static onBoardingList() {
    List<OnBoardingModel> onBoards = [
      OnBoardingModel(0, "Primary Learning Insitute"), //CommonStrings.gardening
      OnBoardingModel(1, "Secondary Learning Insitute"),
      OnBoardingModel(2, "Tertiary Learning Insitute"),
    ];
    return onBoards;
  }
}
