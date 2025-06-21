<template>
  <v-snackbar
    v-model="alertStore.alert"
    :timeout="alertStore.timeout"
    :color="alertStore.alertType"
    location="top"
  >
    {{ alertStore.msg }}
    <template v-slot:actions>
      <v-btn @click="alertStore.alert = false" icon="mdi-close" />
    </template>
  </v-snackbar>
</template>

<script setup lang="ts">
import { useAlertStore } from '@/stores/alertStore'

const alertStore = useAlertStore()
</script>
