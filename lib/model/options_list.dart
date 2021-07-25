import 'package:grow_lah/utils/common_strings.dart';
import 'package:grow_lah/utils/assets.dart';
import 'options.dart';

class OptionsList {
  static List<Options> optionList() {
    List<Options> options = [
      Options(1, CommonStrings.videoStory, Assets.videoIcon),
      Options(2, CommonStrings.monitor, Assets.tempIcon),
      Options(3, "NOTIFICATIONS", Assets.communicate),
      Options(4, "BUY", Assets.bigCart),
      Options(5, CommonStrings.newsFeed, Assets.newsFeed),
      Options(6, CommonStrings.scanSpot, Assets.scanSpot)
    ];
    return options;
  }
}
