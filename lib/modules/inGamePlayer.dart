import 'package:estimation_calculator/modules/player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/game.dart';

class inGamePlayer{

  late String name;
  late int score;
  late int bid;
  late bool isCall;
  late bool isWith;
  late String orderedColor;
  late String risk;

  inGamePlayer(Player p){
    name = p.name;
    score=0;
    bid =0;
    isCall=false;
    isWith=false;
    orderedColor="No Trump";
    risk ="No Risk";
  }

}

class gamePlayers extends StateNotifier<List<inGamePlayer>>{


  gamePlayers([List<inGamePlayer>? initialPlayers]) : super(initialPlayers ?? []) ;

  void add(Player p) {
    print(p.name+"added");
    state = [
      ...state,
      inGamePlayer(p),
    ];
  }

  toggleIsCall(int i){
    state[i].isCall= !state[i].isCall;
  }

  toggleIsWith(int i){
    state[i].isWith= !state[i].isWith;
  }
  setScore(int i, int s){
    state[i].score = s;
  }
  setBid(int i, int s){
    state[i].bid = s;
  }
  setName(int i, String n){
    state[i].name = n;
  }
  setOColor(int i, String o){
    state[i].orderedColor = o;
  }
  setRisk(int i, String r){
    state[i].risk = r;
  }
  int getSumBids(){
    int sum=0;
    for(inGamePlayer i in state){
      sum+=i.bid;
    }
    return sum;
  }


}

final playersProvider = StateNotifierProvider(
    (ref) => gamePlayers([])
);