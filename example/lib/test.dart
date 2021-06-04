void main() {

  Uri uri = Uri.parse('meijianclient://meijian.io/name?url=discover');
  print(uri.path);
  print(uri.queryParameters);
  print('----');
  Pattern pattern = 'discover/game';

  print(pattern.matchAsPrefix('discover')?.group(0));
}