const express = require("express");
const path = require("path");
const pool = require("../config");
const multer = require("multer");
const { isLoggedIn } = require('../middlewares');

router = express.Router();

const isEmployee = async (req, res, next) => {
    if (req.user.role === 'employee'){
      return next()
    } 
    alert("You don't have permission!")
}

const upload = multer();

// get user to CreateAccount.vue Form
router.get("/user", isLoggedIn, isEmployee, async function(req, res, next){
    const conn = await pool.getConnection();
    await conn.beginTransaction();
    try {
        let [user, column] = await conn.query(
            "SELECT * FROM user WHERE role = 'customer'"
        )
        await conn.commit();
        res.json({
            userList : user
        })
    }catch(err){
        console.log(err)
        await conn.rollback();
        res.status(400).json(err);
    }finally {
        conn.release();
    }
})

// get account number
router.get("/account/:id", isLoggedIn, async function(req, res, next){
    const conn = await pool.getConnection();
    await conn.beginTransaction();
    try {
        let [account, column] = await conn.query(
            "SELECT * FROM account WHERE user_id = ?",[req.params.id]
        )
        await conn.commit();
        res.json({
            accountList : account
        })
    }catch(err){
        console.log(err)
        await conn.rollback();
        res.status(400).json(err);
    }finally {
        conn.release();
    }
})

// add account
router.post("/account", isLoggedIn, isEmployee, upload.array(), async function(req, res, next) {
    const conn = await pool.getConnection();
    await conn.beginTransaction();

    try {
        const interest = req.body.interest;
        let maxnumber = await conn.query("SELECT max(account_number) as maxnum FROM account")
        let lastnumber = (parseInt(maxnumber[0][0].maxnum)+1).toString().padStart(10, '0')
        let [emp, column] = await conn.query(
        "SELECT * FROM employee JOIN user USING (user_id) WHERE user_id = ?",
        [req.user.user_id]
        )
        await conn.query(
        'INSERT INTO account(account_number, balance, user_id, emp_id) VALUES(?, ?, ?, ?)',
        [lastnumber, 50000, req.body.user_id , emp[0].emp_id]
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
})

exports.router = router;