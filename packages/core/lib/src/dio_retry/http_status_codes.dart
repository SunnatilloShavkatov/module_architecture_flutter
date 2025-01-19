part of 'retry_interceptor.dart';

const Set<int> retryAbleStatuses = <int>{401, 502, 599, 522};

bool isRetryAble(int statusCode) => retryAbleStatuses.contains(statusCode);
