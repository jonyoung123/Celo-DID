String addCeloPrefix(String identifier) {
  String prefix = 'did:celo:';
  String did = prefix + identifier.trim().toLowerCase();
  return did;
}
