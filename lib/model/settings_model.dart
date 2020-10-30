class SettingsModel {
  int id;
  String title;
  bool isChecked;
  Function onClick = () {};

  SettingsModel(this.id, this.title, this.isChecked, this.onClick);
}
