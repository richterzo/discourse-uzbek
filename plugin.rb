# name: discourse-uz-locale
# about: Adds a new locale for Uzbek
# version: 0.1
# authors: Terzaghi Riccardo
# url: https://github.com/richterzo/discourse-uzbek

register_locale("uz", name: "Uzbek", nativeName: "Ўзбек", fallbackLocale: "en_GB")

after_initialize do
    if defined? DiscourseTranslator::Google::SUPPORTED_LANG_MAPPING
      DiscourseTranslator::Google::SUPPORTED_LANG_MAPPING[:uz] = "uz"
    end
  end
