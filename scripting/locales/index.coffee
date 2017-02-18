import en from './en'
import de from './de'
import es from './es'
import hu from './hu'
import fr from './fr'
import pt from './pt'
import uk from './uk'

locales = {
  en
  de
  es
  hu
  fr
  pt
  uk
}

export default (locale) -> locales[locale]
