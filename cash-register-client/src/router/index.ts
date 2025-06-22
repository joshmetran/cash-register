import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/userStore'

import HomeView from '../views/HomeView.vue'

import Login from '@/views/user-session/Login.vue'
import Logout from '@/views/user-session/Logout.vue'

import ProductsView from '@/views/products/ProductsView.vue'
import ProductView from '@/views/products/ProductView.vue'

import OrdersView from '@/views/orders/OrdersView.vue'
import OrderView from '@/views/orders/OrderView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: import.meta.env.VITE_BASE_URL,
      meta: { layout: 'BlankLayout' },
      children: [
        {
          path: 'login',
          name: 'login',
          meta: { layout: 'BlankLayout' },
          component: Login,
        },
        {
          path: 'logout',
          name: 'logout',
          meta: { layout: 'BlankLayout' },
          component: Logout,
        },
        {
          path: '',
          name: 'main',
          component: HomeView,
          meta: { requiresAuth: true, showNav: true, layout: 'BlankLayout' },
        },
        {
          path: 'orders',
          name: 'orders',
          component: OrdersView,
          meta: { requiresAuth: true, showNav: true, layout: 'DefaultLayout' },
        },
        {
          path: 'orders',
          meta: { requiresAuth: true, layout: 'DefaultLayout', showNav: true },
          children: [
            {
              path: '',
              name: 'orders',
              component: OrdersView
            },
            {
              path: ':id',
              name: 'order',
              component: OrderView
            },
          ],
        },
        {
          path: 'products',
          meta: { requiresAuth: true, layout: 'DefaultLayout' },
          children: [
            {
              path: '',
              name: 'products',
              component: ProductsView,
              meta: { showNav: true },
            },
            {
              path: ':id',
              name: 'product',
              component: ProductView,
              meta: { showNav: true },
            },
          ],
        },
        {
          path: 'home',
          meta: { requiresAuth: true, layout: 'BlankLayout' },
          children: [
            {
              path: '',
              name: 'home',
              component: HomeView,
              meta: { showNav: true },
            },
          ],
        },
      ],
    },
  ],
})

router.beforeEach(async (to) => {
  const userStore = useUserStore()

  if (to.meta.requiresAuth && !userStore.hasUser()) {
    return {
      path: '/login',
    }
  }
})

export default router
