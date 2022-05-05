<template>
  <div class="container is-widescreen">
    <section class="section" v-if="error">
      <div class="container is-widescreen">
        <div class="notification is-danger">{{ error }}</div>
      </div>
    </section>
    <section class="hero">
      <div class="hero-body">
        <p class="title" style="display: inline-block">Account Number : {{ $route.params.id }}</p>
        <router-link v-if="isEmployee()" :to="`/cards/${this.$route.params.id}/create`" class="button is-primary" style="margin-left: 20px">
          <strong>Create Card</strong>
        </router-link>
        <p v-if="isEmployee()"> {{ user.bank_name }} ({{ user.branch_name }})</p><br>
      </div>
      
    </section>
    <section class="section">
      <div id="noCardNoti" class="notification has-text-centered is-danger is-light" v-if="creditCardList.length == 0">
        <button class="delete" @click="closeNoti"></button>
        No Card Available
      </div>
      <div class="columns is-multiline">
        <div class="column is-6" v-for='card in creditCardList' :key="card.card_number">
          <div class="card has-background-light">
            <div class="card-content" v-if="editToggle!=1 || editCardNum != card.card_number">
              <div class="content"><i class="fas fa-credit-card"/> หมายเลขบัตร : {{ card.card_number }}</div>
              <div class="content"><i class="fas fa-dollar-sign"/> วงเงิน : {{ card.limit }} (คงเหลือ : {{ card.limit - card.sum }})</div>
              <div class="content"><i class="fas fa-dollar-sign" style="color: red"/> ยอดค้างชำระ : {{ card.outstanding_balance }}</div>
              <div class="content"><i class="fas fa-percent"/> ดอกเบี้ย : {{ card.interest }} %</div>
              <div class="content"><i class="fas fa-calendar"/> วันออกบัตร : {{ card.issue_date.substring(0, 10) }}</div>
              <div class="content"><i class="fas fa-calendar-minus"/> วันหมดอายุ : {{ card.exp_date.substring(0, 10) }}</div>
              <div class="content"><i class="fas fa-signal"/> สถานะ : <p :class="{'has-text-success': card.status == 'Active', 'has-text-warning': card.status == 'Reject', 'has-text-danger': card.status == 'Closed'}" style="display: inline-block">{{ card.status }}</p></div>
            </div>
            <div class="card-content" v-if="editToggle==1 && editCardNum == card.card_number && isEmployee()">
              <div class="content">หมายเลขบัตร<input class="input" type="text" v-model="editCardNum" disabled/></div>
              <div class="content">วงเงิน<input class="input" type="text" v-model="editCardLimit"/></div>
              <div class="content">ยอดค้างชำระ<input class="input" type="text" v-model="editCardOSB"/></div>
              <div class="content">ดอกเบี้ย<input class="input" type="text" v-model="editCardInterest"/></div>
              <div class="content">วันออกบัตร<input class="input" type="date" v-model="editCardIssue" disabled/></div>
              <div class="content">วันหมดอายุ<input class="input" type="date" v-model="editCardExp"/></div>
              <div class="content">
                Status
                <select class="input" v-model="editCardStatus">
                  <option>Active</option>
                  <option>Reject</option>
                  <option>Closed</option>
                </select>
              </div>
            </div>
            <footer class="card-footer" v-if="editToggle!=1 || editCardNum != card.card_number">
              <a class="card-footer-item" @click="manageCard(card)" v-if="isEmployee()">
                <span>Manage this card</span>
              </a>
            </footer>
            <footer class="card-footer" v-if="editToggle==1 && editCardNum == card.card_number && isEmployee()">
              <a class="card-footer-item" @click="saveEditCard(card)">Save</a>
              <a class="card-footer-item" @click="editToggle=-1">
                <span>Cancel</span>
              </a>
            </footer>
          </div>
          <br>
        </div>
      </div>
    </section>
    <router-link class="card-footer-item" to="/">To Home Page</router-link>
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
      editToggle: -1,
      editCardNum: "",
      editCardLimit: 0.0,
      editCardOSB: 0.0,
      editCardInterest: 0.0,
      editCardIssue: "",
      editCardExp: "",
      editCardStatus: "",
    };
  },
  mounted() {
    this.getCardDetail(this.$route.params.id);
  },
  methods: {
    closeNoti(){
      document.getElementById('noCardNoti').style.display = 'none'
    },
    getCardDetail(accountNumber) {
      axios
        .get(`http://localhost:3000/cards/${accountNumber}`)
        .then((response) => {
          this.creditCardList = response.data.creditCard;
          if(this.creditCardList.length > 0){
            for(let i=0; i<this.creditCardList.length; i++){
              this.creditCardList[i].issue_date = this.creditCardList[i].issue_date.toString().substring(0, 8)+(parseInt(this.creditCardList[i].issue_date.toString().substring(8, 10))+1).toString().toFixed(2, '0')
              this.creditCardList[i].exp_date = this.creditCardList[i].exp_date.toString().substring(0, 8)+(parseInt(this.creditCardList[i].exp_date.toString().substring(8, 10))+1).toString().toFixed(2, '0')
            }
          }
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
    },
    saveEditCard(card) {
      let formData = new FormData();
      formData.append("cardLimit", this.editCardLimit);
      formData.append("cardIssue", this.editCardIssue);
      formData.append("cardExp", this.editCardExp);
      formData.append("cardStatus", this.editCardStatus);
      formData.append("cardOSB", this.editCardOSB);
      formData.append("cardInterest", this.editCardInterest);
      card.outstanding_balance = this.editCardOSB
      card.interest = this.editCardInterest
      card.limit = this.editCardLimit
      card.exp_date = this.editCardExp
      card.status = this.editCardStatus
      axios
        .put(`http://localhost:3000/card/${card.card_number}`, formData)
        .then((response) => {
          if(response.data != 'success!'){
            alert(response.data)
          }
          else{
            this.editToggle = -1;
          }
        })
        .catch((error) => {
          this.error = error.message;
        });
    },
    manageCard(card) {
      this.editToggle = 1
      this.editCardNum = card.card_number
      this.editCardLimit = card.limit
      this.editCardOSB = card.outstanding_balance
      this.editCardInterest = card.interest
      this.editCardIssue = card.issue_date.substring(0, 10)
      this.editCardExp = card.exp_date.substring(0, 10)
      this.editCardStatus = card.status
    },
    isEmployee() {
      if (!this.user) return false
      return this.user.role === 'employee'
    },
  },
};
</script>