<template>
  <div class="container is-widescreen">
    <section claas="hero" v-if="isLoggedIn()">
      <div class="hero-body">
        <p class="title">ยินดีต้อนรับเข้าสู่ Ploikong</p>
        <p>กรุณา
          <router-link to="/user/login" class="has-text-info">
            <strong>เข้าสู่ระบบ</strong>
          </router-link> หรือ 
          <router-link to="/user/signup" class="has-text-info">
            <strong>สมัครสมาชิก</strong>
          </router-link></p>
      </div>
    </section>
    <section class="hero" v-else>
      <div class="hero-body">
        <p class="title" v-if="isEmployee()">All Account
          <router-link :to="{ name: 'create-account', params : { id : `${bank_id}`, bank_name : `${bank_name}` }}" class="button is-primary" style="margin-left: 20px">
            <strong>Create Account</strong>
          </router-link>
        </p>
        <p class="title" v-else>My Account</p>
        <p v-if="isEmployee()"> Search in {{ user.bank_name }} ({{ user.branch_name }})</p>
        <div class="columns" v-if="isEmployee()">
          <div class="column is-half">
            <input class="input" type="text" v-model="search" placeholder="Search Account Number"/>
          </div>
          <div class="column is-half">
            <button @click="getAccounts" class="button">Search</button>
          </div>
        </div>
        
        <div class="columns">
          <div class="column is-half">
            <label>Order By </label>
            <select class="select" v-model="order" @change="getAccounts">
              <option value="account_number" selected>Account number</option>
              <option value="balance">Balance</option>
            </select>
          </div>
        </div>
      </div>
      <div id="noCardNoti" class="notification has-text-centered is-danger is-light" v-if="accounts.length == 0">
          <button class="delete" @click="closeNoti"></button>
          No Account Available
      </div>
    </section>
    <section class="section" id="app">
      <div class="content">
        <div class="columns is-multiline">
          <div class="column is-3" v-for="account in accounts" :key="account.account_number">
            <div class="card">
              <div class="card-content">
                <div class="title">{{ account.title }}</div>
                <div class="content"><i class="fas fa-money-check" aria-hidden="true"></i> Account Number : {{ account.account_number }}</div>
                <div class="content"><i class="fas fa-address-card" aria-hidden="true"></i> Name : {{ account.fname }}  {{ account.lname }}</div>
                <div class="content"><i class="fas fa-dollar-sign" aria-hidden="true"></i> Balance : {{ account.balance }}</div>
                <div class="content" v-if="account.type == 'DEPOSIT_ACCOUNT'"><i class="fas fa-address-book" aria-hidden="true"></i> Account Type : Deposit Account</div>
                <div class="content" v-if="account.type == 'CREDIT_ACCOUNT'"><i class="fas fa-address-book" aria-hidden="true"></i> Account Type : Credit Account</div>
                <div class="content"><i class="fas fa-landmark" aria-hidden="true"></i> Bank : {{ account.bank_name }}</div>
              </div>
              <footer class="card-footer">
                <router-link class="card-footer-item" :to="`/accounts/detail/${account.account_number}`">View Card ...</router-link>
              </footer>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import axios from '@/plugins/axios'
// @ is an alias to /src
export default {
  name: "Home",
  props: ['user'],
  data() {
    return {
      search: "",
      accounts: [],
      order: "account_number",
      bank_id: '',
      bank_name: '',
      branch_name: '',
    };
  },
  mounted() {
    this.getAccounts();
  },
  methods: {
    closeNoti(){
      document.getElementById('noCardNoti').style.display = 'none'
    },
    getAccounts() {
      axios
        .get("http://localhost:3000", {
          params: {
            search: this.search,
            order: this.order,
          },
        })
        .then((response) => {
          this.accounts = response.data;
          if (this.isEmployee()){
            this.bank_id = this.accounts[0].bank_id
            this.bank_name = this.accounts[0].bank_name
            this.branch_name = this.accounts[0].branch_name
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    isEmployee() {
      if (!this.user) return false
      return this.user.role === 'employee'
    },
    isLoggedIn(){
      if (!this.user) return true
      return false
    }
  },
};
</script>
