import 'package:flutter/material.dart';
import 'package:instagram/shop.dart';
import 'package:instagram/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2())
        ],
        child: MaterialApp(
          theme: theme,
          home: MyApp(),
        ),
      ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent = '';

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'j');
    storage.get('name');
  }

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0, myData);
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http.get(
        Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    data = result2;
  }

  @override
  void initState() {
    super.initState();
    saveData();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              Navigator.push(context,
                  MaterialPageRoute(builder: (c) =>
                      Upload(
                        userImage: userImage, setUserContent: setUserContent,
                        addMyData: addMyData,)
                  ));
            },
          )
        ],
      ),

      body: [bodyUI(data: data, addData: addData), Shop()][tab],

      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i) {
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: 'shop')
          ]),
    );
  }
}


class bodyUI extends StatefulWidget {
  const bodyUI({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<bodyUI> createState() => _bodyUIState();
}

class _bodyUIState extends State<bodyUI> {

  var scroll = ScrollController();

  getMoreData() async {
    var result = await http.get(
        Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('좋아요 ${widget.data[i]['likes']}'),
                      GestureDetector(
                        child: Text(widget.data[i]['user']),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => Profile())
                          );
                        },
                      ),
                      Text(widget.data[i]['content'])
                    ],
                  ),
                )
              ],
            );
          });
    } //if문 끝
    else {
      return Text('loading');
    }
  }
}


class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData})
      : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            addMyData();
            Navigator.pop(context);
          }, icon: Icon(Icons.send))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage, fit: BoxFit.contain, height: MediaQuery
              .of(context)
              .size
              .height - 400,),
          TextField(onChanged: (text) {
            setUserContent(text);
          },),
          IconButton(onPressed: () {
            Navigator.pop(context);
          },
              icon: Icon(Icons.close)),
        ],
      ),
    );
  }
}

class Store2 extends ChangeNotifier {
  var profileImage = [];

  getData() async {
    var result = await http.get(Uri.parse(
        'https://dart-lang.github.io/linter/lints/unnecessary_getters_setters.html'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

}


class Store1 extends ChangeNotifier {
  var name = 'Hi_doweon';
  var follower = 0;
  var friend = false;


  addFollower() {
    if (friend == false) {
      follower++;
      friend = true;
    }
    else {
      follower--;
      friend = false;
    }
    notifyListeners();
  }


}


class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(context.watch<Store1>().name),),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProfileHeader(),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (c, i) => Image.network(context.watch<Store2>().profileImage[i]),
                      childCount: context.watch<Store2>().profileImage.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            )
          ],
        ),
    );
  }
}







class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(radius: 30,
                    backgroundImage: ExactAssetImage('assets/images/girl.jpg')),
                Text('팔로워 ${context
                    .watch<Store1>()
                    .follower}명'),
                ElevatedButton(onPressed: () {
                  context.read<Store1>().addFollower();
                  }, child: Text('팔로우')),
                ElevatedButton(onPressed: () {
                  context.read<Store2>().getData();
                  }, child: Text('getPic'))
              ],),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doweon Hwang'),
              Text('Content Markerting Manager at vismeapp and Freelance Marketing Writer'),
              Text('Seoul, YeonNam'),
              Text('dorystagram.com')
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                  context.read<Store1>().addFollower();
                  }, child: Text('팔로우'),),
                ElevatedButton(
                    onPressed: () {
                  context.read<Store2>().getData();
                  }, child: Text('getPic'))
              ],
            ),
          ),
        ],
    );
  }
}


