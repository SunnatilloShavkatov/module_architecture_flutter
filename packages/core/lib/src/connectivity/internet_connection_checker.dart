part of 'network_info.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared constants
// ─────────────────────────────────────────────────────────────────────────────

/// Default TCP port used for connectivity probes.
/// Port 443 (HTTPS) is chosen because it is the least-filtered port in
/// real-world networks (corporate firewalls, carrier NAT).
/// Defined at top level so [AddressCheckOptions] can reference it before
/// [InternetConnectionChecker] is declared.
const int _kDefaultPort = 443;

/// Default per-probe socket timeout.
/// 3 s is generous enough for slow connections; because probes run in
/// parallel the effective worst-case latency is still just 3 s, not 3 × n.
const Duration _kDefaultTimeout = Duration(seconds: 3);

// ─────────────────────────────────────────────────────────────────────────────
// AddressCheckResult
// ─────────────────────────────────────────────────────────────────────────────

/// Immutable result of a single host-reachability probe.
@immutable
class AddressCheckResult {
  const AddressCheckResult(this.options, {required this.isSuccess});

  final AddressCheckOptions options;
  final bool isSuccess;

  @override
  String toString() => 'AddressCheckResult($options, isSuccess: $isSuccess)';

  @override
  int get hashCode => Object.hash(options, isSuccess);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AddressCheckResult && other.options == options && other.isSuccess == isSuccess;
}

// ─────────────────────────────────────────────────────────────────────────────
// AddressCheckOptions
// ─────────────────────────────────────────────────────────────────────────────

/// Configuration for a single host-reachability probe.
/// Either [address] (an [InternetAddress]) or [hostname] (a DNS name) must be
/// provided — not both, not neither.
@immutable
class AddressCheckOptions {
  const AddressCheckOptions({this.address, this.hostname, this.port = _kDefaultPort, this.timeout = _kDefaultTimeout})
    : assert(
        (address != null || hostname != null) && ((address != null) != (hostname != null)),
        'Provide either address or hostname — not both, not neither.',
      );

  final InternetAddress? address;
  final String? hostname;
  final int port;
  final Duration timeout;

  @override
  String toString() => 'AddressCheckOptions(${address ?? hostname}, port: $port, timeout: $timeout)';

  @override
  int get hashCode => Object.hash(address, hostname, port, timeout);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressCheckOptions &&
          other.address == address &&
          other.hostname == hostname &&
          other.port == port &&
          other.timeout == timeout;
}

// ─────────────────────────────────────────────────────────────────────────────
// InternetConnectionStatus
// ─────────────────────────────────────────────────────────────────────────────

enum InternetConnectionStatus { connected, disconnected }

// ─────────────────────────────────────────────────────────────────────────────
// InternetConnectionChecker
// ─────────────────────────────────────────────────────────────────────────────

/// Checks internet connectivity by opening short-lived TCP sockets to
/// well-known public HTTPS endpoints.
///
/// ### Reliability level: "route exists + DNS resolves"
/// A TCP connect to a hostname requires a successful DNS resolution first,
/// which rules out most offline and captive-portal scenarios. It does NOT
/// guarantee that the remote service returns a valid HTTP response (for that,
/// use an HTTP 204 check). This level is sufficient for typical mobile-app
/// "online / offline" indicators.
///
/// ### Captive portal note
/// Some advanced portals also intercept DNS and return portal IPs for every
/// hostname. In those cases this checker may return `true` even though full
/// internet is not accessible. If your app needs to distinguish "portal" from
/// "real internet", add an HTTP-level probe on top of this class.
///
/// ### Parallel probes — "first success wins"
/// All addresses are probed concurrently (no `await` inside the loop).
/// A [Completer] resolves as soon as the first socket succeeds. Remaining
/// sockets complete naturally inside [isHostReachable] and are destroyed
/// immediately — no leaks, no dangling handles.
///
/// ### Lightweight result cache
/// Repeated calls within [checkInterval] return the cached value without
/// opening any sockets, avoiding unnecessary radio wake-ups on mobile devices.
///
/// ### No third-party dependencies — pure `dart:io` + `dart:async`.
class InternetConnectionChecker {
  // ── Constructors ──────────────────────────────────────────────────────────

  factory InternetConnectionChecker() => _instance;

  /// Creates a custom instance.
  ///
  /// [checkTimeout] — per-probe socket timeout; applied to every entry in
  /// [defaultAddresses] when [addresses] is not provided explicitly.
  ///
  /// [checkInterval] — how long a result is cached before re-probing.
  /// Acts as a cooldown: rapid successive calls within this window return the
  /// cached value without opening any sockets.
  ///
  /// [addresses] — custom probe list; if omitted [defaultAddresses] is used
  /// and each entry's timeout is overridden with [checkTimeout].
  InternetConnectionChecker.createInstance({
    this.checkTimeout = defaultTimeout,
    this.checkInterval = defaultInterval,
    List<AddressCheckOptions>? addresses,
  }) {
    this.addresses =
        addresses ??
        defaultAddresses
            .map(
              (e) => AddressCheckOptions(address: e.address, hostname: e.hostname, port: e.port, timeout: checkTimeout),
            )
            .toList();
  }

  // ── Constants ─────────────────────────────────────────────────────────────

  /// Default TCP port — 443 (HTTPS/TLS).
  /// Preferred over 53 (DNS/TCP) because corporate firewalls and carrier NAT
  /// almost never block 443.
  static const int defaultPort = _kDefaultPort;

  /// Default per-probe socket timeout (3 s).
  /// Because probes run in parallel the worst-case latency equals this value,
  /// not this value × number of probes.
  static const Duration defaultTimeout = _kDefaultTimeout;

  /// Default cache / re-probe interval (3 s).
  /// Repeated [hasConnection] calls within this window return the cached
  /// result without opening sockets — protects battery on mobile.
  static const Duration defaultInterval = Duration(seconds: 3);

  /// Two hostname-based probes — Cloudflare and Google.
  ///
  /// ### Why hostnames instead of raw IPs?
  /// Raw-IP TCP connects succeed even behind captive portals (the portal
  /// completes the TCP handshake itself). Hostnames require a real DNS
  /// resolution first — a much stronger "route exists" signal.
  ///
  /// ### IP stack coverage
  /// The OS resolves each hostname to an IPv4 **or** IPv6 address based on
  /// the device's active network stack. This is not guaranteed to cover both
  /// stacks simultaneously; it reflects whichever stack is active. If explicit
  /// dual-stack probing is required, provide a custom [addresses] list with
  /// separate [AddressCheckOptions] entries per IP family.
  ///
  /// | Hostname        | Provider   | May resolve to                         |
  /// |:----------------|:-----------|:---------------------------------------|
  /// | one.one.one.one | Cloudflare | 1.1.1.1 (IPv4) / 2606:4700:4700::1111 (IPv6) |
  /// | dns.google      | Google     | 8.8.4.4 (IPv4) / 2001:4860:4860::8888 (IPv6) |
  static const List<AddressCheckOptions> defaultAddresses = [
    AddressCheckOptions(hostname: 'one.one.one.one'),
    AddressCheckOptions(hostname: 'dns.google'),
  ];

  // ── Singleton ─────────────────────────────────────────────────────────────

  static final InternetConnectionChecker _instance = InternetConnectionChecker.createInstance();

  // ── Instance configuration ────────────────────────────────────────────────

  /// Per-probe socket timeout for this instance.
  final Duration checkTimeout;

  /// Cache / re-probe cooldown for this instance.
  /// [hasConnection] calls within this window skip all I/O.
  final Duration checkInterval;

  // ── Internal state ────────────────────────────────────────────────────────

  late List<AddressCheckOptions> _addresses;

  bool? _cachedResult;
  DateTime? _cacheExpiry;

  // ── Public API ────────────────────────────────────────────────────────────

  List<AddressCheckOptions> get addresses => _addresses;

  set addresses(List<AddressCheckOptions> value) {
    _addresses = List<AddressCheckOptions>.unmodifiable(value);
    _invalidateCache();
  }

  /// Probes a single host. Opens a TCP connection and destroys it immediately.
  ///
  /// Returns [AddressCheckResult] with `isSuccess = true` only when the
  /// OS-level TCP handshake completes within the configured timeout.
  /// All exceptions are caught and treated as "unreachable"; the socket is
  /// always destroyed via `finally`.
  Future<AddressCheckResult> isHostReachable(AddressCheckOptions options) async {
    Socket? sock;
    try {
      sock = await Socket.connect(options.address ?? options.hostname, options.port, timeout: options.timeout);
      return AddressCheckResult(options, isSuccess: true);
    } on SocketException {
      // Network unreachable, connection refused, DNS failure, etc.
      return AddressCheckResult(options, isSuccess: false);
    } on TimeoutException {
      // Socket.connect exceeded options.timeout.
      return AddressCheckResult(options, isSuccess: false);
    } on Exception {
      // Catch-all for any other unexpected exception (e.g. OSError).
      return AddressCheckResult(options, isSuccess: false);
    } finally {
      // Guaranteed cleanup regardless of success, timeout, or exception.
      sock?.destroy();
    }
  }

  /// Returns `true` as soon as **any** configured address is reachable.
  ///
  /// ### Algorithm — parallel "first success wins"
  ///
  /// 1. **Empty guard** — resolve `false` immediately without touching I/O.
  /// 2. **Cache hit** — return the cached value without opening any sockets.
  /// 3. **Fan-out** — start all probes concurrently (no `await` in the loop).
  /// 4. **Race** — a [Completer] captures the first `true`; when all probes
  ///    are exhausted without success it captures `false`.
  /// 5. **whenComplete counter** — `pending` is decremented exactly once per
  ///    probe inside `whenComplete`, regardless of whether the probe succeeded
  ///    or threw. This eliminates the double-decrement risk that arises when
  ///    both `.then` and `.catchError` modify the same counter.
  /// 6. **Cache** — persist the result for [checkInterval].
  ///
  /// **Complexity**
  /// • Time  — O(1): bounded by the single fastest responding host.
  /// • Space — O(n): n concurrent futures, n = `addresses.length` (≤ 2).
  Future<bool> get hasConnection async {
    // 1. Empty guard — loop would never fire, Completer would hang forever.
    if (_addresses.isEmpty) {
      _cacheResult(false);
      return false;
    }

    // 2. Cache hit — skip all I/O.
    if (_isCacheValid()) {
      return _cachedResult!;
    }

    // 3. Parallel fan-out — NO await inside the loop.
    final completer = Completer<bool>();
    var pending = _addresses.length;

    for (final opts in _addresses) {
      // `unawaited()` from dart:async or package:meta would work too, but
      // an inline comment keeps this dependency-free and equally clear.
      isHostReachable(opts)
          .then((result) {
            // Resolve immediately on first success; do nothing if already resolved.
            if (!completer.isCompleted && result.isSuccess) {
              completer.complete(true);
            }
          })
          // ignore_for_file: document_ignores, unawaited_futures
          .whenComplete(() {
            // 5. Decrement exactly once per probe — after both .then and
            //    .catchError have run — eliminating double-decrement risk.
            pending--;
            if (!completer.isCompleted && pending == 0) {
              completer.complete(false);
            }
          });
    }

    // 6. Await, cache, and return.
    final connected = await completer.future;
    _cacheResult(connected);
    return connected;
  }

  /// Convenience wrapper — maps [hasConnection] to [InternetConnectionStatus].
  Future<InternetConnectionStatus> get connectionStatus async =>
      await hasConnection ? InternetConnectionStatus.connected : InternetConnectionStatus.disconnected;

  // ── Cache helpers ─────────────────────────────────────────────────────────

  bool _isCacheValid() =>
      _cachedResult != null &&
      _cacheExpiry != null &&
      // UTC avoids false expiry on daylight-saving / system-clock shifts.
      DateTime.now().toUtc().isBefore(_cacheExpiry!);

  void _cacheResult(bool value) {
    _cachedResult = value;
    _cacheExpiry = DateTime.now().toUtc().add(checkInterval);
  }

  void _invalidateCache() {
    _cachedResult = null;
    _cacheExpiry = null;
  }
}
