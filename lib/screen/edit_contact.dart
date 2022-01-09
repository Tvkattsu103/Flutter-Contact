// ignore_for_file: prefer_const_constructors

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditContact extends StatefulWidget {
  String contactKey;

  EditContact({this.contactKey});

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  TextEditingController _nameController, _numberController;
  String _typeSelected = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Contacts');
    getContactDetail();
  }

  Widget _buildContactType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title ? Colors.green : Colors.black45,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.9),
        centerTitle: true,
        title: Text('Cập nhật danh bạ'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                maxLength: 50,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Bạn chưa nhập tên danh bạ';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Nhập tên danh bạ',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _numberController,
                maxLength: 10,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Bạn chưa nhập số điện thoại';
                  }
                  if (!value.startsWith('0')) {
                    return 'Số điện thoại phải bắt đầu bằng chữ số 0';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại',
                  prefixIcon: Icon(
                    Icons.phone_iphone,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildContactType('Công việc'),
                    SizedBox(width: 10),
                    _buildContactType('Gia đình'),
                    SizedBox(width: 10),
                    _buildContactType('Bạn bè'),
                    SizedBox(width: 10),
                    _buildContactType('Khác'),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();

                    saveContact();
                  },
                  color: Colors.blue.withOpacity(0.9),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getContactDetail() async {
    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();

    Map contact = snapshot.value;

    _nameController.text = contact['name'];

    _numberController.text = contact['number'];

    setState(() {
      _typeSelected = contact['type'];
    });
  }

  void saveContact() {
    String name = _nameController.text;
    String number = _numberController.text;

    Map<String, String> contact = {
      'name': name,
      'number': number,
      'type': _typeSelected,
    };

    _ref.child(widget.contactKey).update(contact).then((value) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: "Đã cập nhật danh bạ",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.red,
      )..show(context).then((r) => Navigator.pop(context));
    });
  }
}
