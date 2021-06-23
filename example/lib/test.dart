void main() {

  Uri uri = Uri.parse('meijianclient://meijian.io/name/file?url=discover');
  print(uri.path);
  print(uri.queryParameters['url']);
  print('----');
  Pattern pattern = 'discover/game';

  print(pattern.matchAsPrefix('discover')?.group(0));
}