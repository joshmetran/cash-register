<template>
  <v-alert :type="alerMessage.type" v-model="alerMessage.show" class="text-sm my-8">
    <ul class="ma-0 p-0">
      <li v-for="message in alerMessage.messages" :key="message" style="min-width: 230px">
        {{ rewriteMessage(message) }}
      </li>
    </ul>
  </v-alert>
</template>

<script>
export default {
  name: 'alert-message',
  props: ['alerMessage'],
  data: () => ({}),
  computed: {},
  methods: {
    rewriteMessage(msg) {
      msg = msg.replace(this.alerMessage.omitMessage, '')
      return msg.charAt(0).toUpperCase() + msg.slice(1)
    },
  },
  mounted() {},
  components: {},
}
</script>
