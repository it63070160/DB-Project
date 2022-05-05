<template>
  <div class="container is-widescreen">
    <section class="hero">
      <div class="hero-body">
        <p class="title">Store</p>
      </div>
    </section>
    <section class="section" id="app">
      <div class="content">
        <div class="columns is-multiline">
          <div class="column is-3" v-for="store in stores" :key="store.store_id">
            <div class="card">
              <div class="card-content">
                <div class="content"><i class="fas fa-store" aria-hidden="true"></i> {{ store.store_name }}</div>
              </div>
              <footer class="card-footer">
                <router-link class="card-footer-item" :to="{ name: 'product', params : { id : `${store.store_id}`, name : `${store.store_name}` }}">View Products ...</router-link>
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
      stores: [],
    };
  },
  mounted() {
    this.getStores();
  },
  methods: {
    getStores() {
      axios
        .get("http://localhost:3000/store")
        .then((response) => {
          this.stores = response.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>
