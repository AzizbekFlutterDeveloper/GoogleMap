import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  LatLng position = const LatLng(0.0, 0.0);
  Uint8List? customMarker;

  @override
  void initState() {
    super.initState();
    getBytestFromAssets(path: "assets/images/marker.png",width: 100).then((value) {
      setState(() {
        customMarker = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(markerId: MarkerId('1'), position: position,icon: BitmapDescriptor.fromBytes(customMarker!)),
        },
        onTap: (value) {
          setState(() {
            position = value;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _goToTheLake();
        },
        child: Icon(Icons.location_city),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    Future<void> _goToTheLake() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 192.8334901395799,
            target: position,
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
          ),
        ),
      );
    }
  }

  Future<Uint8List> getBytestFromAssets({String? path, int? width}) async{
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(
   data.buffer.asUint8List(), 
   targetWidth: width
 );
ui.FrameInfo fi = await codec.getNextFrame();
return (await fi.image.toByteData(
   format: ui.ImageByteFormat.png))!
 .buffer.asUint8List();
  }
}
