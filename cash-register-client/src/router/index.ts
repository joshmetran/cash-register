import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/userStore'

import HomeView from '../views/HomeView.vue'

import Login from '@/views/user-session/Login.vue'
import Logout from '@/views/user-session/Logout.vue'

import ProductsView from '@/views/products/ProductsView.vue'
import ProductView from '@/views/products/ProductView.vue'

import OrdersView from '@/views/orders/OrdersView.vue'

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
          meta: { requiresAuth: true, showNav: true, layout: 'DefaultLayout' },
        },
        {
          path: 'orders',
          name: 'orders',
          component: OrdersView,
          meta: { requiresAuth: true, showNav: true, layout: 'DefaultLayout' },
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
          meta: { requiresAuth: true, layout: 'DefaultLayout' },
          children: [
            {
              path: '',
              name: 'home',
              component: HomeView,
              meta: { showNav: true },
            },
            {
              path: 'new',
              name: 'new_article',
              component: HomeView,
              meta: { showNav: true },
            },
            {
              path: 'update/:slug',
              name: 'updateArticle',
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
