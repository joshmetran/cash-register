<template>
  <div class="text-right mb-6">
    <v-btn
      @click="$router.push({ name: 'orders' })"
      class="ms-6 text-none"
      color="primary"
      prepend-icon="mdi-chevron-left"
      variant="flat"
      size="large"
    >
      Orders
    </v-btn>
  </div>

  <v-card class="card-edge-spacer" variant="elevated">
    <v-card-title class="mx-6 mt-6">
      Invoice      
    </v-card-title>
    <v-card-subtitle class="mx-6">
      #{{order.invoice_no}}      
    </v-card-subtitle>
    <v-card-text class="text--primary">
      <v-row no-gutters>
        <v-col cols="12" md="6">
          <v-list lines="two">
            <v-list-item>
              <template v-slot:prepend>
                <v-avatar>
                  <v-icon icon="mdi-currency-eur"></v-icon>
                </v-avatar>
              </template>
              <v-list-item-title class="black-color font-weight-bold">{{ formatCurrency(order.total_price) }}</v-list-item-title>
              <v-list-item-subtitle>Total Amount</v-list-item-subtitle>
            </v-list-item>
          </v-list>
        </v-col>
        <v-col cols="12" md="6">
          <v-list lines="two">
            <v-list-item>
              <template v-slot:prepend>
                <v-avatar>
                  <v-icon icon="mdi-calendar"></v-icon>
                </v-avatar>
              </template>
              <v-list-item-title>{{ formatDateTime(order.created_at) }}</v-list-item-title>
              <v-list-item-subtitle>Order Date</v-list-item-subtitle>
            </v-list-item>
          </v-list>
        </v-col>            
      </v-row>
    </v-card-text>
    <v-card-title class="mx-6 mt-6">
      Items      
    </v-card-title>
    <v-divider></v-divider>

    <v-data-table-server
      v-model="selected"
      :headers="headers"
      :items="order.order_details"
      :loading="loading"
      no-data-text="No Items Found"
      density="compact"
      hide-default-footer
    >
      <template v-slot:loading>
        <v-skeleton-loader type="table-row@10"></v-skeleton-loader>
      </template>

      <template v-slot:item.product_img_url="{ item }">
        <v-avatar size="x-large" class="my-1">
          <v-img :src="item.product_img_url"></v-img>
        </v-avatar>
      </template>
      <template v-slot:item.price="{ item }">
        {{ formatCurrency(item.price) }}
      </template>
      <template v-slot:item.total_price="{ item }">
        {{ formatCurrency(item.total_price) }}
      </template>
    </v-data-table-server>
  </v-card>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { debounce } from 'lodash'
import { formatDateTime, formatCurrency } from '@/utils/index'
import AlertMessage from '@/components/AlertMessage.vue'
import { MESSAGES } from '@/interfaces/constMessages'
import { useLoaderStore } from '@/stores/loaderStore'
import { useAlertStore } from '@/stores/alertStore'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()
const route = useRoute()
const loaderStore = useLoaderStore()
const alertStore = useAlertStore()

const alerMessage = ref({
  show: false,
  status: '',
  type: 'error',
  omitMessage: '',
  messages: [],
})

const headers = ref([
  { title: '', align: 'start', sortable: false, key: 'product_img_url', width: '80' },
  { title: 'Product Name', align: 'start', sortable: false, key: 'product_name' },
  { title: 'Qty', align: 'end', sortable: false, key: 'qty', align: 'center' },
  { title: 'Actual Qty', align: 'end', sortable: false, key: 'actual_qty', align: 'center' },
  { title: 'Price', align: 'end', sortable: false, key: 'price', align: 'right' },
  { title: 'Total Price', align: 'end', sortable: false, key: 'total_price' },
  { title: 'Remarks', key: 'remarks', sortable: false }  
])

const loading = ref(false)
const totalItems = ref(0)
const itemPerPage = ref(10)
const orders = ref([])
const selected = ref([])
const order = ref({})
const id = ref(0)

async function getOrder () {
  try {
    loaderStore.loader = true
    loading.value = true
    const { data } = await axios.get(`orders/${id.value}`)
    order.value = data
  } catch (err) {
    console.error('err:', err)
    alerMessage.value.messages = err.response.data.error || MESSAGES.DEFAULT_ERROR_MESSAGE
    alerMessage.value.show = true
  } finally {
    loading.value = false
    loaderStore.loader = false
  }
}

if (route.params.id != 0) {
  id.value = route.params.id
  getOrder()
}
</script>
