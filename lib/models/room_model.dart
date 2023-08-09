class RoomModel {
  String? roomID;
  String? roomNumber;
  String? roomName;
  String? ownerID;
  String? ownerName;
  String? city;
  String? desc;
  String? date;
  String? category;
  String? location;
  String? capacity;
  List<dynamic>? members;
  //int? teamNumbers;
  //Map<String, List<dynamic>>? teams;
  bool? active;

  RoomModel(
      {this.roomID,
      this.roomNumber,
      this.roomName,
      this.ownerID,
      this.ownerName,
      this.city,
      this.desc,
      this.date,
      this.category,
      this.location,
      this.capacity,
      this.members,
      //this.teamNumbers,
      //this.teams,
      this.active});

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'roomNumber': roomNumber ?? '',
      'roomName': roomName ?? '',
      'ownerID': ownerID,
      'ownerName': ownerName ??'',
      'city': city ?? '',
      'desc': desc ?? '',
      'date': date ?? '',
      'category': category ?? '',
      'location': location ?? '',
      'capacity': capacity ?? '',
      'members': members ?? [],
      //'teamNumbers': teamNumbers,
      //'teams': teams ?? {},
      'active': active,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic>? map) {
    return RoomModel(
      roomID: map?['roomID'] as String?,
      roomNumber: map?['roomNumber'] as String?,
      roomName: map?['roomName'] as String?,
      ownerID: map?['ownerID'] as String?,
      ownerName: map?['ownerName'] as String?,
      city: map?['city'] as String?,
      desc: map?['desc'] as String?,
      date: map?['date'] as String?,
      category: map?['category'] as String?,
      location: map?['location'] as String?,
      capacity: map?['capacity'] as String?,
      members: map?['members'] as List<dynamic>?,
      //teamNumbers: map?['teamNumbers'] as int?,
      //teams: map?['teams']?.cast<String, List<dynamic>>(),
      active: map?['active'] as bool,
    );
  }

  @override
  String toString() {
    return 'RoomModel{roomID: $roomID, roomNumber: $roomNumber, roomName: $roomName, ownerID: $ownerID, ownerName: $ownerName, city: $city, desc: $desc, date: $date, category: $category, location: $location, capacity: $capacity, members: $members, active: $active}';
  }
}
