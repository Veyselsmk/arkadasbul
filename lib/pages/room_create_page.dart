import 'package:flutter/material.dart';

import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_detail_page.dart';
import 'package:friend_circle/pages/room_information_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RoomCreatePage extends StatefulWidget {
  final UserModel? user;

  const RoomCreatePage({Key? key, this.user}) : super(key: key);

  @override
  State<RoomCreatePage> createState() => _RoomCreatePageState();
}

class _RoomCreatePageState extends State<RoomCreatePage> {
  RoomModel? newRoom;
  final TextEditingController descController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  static const List<String> categories = ['Halı Saha', 'Gezi', 'Seminer', 'Sinema'];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    descController.dispose();
    roomNameController.dispose();
    categoryController.dispose();
    capacityController.dispose();
    dateController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Oda Kur',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  buildTextFieldWithIcon(
                    controller: roomNameController,
                    labelText: 'Oda İsmi',
                    icon: Icons.meeting_room,
                  ),
                  SizedBox(height: 20),
                  buildTextFieldWithIcon(
                    controller: descController,
                    labelText: 'Açıklama',
                    icon: Icons.description,
                  ),
                  SizedBox(height: 20),
                  buildCategoryDropdown(),
                  SizedBox(height: 20),
                  buildTextFieldWithIcon(
                    controller: capacityController,
                    labelText: 'Kapasite',
                    icon: Icons.person,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  buildDateTextField(),
                  SizedBox(height: 20),
                  buildTextFieldWithIcon(
                    controller: locationController,
                    labelText: 'Yer',
                    icon: Icons.location_on,
                  ),
                  SizedBox(height: 20),
                  buildCreateRoomButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      maxLines: labelText == 'Açıklama' ? 3 : 1,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Container buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration.collapsed(hintText: 'Kategori'),
        value: categoryController.text.isNotEmpty ? categoryController.text : null,
        items: categories.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            categoryController.text = newValue!;
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 30,
      ),
    );
  }

  TextFormField buildDateTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      readOnly: true,
      controller: dateController,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: 'Tarih',
        border: OutlineInputBorder(),
      ),
      onTap: () => pickDateTime(context),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş Bırakılamaz';
        }
        final selectedDateTime = DateFormat.yMd().add_jm().parse(value, true).toLocal();
        if (selectedDateTime.isBefore(DateTime.now())) {
          return 'Geçmiş Bir Tarih Seçilemez';
        }
        return null;
      },
    );
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (selectedDateTime.isBefore(DateTime.now())) {
          showSnackBar('Geçmiş Bir Tarih Seçilemez');
          return;
        }

        final formattedDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(selectedDateTime);
        setState(() {
          dateController.text = formattedDateTime;
        });
      } else {
        print('No time selected');
      }
    } else {
      print('No date selected');
    }
  }


  Container buildCreateRoomButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (validateFields()) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => navigateFuturebuilder()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          'Oda Kur',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    if (roomNameController.text.isEmpty ||
        descController.text.isEmpty ||
        categoryController.text.isEmpty ||
        capacityController.text.isEmpty ||
        dateController.text.isEmpty ||
        locationController.text.isEmpty) {
      showSnackBar('Lütfen Tüm Alanları Doldurun');
      return false;
    }
    if (int.tryParse(capacityController.text) == null) {
      showSnackBar('Geçerli bir sayı giriniz');
      return false;
    }
    final selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (dateController.text.compareTo(selectedDate) < 0) {
      showSnackBar('Geçmiş bir tarih seçemezsiniz');
      return false;
    }
    return true;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<RoomModel?> createRoom(BuildContext context) async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);
    var ownerID = widget.user!.userID!;
    RoomModel room = RoomModel(
      desc: descController.text,
      roomName: roomNameController.text,
      date: dateController.text,
      category: categoryController.text,
      capacity: capacityController.text,
      location: locationController.text,
    );
    return await viewModel.createRoom(ownerID, room);
  }

  FutureBuilder navigateFuturebuilder() {
    return FutureBuilder<RoomModel?>(
      future: createRoom(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return RoomDetailPage(user: widget.user, room: snapshot.data);
        } else {
          return Scaffold(
            body: Center(child: Text('Oda oluşturma sırasında bir hata oluştu. Tekrar deneyiniz')),
          );
        }
      },
    );
  }
}
