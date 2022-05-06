class ExerciseModel {
  String? exercise;
  String? weight;
  String? sets;
  String? reps;
  List? ledger;

  ExerciseModel({this.exercise, this.weight, this.sets, this.reps, this.ledger});

  //receiving data from our server
  factory ExerciseModel.fromMap(map){
    return ExerciseModel(
      exercise: map['exercise'],
      weight: map['weight'],
      reps: map['reps'],
      sets: map['sets'],
      ledger: map['ledger'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap(){
    return {
      'exercise' : exercise,
      'weight' : weight,
      'sets' : sets,
      'reps' : reps,
    };

  }

}