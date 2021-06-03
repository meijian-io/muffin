void main() {

  Uri uri = Uri.parse('/');
  print(uri.toString());
  print(uri.path);
  print(uri.toString() == '/');


  Pattern pattern = '/home';

  print(pattern.toString());
}