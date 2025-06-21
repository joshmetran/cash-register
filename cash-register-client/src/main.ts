import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import './utils/http.js'

// Vuetify
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import { VBtn, VTextField } from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { aliases, mdi } from 'vuetify/iconsets/mdi'

// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

const theme = {
  dark: false,
  colors: {
    utilBg: '#1A2549',
    secondaryBtn: '#f5f5f5',
    primary: '#035db8',
    secondary: '#424242',
    error: '#FF5252',
    info: '#2196F3',
    success: '#4CAF50',
    warning: '#FB8C00',
  },
}

const vuetify = createVuetify({
  aliases: {
    ATextField: VTextField,
    VBtnSecondary: VBtn,
    VBtnRounded: VBtn,
    VBtnRoundedSecondary: VBtn,
    VBtnTertiary: VBtn,
  },
  defaults: {
    ATextField: {
      variant: 'underlined',
    },
    VBtn: {
      color: 'primary',
      variant: 'flat',
    },
    VBtnSecondary: {
      color: '#e4e4e4',
      variant: 'flat',
    },
    VBtnRounded: {
      color: 'primary',
      variant: 'flat',
      rounded: true,
    },
    VBtnRoundedSecondary: {
      color: '#e4e4e4',
      variant: 'flat',
      rounded: true,
    },
    VBtnTertiary: {
      rounded: true,
      variant: 'plain',
    },
  },
  components,
  directives,
  icons: {
    defaultSet: 'mdi',
    aliases,
    sets: {
      mdi,
    },
  },
  theme: {
    defaultTheme: 'theme',
    themes: {
      theme,
    },
  },
})

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(vuetify)

app.mount('#app')
