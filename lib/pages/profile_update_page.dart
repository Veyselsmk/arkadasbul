// bu bölümde profil için gerekli güncelleme input bölümleri olacak
//profil güncellendiğinde profil_page yönlendirilecek

/*var cities = [
  "Adana",
  "Adıyaman",
  "Afyon",
  "Ağrı",
  "Amasya",
  "Ankara",
  "Antalya",
  "Artvin",
  "Aydın",
  "Balıkesir",
  "Bilecik",
  "Bingöl",
  "Bitlis",
  "Bolu",
  "Burdur",
  "Bursa",
  "Çanakkale",
  "Çankırı",
  "Çorum",
  "Denizli",
  "Diyarbakır",
  "Edirne",
  "Elazığ",
  "Erzincan",
  "Erzurum",
  "Eskişehir",
  "Gaziantep",
  "Giresun",
  "Gümüşhane",
  "Hakkari",
  "Hatay",
  "Isparta",
  "İçel (Mersin)",
  "İstanbul",
  "İzmir",
  "Kars",
  "Kastamonu",
  "Kayseri",
  "Kırklareli",
  "Kırşehir",
  "Kocaeli",
  "Konya",
  "Kütahya",
  "Malatya",
  "Manisa",
  "Kahramanmaraş",
  "Mardin",
  "Muğla",
  "Muş",
  "Nevşehir",
  "Niğde",
  "Ordu",
  "Rize",
  "Sakarya",
  "Samsun",
  "Siirt",
  "Sinop",
  "Sivas",
  "Tekirdağ",
  "Tokat",
  "Trabzon",
  "Tunceli",
  "Şanlıurfa",
  "Uşak",
  "Van",
  "Yozgat",
  "Zonguldak",
  "Aksaray",
  "Bayburt",
  "Karaman",
  "Kırıkkale",
  "Batman",
  "Şırnak",
  "Bartın",
  "Ardahan",
  "Iğdır",
  "Yalova",
  "Karabük",
  "Kilis",
  "Osmaniye",
  "Düzce"
];*/


/////


/*
import 'dart:io';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUpdatePage extends StatefulWidget {
  final UserModel? user;
  const ProfileUpdatePage({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  String? _email, _username, _city, _bio;
  var _imgUrl;
  var _profilFoto;
  var cities = ['adana'];
  TextEditingController? _emailController;
  TextEditingController? _usernameController;
  TextEditingController? _bioController;
  TextEditingController? _cityController;
  var viewModel;

  @override
  void initState() {
    viewModel = Provider.of<ViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser(widget.user);
    });
    super.initState();
  }

  void useCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilFoto = File(photo!.path);
      Navigator.of(context).pop();
    });
  }

  void useGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilFoto = File(photo!.path);

      Navigator.of(context).pop();
    });
  }

  @override
  void getUser(UserModel? user) async {

    setState(() {
      _imgUrl = user?.imgURL;
      _emailController = TextEditingController(text: user?.email);
      _usernameController = TextEditingController(text: user?.username);
      _bioController = TextEditingController(text: user?.bio);
      _cityController = TextEditingController(text: user?.city);
    });
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _usernameController?.dispose();

    _bioController?.dispose();
    _cityController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade700, borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text("Kameradan Çek"),
                                    onTap: () {
                                      useCamera();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text("Galeriden Seç"),
                                    onTap: () {
                                      useGallery();
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.green,
                      backgroundImage: _imgUrl != null && _imgUrl != "http://via.placeholder.com/100x100"
                          ? NetworkImage(_imgUrl)
                          : _profilFoto != null
                              ? FileImage(_profilFoto) as ImageProvider
                              : NetworkImage("http://via.placeholder.com/100x100"),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blueGrey.shade700, borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Email Adres',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      )),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blueGrey.shade700, borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      )),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blueGrey.shade700, borderRadius: BorderRadius.circular(6)),
                  child: DropDownField(
                    controller: _cityController,
                    //value: _cityController!.text,
                    labelText: 'Şehir Seçiniz',
                    //labelStyle: TextStyle(backgroundColor: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold),
                    icon: Icon(Icons.location_city),
                    items: cities,
                    setter: (dynamic newValue) {
                      _cityController!.text = newValue;
                    },
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blueGrey.shade700, borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _bioController,
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        border: OutlineInputBorder(),
                      )),
                ),
                Divider(),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      _email = _emailController!.text;
                      _username = _usernameController!.text;
                      _city = _cityController!.text;
                      //_phoneNo = _phoneNoController!.text;
                      _bio = _bioController!.text;
                      //_abilities = _abilitiesController!.text;
                      profileUpdate(context);
                    },
                    color: Colors.green,
                    child: Text(
                      'Profili Güncelle',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void profileUpdate(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    if (_profilFoto != null) {
      _imgUrl = await viewModel.uploadFile(widget.user?.userID, "profil_foto", _profilFoto!);
    }
    //debugPrint("city!!!!!: $_city");
    UserModel? newUser = UserModel(
        userID: widget.user?.userID,
        email: _email,
        username: _username,
        bio: _bio,
        city: _city,
        imgURL: _imgUrl);
    UserModel? updatedUser = await viewModel.updateUser(widget.user?.userID, newUser);
    debugPrint(updatedUser.toString());
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(user:updatedUser)));
  }
}
*/
import 'dart:io';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/home_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUpdatePage extends StatefulWidget {
  final UserModel? user;

  const ProfileUpdatePage({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  String? _email, _username, _city, _bio, _imgUrl;
  File? _profilFoto;
  var cities = [
    "Adana",
    "Adıyaman",
    "Afyon",
    "Ağrı",
    "Amasya",
    "Ankara",
    "Antalya",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakır",
    "Edirne",
    "Elazığ",
    "Erzincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Isparta",
    "İçel (Mersin)",
    "İstanbul",
    "İzmir",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırklareli",
    "Kırşehir",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Kahramanmaraş",
    "Mardin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Şanlıurfa",
    "Uşak",
    "Van",
    "Yozgat",
    "Zonguldak",
    "Aksaray",
    "Bayburt",
    "Karaman",
    "Kırıkkale",
    "Batman",
    "Şırnak",
    "Bartın",
    "Ardahan",
    "Iğdır",
    "Yalova",
    "Karabük",
    "Kilis",
    "Osmaniye",
    "Düzce"
  ];
  TextEditingController? _emailController;
  TextEditingController? _usernameController;
  TextEditingController? _bioController;
  TextEditingController? _cityController;
  var viewModel;

  @override
  void initState() {
    viewModel = Provider.of<ViewModel>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getUser(widget.user);
    });
    super.initState();
  }

  void useCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilFoto = File(photo!.path);
      Navigator.of(context).pop();
    });
  }

  void useGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilFoto = File(photo!.path);

      Navigator.of(context).pop();
    });
  }

  @override
  void getUser(UserModel? user) {
    setState(() {
      _imgUrl = user?.imgURL ??
          'https://firebasestorage.googleapis.com/v0/b/friend-circle-66cb3.appspot.com/o/default_img%2Fprfoile_img.png?alt=media&token=0c78bcf0-90c1-4303-a285-28b1cdd7d8fe';
      _emailController = TextEditingController(text: user?.email);
      _usernameController = TextEditingController(text: user?.username);
      _bioController = TextEditingController(text: user?.bio);
      _cityController = TextEditingController(text: user?.city);
    });
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _usernameController?.dispose();
    _bioController?.dispose();
    _cityController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profili Güncelle'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildProfileImage(),
            SizedBox(height: 16.0),
            buildEmailField(),
            SizedBox(height: 16.0),
            buildUsernameField(),
            SizedBox(height: 16.0),
            buildCityField(),
            SizedBox(height: 16.0),
            buildBioField(),
            SizedBox(height: 24.0),
            buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget buildProfileImage() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Colors.white),
                    title: Text("Fotoğraf Çek", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      useCamera();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.image, color: Colors.white),
                    title: Text("Galeriden resim yükle", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      useGallery();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        radius: 66,
        backgroundImage: _imgUrl != null && _imgUrl != 'https://firebasestorage.googleapis.com/v0/b/friend-circle-66cb3.appspot.com/o/default_img%2Fprfoile_img.png?alt=media&token=0c78bcf0-90c1-4303-a285-28b1cdd7d8fe'
            ? NetworkImage(_imgUrl!)
            : _profilFoto != null
            ? FileImage(_profilFoto!) as ImageProvider
            : NetworkImage('https://firebasestorage.googleapis.com/v0/b/friend-circle-66cb3.appspot.com/o/default_img%2Fprfoile_img.png?alt=media&token=0c78bcf0-90c1-4303-a285-28b1cdd7d8fe'),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        readOnly: true,
        style: TextStyle(color: Colors.black, fontSize: 20),
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: 'Email Adres',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.email, color: Colors.blue),
          labelStyle: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget buildUsernameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _usernameController,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: 'Kullanıcı Adı',
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(Icons.person, color: Colors.blue),
        ),
      ),
    );
  }


  Widget buildCityField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropDownField(
        controller: _cityController,
        labelText: 'Şehir Seçiniz',
        icon: Icon(Icons.location_city, color: Colors.blue),
        items: cities,
        setter: (dynamic newValue) {
          _cityController!.text = newValue;
        },
        textStyle: TextStyle(color: Colors.black),
      ),
    );
  }

/*
  Widget buildCityField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _cityController!.text,
        decoration: InputDecoration(
          labelText: 'Select City',
          prefixIcon: Icon(Icons.location_city, color: Colors.blue),
        ),
        items: cities.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _cityController!.text = newValue!;
        },
      ),
    );
  }
*/
  /*Widget buildCityField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        items: cities.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (selectedCity) {
          setState(() {
            _cityController!.text = selectedCity!;
          });
        },
        value: _cityController!.text.isNotEmpty ? _cityController!.text : '',
        decoration: InputDecoration(
          labelText: 'City',
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(Icons.location_city, color: Colors.blue),
        ),
      ),
    );
  }
*/


  Widget buildBioField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _bioController,
        style: TextStyle(color: Colors.black),
        maxLines: 3,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: 'Bio',
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(Icons.notes, color: Colors.blue),
        ),
      ),
    );
  }

  Widget buildUpdateButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () {
        _email = _emailController!.text;
        _username = _usernameController!.text;
        _city = _cityController!.text;
        _bio = _bioController!.text;
        profileUpdate(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Güncelle',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }


  void profileUpdate(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);


    if (_username == null || _username!.isEmpty ||_username!.length > 16|| _city == null || _city!.isEmpty || cities.contains(_city) ==false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('kullanıcı adı en fazla en 15 uzunluğa sahip olabilir ve kullanıcı adı ve şehir alanları boş bırakılamaz'),backgroundColor: Colors.red),
      );
      return;
    }
    if (_profilFoto != null) {
      debugPrint(widget.user?.userID);
      _imgUrl = await viewModel.uploadFile(widget.user?.userID, "profil_foto", _profilFoto!);
    }
    UserModel? newUser = UserModel(
      userID: widget.user?.userID,
      email: _email,
      username: _username,
      bio: _bio,
      city: _city,
      imgURL: _imgUrl ?? 'https://firebasestorage.googleapis.com/v0/b/friend-circle-66cb3.appspot.com/o/default_img%2Fprfoile_img.png?alt=media&token=0c78bcf0-90c1-4303-a285-28b1cdd7d8fe',
    );
    UserModel? updatedUser = await viewModel.updateUser(widget.user?.userID, newUser);
    debugPrint(updatedUser.toString());
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(user:updatedUser)),(route) => route.isCurrent);
  }
}
