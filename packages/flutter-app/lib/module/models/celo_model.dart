class CeloDIDModel {
  CeloDIDModel(
      {this.address, this.identifier, this.oldIdentifier, this.celoDid});

  CeloDIDModel.fromJson(Map<String, dynamic> json) {
    address = json['address'] as String?;
    identifier = json['identifier'] as String?;
    oldIdentifier = json['oldIdentifier'] as String?;
    celoDid = json['celoDid'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['address'] = address;
    json['identifier'] = identifier;
    json['oldIdentifier'] = oldIdentifier;
    json['celoDid'] = celoDid;
    return json;
  }

  String? address;
  String? identifier;
  String? oldIdentifier;
  String? celoDid;
}
