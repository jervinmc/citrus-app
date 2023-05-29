import 'dart:async';
import 'dart:convert';
import 'package:calamansi_recognition/config/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:get/get_core/src/get_main.dart';
import 'package:tflite/tflite.dart';
import 'package:latlong/latlong.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:geocoding/geocoding.dart';



class AddPantry extends StatefulWidget {
  const AddPantry({Key? key}) : super(key: key);

  @override
  _AddPantryState createState() => _AddPantryState();
}

class _AddPantryState extends State<AddPantry> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
late Position _currentPosition;
late String _currentAddress;

//   void getLoc() async{
//     try{
//   Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   print(position);
// }
// catch(error)
// {
//   print(error);
// //flutter: final position: Lat: 59.xyz, Long: 17.xyz

// }
//   }

  _getCurrentLocation()async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() async {
        _currentPosition = position;
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        final response = await http.post(Uri.parse(BASE_URL_LONGLAT),
              headers: {"Content-Type": "application/json"},
              body: json.encode({"latitude":latitude,"longitude":longitude}));
          final data = json.decode(response.body);
        geographical_location = data;
        setState(() {
          
        });
        // print(_currentPosition.latitude);
      });
      // _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }


  bool _load = false;
  static String BASE_URL = '' + Global.url + '/logs';
static String BASE_URL_LONGLAT = '' + Global.url + '/longlat';
  TextEditingController name = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  String name_types = '';
  String scientific_name ='';
  String leaves ='';
  String geographical_location ='';
  String descriptions ='Citrus greening is one of the most destructive diseases of citrus. Infected trees or branches suffer heavy leaf drop followed by out-of-season flushing and flowering, with dieback occurring in severe cases.';
  String fruit ='';
  String confidence = '';
  double latitude = 0.0;
  double longitude = 0.0;
  bool hasImage = false;
  bool isClicked = false;

 loadMyModel()async{
    var resultant = await Tflite.loadModel(model: 
    "assets/model_unquant.tflite",labels:"assets/labels.txt");
  }
  applyModelOnImage(io.File file)async{
    var res = await Tflite.runModelOnImage(path:file.path,numResults:4,threshold: 0.5,imageMean:127.5,imageStd:127.5);
    setState(()async{
      if(res==[]){
         AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: "No detected objects",
      desc: "",
      btnOkOnPress: () {
   
      },
    )..show();
    return;
      }
     setState(() {
       name_types = res![0]['label'].toString();
       confidence = res![0]['confidence'].toString();
     });
 
    //   final response = await http.post(Uri.parse(BASE_URL),
    //     headers: {"Content-Type": "application/json"},
    //     body: json.encode({"location":geographical_location,"types":name_types}));
    // final data = json.decode(response.body); 
     if(name_types == '0 Calamondin'){
       descriptions = "Also known as kalamansi, calamondin Philippine lime or Philippine lemon, is an economically important citrus hybrid predominantly cultivated in the Philippines";
       scientific_name = 'Citrus Microcarpa';
       leaves = 'The plant is characterized by wing-like appendages on the leaf petioles and white or purplish flowers.';
       fruit='The fruit of the calamondin resembles a small, round lime, usually 25-35mm in diameter, but sometimes up to 45mm';
          setState(() {
         
       });
     }
     else if(name_types == '1 Clementine'){
       descriptions = 'Clementine trees bear delectable fruit during the holiday season, earning them the name “Christmas oranges.” Clementines are a type of mandarin, and their fruit is easy to peel, virtually seedless, juicy, and much less acidic than traditional oranges';
       scientific_name = 'Citrus Clementina';
       leaves = 'Clementine trees have rounded, glossy canopy of dark green leaves that keep their color year-round.';
       fruit ='Virtually seedless, juicy, and much less acidic than traditional oranges';
        setState(() {
         
       });
     }
     else if(name_types == '2 Dalandan'){
       descriptions = 'Also known as sweet orange, is a small, erect tree with smooth, greenish white shoots with spinescent thorns.';
       scientific_name = 'Citrus Aurantium';
       leaves = 'Leaves are oblong to subelliptic, 10 cm long by about 4 cm wide.';
       fruit ='Fruit is nearly spherical, 5 to 9 cm in diameter, and mamillate or not, the skin is orange red and tight; partitioned inside with yellowish juice sacks. Taste is usually sweet, occasionally sour.';
       setState(() {
         
       });
     }
     else if(name_types == '3 Dayap'){
       descriptions = 'Also known as the Key lime or acid lime is a citrus hybrid native to tropical Southeast Asia';
       scientific_name = 'Citrus Aurantifolia';
       leaves = 'Leaves are oblong-ovate to elliptic-ovate, 4 to 6 centimeters long. Petioles are 1 to 1.5 centimeters long, and narrowly winged. Racemes are short and axillary, bearing few flowers which are white and fragrant.';
       fruit ='The Key lime is usually picked while it is still green, but it becomes yellow when ripe.';
      setState(() {
         
       });
     }
     else if(name_types == '4 Lemon'){
       descriptions = ' small tree or spreading bush of the rue family (Rutaceae) and its edible fruit.';
       scientific_name = 'Citrus Limon';
       leaves = 'Lemon leaves are small to medium in size and are ovate, oblong, and taper to a point on the non-stem end. The vibrant green leaves grow alternately along the branches, and they have fine-toothed edges with a slight rippling.';
       fruit ='The lemon fruit is an ellipsoid berry surrounded by a green rind, which ripens to yellow, protecting soft yellow segmented pulp..';
       setState(() {
         
       });
     }
     else if(name_types == '5 Orange'){
       descriptions = 'Is an evergreen tree in the family Rutaceae grown for its edible fruit. The orange tree is branched with a rounded crown and possesses elliptical or oval leaves which are alternately arranged on the branches..';
       scientific_name = 'Citrus Sinensis';
       leaves = 'The leaves have narrowly winged petioles, a feature that distinguishes it from bitter orange, which has broadly winged petioles.';
       fruit ='The fruit is a spherical berry with a green-yellow to orange skin covered in indented glands and a segmented pulpy flesh and several seeds.';
       setState(() {
         
       });
     }
     else if(name_types == '6 Pomelo'){
       descriptions = 'is the largest type of citrus fruit that belongs to the family Rutaceae (citrus family). ';
       scientific_name = 'Citrus Maxima';
       leaves = 'Pomelo tree can grow from 15 to 50 feet in height. It develops large evergreen leaves. They are oblong or elliptic-shaped and have winged petioles.';
       fruit ='Pomelo is best known by its pear-shaped or round fruit. Unripe fruit is green colored. It changes color to yellow as it ripens. Fruit is large, usually 5.9 to 9.8 inches wide and weighs between 2.2 and 4.4 pounds.';
        setState(() {
         
       });
      }
     else if(name_types == '7 Tangerine'){
       descriptions = 'Also known as sinturis/ sintunis or dalanghita, is a small tree is  widely scattered in cultivation in the Philippines. Large scale cultivation are found in Batangas Province. ';
       scientific_name = 'Citrus Nobilis';
       leaves = 'Leaves are smooth, oblong to broadly lanceolate, 4 to 10 centimeters long, with narrowly winged short petioles of about 1 centimeter long.';
       fruit ='Fruits are hesperidums, with a loose skin and leathery pericarp, with a sweet pulp that is only fairly juicy. Green fruit turns to yellow, greenish yellow or orange.';
        setState(() {
         
       });
     }
     else{
        descriptions= 'No detected';
        scientific_name ='';
        leaves='';
        fruit ='';
     }
     
    
    });
    setState(() {
      
    });
  }
  void addToPantry() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
      "name": name.text,
      "quantity": quantity.text,
      "user_id": _id,
    };
    final response = await http.post(Uri.parse(BASE_URL + '/' + '1'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    final data = json.decode(response.body); 
     AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: "Successfull Created !",
      desc: "",
      btnOkOnPress: () {
        Get.toNamed('/home');
      },
    )..show();
  }
  late  io.File selectedImage;
  String url = '';
  void runFilePiker() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.camera);
        print("not okay");

    if (pickedFile != null) {
       selectedImage = io.File(pickedFile.path);
      url = pickedFile.path;
      applyModelOnImage(io.File(pickedFile.path));
      print(url);
      print("okay");
      setState(() {
        
      });
    }
  }
  void uploadImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
        print("not okay");

    if (pickedFile != null) {
       selectedImage = io.File(pickedFile.path);
      url = pickedFile.path;
      applyModelOnImage(io.File(pickedFile.path));
      print(url);
      print("okay");
      setState(() {
        
      });
    }
  }
  @override
 void initState(){
    super.initState();
    // getLoc();
    // _getCurrentLocation();
    loadMyModel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('',style:TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color:  Color(0xff68c3a3),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Get.toNamed('/profile');
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: Text('Pantry'),
            //   onTap: () {
            //     Get.toNamed('/pantry');
            //     // Update the state of the app
            //     // ...
            //     // Then close the drawer
            //     // Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   title: Text('Groceries'),
            //   onTap: () {
            //     Get.toNamed('/groceries');
            //     // Update the state of the app
            //     // ...
            //     // Then close the drawer
            //     // Navigator.pop(context);
            //   },
            // ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
              
                 AwesomeDialog(
                context: context,
                dialogType: DialogType.QUESTION,
                animType: AnimType.BOTTOMSLIDE,
                title: "Are you sure you want to logout?",
                desc: "",
                btnOkOnPress: () {
                  Navigator.pop(context);
                  Get.toNamed('/login');
                },
                btnCancelOnPress: (){

                }
              )..show();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff68c3a3),
      ),
      body:ListView(
        children: [
           Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Image.file(io.File(url)),
            ),
            name_types!='' ? Container(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Container(
                    padding:EdgeInsets.all(10),
                    child: Text("Generated Report",style:TextStyle(fontSize:20.0,fontWeight: FontWeight.bold))
                  ),
                  Container(
                    padding:EdgeInsets.all(10),
                    child: Text("Types of Citrus: ${name_types
                    }"),
                  ),
                  
                  Container(
                    padding:EdgeInsets.all(10),
                    child: Text("Confidence Rate: ${confidence}"),
                  ),
                  Container(
                    padding:EdgeInsets.all(10),
                    child: Text("Description: ${descriptions}"),
                  ),
                ],
              )
            ) : Column(
              children: [
                Text("Hello, Welcome to Citrus Leaf Recognition System!",style:TextStyle(fontSize: 30.0,fontWeight:FontWeight.bold)),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text("To use this application, please upload or capture an image of citrus leaf in order to generate a report and classify what type it is. When capturing an image, make sure your camera is 5-8 inches away from the leaf and have a good lighting. This application can only classify 8 different types commonly in the Philippines, such as Calamondin, Clementine, Dalandan, Dayap, Lemon, Orange, Pomelo, and Tangerine.",style:TextStyle(fontSize: 15.0))
              ],
            ),
                Padding(padding: EdgeInsets.only(top: 20)),
                 new SizedBox(
                width: 350.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    runFilePiker();
                    //  uploadImage();
                  },
                  child: Text('Capture Image'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff68c3a3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                )),
                   Padding(padding: EdgeInsets.only(top: 20)),
                    new SizedBox(
                width: 350.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    uploadImage();
                    //  uploadImage();
                  },
                  child: Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff68c3a3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                )),
                //  new SizedBox(
                // width: 350.0,
                // height: 50.0,
                // child: ElevatedButton(
                //   onPressed: () {
                //     _getCurrentLocation();
                //     //  uploadImage();
                //   },
                //   child: Text('location'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Color(0xffc6782b),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12), // <-- Radius
                //     ),
                //   ),
                // )),
            _load
                ? Container(
                    color: Colors.white10,
                    width: 70.0,
                    height: 70.0,
                    child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Center(
                            child: const CircularProgressIndicator())),
                  )
                : Text(''),
          ],
        ),
      ),
        ],
      )
    );
  }
}
