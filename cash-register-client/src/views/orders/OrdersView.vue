<template>
  <div class="text-right mb-6">
    <v-btn
      @click="$router.push({ name: 'home' })"
      class="ms-6 text-none"
      color="primary"
      prepend-icon="mdi-plus"
      variant="flat"
      size="large"
    >
      Create New Order
    </v-btn>
  </div>

  <v-card class="card-edge-spacer" variant="elevated">
    <v-card-text class="d-flex align-center flex-wrap gap-4 px-6 pt-6">
      <v-card-title class="flex-grow-1 ps-0"> Orders </v-card-title>

      <v-text-field
        v-model="search"
        @input="handleSearch"
        class="inp-filter"
        placeholder="Search"
        append-inner-icon="mdi-magnify"
        density="compact"
        variant="outlined"
        hide-details
      ></v-text-field>
    </v-card-text>

    <v-divider></v-divider>

    <v-data-table-server
      v-model="selected"
      :headers="headers"
      :items-length="totalItems"
      :items-per-page-options="[10, 20, 30, 40]"
      :items-per-page="itemPerPage"
      :items="orders"
      :loading="loading"
      no-data-text="No Orders Found"
      density="compact"
      :search="searchStr"
      @update:options="loadOrders"
    >
      <template v-slot:loading>
        <v-skeleton-loader type="table-row@10"></v-skeleton-loader>
      </template>

      <template v-slot:item.is_buy_one_take_one="{ item }">
        <v-chip v-if="item.is_buy_one_take_one" color="success" size="small">Yes</v-chip>
        <v-chip v-else color="grey" size="small">No</v-chip>
      </template>

      <template v-slot:item.can_bulk_purchase="{ item }">
        <v-chip v-if="item.can_bulk_purchase" color="success" size="small">Yes</v-chip>
        <v-chip v-else color="grey" size="small">No</v-chip>
      </template>

      <template v-slot:item.total_price="{ item }">
        {{ formatCurrency(item.total_price) }}
      </template>

      <template v-slot:item.bulk_purchase_price="{ item }">
        {{ formatCurrency(item.bulk_purchase_price) }}
      </template>

      <template v-slot:item.created_at="{ item }">
        {{ formatDateTime(item.created_at) }}
      </template>

      <template v-slot:item.updated_at="{ item }">
        {{ formatDateTime(item.updated_at) }}
      </template>      
    </v-data-table-server>
  </v-card>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import { debounce } from 'lodash'
import { formatDateTime, formatCurrency } from '@/utils/index'

const headers = ref([
  { title: 'Invoice No.', align: 'start', sortable: true, key: 'invoice_no' },
  { title: 'Total Amount', align: 'end', sortable: true, key: 'total_price' },
  { title: 'Created Date', key: 'created_at',sortable: true,  align: 'center' },
  { title: 'Updated Date', key: 'updated_at',sortable: true,  align: 'center' }
])

const search = ref('')
const searchStr = ref('')
const loading = ref(false)
const totalItems = ref(0)
const itemPerPage = ref(10)
const orders = ref([])
const selected = ref([])

const handleSearch = debounce(() => {
  searchStr.value = search.value
}, 1000)

async function loadOrders({ page, itemsPerPage, sortBy }) {
  try {
    loading.value = true
    let params = { page: page, per_page: itemsPerPage }

    if (sortBy.length) {
      params.sort_by_key = sortBy[0].key
      params.sort_by_order = sortBy[0].order
    }

    if (searchStr.value) {
      params.search = searchStr.value
    }

    const { data } = await axios.get(`orders`, { params: params })
    orders.value = data.orders
    totalItems.value = data.pagination.count
  } catch (err) {
    console.error('err:', err)
  } finally {
    loading.value = false
  }
}
</script>
