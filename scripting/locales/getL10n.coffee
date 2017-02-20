# Use Object.defineProperty because this shouldn't be enumerable:

Object.defineProperty 语, "getL10n",
    value: (locale) -> 研.locales[locale]
