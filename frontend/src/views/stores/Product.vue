<template>
  <div class="container is-widescreen">
    <section class="section" v-if="error">
      <div class="container is-widescreen">
        <div class="notification is-danger">{{ error }}</div>
      </div>
    </section>
    <section class="hero">
      <div class="hero-body">
        <p class="title" style="display: inline-block"> {{ $route.params.name }}</p>
      </div>
    </section>
    <section class="section">
        <div id="noCardNoti" class="notification has-text-centered is-danger is-light" v-if="productList.length == 0">
            <button class="delete" @click="closeNoti"></button>
            No Product Available
        </div>
        <div class="columns">
            <div class="column is-7">
                <div class="columns is-multiline">
                    <div class="column is-6" v-for='product in productList' :key="product.product_id">
                        <div class="card has-background-light">
                          <div class="card-image pt-5">
                            <figure class="image">
                              <img :src="'http://localhost:3000' + product.product_image" alt="Placeholder image" />
                            </figure>
                          </div>
                          <div class="card-content">
                              <div class="content"><i class="fas fa-box"/> สินค้า : {{ product.product_name }}</div>
                              <div class="content"><i class="fas fa-dollar-sign"/> ราคา : {{ product.product_price }}</div>
                          </div>
                          <footer class="card-footer">
                              <a class="card-footer-item" @click="addItem(product)">Add to Cart</a>
                          </footer>
                        </div>
                        <br>
                    </div>
                </div>
            </div>
            <div class="column is-5">
                <div class="card has-background-light">
                    <div class="card-header">
                        <p class="card-header-title"><i class="fas fa-shopping-cart" style="margin-right: 10px"/> สินค้าในตะกร้า (ราคารวม : {{cartTotal}}฿)</p>
                    </div>
                    <div class="card-content">
                        <div class="content" v-for="cart,index in carts" :key="cart.product.product_name">
                          <div class="columns is-multiline">
                            <div class="column is-5">
                            - {{cart.product.product_name}} [{{cart.product.product_price}}฿]
                            </div>
                            <div class="column is-7 has-text-right">
                              <button class="button is-small" style="margin-left: 100px; margin-right: 10px" @click="removeQuantity(cart, index)"><i class="fas fa-minus"></i></button>
                              {{cart.quantity}}
                              <button class="button is-small" style="margin-left: 10px; margin-right: 10px" @click="addQuantity(cart)"><i class="fas fa-plus"></i></button>
                              <button class="delete has-background-danger" @click="removeItem(index)"></button>
                            </div>
                          </div>
                        </div>
                    </div>
                    <footer class="card-footer">
                        <a class="card-footer-item" @click="checkOut">Check out</a>
                    </footer>
                </div>
            </div>
        </div>
      <div class="modal" :class="{'is-active':modalActive,'':modalActive==false}">
        <div class="modal-background"></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">กรุณาเลือกบัตรของท่าน</p>
            <button class="delete" aria-label="close" @click="modalActive?modalActive=false:modalActive"></button>
          </header>
          <section class="modal-card-body">
            <!-- Content ... -->
            <label>Select Account : </label>
            <select class="select" v-model="accountNumber" @change="getCard(accountNumber)">
              <option value="selectAccount" selected>Select Account</option>
              <option v-for="account in accountList" :key="account.account_number" :value="account.account_number">{{account.account_number}} [{{account.balance}}฿]</option>
            </select>
            <br><br>
            <label>Select Card : </label>
            <select class="select" v-model="cardNumber">
              <option value="selectCard" selected>Select Card</option>
              <option v-for="card in cardList" :key="card.card_number" :value="card.card_number" v-show="card.status=='Active'">{{card.card_number}}</option>
            </select>
          </section>
          <footer class="modal-card-foot">
            <button class="button is-success" @click="confirmCheckOut">ยืนยัน</button>
            <button class="button" @click="closeModal">ยกเลิก</button>
          </footer>
        </div>
      </div>
    </section>
    <router-link class="card-footer-item" to="/store">To Store Page</router-link>
  </div>
</template>

<script>
import axios from '@/plugins/axios'

export default {
  props: ['user'],
  data() {
    return {
      productList: {},
      carts: [],
      cartTotal: 0,
      cartQuantity: {},
      modalActive: false,
      accountList: [],
      accountNumber: 'selectAccount',
      cardList: [],
      cardNumber: 'selectCard',
      error: null,
    };
  },
  mounted() {
    this.getProduct(this.$route.params.id);
    this.getAccount(this.user.user_id);
  },
  methods: {
    addQuantity(cart){
      cart.quantity++
      this.cartTotal += cart.product.product_price
    },
    removeQuantity(cart, index){
      if(cart.quantity <= 1){
        this.carts.splice(index, 1)
        this.cartTotal -= cart.product.product_price
      }
      else{
        cart.quantity--
        this.cartTotal -= cart.product.product_price
      }
    },
    closeModal(){
        this.modalActive = false
        this.accountNumber = ''
        this.cardNumber = ''
        this.cardList = []
        this.accountNumber = 'selectAccount'
        this.cardNumber = 'selectCard'
    },
    confirmCheckOut(){
      if (this.accountNumber == 'selectAccount'){
        alert('Please select account')
        return false
      }
      else if (this.cardNumber == 'selectCard'){
        alert('Please select card')
        return false
      }
      axios
        .put(`http://localhost:3000/store/checkout/${this.cardNumber}`,{
          params:{
            cardNumber: this.cardNumber,
            storeId: this.$route.params.id,
            amount: this.cartTotal,
            accountNumber: this.accountNumber,
          }
        })
        .then((response) => {
          if(response.data != 'success!'){
            alert(response.data + '. Please select another account/card')
            this.accountNumber = 'selectAccount'
            this.cardNumber = 'selectCard'
          }
          else{
            this.carts = []
            this.cartTotal = 0
            this.closeModal()
          }
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
        
    },
    checkOut(){
      if(this.carts.length > 0){
        this.modalActive = true
      }
      else{
        alert('ไม่มีสินค้าในตะกร้า')
      }
    },
    addItem(product){
        let checkcart = this.carts.find(x=>x.product.product_name==product.product_name)
        if (checkcart){
          checkcart.quantity++
        }
        else{
          this.carts.push({product: product, quantity: 1})
        }
        this.cartTotal += product.product_price
    },
    removeItem(index){
        this.cartTotal -= this.carts[index].product.product_price * this.carts[index].quantity
        this.carts.splice(index, 1)
    },
    closeNoti(){
      document.getElementById('noCardNoti').style.display = 'none'
    },
    getCard(accountNumber) {
      axios
        .get(`http://localhost:3000/cards/${accountNumber}`)
        .then((response) => {
          this.cardList = response.data.creditCard;
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
    },
    getAccount(userId) {
      axios
        .get(`http://localhost:3000/account/${userId}`)
        .then((response) => {
          this.accountList = response.data.accountList;
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
    },
    getProduct(storeNumber) {
      axios
        .get(`http://localhost:3000/store/${storeNumber}`)
        .then((response) => {
          this.productList = response.data.product
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
    },
    isEmployee() {
      if (!this.user) return false
      return this.user.role === 'employee'
    },
  },
};
</script>