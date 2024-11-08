part of "network_info.dart";

@immutable
class AddressCheckResult {
  const AddressCheckResult(this.options, {required this.isSuccess});

  final AddressCheckOptions options;
  final bool isSuccess;

  @override
  String toString() => "AddressCheckResult($options, $isSuccess)";

  @override
  int get hashCode => Object.hashAll(<Object?>[options, isSuccess]);

  @override
  bool operator ==(Object other) =>
      other is AddressCheckResult && other.options == options && other.isSuccess == isSuccess;
}

@immutable
class AddressCheckOptions {
  const AddressCheckOptions({
    this.address,
    this.hostname,
    this.port = InternetConnectionChecker.defaultPort,
    this.timeout = InternetConnectionChecker.defaultTimeout,
  }) : assert(
          (address != null || hostname != null) && ((address != null) != (hostname != null)),
          "Either address or hostname must be provided, but not both.",
        );

  final InternetAddress? address;
  final String? hostname;
  final int port;
  final Duration timeout;

  @override
  String toString() => "AddressCheckOptions($address, $port, $timeout, $hostname)";

  @override
  int get hashCode => Object.hashAll(<Object?>[address, port, timeout]);

  @override
  bool operator ==(Object other) =>
      other is AddressCheckOptions && other.address == address && other.port == port && other.timeout == timeout;
}

enum InternetConnectionStatus { connected, disconnected }

class InternetConnectionChecker {
  factory InternetConnectionChecker() => _instance;

  InternetConnectionChecker.createInstance({List<AddressCheckOptions>? addresses}) {
    this.addresses = addresses ??
        defaultAddresses
            .map((AddressCheckOptions e) => AddressCheckOptions(address: e.address, hostname: e.hostname, port: e.port))
            .toList();
  }

  /// More info on why default port is 53
  /// here:
  /// - https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
  /// - https://www.google.com/search?q=dns+server+port
  static const int defaultPort = 53;

  /// Default timeout is 10 seconds.
  ///
  /// Timeout is the number of seconds before a request is dropped
  /// and an address is considered unreachable
  static const Duration defaultTimeout = Duration(seconds: 10);

  /// | Address        | Provider   | Info                                    |
  /// |:---------------|:-----------|:----------------------------------------|
  /// | 1.1.1.1        | CloudFlare | https://1.1.1.1                                 |
  /// | 1.0.0.1        | CloudFlare | https://1.1.1.1                                 |
  /// | 8.8.8.8        | Google     | https://developers.google.com/speed/public-dns/ |
  /// | 8.8.4.4        | Google     | https://developers.google.com/speed/public-dns/ |
  /// | 208.67.222.222 | OpenDNS    | https://use.opendns.com/                        |
  /// | 208.67.220.220 | OpenDNS    | https://use.opendns.com/                        |
  static final List<AddressCheckOptions> defaultAddresses = List<AddressCheckOptions>.unmodifiable(
    <AddressCheckOptions>[
      AddressCheckOptions(address: InternetAddress("1.1.1.1", type: InternetAddressType.IPv4)),
      AddressCheckOptions(address: InternetAddress("2606:4700:4700::1111", type: InternetAddressType.IPv6)),
      AddressCheckOptions(address: InternetAddress("8.8.4.4", type: InternetAddressType.IPv4)),
      AddressCheckOptions(address: InternetAddress("2001:4860:4860::8888", type: InternetAddressType.IPv6)),
      AddressCheckOptions(address: InternetAddress("208.67.222.222", type: InternetAddressType.IPv4)),
      AddressCheckOptions(address: InternetAddress("2620:0:ccc::2", type: InternetAddressType.IPv6)),
    ],
  );

  late List<AddressCheckOptions> _addresses;

  List<AddressCheckOptions> get addresses => _addresses;

  set addresses(List<AddressCheckOptions> value) {
    _addresses = List<AddressCheckOptions>.unmodifiable(value);
  }

  static final InternetConnectionChecker _instance = InternetConnectionChecker.createInstance();

  /// Ping a single address. See [AddressCheckOptions] for
  /// info on the accepted argument.
  Future<AddressCheckResult> isHostReachable(AddressCheckOptions options) async {
    Socket? sock;
    try {
      sock = await Socket.connect(options.address ?? options.hostname, options.port, timeout: options.timeout)
        ..destroy();
      return AddressCheckResult(options, isSuccess: true);
    } on Exception catch (_) {
      sock?.destroy();
      return AddressCheckResult(options, isSuccess: false);
    }
  }

  Future<bool> get hasConnection async {
    final Completer<bool> result = Completer<bool>();
    int length = addresses.length;

    for (final AddressCheckOptions addressOptions in addresses) {
      await isHostReachable(addressOptions).then(
        (AddressCheckResult request) {
          length -= 1;
          if (!result.isCompleted) {
            if (request.isSuccess) {
              result.complete(true);
            } else if (length == 0) {
              result.complete(false);
            }
          }
        },
      );
    }

    return result.future;
  }

  Future<InternetConnectionStatus> get connectionStatus async =>
      await hasConnection ? InternetConnectionStatus.connected : InternetConnectionStatus.disconnected;
}
