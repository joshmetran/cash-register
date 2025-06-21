<script setup lang="ts">
const x = import.meta.env.VITE_BASE_URL
</script>

<template>
  <main>
    {{ x }}
    <TheWelcome />
  </main>
</template>
