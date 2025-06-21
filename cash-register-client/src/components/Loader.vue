<template>
  <v-overlay :model-value="loaderStore.loader" class="align-center justify-center" persistent>
    <v-progress-circular color="primary" indeterminate size="64"></v-progress-circular>
  </v-overlay>
</template>

<script setup lang="ts">
import { useLoaderStore } from '@/stores/loaderStore'

const loaderStore = useLoaderStore()
</script>
