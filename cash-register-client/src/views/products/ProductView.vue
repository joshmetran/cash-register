<template>
  <v-card class="card-edge-spacer" variant="elevated">
    <v-form ref="form" @submit.prevent="save()">
      <v-card-item>
        <v-container>
          <v-row>
            <v-col cols="12">
              <v-card-title class="flex-grow-1 ps-0 pb-6">
                {{ forUpdate ? 'Update' : 'Create New' }} Product
              </v-card-title>
              <alert-message :alerMessage="alerMessage"></alert-message>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field
                ref="txtCode"
                v-model="code"
                v-bind="codeAttrs"
                :error-messages="toUpperFirstString(errors.code)"
                label="Code"
                variant="outlined"
              ></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="name"
                v-bind="nameAttrs"
                :error-messages="toUpperFirstString(errors.name)"
                label="Name"
                variant="outlined"
              ></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="price"
                v-bind="priceAttrs"
                :error-messages="toUpperFirstString(errors.price)"
                type="number"
                label="Price"
                variant="outlined"
                prefix="€"
              ></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
              <v-switch
                v-model="isBuyOneTakeOne"
                label="Buy One Take One"
                color="primary"
                hide-details
                inset
              ></v-switch>
              <v-switch
                v-model="canBulkPurchase"
                label="Bulk Purchase"
                color="primary"
                hide-details
                inset
              ></v-switch>
            </v-col>
          </v-row>
          <v-row v-if="canBulkPurchase">
            <v-col cols="12" md="6">
              <v-text-field
                type="number"
                v-model="minBulkPurchase"
                v-bind="minBulkPurchaseAttrs"
                :error-messages="toUpperFirstString(errors.minBulkPurchase)"
                label="Min Bulk Purchase"
                variant="outlined"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                type="number"
                v-model="bulkPurchasePrice"
                v-bind="bulkPurchasePriceAttrs"
                :error-messages="toUpperFirstString(errors.bulkPurchasePrice)"
                label="Bulk Purchase Price"
                variant="outlined"
                prefix="€"
              ></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12">
              <v-btn
                @click="$router.push({ name: 'products' })"
                class="text-none btnMinWidth me-4"
                color="secondaryBtn"
                prepend-icon="mdi-chevron-left"
                variant="flat"
                size="large"
              >
                Products
              </v-btn>

              <v-btn
                @click="save()"
                :disabled="loading"
                class="text-none ms-auto btnMinWidth"
                color="primary"
                prepend-icon="mdi-check"
                variant="flat"
                size="large"
              >
                {{ forUpdate ? 'Update' : 'Create' }} Product
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-card-item>
    </v-form>
  </v-card>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/yup'
import { object, string, number, lazy } from 'yup'
import { toUpperFirstString } from '@/utils/index'
import AlertMessage from '@/components/AlertMessage.vue'
import { MESSAGES } from '@/interfaces/constMessages'
import { useLoaderStore } from '@/stores/loaderStore'
import { useAlertStore } from '@/stores/alertStore'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()
const route = useRoute()
const loaderStore = useLoaderStore()
const alertStore = useAlertStore()

const { meta, errors, defineField } = useForm({
  validationSchema: toTypedSchema(
    object({
      code: string().required(),
      name: string().required(),
      price: string().required(),
      minBulkPurchase: lazy((val) =>
        canBulkPurchase.value
          ? string().required('Min Bulk Purchase is a required field')
          : string(),
      ),
      bulkPurchasePrice: lazy((val) =>
        canBulkPurchase.value
          ? string().required('Bulk Purchase Price is a required field')
          : string(),
      ),
    }),
  ),
})

const [code, codeAttrs] = defineField('code')
const [name, nameAttrs] = defineField('name')
const [price, priceAttrs] = defineField('price')
const [minBulkPurchase, minBulkPurchaseAttrs] = defineField('minBulkPurchase')
const [bulkPurchasePrice, bulkPurchasePriceAttrs] = defineField('bulkPurchasePrice')
const id = ref(0)
const canBulkPurchase = ref(false)
const isBuyOneTakeOne = ref(false)

const loading = ref(false)
const form = null
const txtCode = ref(null)

const alerMessage = ref({
  show: false,
  status: '',
  type: 'error',
  omitMessage: '',
  messages: [],
})

const forUpdate = computed(() => {
  return id.value != 0 ? true : false
})

async function save() {
  if (!meta.value.valid) return

  loading.value = true
  loaderStore.loader = true
  alerMessage.value.show = false
  alerMessage.value.messages = []
  const payload = {
    product: {
      code: code.value,
      name: name.value,
      price: price.value,
      is_buy_one_take_one: isBuyOneTakeOne.value,
      can_bulk_purchase: canBulkPurchase.value,
    },
  }

  payload.product.min_bulk_purchase = canBulkPurchase.value ? minBulkPurchase.value : null
  payload.product.bulk_purchase_price = canBulkPurchase.value ? bulkPurchasePrice.value : null

  if (forUpdate.value) {
    update(payload)
  } else {
    create(payload)
  }
}

async function create(payload) {
  try {
    const { data } = await axios.post(`products`, payload)

    alertStore.show(`${name.value} ${MESSAGES.MESSAGE.ADD_SUCCESS}`)
    router.push({ name: 'products' })
  } catch (err) {
    console.error('err:', err)
    alerMessage.value.messages = err.response.data.error || MESSAGES.DEFAULT_ERROR_MESSAGE
    alerMessage.value.show = true
  } finally {
    loaderStore.loader = false
    loading.value = false
  }
}

async function update(payload) {
  try {
    const { data } = await axios.put(`products/${id.value}`, payload)

    alertStore.show(`${name.value} ${MESSAGES.MESSAGE.UPDATE_SUCCESS}`)
    router.push({ name: 'products' })
  } catch (err) {
    console.error('err:', err)
    alerMessage.value.messages = err.response.data.error || MESSAGES.DEFAULT_ERROR_MESSAGE
    alerMessage.value.show = true
  } finally {
    loaderStore.loader = false
    loading.value = false
  }
}

async function getProduct() {
  try {
    loading.value = true
    const { data } = await axios.get(`products/${id.value}`)
    code.value = data.code
    name.value = data.name
    price.value = data.price
    isBuyOneTakeOne.value = data.is_buy_one_take_one
    canBulkPurchase.value = data.can_bulk_purchase
    if (canBulkPurchase.value) {
      minBulkPurchase.value = data.min_bulk_purchase
      bulkPurchasePrice.value = data.bulk_purchase_price
    }
  } catch (err) {
    console.error('err:', err)
    alerMessage.value.messages = err.response.data.error || MESSAGES.DEFAULT_ERROR_MESSAGE
    alerMessage.value.show = true
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  txtCode.value.focus()
})

if (route.params.id != 0) {
  id.value = route.params.id
  getProduct()
}
</script>
