class Validators {
  // Private constructor to prevent instantiation
  Validators._();
  
  /// Validates an email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  /// Validates a password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    return null;
  }
  
  /// Validates password confirmation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  /// Validates a name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    return null;
  }
  
  /// Validates a phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number might be optional
    }
    
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  /// Validates a required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }
  
  /// Validates text length
  static String? validateLength(String? value, int minLength, int maxLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    
    if (value.length > maxLength) {
      return '$fieldName must be at most $maxLength characters long';
    }
    
    return null;
  }
}