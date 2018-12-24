# hasgo_flutter

[![Build Status](https://travis-ci.com/capella-sun/hasgo_flutter.svg?branch=master)](https://travis-ci.com/capella-sun/hasgo_flutter)

Flutter implementation of Hide and Seek Go

## Getting Started

Make sure Flutter is configured according to the [online documentation](https://flutter.io/docs) (See the `Getting Started` section if you're new to Flutter!).

## Tips

### Json De/Serialization

To generate `*.g.dart` files, run `flutter packages pub run build_runner build` as mentioned [here](https://github.com/dart-lang/json_serializable/tree/master/example).

Be sure to leave in the `part '*.g.dart'` and any `toJson` and `fromJson` declarations in the file. They will be fixed.