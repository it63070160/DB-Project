<template>
  <div class="container is-widescreen">
    <section class="hero">
      <div class="hero-body">
        <p class="title">Bank</p>
      </div>
    </section>
    <div class="card mb-5" id="app" v-for="bank in banks" :key="bank.bank_id">
      <div class="card-content">
        <div class="content">
        <h3 class="is-size-3"><i class="fas fa-landmark has-text-success-light has-background-primary is-size-4" aria-hidden="true"></i> {{ bank[0] }}</h3>
        <ul v-for="branch in bank[1]" :key="branch.branch_id" class="has-text-black">
          <li class="has-text-weight-bold">{{ branch.branch_name }}</li>
          <dd>Location : {{branch.branch_location }}</dd>
          <dd>Manager : {{branch.emp_fname}} {{branch.emp_lname}}</dd>
        </ul>
      </div>
    </div>
  </div>
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
      banks: [],
    };
  },
  mounted() {
    this.getBank();
  },
  methods: {
    getBank() {
      axios
        .get("http://localhost:3000/bank")
        .then((response) => {
          this.banks = response.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>
