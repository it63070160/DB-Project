const express = require("express");
const path = require("path");
const pool = require("../config");
const fs = require("fs");
const multer = require("multer");
const { isLoggedIn } = require('../middlewares');
const { date } = require("joi");
const { max } = require("lodash");

router = express.Router();

const isCustomer = async (req, res, next) => {
  if (req.user.role === 'customer'){
    return next()
  }
  alert("You don't have permission!")
}

// show store
router.get("/store/:id", isLoggedIn, isCustomer, function (req, res, next) {
  // Query data from 3 tables
  const promise1 = pool.query("SELECT * FROM product WHERE store_id=?", [
    req.params.id,
  ]);

  // Use Promise.all() to make sure that all queries are successful
  Promise.all([promise1])
    .then((results) => {
      const [product, blogFields] = results[0];
      res.json({
        product: product
      });
    })
    .catch((err) => {
      return res.status(500).json(err);
    });
});

// use card
router.put("/store/checkout/:id", isLoggedIn, isCustomer, async function (req, res, next) {
  // Your code here
  let cardNumber = req.body.params.cardNumber
  let storeId = req.body.params.storeId
  let amount = req.body.params.amount
  let accountNumber = req.body.params.accountNumber

  const conn = await pool.getConnection()
  await conn.beginTransaction();

  try {

    let [lasttransaction, field] = await conn.query("SELECT max(transaction_id) as maxnum FROM transaction")
    let [checkBalance, field2] = await conn.query("SELECT balance FROM account WHERE account_number = ?", [accountNumber])
    let [maxLimit, field3] = await conn.query("SELECT credit_card.limit FROM credit_card WHERE card_number = ?", [cardNumber])

    let shopDate = new Intl.DateTimeFormat('en-GB', { dateStyle: 'short'}).format(new Date());
    let shopYear = parseInt(shopDate.slice(6, 10))
    let shopMonth = parseInt(shopDate.slice(0, 2))

    let [checkLimit, field4] = await conn.query("SELECT YEAR(date_time) as year, MONTH(date_time) as month, card_number , sum(amount) as sum FROM transaction group by YEAR(date_time), MONTH(date_time), card_number HAVING year = ? AND month = ? AND card_number = ?",
    [shopYear, shopMonth, cardNumber]);

    let currentAmount = 0

    if (checkLimit.length != 0){
      currentAmount = checkLimit[0].sum
    }

    if(checkBalance[0].balance-amount >= 0){
      if (currentAmount + amount > maxLimit[0].limit){
        res.send('Full of limit')
      }
      else{
        await conn.query("UPDATE account SET balance = ? WHERE account_number = ?",[checkBalance[0].balance-amount, accountNumber])
        if (lasttransaction[0].maxnum == null){
          await conn.query("INSERT INTO transaction VALUE(?, ?, ?, ?, CURRENT_TIMESTAMP)",[1, cardNumber, storeId, amount])
        }
        else{
          await conn.query("INSERT INTO transaction VALUE(?, ?, ?, ?, CURRENT_TIMESTAMP)",[lasttransaction[0].maxnum+1, cardNumber, storeId, amount])
        }
      }
      res.send("success!");
    }
    else{
      let [osb, field5] = await conn.query("SELECT outstanding_balance as osb FROM credit_card WHERE card_number = ?", [cardNumber])
      let outstanding = osb[0].osb+Math.abs(checkBalance[0].balance-amount)
      if (currentAmount + amount > maxLimit[0].limit){
        res.send('Full of limit')
      }
      else{
        await conn.query("UPDATE account SET balance = ? WHERE account_number = ?",[0, accountNumber])
        await conn.query("UPDATE credit_card SET outstanding_balance = ? WHERE card_number = ?",[outstanding, cardNumber])
        if (lasttransaction[0].maxnum == null){
          await conn.query("INSERT INTO transaction VALUE(?, ?, ?, ?, CURRENT_TIMESTAMP)",[1, cardNumber, storeId, amount])
        }
        else{
          await conn.query("INSERT INTO transaction VALUE(?, ?, ?, ?, CURRENT_TIMESTAMP)",[lasttransaction[0].maxnum+1, cardNumber, storeId, amount])
        }
      }
      res.send("success!");
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