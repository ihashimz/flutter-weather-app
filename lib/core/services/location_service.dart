import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../errors/failures.dart';

abstract class LocationService {
  Future<Either<Failure, Position>> getCurrentLocation();
  Future<Either<Failure, bool>> requestLocationPermission();
  Future<bool> isLocationPermissionGranted();
  Future<bool> shouldShowPermissionRequest();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final hasPermission = await isLocationPermissionGranted();
      if (!hasPermission) {
        return const Left(
            LocationFailure(message: 'Location permission not granted'));
      }

      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        return const Left(
            LocationFailure(message: 'Location services are disabled'));
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return Right(position);
    } catch (e) {
      return Left(
          LocationFailure(message: 'Failed to get location: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return Right(status == PermissionStatus.granted);
    } catch (e) {
      return Left(LocationFailure(
          message: 'Failed to request permission: ${e.toString()}'));
    }
  }

  @override
  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  @override
  Future<bool> shouldShowPermissionRequest() async {
    final status = await Permission.location.status;
    // Show bottom sheet only if permission is denied or not yet requested
    // Don't show if permanently denied (user needs to go to settings)
    return status == PermissionStatus.denied ||
        status == PermissionStatus.restricted;
  }
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message});
}
