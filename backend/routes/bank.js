const express = require("express");
const path = require("path");
const pool = require("../config");
const _ = require('lodash');

router = express.Router();

router.get("/bank", async function(req, res, next) {
    const conn = await pool.getConnection();
    try {
        let [rows,fields,] = await conn.query("SELECT ba.bank_name, br.*, emp.emp_fname, emp.emp_lname FROM bank as ba JOIN (SELECT * from branch) as br USING (bank_id) JOIN employee as emp USING (emp_id) GROUP BY ba.bank_name, branch_id ORDER BY ba.bank_name");
        let group = _.groupBy(rows, 'bank_name')
        res.json(Object.entries(group));
    }catch(err){
        return res.status(500).json(err);
    }
})

exports.router = router;