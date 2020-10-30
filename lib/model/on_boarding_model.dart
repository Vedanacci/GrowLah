import 'package:grow_lah/utils/common_strings.dart';

class OnBoardingModel{
  int id;
  String content;

  OnBoardingModel(this.id, this.content);
}

class OnBoardingList{
  static onBoardingList(){
    List<OnBoardingModel> onBoards=[
    OnBoardingModel(0, CommonStrings.gardening),
    OnBoardingModel(1, CommonStrings.farming),
    OnBoardingModel(2, CommonStrings.corp),
      ];
    return onBoards;
  }
}