class Model {
  int id;
  String firstName;
  String lastName;

  Model({this.id, this.firstName, this.lastName});

  Model fromJson(json) {
    return Model(
        id: json['id'], firstName: json['firstName'], lastName: json['lastName']);
  }
  Map<String, dynamic> toJson() {
    return {'firstName': firstName, 'lastName': lastName};
  }

}
