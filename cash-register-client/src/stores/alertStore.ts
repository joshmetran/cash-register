import { defineStore } from 'pinia'
import { ref } from 'vue'
import { debounce } from 'lodash'

export const ALERT_TYPE = {
  SUCCESS: 'success',
  WARNING: 'warning',
}

export const useAlertStore = defineStore('alert', () => {
  const alert = ref(false)
  const alertType = ref(ALERT_TYPE.SUCCESS)
  const msg = ref('')
  const timeout = ref(3000)

  function show(str: string, type = ALERT_TYPE.SUCCESS, _timeout = 5000) {
    msg.value = str
    alert.value = false
    alertType.value = type
    timeout.value = _timeout
    handleShowAlert()
  }

  const handleShowAlert = debounce(() => {
    alert.value = true
  }, 100)

  return { alert, alertType, msg, timeout, show }
})
