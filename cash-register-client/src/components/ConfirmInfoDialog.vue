<template>
  <div class="text-center pa-4">
    <v-dialog v-model="dialog.show" max-width="400" persistent>
      <v-card class="p-1">
        <!-- <v-btn
          @click="dialog.show = false"
          density="comfortable"
          variant="tonal"
          icon="mdi-close"
          class="btnClose"
        ></v-btn> -->
        <div class="d-flex flex-nowrap p-4">
          <div v-if="dialog.icon" class="flex-grow-0 flex-shrink-0">
            <v-icon
              :icon="dialog.icon"
              :color="dialog?.iconColor"
              class="ps-1 pe-4 pt-2"
              style="font-size: 45px"
            ></v-icon>
          </div>
          <div class="flex-grow-1 flex-shrink-1 me-2">
            <div class="font-weight-bold">{{ dialog.title }}</div>
            {{ dialog.msg }}
          </div>
        </div>

        <template v-slot:actions>
          <v-spacer></v-spacer>
          <v-btn @click="doCancel()" class="px-3 text-none font-weight-bold" variant="text">
            {{ dialog.cancelBtn }}
          </v-btn>

          <v-btn
            @click="doConfirm()"
            class="px-3 text-none font-weight-bold"
            color="red"
            variant="flat"
          >
            {{ dialog.confirmBtn }}
          </v-btn>
        </template>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
import { CONFIRMATION_TYPE } from '@/interfaces/const'
const props = defineProps(['dialog'])
const emit = defineEmits(['doConfirm', 'doCancel'])

function doConfirm() {
  emit('doConfirm')
}

function doCancel() {
  emit('doCancel')
}
</script>
