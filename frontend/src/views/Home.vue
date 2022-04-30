<template>
  <div class="container is-widescreen">
    <section class="hero">
      <div class="hero-body">
        <p class="title">My Account</p>
        <!-- <div class="columns">
          <div class="column is-half">
            <input class="input" type="text" v-model="search" placeholder="Search card(s)" />
          </div>
          <div class="column is-half">
            <button @click="getBlogs" class="button">Search</button>
          </div>
        </div> -->
      </div>
    </section>
    <section class="section" id="app">
      <div class="content">
        <div class="columns is-multiline">
          <div class="column is-3" v-for="blog in blogs" :key="blog.account_number">
            <div class="card">
              <!-- <div class="card-image pt-5">
                <figure class="image">
                  <img
                    style="height: 120px"
                    :src="imagePath(blog.file_path)"
                    alt="Placeholder image"
                  />
                </figure>
              </div> -->
              <div class="card-content">
                <div class="title">{{ blog.title }}</div>
                <div class="content"><i class="fas fa-money-check" aria-hidden="true"></i> Account Number : {{ blog.account_number }}</div>
                <div class="content"><i class="fas fa-dollar-sign" aria-hidden="true"></i> Balance : {{ blog.balance }}</div>
                <div class="content" v-if="blog.type == 'DEPOSIT_ACCOUNT'"><i class="fas fa-address-book" aria-hidden="true"></i> Account Type : Deposit Account</div>
                <div class="content" v-if="blog.type == 'CREDIT_ACCOUNT'"><i class="fas fa-address-book" aria-hidden="true"></i> Account Type : Credit Account</div>
                <div class="content"><i class="fas fa-landmark" aria-hidden="true"></i> Bank : {{ blog.bank_name }}</div>
              </div>
              <footer class="card-footer">
                <router-link class="card-footer-item" :to="`/blogs/detail/${blog.account_number}`">View Card ...</router-link>
                <!-- <a class="card-footer-item" @click="addLike(blog.id)"> -->
                  <!-- <span class="icon-text">
                    <span class="icon">
                      <i class="far fa-heart"></i>
                    </span>
                    <span>Like ({{blog.like}})</span>
                  </span> -->
                <!-- </a> -->
                <!-- <a
                  v-if="isBlogOwner(blog)"
                  class="card-footer-item"
                  @click="$router.push({name:'update-blog',params:{id:blog.id}})"
                >
                  <span class="icon-text">
                    <span>Edit</span>
                  </span>
                </a> -->
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
      blogs: [],
    };
  },
  mounted() {
    this.getBlogs();
  },
  methods: {
    getBlogs() {
      axios
        .get("http://localhost:3000", {
          params: {
            search: this.search,
          },
        })
        .then((response) => {
          this.blogs = response.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    imagePath(file_path) {
      if (file_path) {
        return "http://localhost:3000/" + file_path;
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    shortContent(content) {
      if (content.length > 200) {
        return content.substring(0, 197) + "...";
      }
      return content;
    },
    addLike(blogId) {
      axios
        .put(`http://localhost:3000/blogs/addlike/${blogId}`)
        .then((response) => {
          let selectedBlog = this.blogs.filter((e) => e.id === blogId)[0];
          selectedBlog.like = response.data.like;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    isBlogOwner(blog) {
      if (!this.user) return false
      return blog.create_by_id === this.user.id || this.user.role === 'employee'
    }
  },
};
</script>
