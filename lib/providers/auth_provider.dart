part of 'providers.dart';

// final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC_QEWlK4bzGvq6INOAUE76_wHD4pK0n00')
// http.post(url, ...)

// final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=<YOUR_API_KEY>')
// http.post(url, ...)

// https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != '';
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return '';
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC_QEWlK4bzGvq6INOAUE76_wHD4pK0n00');
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));
      final responseData = json.decode(response.body);
      // print(responseData);
      // print(responseData['error']);
      if (responseData['error'] != null) {
        return Future.error(HttpException(responseData['error']['message']));
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      // print(userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // print(prefs.containsKey('userData'));
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = prefs.getString('userData');
    final userData = json.decode(extractedUserData!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryDate'] as String);
    // print(extractedUserData);

    if (expiryDate.isBefore(DateTime.now())) {
       print(expiryDate);
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    // print(_token);

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.clear(); clear all data in the local
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
