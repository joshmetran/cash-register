import format from 'date-fns/format'
import parse from 'date-fns/parse'
import { useRouter } from 'vue-router'

export function goTo(name) {
  const router = useRouter()
  router.push(name)
}

export function replaceString(str, replaceStr, useStr) {
  return str ? str.replace(replaceStr, useStr) : ''
}

export function toUpperFirstString(str) {
  return str ? str.charAt(0).toUpperCase() + str.slice(1).toLowerCase() : ''
}

export function formatDateTime(dateString) {
  try {
    return format(new Date(dateString), 'MMM d, yyyy h:mma')
  } catch {
    return ''
  }
}

export function formatDate(dateString) {
  try {
    return format(new Date(dateString), 'MM-dd-yyyy')
  } catch {
    return ''
  }
}

export function parseDate(dateString) {
  return parse(dateString, 'MM-dd-yyyy', new Date())
}

export const CURRENCY_FORMAT = new Intl.NumberFormat('en-US', {
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
})

export function formatCurrency(amount) {
  return `${CURRENCY_FORMAT.format(amount)} €`
}

// https://emailregex.com/
export const EMAIL_REGEX = new RegExp(
  /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
)
