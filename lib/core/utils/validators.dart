class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi giriniz';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }

    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }

    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ürün linki gerekli';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Geçerli bir URL girin';
    }

    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fiyat gerekli';
    }

    final price = double.tryParse(value);

    if (price == null) {
      return 'Geçeli bir fiyat girin';
    }

    if (price <= 0) {
      return 'Fiyat 0\'dan büyük olmalı';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'İsim gerekli';
    }

    if (value.length < 2) {
      return 'İsim en az 2 karakter olmalıdır';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final phoneRegex = RegExp(r'^05\d{9}$');
    final cleanedPhone = value.replaceAll(RegExp(r'[\s-()]'), '');

    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return 'Geçeli bir telefon numarası giriniz';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Şifre tekrar';
    }

    if (password != confirmPassword) {
      return 'Şifreler eşleşmiyor';
    }

    return null;
  }
}
