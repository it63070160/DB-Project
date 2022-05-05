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
        <p class="title">Create a card</p>
      </div>
    </section>
    <section class="px-6">
      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Account Number</label>
            <div class="control">
              <input v-model="accountnumber" class="input" type="text" disabled/>
            </div>
          </div>
        </div>
      </div>
      
      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Interest (%)</label>
            <div class="control">
              <input v-model="interest" class="input" type="number" step="0.01" placeholder="Interest for this card"/>
            </div>
          </div>
        </div>
      </div>

      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Limit</label>
            <div class="control">
              <input v-model="limit" class="input" type="number" step="0.01" placeholder="Limit for this card"/>
            </div>
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
      creditCardList: {},
      error: null,
      accountnumber: '',
      interest: 0,
      limit: 0,
      isActive: false,
      isActive2: false,
      modalActive: false,
      acceptModal: false,
    };
  },
  mounted() {
    this.getCardDetail(this.$route.params.id);
  },
  created(){
    this.accountnumber = this.$route.params.id
  },
  methods: {
    getCardDetail(accountNumber) {
      axios
        .get(`http://localhost:3000/blogs/${accountNumber}`)
        .then((response) => {
          this.creditCardList = response.data.creditCard;
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
    },
    showModal(){
      this.modalActive = true
    },
    submitModal() {
      let formData = new FormData();
      formData.append("accountnumber", this.accountnumber);
      formData.append("interest", this.interest);
      formData.append("limit", this.limit);
      formData.append("cardType", this.cardType==1?"CREDIT_ACCOUNT":"DEPOSIT_ACCOUNT");

      axios
        .post("http://localhost:3000/cards", formData)
        .then((res) => this.$router.go(-1))
        .catch((e) => console.log(e.response.data));
    },
  },
};
</script>

<style>
</style>