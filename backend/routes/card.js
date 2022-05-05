const express = require("express");
const path = require("path");
const pool = require("../config");
const fs = require("fs");
const multer = require("multer");
const { isLoggedIn } = require('../middlewares');

router = express.Router();

const isEmployee = async (req, res, next) => {
  if (req.user.role === 'employee'){
    return next()
  }

  next()
}

const upload = multer();

// add card to account
router.post("/cards", isLoggedIn, upload.array(), async function (req, res, next) {
  const accountnumber = req.body.accountnumber;
  const cardLimit = req.body.limit;

  // Begin transaction
  const conn = await pool.getConnection();
  await conn.beginTransaction();
  var today = new Date();
  var dates = today.getFullYear()+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');
  var exp_date = (today.getFullYear()+2)+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');

  try {
    const interest = req.body.interest;
    let maxnumber = await conn.query("SELECT max(card_number) as maxnum FROM credit_card")
    let lastnumber = (parseInt(maxnumber[0][0].maxnum)+1).toString().padStart(16, '0')
    let [emp, column] = await conn.query(
      "SELECT * FROM employee JOIN user USING (user_id) WHERE user_id = ?",
      [req.user.user_id]
    )
    await conn.query(
      'INSERT INTO credit_card(card_number, `limit`, outstanding_balance, `status`, interest, issue_date, exp_date, account_number, emp_id) VALUES(?, ?, 0, ?, ?, ?, ?, ?, ?)',
      [lastnumber, cardLimit, "Active", interest, dates, exp_date, accountnumber, emp[0].emp_id]
    );

    await conn.commit();
    res.send("success!");
  } catch (err) {
    console.log(err)
    await conn.rollback();
    return res.status(400).json(err);
  } finally {
    conn.release();
  }
});

// show card
router.get("/cards/:id", function (req, res, next) {
  let shopDate = new Intl.DateTimeFormat('en-GB', { dateStyle: 'short'}).format(new Date());
  let shopYear = parseInt(shopDate.slice(6, 10))
  let shopMonth = parseInt(shopDate.slice(0, 2))

  const promise1 = pool.query("SELECT *, ifnull(c.sum, 0) as sum FROM credit_card as card LEFT OUTER JOIN (SELECT YEAR(date_time) as year, MONTH(date_time) as month, card_number , sum(amount) as sum, account_number FROM transaction JOIN credit_card USING (card_number) JOIN account USING (account_number) group by YEAR(date_time), MONTH(date_time), card_number HAVING year = ? AND month = ?) as c USING (card_number) WHERE card.account_number=?", [
    shopYear, shopMonth, req.params.id
  ]);

  // Use Promise.all() to make sure that all queries are successful
  Promise.all([promise1])
    .then((results) => {
      const [creditCard, blogFields] = results[0];
      res.json({
        creditCard: creditCard
      });
    })
    .catch((err) => {
      return res.status(500).json(err);
    });
});

// manage card
router.put("/card/:id", isLoggedIn, isEmployee, upload.array(), async function (req, res, next) {
  // Your code here
  const cardLimit = req.body.cardLimit
  const cardIssue = req.body.cardIssue
  const cardExp = req.body.cardExp
  const cardStatus = req.body.cardStatus
  const cardOSB = req.body.cardOSB
  const cardInterest = req.body.cardInterest

  const conn = await pool.getConnection()
  await conn.beginTransaction();

  try {
    if(cardIssue<cardExp){
      await conn.query(
        "UPDATE credit_card SET `limit`=?, outstanding_balance=?, `status`=?, interest=?, exp_date=? WHERE card_number = ?",
        [cardLimit, cardOSB, cardStatus, cardInterest, cardExp, req.params.id]
      )
      res.send("success!");
    }
    else{
      res.send("วันหมดอายุควรจะเป็นวันที่หลังวันออกบัตร")
    }
    await conn.commit()
  } catch (err) {
    await conn.rollback();
    next(err);
  } finally {
    console.log('finally')
    conn.release();
  }
  return;
});

exports.router = router;