class Player {
  String name;
  String imgAsset;

  Player({required this.name,required this.imgAsset});

  @override
  bool operator ==(other) {
    //print("overloaded");
    if (other is Player){
      if( other.name == name && other.imgAsset == imgAsset) return true;
    }
    return false;
  }

  Map<String, String> toJsonPlayer() => {
    'name': name,
    'imgAsset': imgAsset,
  };

  Player.fromJson(json)
      : name = json['name'],
        imgAsset = json['imgAsset'];

}