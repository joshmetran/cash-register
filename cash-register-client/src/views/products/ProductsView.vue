<template>
  <div class="text-right mb-6">
    <v-btn
      @click="$router.push({ name: 'product', params: { id: 0 } })"
      class="ms-6 text-none"
      color="primary"
      prepend-icon="mdi-plus"
      variant="flat"
      size="large"
    >
      Create New Product
    </v-btn>
  </div>

  <v-card class="card-edge-spacer" variant="elevated">
    <v-card-text class="d-flex align-center flex-wrap gap-4 px-6 pt-6">
      <v-card-title class="flex-grow-1 ps-0"> Products </v-card-title>

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
      :items="products"
      :loading="loading"
      no-data-text="No Products Found"
      density="compact"
      :search="searchStr"
      @update:options="loadProducts"
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

      <template v-slot:item.price="{ item }">
        {{ formatCurrency(item.price) }}
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

      <template v-slot:item.action="{ item }">
        <v-btn
          @click="$router.push({ name: 'product', params: { id: item.id } })"
          density="comfortable"
          variant="text"
          icon="mdi-pencil-outline"
          class="me-1"
        >
          <v-icon icon="mdi-pencil-outline"></v-icon>
          <v-tooltip activator="parent" location="top">Edit</v-tooltip>
        </v-btn>
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
  { title: 'Code', align: 'start', sortable: true, key: 'code' },
  { title: 'Name', align: 'start', sortable: true, key: 'name' },
  { title: 'Price', align: 'end', sortable: true, key: 'price' },
  {
    title: 'Buy One Take One',
    align: 'center',
    sortable: true,
    key: 'is_buy_one_take_one',
    minWidth: '170',
  },
  {
    title: 'Bulk Purchase',
    align: 'center',
    sortable: true,
    key: 'can_bulk_purchase',
    width: '144',
  },
  {
    title: 'Min. Bulk Purchase',
    align: 'center',
    sortable: true,
    key: 'min_bulk_purchase',
    width: '180',
  },
  {
    title: 'Bulk Purchase Price',
    align: 'end',
    sortable: true,
    key: 'bulk_purchase_price',
    width: '180',
  },
  { title: '', key: 'action', sortable: false, align: 'start', width: '70' },
])

const search = ref('')
const searchStr = ref('')
const loading = ref(false)
const totalItems = ref(0)
const itemPerPage = ref(10)
const products = ref([])
const selected = ref([])

const handleSearch = debounce(() => {
  searchStr.value = search.value
}, 1000)

async function loadProducts({ page, itemsPerPage, sortBy }) {
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

    const { data } = await axios.get(`products`, { params: params })
    products.value = data.products
    totalItems.value = data.pagination.count
  } catch (err) {
    console.error('err:', err)
  } finally {
    loading.value = false
  }
}
</script>
