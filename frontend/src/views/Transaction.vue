<template>
  <div class="container is-widescreen">
    <section class="hero">
      <div class="hero-body">
        <p class="title">Transaction</p>
      </div>
      <div id="noCardNoti" class="notification has-text-centered is-danger is-light" v-if="transactions.length == 0">
        <button class="delete" @click="closeNoti"></button>
        No Transactions Data
    </div>
      <div class="field">
        <div class="has-text-right">
          <label>Order By </label>
          <select class="select" v-model="order" @change="getTransaction">
            <option value="date_time DESC" selected>Date time DESC</option>
            <option value="card_number">Card number</option>
          </select>
        </div>
      </div>
    </section>
    
    <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth mt-6">
      <thead>
        <tr class="tr is-selected">
          <th>Transaction id</th>
          <th>Card Number</th>
          <th>Store name</th>
          <th>Date/time</th>
          <th>Amount</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="transaction in transactions"
          :key="transaction.transaction_id"
        >
          <td>{{ transaction.transaction_id }}</td>
          <td>{{ transaction.card_number }}</td>
          <td>{{ transaction.store_name }}</td>
          <td>{{ transaction.date_time }}</td>
          <td>{{ transaction.amount }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
// @ is an alias to /src
export default {
  name: "Bank",
  props: ["user"],
  data() {
    return {
      transactions: [],
      order: "date_time DESC",
    };
  },
  mounted() {
    this.getTransaction();
  },
  methods: {
    closeNoti(){
      document.getElementById('noCardNoti').style.display = 'none'
    },
    getTransaction() {
      axios
        .get("http://localhost:3000/transaction", {
          params: {
            order: this.order,
          },
        })
        .then((response) => {
          this.transactions = response.data.transaction;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>