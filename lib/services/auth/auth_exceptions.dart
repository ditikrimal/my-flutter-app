//login Exceptions
class InvalidCredentialsAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

//register Exceptions
class InvalidEmailAuthException implements Exception {}

class EmptyFieldAuthException implements Exception {}

class EmailAlreadyTakenAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}
