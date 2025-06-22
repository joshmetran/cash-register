<template>
  <v-app>
    <v-main>
      <v-navigation-drawer v-if="$route.meta.showNav" v-model="drawer" width="250">
        <div class="px-10 py-16 bg-lightblue mb-8">
          <img class="mx-auto" src="/img/amenitiz-logo.svg" />
        </div>
        <v-list>
          <v-list-item
            prepend-avatar="/img/profile_pic.jpg"
            :subtitle="userStore.currentUser.email"
            :title="userStore.currentUser.name"
          >
          </v-list-item>
        </v-list>

        <v-divider></v-divider>

        <v-list class="mt-8" density="compact" nav>
          <template v-for="section in sections" :key="section.name">
            <v-list-item
              v-if="section.type == 'link'"
              :prepend-icon="section.icon"
              :title="section.name"
              :to="section.route"
            ></v-list-item>

            <v-list-group v-else :value="section.name">
              <template v-slot:activator="{ props }">
                <v-list-item
                  v-bind="props"
                  :prepend-icon="section.icon"
                  :title="section.name"
                ></v-list-item>
              </template>

              <v-list-item
                v-for="child in section.children"
                :key="child.name"
                :value="child.name"
                :title="child.name"
                :prepend-icon="child.icon"
                :to="child.route"
              ></v-list-item>
            </v-list-group>
          </template>
        </v-list>
      </v-navigation-drawer>
      <v-app-bar v-if="$route.meta.showNav">
        <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
        <v-toolbar-title>Cashier Register System</v-toolbar-title>
      </v-app-bar>

      <SnackBar />
      <Loader />
      <component :is="layout"></component>
    </v-main>
  </v-app>
</template>

<script setup>
import { shallowRef } from 'vue'
import router from './router'
import layouts from './layouts'
import SnackBar from '@/components/SnackBar.vue'
import Loader from '@/components/Loader.vue'
import { ref, watch } from 'vue'
import { useUserStore } from '@/stores/userStore'

const layout = shallowRef('div')

const drawer = ref(true)
const sections = ref([])

router.afterEach((to) => {
  layout.value = layouts[to.meta.layout]
})

const userStore = useUserStore()

watch(
  () => userStore.signedIn,
  () => {
    if (userStore.signedIn == '1') {
      initSections()
    }
  },
)

watch(
  () => userStore.goTo,
  () => {
    if (userStore.goTo?.name) {
      router.push(userStore.goTo.name)
      userStore.goTo.name = ''
    }
  },
)

function initSections() {
  sections.value = [
    {
      id: 1,
      name: 'Cashier',
      icon: 'mdi-currency-eur',
      route: { name: 'home' },
      type: 'link',
      active: false,
    },
    {
      id: 2,
      name: 'Products',
      icon: 'mdi-file-document-multiple-outline',
      route: { name: 'products' },
      type: 'link',
      active: false,
    },
    {
      id: 3,
      name: 'Orders',
      icon: 'mdi-shopping-outline',
      route: { name: 'orders' },
      type: 'link',
      active: false,
    },
    {
      id: 4,
      name: 'Logout',
      icon: 'mdi-logout',
      route: { name: 'logout' },
      type: 'link',
      active: false,
    },
  ]
}

userStore.getCurrentUser()
initSections()
</script>
