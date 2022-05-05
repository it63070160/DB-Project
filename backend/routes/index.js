const express = require("express");
const pool = require("../config");
const { isLoggedIn } = require('../middlewares')

router = express.Router();

router.get("/", isLoggedIn, async function (req, res, next) {
  try {
    const search = req.query.search || ''
    const order = req.query.order || ''
    let sql = ""
    let cond = []
    if(req.user.role=='employee'){
      const [checkBank,field] = await pool.query("SELECT * FROM employee as emp JOIN branch as br USING (branch_id) JOIN bank as ba USING (bank_id) WHERE emp.emp_fname = ? AND emp.emp_lname = ?",
      [req.user.fname, req.user.lname])
      sql = "SELECT * FROM account as a JOIN (SELECT emp_id, branch_id FROM employee) as emp USING (emp_id) JOIN branch USING (branch_id) JOIN bank USING (bank_id) JOIN user USING (user_id) WHERE bank_id = ?"
      cond = [checkBank[0].bank_id]
      if (search.length > 0) {
        sql = "SELECT * FROM account as a JOIN employee USING (emp_id) JOIN branch USING (branch_id) JOIN bank USING (bank_id) JOIN user USING (user_id) WHERE bank_id = ? AND account_number LIKE ?"
        cond = [checkBank[0].bank_id , `%${search}%`]
      }
    }
    else{
      sql = "SELECT * FROM account as a JOIN (SELECT emp_id, branch_id FROM employee) as emp USING (emp_id) JOIN branch USING (branch_id) JOIN bank USING (bank_id) JOIN user USING (user_id) WHERE a.user_id = ?"
      cond = [req.user.user_id]
    }

    if (order.length > 0){
      sql += ' ORDER BY '+order
    }
    
    const [rows, fields] = await pool.query(sql, cond);
    res.json(rows);
  } catch (err) {
    console.log(err)
    return res.status(500).json(err)
  }
});

router.get("/store", isLoggedIn, async function (req, res, next) {
  try {
    let sql = ""
    let cond = []
    sql = "SELECT * FROM store"

    const [rows, fields] = await pool.query(sql, cond);
    res.json(rows);
  } catch (err) {
    console.log(err)
    return res.status(500).json(err)
  }
});

exports.router = router;
