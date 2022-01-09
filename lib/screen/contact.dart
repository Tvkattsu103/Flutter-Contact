// ignore_for_file: prefer_const_constructors

import 'package:contact_database/screen/add_contact.dart';
import 'package:contact_database/screen/edit_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Query _ref;
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('Contacts');
  bool searchState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('Contacts')
        .orderByChild('name');
  }

  Widget _buildContactItem({Map contact}) {
    Color typeColor = getTypeColor(contact['type']);
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
      padding: EdgeInsets.all(10),
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      // color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.black.withOpacity(0.8),
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['name'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                color: Colors.black.withOpacity(0.8),
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['number'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.group_work,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['type'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditContact(
                                contactKey: contact['key'],
                              )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Sửa',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(contact: contact);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Xóa',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  _showDeleteDialog({Map contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Xóa ${contact['name']}'),
            content: Text('Bạn muốn xóa danh bạ này?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Hủy')),
              FlatButton(
                  onPressed: () {
                    reference
                        .child(contact['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Xóa'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.9),
        centerTitle: true,
        title: !searchState
            ? Text('DANH BẠ')
            : TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.8).withOpacity(0.3),
                        width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.8).withOpacity(0.3),
                        width: 2.0),
                  ),
                  icon: Icon(
                    Icons.search,
                  ),
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) => SearchMethod(value),
              ),
        actions: <Widget>[
          !searchState
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                  icon: Icon(Icons.search))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                  icon: Icon(Icons.cancel))
        ],
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            contact['key'] = snapshot.key;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddContact();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue.withOpacity(0.9),
      ),
    );
  }

  Color getTypeColor(String type) {
    Color color = Colors.black.withOpacity(0.8);

    if (type == 'Công việc') {
      color = Colors.black.withOpacity(0.8);
    }

    if (type == 'Gia đình') {
      color = Colors.black.withOpacity(0.8);
    }

    if (type == 'Bạn bè') {
      color = Colors.black.withOpacity(0.8);
    }
    return color;
  }

  SearchMethod(String value) {
    _ref = FirebaseDatabase.instance
        .reference()
        .child('Contacts')
        .orderByChild('name')
        .startAt(value);
  }
}
