<template>
  <div class="container is-widescreen">
    <section class="section" v-if="error">
      <div class="container is-widescreen">
        <div class="notification is-danger">
          {{ error }}
        </div>
      </div>
    </section>
    <section class="hero">
      <div class="hero-body">
        <p class="title">Create a account</p>
      </div>
    </section>
    <section class="px-6">

      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Bank name</label>
            <div class="control">
              <input :value="user.bank_name" class="input" type="text" disabled/>
            </div>
          </div>
        </div>
      </div>
      
      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Employee name</label>
            <div class="control">
              <input v-model="empName" class="input" type="text" disabled/>
            </div>
          </div>
        </div>
      </div>

      <div class="field">
        <label class="label">Select account name</label>
        <div class="control">
          <div class="select is-12">
            <select v-model="selectUser">
              <option value="selectUser" selected>Select user</option>
              <option v-for="user in userList" :key="user.user_id" :value="user.user_id">{{ user.fname }} {{ user.lname }}</option>
            </select>
          </div>
        </div>
      </div>

      <div class="field is-grouped">
        <div class="control">
          <button @click="showModal" class="button is-link">Submit</button>
        </div>
        <div class="control">
          <button @click="$router.go(-1)" class="button is-link is-light">Cancel</button>
        </div>
      </div>

      <div class="modal" :class="{'is-active':modalActive,'':modalActive==false}">
        <div class="modal-background"></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">ข้อกำหนดการร้องขอทำบัตร</p>
            <button class="delete" aria-label="close" @click="modalActive?modalActive=false:modalActive"></button>
          </header>
          <section class="modal-card-body">
            <!-- Content ... -->
            - ต้องมีอายุมากกว่าหรือเท่ากับ 18 ปีบริบูรณ์<br>
            - ต้องมีเงินเดือนมากกว่า 20,000 บาท/เดือน
          </section>
          <footer class="modal-card-foot">
            <button class="button is-success" @click="submitModal">ยอมรับ</button>
            <button class="button" @click="modalActive?modalActive=false:modalActive">ยกเลิก</button>
          </footer>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import axios from '@/plugins/axios'

export default {
  props: ['user'],
  data() {
    return {
      error: null,
      bank_id : '',
      bank_name: '',
      empName: '',
      isActive: false,
      modalActive: false,
      acceptModal: false,
      userList: [],
      selectUser : 'selectUser',
    };
  },
  mounted(){
    this.setForm(this.$route.params.id, this.$route.params.bank_name)
    this.getUser()
  },
  created(){
    this.bank_id = this.$route.params.id
    this.bank_name = this.$route.params.bank_name
  },
  methods: {
    setForm(bank_id, bank_name){
      this.bank_id = bank_id
      this.bank_name = bank_name
      this.empName = this.user.fname + ' ' + this.user.lname
    },
    getUser(){
      axios
        .get("http://localhost:3000/user")
        .then((res) => this.userList = res.data.userList)
        .catch((e) => console.log('error'))
    },
    showModal(){
      if (this.selectUser == 'selectUser'){
        alert('Please select account name.')
      }
      else{
        this.modalActive = true
      }
    },
    submitModal() {
      let formData = new FormData();
      formData.append("bank_id", this.bank_id);
      formData.append("user_id", this.selectUser);
      axios
        .post("http://localhost:3000/account", formData)
        .then((res) => this.$router.go(-1))
        .catch((e) => console.log(e.response.data));
    },
  },
};
</script>

<style>
</style>