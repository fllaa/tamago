class StringConstants {
  // Private constructor to prevent instantiation
  StringConstants._();

  // Common strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String save = 'Save';
  static const String submit = 'Submit';
  static const String search = 'Search';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';

  // Error messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String connectionError =
      'No internet connection. Please check your network.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String notFoundError = 'The requested resource was not found.';
  static const String serverError =
      'Server error occurred. Please try again later.';
  static const String unauthorizedError =
      'Unauthorized access. Please log in again.';
  static const String validationError =
      'Please check your input and try again.';

  // Auth strings
  static const String login = 'Login';
  static const String register = 'Register';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String loginSuccessful = 'Login successful!';
  static const String registrationSuccessful = 'Registration successful!';
  static const String passwordResetEmailSent =
      'Password reset email has been sent.';
  static const String passwordResetSuccessful =
      'Password has been reset successfully.';
  static const String logout = 'Logout';
  static const String logoutConfirmation = 'Are you sure you want to logout?';

  // Form labels
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String username = 'Username';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String address = 'Address';

  // Form validation messages
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword =
      'Password must be at least 8 characters long';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';

  // Home strings
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String popularProducts = 'Popular Products';
  static const String newArrivals = 'New Arrivals';
  static const String viewAll = 'View All';

  // Profile strings
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String myOrders = 'My Orders';
  static const String wishlist = 'Wishlist';
  static const String settings = 'Settings';
  static const String helpAndSupport = 'Help & Support';
  static const String termsAndConditions = 'Terms & Conditions';
  static const String privacyPolicy = 'Privacy Policy';
  static const String aboutUs = 'About Us';

  // Product strings
  static const String products = 'Products';
  static const String productDetails = 'Product Details';
  static const String price = 'Price';
  static const String description = 'Description';
  static const String reviews = 'Reviews';
  static const String addToCart = 'Add to Cart';
  static const String buyNow = 'Buy Now';
  static const String outOfStock = 'Out of Stock';
  static const String addToWishlist = 'Add to Wishlist';
  static const String removeFromWishlist = 'Remove from Wishlist';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String noProductsFound = 'No products found';
}
