import { faUser } from '@fortawesome/free-solid-svg-icons'
import Vue from 'vue'
import VueRouter from 'vue-router'
import axios from '@/plugins/axios'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/accounts/detail/:id',
    name: 'detail',
    meta: { login: true },
    component: () => import('../views/accounts/DetailAccount.vue')
  },
  {
    path: '/cards/:id/create',
    name: 'create-card',
    meta: { login: true, employee : true },
    component: () => import('../views/accounts/CreateCard.vue')
  },
  {
    path: '/user/signup',
    name: 'signup',
    meta: { guess: true },
    component: () => import('../views/Signup.vue')
  },
  {
    path: '/user/login',
    name: 'login',
    meta: { guess: true },
    component: () => import('../views/Login.vue')
  },
  {
    path: '/bank',
    name: 'bank',
    component: () => import('../views/Bank.vue')
  },
  {
    path: '/account/:id/create',
    name: 'create-account',
    meta : { login: true, employee : true },
    component: () => import('../views/accounts/CreateAccount.vue')
  },
  {
    path: '/transaction',
    name: 'transaction',
    meta: { login: true, customer : true },
    component: () => import('../views/Transaction.vue')
  },
  {
    path: '/store',
    name: 'store',
    meta: { login: true, customer : true },
    component: () => import('../views/Store.vue')
  },
  {
    path: '/store/detail/:id',
    name: 'product',
    meta: { login: true, customer : true },
    component: () => import('../views/stores/Product.vue')
  },
]

const router = new VueRouter({ routes })

router.beforeEach((to, from, next) => {
  const isLoggedIn = !!localStorage.getItem('token')

  if (to.meta.login && !isLoggedIn) {
    alert('Please login first!')
    next({ path: '/user/login' })
  }
  else{
    axios.get('/user/me').then(res => {
      var user = res.data

      if (to.meta.employee && (user.role != 'employee')){
        alert("You don't permision to access this page")
        next({ path: '/' })
      }

      if (to.meta.customer && (user.role != 'customer')){
        alert("You don't permision to access this page")
        next({ path: '/' })
      }
    })
  }

  if (to.meta.guess && isLoggedIn) {
    alert("You've already logged in")
    next({ path: '/'})
  }

  next()
})

export default router
