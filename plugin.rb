# name: discourse-german-formal-locale
# about: Adds a new locale for formal German
# version: 0.1
# authors: Terzaghi Riccardo
# url: https://github.com/richterzo/discourse-uzbek

register_locale(
    "uz",
    name: "Uzbek",
    nativeName: "Ўзбек",
    fallbackLocale: "en_GB"),
    plural: {
    keys: [:one, :other],
    rule: lambda { |n| n == 1 ? :one : :other }
  }
