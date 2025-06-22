<template>
  <v-container class="pa-0 ma-0">
    <v-row no-gutters>
      <v-col cols="12" class="px-10 py-8">
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
        <v-container>
          <v-row>
            <v-col v-for="product in products" :key="product.id" cols="4">
              <v-card class="d-flex flex-column" height="100%">
                <v-img height="150" :src="product.img_url || '/img/food.png'" cover></v-img>
                <v-card-item>
                  <v-card-title>{{ product.name }}</v-card-title>
                </v-card-item>
                <v-card-text>
                  <div class="text-subtitle-1">{{ formatCurrency(product.price) }}</div>
                </v-card-text>
                <div
                  v-if="product.is_buy_one_take_one || product.can_bulk_purchase"
                  class="px-4 mb-2"
                >
                  <v-chip
                    v-if="product.is_buy_one_take_one"
                    color="success"
                    size="small"
                    class="mr-1"
                    >Buy One Take One</v-chip
                  >
                  <v-chip
                    v-if="product.can_bulk_purchase"
                    color="info"
                    size="small"
                    :class="{ 'mt-1': product.is_buy_one_take_one }"
                    >Bulk Purchase
                    <span class="ml-1"
                      ><strong>{{ formatCurrency(product.bulk_purchase_price) }}</strong></span
                    ></v-chip
                  >
                </div>
                <v-card-actions>
                  <v-btn
                    @click="addToCart(product)"
                    :disabled="loading"
                    class="text-none ms-auto btnMinWidth"
                    prepend-icon="mdi-plus-thick"
                    variant="tonal"
                    size="large"
                    block
                  >
                    Add
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-col>
          </v-row>
        </v-container>
      </v-col>
    </v-row>
  </v-container>

  <v-navigation-drawer location="right" width="350">
    <div class="mt-4" style="background-color: #ffffff">
      <v-card class="mx-auto" max-width="344" elevation="0">
        <v-card-title> Order Details </v-card-title>
      </v-card>
      <v-divider></v-divider>
    </div>

    <v-list lines="two">
      <template v-for="(item, index) in cartItems" :key="index">
        <v-list-item>
          <template v-slot:prepend>
            <v-avatar>
              <v-img :src="item.img_url"></v-img>
            </v-avatar>
          </template>

          <v-list-item-title>{{ item.name }}</v-list-item-title>
          <v-list-item-subtitle>
            <template v-if="item.is_buy_one_take_one">{{ item.qty * 2 }}</template>
            <template v-else>{{ item.qty }}</template>
            X
            <template v-if="item.can_bulk_purchase && item.qty >= item.min_bulk_purchase">{{
              formatCurrency(item.bulk_purchase_price)
            }}</template>
            <template v-else>{{ formatCurrency(item.price) }}</template>
            <span class="float-right black-color text-subtitle-2 font-weight-bold">
              <template v-if="item.can_bulk_purchase && item.qty >= item.min_bulk_purchase">{{
                formatCurrency(item.qty * item.bulk_purchase_price)
              }}</template>
              <template v-else>{{ formatCurrency(item.qty * item.price) }}</template>
            </span>
            <v-spacer></v-spacer>
            <div class="float-left pt-2" style="width: 160px">
              <v-text-field
                v-model="item.qty"
                variant="outlined"
                width="150"
                rounded
                readonly
                hide-details
                prepend-icon="mdi-minus-thick"
                @click:prepend="minusQty(item)"
                @click:append="addQty(item)"
                append-icon="mdi-plus-thick"
                density="compact"
                class="order-counter centered-input"
              ></v-text-field>
            </div>
            <div class="pt-1">
              <v-btn
                icon="mdi-trash-can-outline"
                variant="text"
                color="red"
                @click="removeCartItem(item)"
              ></v-btn>
            </div>
          </v-list-item-subtitle>
        </v-list-item>
        <v-divider
          :key="`div` + index"
          class="mx-4"
          v-if="index < cartItems.length - 1"
        ></v-divider>
      </template>
      <v-divider v-if="cartItems.length > 0"></v-divider>
    </v-list>

    <v-card-text v-if="cartItems.length == 0" type="article" align="center" class="py-16">
      <v-icon size="50"> mdi-note-outline </v-icon>
      <br />
      No New Orders Yet
    </v-card-text>
    <template v-else>
      <div class="px-4 py-4 text-subtitle-1 font-weight-medium">
        Payable Amount
        <span class="float-right font-weight-bold text-h6">{{
          formatCurrency(payableAmount)
        }}</span>
      </div>
    </template>

    <div class="px-4 py-2">
      <v-btn
        v-if="cartItems.length > 0"
        class="text-none ms-auto"
        prepend-icon="mdi-send"
        variant="flat"
        size="large"
        block
        rounded
        @click="proceedOrder()"
      >
        Proceed
      </v-btn>
    </div>
  </v-navigation-drawer>

  <v-card class="card-edge-spacer" variant="elevated" style="display: none">
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
    </v-data-table-server>
  </v-card>
</template>

<script setup>
import { ref, computed } from 'vue'
import axios from 'axios'
import { debounce } from 'lodash'
import { formatDateTime, formatCurrency } from '@/utils/index'
import { useLoaderStore } from '@/stores/loaderStore'
import AlertMessage from '@/components/AlertMessage.vue'
import { useAlertStore } from '@/stores/alertStore'

const loaderStore = useLoaderStore()
const alertStore = useAlertStore()

const alerMessage = ref({
  show: false,
  status: '',
  type: 'error',
  omitMessage: '',
  messages: [],
})

const headers = ref([{ title: 'Code', align: 'start', sortable: true, key: 'code' }])

const search = ref('')
const searchStr = ref('')
const loading = ref(false)
const totalItems = ref(0)
const itemPerPage = ref(10)
const products = ref([])
const selected = ref([])
const cartItems = ref([])

const payableAmount = computed(() => {
  let totalAmount = 0

  cartItems.value.forEach((obj) => {
    let amount = 0
    if (obj.can_bulk_purchase && obj.qty >= obj.min_bulk_purchase) {
      amount = obj.qty * obj.bulk_purchase_price
    } else {
      amount = obj.qty * obj.price
    }

    totalAmount += amount
  })

  return totalAmount
})

const handleSearch = debounce(() => {
  searchStr.value = search.value
}, 1000)

function addToCart(product) {
  let hasID = false

  cartItems.value.forEach((obj) => {
    if (obj.id == product.id) {
      hasID = true
      obj.qty++
      return false
    }
  })

  if (!hasID) {
    let newItem = {
      id: product.id,
      name: product.name,
      img_url: product.img_url,
      qty: 1,
      price: product.price,
      is_buy_one_take_one: product.is_buy_one_take_one,
      can_bulk_purchase: product.can_bulk_purchase,
      min_bulk_purchase: product.min_bulk_purchase,
      bulk_purchase_price: product.bulk_purchase_price,
    }
    cartItems.value.push(newItem)
  }
}

function removeCartItem(product) {
  cartItems.value.splice(cartItems.value.indexOf(product), 1)
}

function minusQty(product) {
  if (parseInt(product.qty) < 2) return
  product.qty = parseInt(product.qty) - 1

  if (product.qty < 1) {
    removeCartItem(product)
  }
}

function addQty(product) {
  product.qty = parseInt(product.qty) + 1
}

async function proceedOrder() {
  loading.value = true
  loaderStore.loader = true
  alerMessage.value.show = false
  alerMessage.value.messages = []

  const payload = {
    order: {
      order_details_attributes: [],
    },
  }

  cartItems.value.forEach((obj) => {
    payload.order.order_details_attributes.push({ product_id: obj.id, qty: obj.qty })
  })

  try {
    const { data } = await axios.post(`orders`, payload)

    alertStore.show(`Transaction #${data.invoice_no} completed successfully. Thank you!`)
    cartItems.value = []
  } catch (err) {
    console.error('err:', err)
    alerMessage.value.messages = err.response.data.error || MESSAGES.DEFAULT_ERROR_MESSAGE
    alerMessage.value.show = true
  } finally {
    loaderStore.loader = false
    loading.value = false
  }
}

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
