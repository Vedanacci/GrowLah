
import 'package:grow_lah/utils/common_strings.dart';

import 'options.dart';

class OptionsList{
  static List<Options> optionList(){
    List<Options> options=[
      Options(1,CommonStrings.videoStory),
      Options(2,CommonStrings.monitor),
      Options(3,CommonStrings.community),
      Options(4,CommonStrings.buyAndSell),
      Options(5,CommonStrings.newsFeed),
      Options(6,CommonStrings.scanSpot)
    ];
    return options;
  }
}