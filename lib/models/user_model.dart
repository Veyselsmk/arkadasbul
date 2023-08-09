class UserModel {
  final String? userID;
  final String? email;
  final String? username;
  //final String? phoneNo;
  final String? city;
  final String? bio;
  //final String? abilities;
  final String? imgURL;
  UserModel(
      {required this.userID,
      required this.email,
      this.username,
      //this.phoneNo,
      this.city,
      this.bio,
      //this.abilities,
      this.imgURL});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'username': username,
      //'phoneNo': phoneNo,
      'city': city,
      'bio': bio,
      //'abilities': abilities,
      'imgURL': imgURL ?? 'https://firebasestorage.googleapis.com/v0/b/friend-circle-66cb3.appspot.com/o/default_img%2Fprfoile_img.png?alt=media&token=0c78bcf0-90c1-4303-a285-28b1cdd7d8fe',
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      userID: map?['userID'] as String?,
      email: map?['email'] as String?,
      username: map?['username'] as String?,
      //phoneNo: map?['phoneNo'] as String?,
      city: map?['city'] as String?,
      bio: map?['bio'] as String?,
      //abilities: map?['abilities'] as String?,
      imgURL: map?['imgURL'] as String?,
    );
  }

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, username: $username, city: $city, bio: $bio, imgURL: $imgURL}';
  }
}
