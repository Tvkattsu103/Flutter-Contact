// ignore_for_file: prefer_const_constructors
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _nameController;
  TextEditingController _numberController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _typeSelected = '';

  DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Contacts');
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
        title: Text('Thêm danh bạ'),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: RaisedButton(
                  child: Text(
                    'Thêm',
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

  void saveContact() {
    String name = _nameController.text;
    String number = _numberController.text;

    Map<String, String> contact = {
      'name': name,
      'number': number,
      'type': _typeSelected,
    };

    _ref.push().set(contact).then((value) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: "Đã thêm danh bạ mới",
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
