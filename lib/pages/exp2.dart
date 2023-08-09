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
];

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
  String? _email, _username, _city, _bio,_imgUrl;
  File? _profilFoto;
  var cities = ['adana','adıyaman'];
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
      _imgUrl = user?.imgURL ?? 'https://firebasestorage.googleapis.com/v0/b/friend-circle-66cb3.appspot.com/o/default_img%2Fprfoile_img.png?alt=media&token=0c78bcf0-90c1-4303-a285-28b1cdd7d8fe';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Profile Update'),
        backgroundColor: Colors.deepPurple,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
            ),
          );
        },
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
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Colors.white),
                    title: Text("Take Photo", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      useCamera();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.image, color: Colors.white),
                    title: Text("Choose from Gallery", style: TextStyle(color: Colors.white)),
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
        radius: 96,
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
        color: Colors.deepPurple.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        readOnly: true,
        style: TextStyle(color: Colors.white,fontSize: 20),
        decoration: InputDecoration(
          labelText: 'Email Address',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.email, color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildUsernameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _usernameController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'User Name',
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildCityField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropDownField(
        controller: _cityController,
        labelText: 'Select City',
        icon: Icon(Icons.location_city, color: Colors.white),
        items: cities,
        setter: (dynamic newValue) {
          _cityController!.text = newValue;
        },
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildBioField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _bioController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Bio',
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildUpdateButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(100),
      ),
      child: MaterialButton(
        onPressed: () {
          _email = _emailController!.text;
          _username = _usernameController!.text;
          _city = _cityController!.text;
          _bio = _bioController!.text;
          profileUpdate(context);
        },
        child: Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void profileUpdate(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);


    if (_username == null || _username!.isEmpty || _city == null || _city!.isEmpty || cities.contains(_city) ==false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and City fields cannot be empty')),
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
