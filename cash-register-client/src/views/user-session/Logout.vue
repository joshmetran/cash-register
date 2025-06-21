<template>
  <v-main> </v-main>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/userStore'

const router = useRouter()
const userStore = useUserStore()

userStore.unsetCurrentUser()
router.push({ name: 'login' })
</script>
