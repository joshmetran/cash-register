<template>
  <v-container fluid height="100%" class="container-bg-color pa-0">
    <v-row no-gutters align="center" style="height: 100%">
      <v-col cols="12" sm="12" md="3" class="d-none d-md-flex d-sm-none"> </v-col>
      <v-col cols="12" sm="12" md="6" align="center" class="pa-12">
        <a class="text-decoration-none" href="/">
          <img src="@/assets/images/amenitiz-logo.svg" width="250" />
        </a>
        <div class="mx-auto pt-10" style="width: fit-content; text-align: left">
          <alert-message :aler-message="alerMessage"></alert-message>
          <h2 class="mb-1">Sign in to cash register</h2>
          <p class="pb-6">Enter your passcode to access the cash register.</p>
          <form @submit.prevent="submit">
            <v-text-field
              ref="txtPasscode"
              v-model="passcode"
              v-bind="passcodeAttrs"
              :error-messages="toUpperFirstString(errors.passcode)"
              :append-inner-icon="visible ? 'mdi-eye-off' : 'mdi-eye'"
              :type="visible ? 'text' : 'password'"
              name="input-10-2"
              label="Passcode"
              :disabled="loading"
              variant="outlined"
              autocomplete="false"
              class="input-group--focused mt-3"
              @click:append-inner="visible = !visible"
            ></v-text-field>
          </form>
          <v-btn-rounded
            block
            size="large"
            class="mt-6"
            :disabled="loading || !meta.valid"
            @click="submit()"
          >
            {{ loading ? 'Please wait...' : 'Enter' }}
          </v-btn-rounded>
        </div>
      </v-col>
      <v-col cols="12" sm="12" md="3" class="d-none d-md-flex d-sm-none"> </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import axios from 'axios'
import { ref, onMounted } from 'vue'
import { toUpperFirstString } from '@/utils/index'
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/yup'
import { object, string } from 'yup'
import { useRoute, useRouter } from 'vue-router'
import AlertMessage from '@/components/AlertMessage.vue'
import { MESSAGES } from '@/interfaces/constMessages'
import { useLoaderStore } from '@/stores/loaderStore'
import { useUserStore } from '@/stores/userStore'

const router = useRouter()
const loaderStore = useLoaderStore()
const userStore = useUserStore()

const visible = ref(false)
const txtPasscode = ref(null)
const loading = ref(false)

const alerMessage = ref({
  show: false,
  status: '',
  type: 'error',
  omitMessage: '',
  messages: [],
})

const { meta, errors, defineField, handleReset } = useForm({
  validationSchema: toTypedSchema(
    object({
      passcode: string().required(),
    }),
  ),
})

const [passcode, passcodeAttrs] = defineField('passcode')

async function submit() {
  if (!meta.value.valid) return

  try {
    loading.value = true
    loaderStore.loader = true
    alerMessage.value.show = false
    alerMessage.value.messages = []

    if (passcode.value === '1') {
      //@4m3Nit1z
      userStore.setCurrentUser({ name: 'Joseph Metran', email: 'joshmetran@gmail.com' })
      router.push({ name: 'home' })
    } else {
      passcode.value = ''
      handleReset()
      alerMessage.value.messages = ['Invalid passcode.']
      alerMessage.value.show = true
    }
  } finally {
    loaderStore.loader = false
    loading.value = false
  }
}

onMounted(() => {
  txtPasscode.value.focus()
})

userStore.unsetCurrentUser()
</script>

<style lang="scss">
input {
  /* hack for the Webkit browser's autofill style */
  &:-webkit-autofill {
    background-clip: text !important;
  }
  &.white:-webkit-autofill {
    -webkit-text-fill-color: white;
  }
}
</style>
