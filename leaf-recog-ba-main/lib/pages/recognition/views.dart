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
  String name_disease = '';
  String symptoms ='';
  String causal_agent ='';
  String geographical_location ='';
  String descriptions ='';
  String organic ='';
  String chemical ='';
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
    print(res);
    print("OKAYYSFADFAEF");
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
       name_disease = res![0]['label'].toString();
     });
 
      final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"location":geographical_location,"disease":name_disease}));
    final data = json.decode(response.body); 
     if(name_disease == 'Sooty Mood'){
       descriptions = 'Sooty mold is a fungal disease that grows on plants and other surfaces covered by honeydew, a sticky substance created by certain insects. Sooty molds name comes from the dark threadlike growth (mycelium) of the fungi resembling a layer of soot. Sooty mold doesnt infect plants but grows on plant parts and other surfaces where honeydew deposits accumulate.';
       symptoms = 'The fungus colonises both upper and lower surfaces causing black, circular spots, up to 5 mm diameter';
       causal_agent = 'Sooty mold is a black thin mat usually caused by a fungus that grows on the sugary excrement (honeydew) of insects with piercing-sucking mouth parts such as whiteflies, scales, aphids, and mealybugs.';
       organic='Use formulations of neem oil, which is an organic broad spectrum compound, to ward off white flies, aphids, scales, ants and mealy bugs . Neem oil also reduces the growth of the fungal itself. Insecticidal soap or dish soap can be sprayed on affected plants.';
       chemical="Synthetic insecticides of the organophosphate family such as malathion can be used to prevent insects from feeding in the plant.";
          setState(() {
         
       });
     }
     else if(name_disease == 'Phytphthora'){
       descriptions = 'Phytophthora  is a soilborne pathogen that attacks the root systems and affects the entire citrus tree. As the pathogen degrades the tree’s root system, above ground symptoms such as slowed growth, chlorotic foliage and reduced fruit size intensify. Eventually, this may result in the death of the tree.';
       symptoms = 'Phytophthora gummosis causes sap to ooze from small cracks in infected bark until the damaged bark eventually cracks and falls off, while tree leaves yellow and eventually drop. Phytophthora root rot also cause leaves to yellow and fall off. Other symptoms include destroyed feeder roots, nutrient deficiencies and water stress.';
       causal_agent = 'Phytophthora root rot in citrus is caused by the pathogenic fungi P. citrophthora and/or P. nicotianae. Below-ground symptoms are the loss of feeder roots.';
       organic ='Streptomyces griseoviridis (MycoStop) is a bacteria you can use to inoculate the soil. It’s organic approved, and listed as a control for Phytophthora.';
       chemical ='Orondis is effective at very low rates and can be applied as a soil spray, a foliar application treatment or through micro-sprinkler or drip irrigation. However, Orondis should be used for either soil applications or foliar applications, but not both.';
        setState(() {
         
       });
     }
     else if(name_disease == 'Greasy Spot'){
       descriptions = 'Greasy spot spores germinate on the underside of the leaves, penetrate the leaf tissue, and cause cellular swelling resulting in blister formation on the lower leaf surface. Leaf drop may occur even before full leaf symptoms develop. Defoliation decreases fruit production, and makes the tree more susceptible to cold damage and attack by other pests.';
       symptoms = 'Yellow spots first appear on the upper leaf surface, then irregular brown blisters that become dark, slightly raised, and have a greasy appearance develop on lower, and later, upper leaf surfaces.';
       causal_agent = 'The fungus caused by greasy spot is caused by the fungus Mycosphaerella citri.';
       organic ='No biological treatment is available against Mycosphaerella citri.';
       chemical ='The best treatment around is to use one of the copper fungicides out there and spray the tree with it.';
       setState(() {
         
       });
     }
     else if(name_disease == 'Citrus Scab'){
       descriptions = 'It starts as a small pale-orange, somewhat circular, elevated spot on the leaf. A severely infected leaf becomes so distorted, crinkled and stunted that whatever remains has very little semblance to a normal leaf';
       symptoms = 'In citrus scab, corky outgrowths begin on leaves, shoots, and fruit as rounded pustules (Figure 12). Initially, scab lesions on fruit consist of slightly raised pink to light brown pustules. As these pustules develop, they become wart-like, cracked, turn yellowish brown, and eventually dark gray.';
       causal_agent = 'Scab is caused by the fungus Elsinoe fawcettii.';
       organic ='No biological treatment is available against these fungi. Certified organic fungicides based on copper can be used  to prevent new infections and fungal spread.';
       chemical ='Protectant fungicides based thiram, difenoconazole and chlorothalonil can be used preventively to avoid widespread infection.  Systemic fungicides are another options.';
      setState(() {
         
       });
     }
     else if(name_disease == 'Cranker'){
       descriptions = 'Citrus canker,  is a serious disease of most citrus varieties. The disease causes necrotic lesions on leaves, stems, and fruit. Severe infestation can cause defoliation, premature fruit drop, twig dieback, general tree decline, and very bad blemishes on fruit.';
       symptoms = 'The earliest symptoms on leaves appear as slightly-raised, tiny, blister-like lesions. As the lesions age, they turn tan to brown and a wate- soaked margin appears surrounded by a yellow halo';
       causal_agent = 'Citrus canker, caused by a bacterial pathogen';
       organic ='No effective biological control methods are available.';
       chemical ='Unfortunately, there is no effective control on citrus canker once it has been detected. Preventive measures such as the clearing and destruction of fallen tree material are essential to minimize the effect of the disease. The control of citrus psyllids can also be a way to limit the damage.';
       setState(() {
         
       });
     }
     else if(name_disease == 'Greening'){
       descriptions = 'Citrus greening is one of the most destructive diseases of citrus. Infected trees or branches suffer heavy leaf drop followed by out-of-season flushing and flowering, with dieback occurring in severe cases.';
       symptoms = 'The early symptoms usually appear on one sector or branch of the tree. Symptoms are characterized by yellowing of normal-sized leaves along the veins and sometimes by the development of a blotchy-mottle';
       causal_agent = 'Citrus greening is caused by systemic phloem-inhabiting bacterium.';
       organic ='Currently, the most common method for controlling citrus greening is by spraying large amounts of synthetic pesticides such as neonicotinoids.';
       chemical ='To control the canker, spray the trees with fungicide solutions when the trees area at dormant stage. Consult the dealers of fungicides for proper application of the chemicals.';
       setState(() {
         
       });
     }
     else if(name_disease == 'Alternaria Brown Spot'){
       descriptions = 'Alternaria brown spot infection of young shoots and leaves causes dieback and defoliation. Later infection of leaves produces discrete brown spots and/or large blotches surrounded by yellow areas followed by out-of-season flushing and flowering, with dieback occurring in severe cases. Early infection of fruit causes slightly sunken black to dark brown spots with yellow color halos and fruit drop. The sunken areas become corky and fail to produce characteristic round pockmarks in fruit that continue to mature. This fungal disease can cause severe leaf and fruit drop particularly in Minneola (Honeybell) and Orlando tangelos, Dancy tangerine, and Murcott (Honey tangerine). ';
       symptoms = 'Symptom of Alternaria brown spot is the blackening of leaf veins leading from dark lesions.';
       causal_agent = 'The symptoms are caused by the fungus Alternaria alternata.';
       organic ='Currently, the most common method for controlling citrus greening is by spraying large amounts of synthetic pesticides such as neonicotinoids.';
       chemical ='Treatment for Alternaria requires fungicide to be sprayed directly on infected plants. Fungicide based on iprodione,  chlorothalonil and azoxystrobin provide good control of Alternaria brown. Products based on propiconazole and thiophanate methyl have also been proved effective.';
        setState(() {
         
       });
     }
     else{
        descriptions= 'No detected';
        symptoms ='';
        causal_agent='';
        organic ='';
        chemical = '';
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
            name_disease!='' ? Container(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Container(
                    padding:EdgeInsets.all(10),
                    child: Text("Generated Report",style:TextStyle(fontSize:20.0,fontWeight: FontWeight.bold))
                  ),
                  Container(
                    padding:EdgeInsets.all(10),
                    child: Text("Diagnosis: ${name_disease}"),
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
