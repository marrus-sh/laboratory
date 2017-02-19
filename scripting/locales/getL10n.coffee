# Use Object.defineProperty because this shouldn't be enumerable:

Object.defineProperty 研.locales, "getL10n",
    value: (locale) -> 研.locales[locale]
