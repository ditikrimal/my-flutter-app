//login Exceptions
class InvalidCredentialsAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

//register Exceptions
class EmailAlreadyTakenAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}
