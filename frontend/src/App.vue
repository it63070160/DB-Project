<style>
  @import url('https://fonts.googleapis.com/css2?family=Fira+Sans&display=swap%27');
</style>
<template>
  <div id="app" style="font-family: 'Fira Sans', sans-serif;">
    <!-- nav bar -->
    <nav class="navbar is-info" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <router-link to="/" class="navbar-item is-size-4">
          <i class="fas fa-landmark" style="margin-right: 10px;" aria-hidden="true"></i>Ploikong
        </router-link>
      
        <a
          role="button"
          class="navbar-burger"
          aria-label="menu"
          aria-expanded="false"
          data-target="navbarBasicExample"
          v-show="burgerActive==false"
          @click="burgerActive=true"
        >
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
        <a
          role="button"
          class="navbar-burger"
          aria-label="menu"
          aria-expanded="false"
          data-target="navbarBasicExample"
          v-show="burgerActive==true"
          @click="burgerActive=false"
        >
        <i class="fas fa-angle-right" style="margin-top: 18px; margin-left: 23px" aria-hidden="true"></i>
        </a>
        <router-link to="/store" class="navbar-item" v-if="user && burgerActive && isCustomer()">Store</router-link>
        <router-link to="/transaction" class="navbar-item " v-if="user && burgerActive && isCustomer()">Transaction</router-link>
        <router-link to="/bank" class="navbar-item" v-if="burgerActive">Bank</router-link>
        <a class="navbar-item" v-if="user && burgerActive" @click="logOut()">Log out</a>
      </div>

      <div class="navbar-menu">
        <div class="navbar-start">
          <router-link to="/store" class="navbar-item" v-if="isCustomer()">Store</router-link>
          <router-link to="/transaction" class="navbar-item " v-if="isCustomer()">Transaction</router-link>
          <router-link to="/bank" class="navbar-item">Bank</router-link>
        </div>
        <div class="navbar-end">
          <div class="navbar-item">
            {{ time }}
          </div>
          <div v-if="user" class="navbar-item has-dropdown is-hoverable">
            <a class="navbar-link">
              <i class="fas fa-user" style="margin-right: 1px;" aria-hidden="true"></i>
              <span class="pl-3">{{ user.fname }} {{ user.lname }}</span>
            </a>
            <div class="navbar-dropdown">
              <a class="navbar-item" @click="logOut()">Log out</a>
            </div>
          </div>

          <div v-if="!user" class="navbar-item">
            <router-link to="/user/login" class="has-text-light">
              <strong>Login</strong>
            </router-link>
          </div>
          <div v-if="!user" class="navbar-item">
            <router-link to="/user/signup" class="has-text-light">
              <strong>Signup</strong>
            </router-link>
          </div>
        </div>
      </div>
    </nav>
    
    <router-view :key="$route.fullPath" @auth-change="onAuthChange" :user="user" />

  </div>
  
</template>

<script>
import axios from '@/plugins/axios'
export default {
  data () {
    return {
      user: null,
      time: null,
      interval: null,
      burgerActive: false,
    }
  },
  beforeDestroy() {
    clearInterval(this.interval)
  },
  created() {
    // update time
    this.interval = setInterval(() => {
      this.time = new Intl.DateTimeFormat('en-GB', { dateStyle: 'short', timeStyle: 'medium'}).format(new Date());
    }, 1000)
  },
  mounted () {
    this.onAuthChange()
  },
  methods: {
    onAuthChange () {
      const token = localStorage.getItem('token')
      if (token) {
        this.getUser()
      }
    },
    getUser () {
      axios.get('/user/me').then(res => {
        this.user = res.data
      })
    },
    logOut(){
      this.user = null
      localStorage.removeItem('token')
      this.$router.push('/user/login')
    },isCustomer() {
      if (!this.user) return false
      return this.user.role === 'customer'
    },
  }
}
</script>