enum RMethodTypes {
  get(param: 'GET'),
  post(param: 'POST'),
  patch(param: 'PATCH'),
  put(param: 'PUT'),
  delete(param: 'DELETE');

  const RMethodTypes({required this.param});

  final String param;
}
