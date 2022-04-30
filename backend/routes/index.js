const express = require("express");
const pool = require("../config");
const { isLoggedIn } = require('../middlewares')

router = express.Router();

router.get("/", isLoggedIn, async function (req, res, next) {
  try {
    // const search = req.query.search || ''
    let sql = "SELECT * FROM account as a JOIN (SELECT * FROM credit_account) as b ON a.account_number = b.account_number JOIN (SELECT * FROM employee) as emp ON a.emp_id = emp.emp_id JOIN (SELECT * FROM branch) as br ON emp.branch_id = br.branch_id JOIN (SELECT * FROM bank) as ba ON br.bank_id = ba.bank_id WHERE user_id=? UNION SELECT * FROM account as c JOIN (SELECT * FROM deposit_account) as d ON c.account_number = d.account_number JOIN (SELECT * FROM employee) as emp ON c.emp_id = emp.emp_id JOIN (SELECT * FROM branch) as br ON emp.branch_id = br.branch_id JOIN (SELECT * FROM bank) as ba ON br.bank_id = ba.bank_id WHERE user_id=?;"
    // let cond = []

    // if (search.length > 0) {
    //   sql = 'SELECT a.*, b.file_path FROM blogs AS a LEFT JOIN (SELECT * FROM images WHERE main=1) AS b ON a.id = b.blog_id WHERE a.title LIKE ? OR a.content LIKE ?;'
    //   cond = [`%${search}%`, `%${search}%`]
    // }
    console.log('here');
    console.log(req.user.user_id)
    const [rows, fields] = await pool.query(sql, [req.user.user_id, req.user.user_id]);
    console.log(rows);
    return res.json(rows);
  } catch (err) {
    console.log(err)
    return res.status(500).json(err)
  }
});

exports.router = router;
