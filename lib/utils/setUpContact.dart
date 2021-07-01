import 'package:grow_lah/view/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
