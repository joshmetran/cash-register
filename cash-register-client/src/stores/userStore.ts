import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const signedIn = ref(localStorage.getItem('signedIn') || '0')
  const currentUser = ref(JSON.parse(localStorage.getItem('currentUser')) || {})

  const goTo = ref('')

  function hasUser() {
    return localStorage.getItem('signedIn') === '1' ? true : false
  }

  function setCurrentUser(user) {
    currentUser.value = user
    signedIn.value = '1'
    localStorage.setItem('currentUser', JSON.stringify(user))
    localStorage.setItem('signedIn', '1')
  }

  function getCurrentUser() {
    return JSON.parse(localStorage.getItem('currentUser'))
  }

  function unsetCurrentUser() {
    currentUser.value = {}
    signedIn.value = '0'
    localStorage.removeItem('currentUser')
    localStorage.removeItem('signedIn')
  }

  return { signedIn, currentUser, getCurrentUser, hasUser, setCurrentUser, unsetCurrentUser, goTo }
})
