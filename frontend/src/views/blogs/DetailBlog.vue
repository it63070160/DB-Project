<template>
  <div class="container is-widescreen">
    <section class="section" v-if="error">
      <div class="container is-widescreen">
        <div class="notification is-danger">{{ error }}</div>
      </div>
    </section>
    <section class="hero">
      <div class="hero-body">
        <p class="title">Account Number : {{ $route.params.id }}</p>
      </div>
    </section>
    <section class="section">
      <div class="content">
        <div class="card has-background-light">
          <div class="card" v-for='card in creditCardList' :key="card.card_number">
          <div class="card-content" v-if="editToggle!=1">
            <div class="content"><i class="fas fa-credit-card"/> หมายเลขบัตร : {{ card.card_number }}</div>
            <div class="content"><i class="fas fa-dollar-sign"/> วงเงิน : {{ card.limit }}</div>
            <div class="content"><i class="fas fa-dollar-sign" style="color: red"/> ยอดค้างชำระ : {{ card.outstanding_balance }}</div>
            <div class="content"><i class="fas fa-percent"/> ดอกเบี้ย : {{ card.interest }} %</div>
            <div class="content"><i class="fas fa-calendar"/> วันออกบัตร : {{ card.issue_date.substring(0, 10) }}</div>
            <div class="content"><i class="fas fa-calendar-minus"/> วันหมดอายุ : {{ card.exp_date.substring(0, 10) }}</div>
            <div class="content"><i class="fas fa-signal"/> สถานะ : <p :class="{'has-text-success': card.status == 'Active', 'has-text-warning': card.status == 'Reject', 'has-text-danger': card.status == 'Closed'}" style="display: inline-block">{{ card.status }}</p></div>
          </div>
          <div class="card-content" v-if="editToggle==1 && isEmployee()">
            <div class="content">หมายเลขบัตร<input class="input" type="text" v-model="editCardNum" disabled/></div>
            <div class="content">วงเงิน<input class="input" type="text" v-model="editCardLimit"/></div>
            <div class="content">ยอดค้างชำระ<input class="input" type="text" v-model="editCardOSB"/></div>
            <div class="content">ดอกเบี้ย<input class="input" type="text" v-model="editCardInterest"/></div>
            <div class="content">วันออกบัตร<input class="input" type="date" v-model="editCardIssue"/></div>
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
          <!-- <div class="card-image pt-5">
            <div class="columns">
              <div v-for="image in images" :key="image.id" class="column">
                <figure class="image">
                  <img
                    :src="'http://localhost:3000/'+image.file_path"
                    alt="Placeholder image"
                    style="height: 500px; object-fit: cover;"
                  />
                </figure>
              </div>
            </div>
          </div>
          <div class="card-content">
            <div class="content">{{ blog.content }}</div>
            <div class="container pb-3">
              <p class="subtitle">Comments</p>
              <div class="columns">
                <div class="column is-8">
                  <input type="text" class="input" v-model="commTxt" placeholder="Add new comment" />
                </div>
                <div class="column is-4">
                  <button @click="addComment" class="button">Add comment</button>
                </div>
              </div>
            </div>
            <div v-for="(comment,index) in comments" :key="comment.id" class="box">
              <article class="media">
                <div class="media-left">
                  <figure class="image is-64x64">
                    <img src="https://bulma.io/images/placeholders/128x128.png" alt="Image" />
                  </figure>
                </div>
                <div v-if="index===editToggle" class="media-content">
                  <div class="content">
                    <input v-model="editCommentMessage" class="input" type="text" />
                    <p class="is-size-7">{{ comment.comment_date }}</p>
                  </div>
                  <nav class="level">
                    <div class="level-left">
                      <a class="level-item" aria-label="like">
                        <span class="icon is-small pr-3">
                          <i class="fas fa-heart" aria-hidden="true"></i>
                        </span>
                        Like (0)
                      </a>
                    </div>
                    <div class="level-right">
                      <div class="level-item">
                        <button
                          @click="saveEditComment(comment.id,index)"
                          class="button is-primary"
                        >
                          <span>Save Comment</span>
                          <span class="icon is-small">
                            <i class="fas fa-edit"></i>
                          </span>
                        </button>
                      </div>
                      <div class="level-item">
                        <button @click="editToggle = -1" class="button is-info is-outlined">
                          <span>Cancel</span>
                          <span class="icon is-small">
                            <i class="fas fa-times"></i>
                          </span>
                        </button>
                      </div>
                    </div>
                  </nav>
                </div>
                <div v-else class="media-content">
                  <div class="content">
                    <p>{{ comment.comment }}</p>
                    <p class="is-size-7">{{ comment.comment_date }}</p>
                  </div>
                  <nav class="level">
                    <div class="level-left">
                      <a @click="addLikeComment(comment.id)" class="level-item" aria-label="like">
                        <span class="icon is-small pr-3">
                          <i class="fas fa-heart" aria-hidden="true"></i>
                        </span>
                        Like ({{comment.like}})
                      </a>
                    </div>
                    <div class="level-right" v-if="isCommentOwner(comment)">
                      <div class="level-item">
                        <button
                          @click="editToggle = index; editCommentMessage = comment.comment"
                          class="button is-warning"
                        >
                          <span>Edit</span>
                          <span class="icon is-small">
                            <i class="fas fa-edit"></i>
                          </span>
                        </button>
                      </div>
                      <div class="level-item">
                        <button
                          @click="deleteComment(comment.id, index)"
                          class="button is-danger is-outlined"
                        >
                          <span>Delete</span>
                          <span class="icon is-small">
                            <i class="fas fa-times"></i>
                          </span>
                        </button>
                      </div>
                    </div>
                  </nav>
                </div>
              </article>
            </div>
          </div>-->
          <footer class="card-footer" v-if="editToggle!=1">
            <router-link class="card-footer-item" to="/">To Home Page</router-link>
            <a class="card-footer-item" @click="manageCard(card, 'CREDIT')" v-if="isEmployee()">
              <span>Manage this card</span>
            </a>
          </footer>
          <footer class="card-footer" v-if="editToggle==1 && isEmployee()">
            <a class="card-footer-item" @click="saveEditCard">Save</a>
            <a class="card-footer-item" @click="editToggle=-1">
              <span>Cancel</span>
            </a>
          </footer>
        </div>
        <div class="card has-background-light">
          <div class="card" v-for='card in debitCardList' :key="card.card_number">
            <div class="card-content" v-if="editToggle==-1">
              <div class="content"><i class="fas fa-credit-card"/> หมายเลขบัตร : {{ card.card_number }}</div>
            <div class="content"><i class="fas fa-dollar-sign"/> วงเงินรายวัน : {{ card.limit_per_day }}</div>
            <div class="content"><i class="fas fa-calendar"/> วันออกบัตร : {{ card.issue_date.substring(0, 10) }}</div>
            <div class="content"><i class="fas fa-calendar-minus"/> วันหมดอายุ : {{ card.exp_date.substring(0, 10) }}</div>
            <div class="content"><i class="fas fa-signal"/> สถานะ : <p :class="{'has-text-success': card.status == 'Active', 'has-text-warning': card.status == 'Reject', 'has-text-danger': card.status == 'Closed'}" style="display: inline-block">{{ card.status }}</p></div>
            </div>
            <div class="card-content" v-if="editToggle==1 && isEmployee()">
              <div class="content">หมายเลขบัตร<input class="input" type="text" v-model="editCardNum" disabled/></div>
              <div class="content">วงเงินรายวัน<input class="input" type="text" v-model="editCardLimit"/></div>
              <div class="content">วันออกบัตร<input class="input" type="date" v-model="editCardIssue"/></div>
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
            <footer class="card-footer" v-if="editToggle!=1">
              <router-link class="card-footer-item" to="/">To Home Page</router-link>
              <a class="card-footer-item" @click="manageCard(card, 'DEBIT')" v-if="isEmployee()">
                <span>Manage this card</span>
              </a>
            </footer>
            <footer class="card-footer" v-if="editToggle==1 && isEmployee()">
              <a class="card-footer-item" @click="saveEditCard">Save</a>
              <a class="card-footer-item" @click="editToggle=-1">
                <span>Cancel</span>
              </a>
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

export default {
  props: ['user'],
  data() {
    return {
      creditCardList: {},
      debitCardList: {},
      // comments: [],
      // images: [],
      error: null,
      commTxt: "",
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
    getCardDetail(blogId) {
      axios
        .get(`http://localhost:3000/blogs/${blogId}`)
        .then((response) => {
          this.creditCardList = response.data.creditCard;
          this.debitCardList = response.data.debitCard;
          if(response.data.creditCard.length > 0){
            this.creditCardList[0].issue_date = this.creditCardList[0].issue_date.toString().substring(0, 8)+(parseInt(this.creditCardList[0].issue_date.toString().substring(8, 10))+1)
            this.creditCardList[0].exp_date = this.creditCardList[0].exp_date.toString().substring(0, 8)+(parseInt(this.creditCardList[0].exp_date.toString().substring(8, 10))+1)
          }
          else if(response.data.debitCard.length > 0){
            this.debitCardList[0].issue_date = this.debitCardList[0].issue_date.toString().substring(0, 8)+(parseInt(this.debitCardList[0].issue_date.toString().substring(8, 10))+1)
            this.debitCardList[0].exp_date = this.debitCardList[0].exp_date.toString().substring(0, 8)+(parseInt(this.debitCardList[0].exp_date.toString().substring(8, 10))+1)
          }
        })
        .catch((error) => {
          this.error = error.response.data.message;
        });
    },
    // addComment() {
    //   axios
    //     .post(`http://localhost:3000/${this.blog.id}/comments`, {
    //       comment: this.commTxt,
    //     })
    //     .then((response) => {
    //       this.commTxt = "";
    //       this.comments.push(response.data);
    //     })
    //     .catch((error) => {
    //       this.error = error.response.data.message;
    //     });
    // },
    saveEditCard() {
      let formData = new FormData();
      formData.append("cardLimit", this.editCardLimit);
      formData.append("cardIssue", this.editCardIssue);
      formData.append("cardExp", this.editCardExp);
      formData.append("cardStatus", this.editCardStatus);
      let creditCheck = this.creditCardList
      let debitCheck = this.debitCardList
      if(creditCheck[0].card_number == this.editCardNum){
        formData.append("cardType", "CREDIT_ACCOUNT");
        formData.append("cardOSB", this.editCardOSB);
        formData.append("cardInterest", this.editCardInterest);
        this.creditCardList[0].limit = this.editCardLimit
        this.creditCardList[0].outstanding_balance = this.editCardOSB
        this.creditCardList[0].interest = this.editCardInterest
        this.creditCardList[0].issue_date = this.editCardIssue
        this.creditCardList[0].exp_date = this.editCardExp
        this.creditCardList[0].status = this.editCardStatus
      }
      else if(debitCheck[0].card_number == this.editCardNum){
        formData.append("cardType", "DEBIT_ACCOUNT");
        this.debitCardList[0].limit_per_day = this.editCardLimit
        this.debitCardList[0].issue_date = this.editCardIssue
        this.debitCardList[0].exp_date = this.editCardExp
        this.debitCardList[0].status = this.editCardStatus
      }
      axios
        .put(`http://localhost:3000/card/${this.$route.params.id}`, formData)
        .then((response) => {
          this.editToggle = -1;
        })
        .catch((error) => {
          this.error = error.message;
        });
    },
    // deleteComment(commentId, index) {
    //   const result = confirm(`Are you sure you want to delete this comment`);
    //   if (result) {
    //     axios
    //       .delete(`http://localhost:3000/comments/${commentId}`)
    //       .then((response) => {
    //         console.log(response);
    //         this.comments.splice(index, 1);
    //       })
    //       .catch((error) => {
    //         this.error = error.message;
    //       });
    //   }
    // },
    // addLikeComment(commentId) {
    //   axios
    //     .put(`http://localhost:3000/comments/addlike/${commentId}`)
    //     .then((response) => {
    //       let selectedComment = this.comments.filter(
    //         (e) => e.id === commentId
    //       )[0];
    //       console.log(selectedComment);
    //       selectedComment.like = response.data.like;
    //       console.log(selectedComment);
    //     })
    //     .catch((error) => (this.error = error.message));
    // },
    manageCard(card, cardType) {
      this.editToggle = 1
      this.editCardNum = card.card_number
      if(cardType == 'CREDIT'){
        this.editCardLimit = card.limit
        this.editCardOSB = card.outstanding_balance
        this.editCardInterest = card.interest
      }
      else if(cardType == 'DEBIT'){
        this.editCardLimit = card.limit_per_day
      }
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
