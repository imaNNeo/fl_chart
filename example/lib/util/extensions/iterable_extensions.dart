extension IterableToMapExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> get asMap => Map.fromEntries(this);
}
