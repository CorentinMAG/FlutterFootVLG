class Sheet{
  int id_team;
  int id_event;
  String adverse_team;
  String score;
  String nb_sheet;

  Sheet({
    this.id_team=0,
    this.id_event=0,
    this.adverse_team="",
    this.score="",
    this.nb_sheet=""
});

  Map<String, dynamic> toJson() =>
      {
       "id_team":id_team,
        "id_event":id_event,
        "adverse_team":adverse_team,
        "score":score,
        "nb_sheet":nb_sheet
      };

  factory Sheet.fromJson(Map<String, dynamic> json) {
    var sheet = Sheet(
    id_team: json['id_team'],
    id_event: json['id_event'],
    adverse_team : json['adverse_team'],
    score : json['score'],
    );
    if(json['nb_sheet']!=null)
     sheet.nb_sheet = json['nb_sheet'];
    return sheet;
  }
}