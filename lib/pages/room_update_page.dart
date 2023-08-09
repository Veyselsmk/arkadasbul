import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:friend_circle/models/room_model.dart';
import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/pages/room_detail_page.dart';
import 'package:friend_circle/view_model/view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RoomUpdatePage extends StatefulWidget {
  final RoomModel? room;
  final UserModel? user;

  const RoomUpdatePage({Key? key, this.room, this.user}) : super(key: key);

  @override
  State<RoomUpdatePage> createState() => _RoomUpdatePageState();
}

class _RoomUpdatePageState extends State<RoomUpdatePage> {
  late TextEditingController descController;
  late TextEditingController roomNameController;
  late TextEditingController categoryController;
  late TextEditingController capacityController;
  late TextEditingController dateController;
  late TextEditingController locationController;
  late bool active;

  static const List<String> categories = ['Halı Saha', 'Gezi', 'Seminer', 'Sinema'];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    descController = TextEditingController(text: widget.room?.desc);
    roomNameController = TextEditingController(text: widget.room?.roomName);
    categoryController = TextEditingController(text: widget.room?.category);
    capacityController = TextEditingController(text: widget.room?.capacity);
    dateController = TextEditingController(text: widget.room?.date);
    locationController = TextEditingController(text: widget.room?.location);
    active = widget.room!.active!;
  }

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
                    'Odayı Güncelle',
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
                  buildActiveSwitch(),
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
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  DropdownButtonFormField<String> buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: categoryController.text,
      items: categories.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Kategori',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      onChanged: (String? value) {
        setState(() {
          categoryController.text = value!;
        });
      },
    );
  }

  TextFormField buildDateTextField() {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: pickDateTime,
      decoration: InputDecoration(
        labelText: 'Tarih',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          dateController.text = DateFormat.yMd().add_jm().format(pickedDateTime);
        });
      }
    }
  }

  Row buildActiveSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Aktif'),
        Switch(
          value: active,
          onChanged: (bool value) {
            setState(() {
              active = value;
            });
          },
        ),
      ],
    );
  }

  ElevatedButton buildCreateRoomButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => navigateFuturebuilder()),
        );
      },
      child: Text('Odayı Güncelle'),
    );
  }

  void validateFields() {
    if (roomNameController.text.isEmpty ||
        descController.text.isEmpty ||
        categoryController.text.isEmpty ||
        capacityController.text.isEmpty ||
        dateController.text.isEmpty ||
        locationController.text.isEmpty) {
      showSnackBar(context, 'Lütfen Tüm alanları Doldurunuz');
    } else {
      updateRoom();
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FutureBuilder navigateFuturebuilder() {
    return FutureBuilder(
      future: updateRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return RoomDetailPage(user: widget.user, room: snapshot.data);
        } else {
          return Scaffold(
            body: Center(child: Text('Oda Güncellemede Bir Sorun Yaşandı. Lütfen Tekrar Deneyiniz')),
          );
        }
      },
    );
  }

  Future updateRoom() async {
    final viewModel = Provider.of<ViewModel>(context, listen: false);

    widget.room!.roomName = roomNameController.text;
    widget.room!.desc = descController.text;
    widget.room!.category = categoryController.text;
    widget.room!.capacity = capacityController.text;
    widget.room!.date = dateController.text;
    widget.room!.location = locationController.text;
    widget.room!.active = active;

    return await viewModel.updateRoom(widget.room!.roomID, widget.room);
  }
}
