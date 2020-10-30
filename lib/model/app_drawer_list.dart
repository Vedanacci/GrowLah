import 'package:grow_lah/model/app_drawer_model.dart';
import 'package:grow_lah/utils/common_strings.dart';

class AppDrawerList{
  static  List<AppDrawerModel> drawerList(){
    List<AppDrawerModel>drawer=[
      AppDrawerModel(0, CommonStrings.myProfile),
      AppDrawerModel(1, CommonStrings.donate),
      AppDrawerModel(2, CommonStrings.settings),
      AppDrawerModel(3, CommonStrings.myOrders),
      AppDrawerModel(4, CommonStrings.subscription),
      AppDrawerModel(5, CommonStrings.referAndEarn),
      AppDrawerModel(6, CommonStrings.logOut),
    ];
    return drawer;
  }
}