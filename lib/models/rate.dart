class Rate{
  final int id_rate;
  final int id_event;
  final int id_member;
  final int id_player;
  final int rate;

  Rate({
    this.id_rate=0,
    this.id_event,
    this.id_member,
    this.id_player,
    this.rate
});

  Map<String, dynamic> toJson() =>
      {
        "id_rate":id_rate,
        "id_event":id_event,
        "id_member":id_member,
        "id_player":id_player,
        "rate":rate

      };

  factory Rate.fromJson(Map<String, dynamic> json) {
    var rate=Rate(
      id_rate: json["id_rate"],
      id_event: json['id_event'],
      id_member: json['id_member'],
      id_player: json['id_player'],
      rate: json['rate']
    );
    return rate;
  }

}