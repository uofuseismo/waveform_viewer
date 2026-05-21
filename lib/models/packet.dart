import 'dart:math';
import 'dart:typed_data';

/// Defines a data packet.
class Packet {
  final int startTimeMuS;      /// Time of first sample (UTC seconds microseconds since epoch)
  final double samplingRateHz; /// The sampling rate in Hz.
  final Float64List data;  /// The time series data.
  late int endTimeMuS;      /// The end time of the packet.
  late double minimumValue; /// The minimum value of the dataset.
  late double maximumValue; /// The maximum value of the dataset.
  late int samplingPeriodInMicroSeconds; /// Sampling period in microseconds
  Packet(this.startTimeMuS, this.samplingRateHz, this.data) {
    if (samplingRateHz <= 0) {
      throw 'Sampling rate $samplingRateHz must be positive';
    }
    var dtMuS = 1000000 / samplingRateHz;
    samplingPeriodInMicroSeconds = dtMuS.round();
    if (data.isNotEmpty) {
      endTimeMuS = startTimeMuS + samplingPeriodInMicroSeconds * (data.length - 1);
      minimumValue = data.reduce(min);
      maximumValue = data.reduce(max);
      /// absoluteMinimumValue = data.reduce( (absMin, value) => min( absMin, value.abs() ))
      /// absoluteMaximumValue = data.reduce( (absMax, value) => max( absMax, value.abs() ))
      /*
      minimumValue = data[0];
      maximumValue = data[0];
      for (double value in data) {
        minimumValue = min(minimumValue, value);
        maximumValue = max(maximumValue, value);
      }
      */
    }
    else {
      endTimeMuS = startTimeMuS;
      minimumValue = 0;
      maximumValue = 0;
    }
  }

  /// True indicates this has data. 
  bool isNotEmpty() {
    return data.isNotEmpty;
  }
}

/// Utility to decimate for plotting.  In this case, we are drawing
/// vertical lines between the min and max value in a chunk.
Float64x2List decimateForPlotting(int factor, Float64List data) {
    // Doesn't make sense
  if (factor < 1) {
    throw 'Plot decimation factor $factor must be positive';
  }
  int nSamples = data.length;
  if (nSamples == 0) {
    return Float64x2List(0); 
  }
  // This is super wonky - why are you doing this?
  if (nSamples < factor) {
    double dMin = data.reduce(min);
    double dMax = data.reduce(max);
    return Float64x2List.fromList( [Float64x2(dMin, dMax)] );
  }
  // Okay, we now have at least one block.  Let's estimate the output space.
  int nBlocks = (nSamples/factor).floor();
  // The one edge case is when we go over 1 sample.  Then min/max collapses
  // to a point.  Otherwise, if there are more than 1 extra elements we can
  // squeeze in a vertical line.
  int remainder = nSamples%factor;
  if (remainder != 0 && nSamples - factor*nBlocks > 1) {
    nBlocks = nBlocks + 1;
  }

  var decimatedData = Float64x2List(nBlocks);
  for (var block = 0; block < nBlocks; block++) {
    int startSample = block*factor;
    int endSample = startSample + factor;
    if (block == nBlocks - 1){endSample = nSamples;}
    double dMin = data[startSample];
    double dMax = dMin;
    for (int s = startSample + 1; s < endSample; s++) {
      double sample = data[s];
      dMin = min(sample, dMin);
      dMax = max(sample, dMax);
    }
    decimatedData[block] = Float64x2(dMin, dMax);
  }
  return decimatedData;
}