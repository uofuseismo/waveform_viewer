import 'dart:math';
import 'dart:typed_data';
import './packet.dart';
import './stream_identifier.dart';

/// Defines a stream (a list of packets with a stream identifier)
class Stream {
  final StreamIdentifier streamIdentifier;
  late List<Packet> packets;
  late int startTimeMuS;
  late int endTimeMuS;

  Stream(this.streamIdentifier, this.packets) {
    _sanitize();
    _findStartAndEndTime();
  }

  void _sanitize() {
    packets = packets.where( (packet) => packet.data.isNotEmpty ).toList();
    packets.sort( (a, b) => a.startTimeMuS.compareTo(b.startTimeMuS) );
  }

  void _findStartAndEndTime() {
    if (packets.isNotEmpty) {
      startTimeMuS = packets[0].startTimeMuS;
      startTimeMuS
        = packets.fold<int> ( 
            startTimeMuS, 
            (minTime, packet) => min(minTime, packet.startTimeMuS) 
          );
      endTimeMuS = packets[0].endTimeMuS;
      endTimeMuS = packets.fold<int> (
            endTimeMuS, 
            (maxTime, packet) => max(maxTime, packet.endTimeMuS) 
          );  
    }
    else {
      startTimeMuS = 0;
      endTimeMuS = 0;
    }
  }
}

Stream createRandomStream() {
  final int timeWindowMicroSeconds = 120*1000000;
  final double samplingRateHz = 100;
  final double dtMicroSeconds = 1000000/samplingRateHz;
  final int nSamples = (timeWindowMicroSeconds/dtMicroSeconds).floor() + 1;

  final currentTime = DateTime.now();
  final endTimeMicroSeconds = currentTime.microsecondsSinceEpoch - 10000000;
  //final endTime = DateTime.fromMicrosecondsSinceEpoch(endTimeMicroSeconds);
  final startTimeMicroSeconds = endTimeMicroSeconds - timeWindowMicroSeconds;
  //final startTime = DateTime.fromMicrosecondsSinceEpoch(startTimeMicroSeconds);

  var packets = <Packet> [];
  var rng = Random();
  var i = 0;
  while (i < nSamples) {
    int nSamples = rng.nextInt(500);
    var samples = Float64List(nSamples);
    var packetStartTime = startTimeMicroSeconds + i*dtMicroSeconds;
    for (var s = 0; s < nSamples; s++) {
      samples[s] = rng.nextDouble()*100 - 200;
      i = i + 1;
    }
    var packet = Packet(packetStartTime.round(), samplingRateHz, samples);
    packets.add(packet);
  }

  final streamIdentifier = StreamIdentifier("UU", "CWU", "HHZ", "01");
  return Stream(streamIdentifier, packets);
}