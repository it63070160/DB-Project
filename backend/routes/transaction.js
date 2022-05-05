const express = require("express");
const path = require("path");
const pool = require("../config");
const _ = require('lodash');
const { isLoggedIn } = require('../middlewares')

router = express.Router();

router.get("/transaction", isLoggedIn, async function (req, res, next) {
  const conn = await pool.getConnection();
  
  try {
    const order = req.query.order || ''
    let sql = ""
    sql = "SELECT * FROM user as u JOIN account as ac USING(user_id) JOIN credit_card as cr USING(account_number) JOIN transaction as ts USING(card_number) JOIN store as st USING (store_id) WHERE user_id = ?"
    if (order.length > 0) {
      sql += ' ORDER BY ' + order
    }
    let [rows, column] = await conn.query(sql, [req.user.user_id])
    for (let i = 0 ; i < rows.length; i++){
      rows[i].date_time = new Intl.DateTimeFormat('en-GB', { dateStyle: 'short', timeStyle: 'medium' }).format(new Date(rows[i].date_time))
    }
    res.json({
      transaction: rows
    })
  } catch (err) {
    console.log(err)
    return res.status(500).json(err);
  }
})

exports.router = router;