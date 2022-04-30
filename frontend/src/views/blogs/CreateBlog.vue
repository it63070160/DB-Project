<template>
  <div class="container is-widescreen">
    <section class="section" v-if="error">
      <div class="container is-widescreen">
        <div class="notification is-danger">
          <!-- <%= error.code + ': ' + error.sqlMessage %> -->
          <!---->
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
      <!-- <input
        class="mb-5"
        multiple
        type="file"
        accept="image/png, image/jpeg, image/webp"
        @change="selectImages"
      />

      <div v-if="images" class="columns is-multiline">
        <div v-for="(image, index) in images" :key="image.id" class="column is-one-quarter">
          <div class="card">
            <div class="card-image">
              <figure class="image is-4by3">
                <img :src="showSelectImage(image)" alt="Placeholder image" />
              </figure>
            </div>
            <footer class="card-footer">
              <a @click="deleteSelectImage(index)" class="card-footer-item has-text-danger">Delete</a>
            </footer>
          </div>
        </div>
      </div> -->
      <div class="control mb-3">
        <label class="label">Type</label>
        <label class="radio">
          <input v-model="cardType" type="radio" name="answer" value="01" />
          Credit
        </label>
        <label class="radio">
          <input v-model="cardType" type="radio" name="answer" value="02" />
          Deposit
        </label>
      </div>

      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Account Number</label>
            <div class="control">
              <input v-model="accountnumber" class="input" type="text" placeholder="Owner's Account Number"/>
            </div>
          </div>
        </div>
      </div>
      
      <div class="field" v-if="cardType=='01'">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Interest</label>
            <div class="control">
              <input v-model="interest" class="input" type="number" step="0.01" placeholder="Interest for this card"/>
            </div>
          </div>
        </div>
      </div>

      <!-- <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">First Name</label>
            <div class="control">
              <input v-model="first_name" class="input" type="text" placeholder="Owner's Firstname"/>
            </div>
          </div>
          <div class="column">
            <label class="label">Last Name</label>
            <div class="control">
              <input v-model="last_name" class="input" type="text" placeholder="Owner's Lastname"/>
            </div>
          </div>
        </div>
      </div>

      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Sex</label>
            <div class="control">
              <div class="dropdown" :class="{'is-active':isActive}">
                <div class="dropdown-trigger">
                  <button class="button" aria-haspopup="true" aria-controls="dropdown-menu3" @click="isActive?isActive=false:isActive=true">
                    <span>{{sex}}</span>
                    <span class="icon is-small">
                      <i class="fas fa-angle-down" aria-hidden="true"></i>
                    </span>
                  </button>
                </div>
                <div class="dropdown-menu" id="dropdown-menu3" role="menu">
                  <div class="dropdown-content">
                    <a href="#" class="dropdown-item" @click="sex='Male';isActive=false">
                      Male
                    </a>
                    <hr class="dropdown-divider">
                    <a href="#" class="dropdown-item"  @click="sex='Female';isActive=false">
                      Female
                    </a>
                    <hr class="dropdown-divider">
                    <a href="#" class="dropdown-item"  @click="sex='Other';isActive=false">
                      Other
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="column is-half">
            <label class="label">Status</label>
            <div class="control">
              <div class="dropdown" :class="{'is-active':isActive2}">
                <div class="dropdown-trigger">
                  <button class="button" aria-haspopup="true" aria-controls="dropdown-menu3" @click="isActive2?isActive2=false:isActive2=true">
                    <span>{{status}}</span>
                    <span class="icon is-small">
                      <i class="fas fa-angle-down" aria-hidden="true"></i>
                    </span>
                  </button>
                </div>
                <div class="dropdown-menu" id="dropdown-menu2" role="menu">
                  <div class="dropdown-content">
                    <a href="#" class="dropdown-item" @click="status='Single';isActive2=false">
                      Single
                    </a>
                    <hr class="dropdown-divider">
                    <a href="#" class="dropdown-item"  @click="status='Married';isActive2=false">
                      Married
                    </a>
                    <hr class="dropdown-divider">
                    <a href="#" class="dropdown-item"  @click="status='Divorce';isActive2=false">
                      Divorce
                    </a>
                    <hr class="dropdown-divider">
                    <a href="#" class="dropdown-item"  @click="status='Other';isActive2=false">
                      Other
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="field">
        <div class="columns">
          <div class="column is-half">
            <label class="label">Age</label>
            <div class="control">
              <input v-model="age" class="input" type="number"/>
            </div>
          </div>
          <div class="column">
            <label class="label">Salary</label>
            <div class="control">
              <input v-model="salary" class="input" type="number" step="0.01"/>
            </div>
          </div>
        </div>
      </div> -->

      <!-- <div class="field">
        <div class="control">
          <label class="checkbox">
            <input v-model="pinnedBlog" type="checkbox" />
            Pinned
          </label>
        </div>
      </div> -->

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
            <button class="button is-success" @click="submitBlog">ยอมรับ</button>
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
      blog: {},
      error: null,
      images: [], // array of image
      accountnumber: '',
      first_name: '',
      last_name: '',
      contentBlog: "",
      // pinnedBlog: false,
      cardType: "01",
      interest: 0,
      isActive: false,
      isActive2: false,
      modalActive: false,
      acceptModal: false,
      sex: "Male",
      age: 0,
      status: "Single",
      salary: 0,
    };
  },
  methods: {
    selectImages(event) {
      this.images = event.target.files;
    },
    showSelectImage(image) {
      // for preview only
      return URL.createObjectURL(image);
    },
    deleteSelectImage(index) {
      console.log(this.images);
      this.images = Array.from(this.images);
      this.images.splice(index, 1);
    },
    showModal(){
      this.modalActive = true
    },
    submitBlog() {
      let formData = new FormData();
      formData.append("accountnumber", this.accountnumber);
      formData.append("interest", this.interest);
      // formData.append("firstname", this.first_name);
      // formData.append("lastname", this.last_name);
      // formData.append("sex", this.sex);
      // formData.append("status", this.status);
      // formData.append("age", this.age);
      // formData.append("salary", this.salary);
      formData.append("cardType", this.cardType=="01"?"CREDIT_ACCOUNT":"DEPOSIT_ACCOUNT");

      axios
        .post("http://localhost:3000/blogs", formData)
        .then((res) => this.$router.push({name: 'home'}))
        .catch((e) => console.log(e.response.data));
    },
  },
};
</script>

<style>
</style>
