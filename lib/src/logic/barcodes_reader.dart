part of 'zxing.dart';

/// Reads barcodes from String image path
Future<List<Code>> zxingReadBarcodesImagePathString(
  String path, {
  Params? params,
}) =>
    zxingReadBarcodesImagePath(
      XFile(path),
      params: params,
    );

/// Reads barcodes from XFile image path
Future<List<Code>> zxingReadBarcodesImagePath(
  XFile path, {
  Params? params,
}) async {
  final Uint8List imageBytes = await path.readAsBytes();
  final imglib.Image? image = imglib.decodeImage(imageBytes);
  if (image == null) {
    return <Code>[];
  }
  return zxingReadBarcodes(
    image.getBytes(format: imglib.Format.luminance),
    width: image.width,
    height: image.height,
    params: params,
  );
}

/// Reads barcodes from image url
Future<List<Code>> zxingReadBarcodesImageUrl(
  String url, {
  Params? params,
}) async {
  final Uint8List imageBytes =
      (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
  final imglib.Image? image = imglib.decodeImage(imageBytes);
  if (image == null) {
    return <Code>[];
  }
  return zxingReadBarcodes(
    image.getBytes(format: imglib.Format.luminance),
    width: image.width,
    height: image.height,
    params: params,
  );
}

/// Reads barcodes from Uint8List image bytes
List<Code> zxingReadBarcodes(
  Uint8List bytes, {
  required int width,
  required int height,
  Params? params,
}) {
  final CodeResults result = bindings.readBarcodes(
    bytes.allocatePointer(),
    params?.format ?? Format.any,
    width,
    height,
    params?.cropWidth ?? 0,
    params?.cropHeight ?? 0,
    params?.tryHarder ?? false ? 1 : 0,
    params?.tryRotate ?? true ? 1 : 0,
  );
  final List<Code> results = <Code>[];
  for (int i = 0; i < result.count; i++) {
    results.add(result.results.elementAt(i).ref.toCode());
  }
  return results;
}
