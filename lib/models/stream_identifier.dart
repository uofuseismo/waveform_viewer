/// Capitalizes and removes all spaces from a string.
String capitalizeAndRemoveBlanks(String input) {
  return input.toUpperCase().replaceAll(' ', '');
}

/// Defines a stream's name.
class StreamIdentifier {
  late String network;      /// The network code - e.g., UU
  late String station;      /// The station code - e.g., CTU
  late String channel;      /// The channel code - e.g., HHZ
  late String locationCode; /// The location code - e.g., 01
  StreamIdentifier(String network, String station, String channel, String locationCode) {
    this.network = capitalizeAndRemoveBlanks(network);
    this.station = capitalizeAndRemoveBlanks(station);
    this.channel = capitalizeAndRemoveBlanks(channel);
    this.locationCode = capitalizeAndRemoveBlanks(locationCode);
  }
  @override
  String toString() {
    //final suffix = locationCode.isNotEmpty ? '.$locationCode' : '';
    return '$network.$station.$channel${locationCode.isNotEmpty ? ".$locationCode" : ".--"}';
  }
}