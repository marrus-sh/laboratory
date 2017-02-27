# Use Object.defineProperty because this shouldn't be enumerable:

Object.defineProperty Laboratory.Locales, "getL10n",
    value: (locale) -> Laboratory.Locales[locale]
