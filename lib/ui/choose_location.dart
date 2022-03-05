
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab3_mis/model/laboratory.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/service/laboratories_service.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({Key? key, required this.studentExam, required this.laboratoryName}) : super(key: key);

  final StudentExam studentExam;
  final String laboratoryName;
  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final LaboratoriesService _laboratoriesService = LaboratoriesService();

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.6086, 21.7453),
    zoom: 7.5,
  );

  late GoogleMapController _googleMapController;
  Marker _origin = Marker(markerId: const MarkerId('null'));

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
                'Select Your Laboratory Location'),
            elevation: 0,
          ),
          body: Stack(
            children: [
              GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: {
                  if (_origin != null && _origin.markerId != 'null') _origin
                },
                onLongPress: _addMarker,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: const Color(0xff14279B)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Long press on your location to add",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6)
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: EdgeInsets.all(10))
            ],
          ),
          bottomNavigationBar: ElevatedButton(
              onPressed: () {
                this._laboratoriesService
                    .addLaboratory(this.widget.laboratoryName, _origin.position, this.widget.studentExam)
                    .then((value) =>
                {
                  Navigator.pushNamed(context, "/home")
                });
              },
              child: Text("Add location")
          )

      );
    }

  void _addMarker(LatLng pos) {
    if (_origin != null) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Your location'),
          icon: BitmapDescriptor.defaultMarker,
          position: pos,
          onTap: () =>
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(
                    target: _origin.position, zoom: 15.5, tilt: 50.0)),
              ),
        );
      });
    }
  }
}