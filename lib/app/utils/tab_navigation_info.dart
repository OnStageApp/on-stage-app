class NavigationInfo {
  final Set<int> unsafeIndices;
  final Future<void> Function()? onConfirm;
  final String? modalTitle;
  final String? modalDescription;

  const NavigationInfo({
    required this.unsafeIndices,
    this.onConfirm,
    this.modalTitle,
    this.modalDescription,
  });
}
