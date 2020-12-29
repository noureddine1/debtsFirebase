// To parse this JSON data, do
//
//     final debt = debtFromJson(jsonString);

import 'dart:convert';

Debt debtFromJson(String str) => Debt.fromJson(json.decode(str));

String debtToJson(Debt data) => json.encode(data.toJson());

class Debt {
  Debt({
    this.id,
    this.fullname,
    this.amount,
    this.duedate,
    this.startdate,
    this.type,
    this.status,
  });

  int id;
  String fullname;
  int amount;
  String duedate;
  String startdate;
  String type;
  String status;

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        id: json["id"],
        fullname: json["fullname"],
        amount: json["amount"],
        duedate: json["duedate"],
        startdate: json["startdate"],
        type: json["type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "amount": amount,
        "duedate": duedate,
        "startdate": startdate,
        "type": type,
        "status": status,
      };
}
