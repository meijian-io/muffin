typedef Mock = dynamic Function(String key, dynamic value);

class MockConfig {
  final String key;
  final Mock mock;

  MockConfig(this.key, this.mock);
}
