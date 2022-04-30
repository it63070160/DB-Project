const express = require("express");
const path = require("path");
const pool = require("../config");
const fs = require("fs");
const multer = require("multer");
const { isLoggedIn } = require('../middlewares');
const { date } = require("joi");

router = express.Router();

const blogOwner = async (req, res, next) => {
  if (req.user.role === 'employee'){
    return next()
  }
  
  // const [[blog]] = await pool.query('SELECT * FROM account WHERE user_id=?', [req.params.id])

  // if (blog.create_by_id !== req.user.id) {
  //   return res.status(403).send('You do not have permission to perform this action')
  // }

  next()
}

// SET STORAGE
const storage = multer.diskStorage({
  destination: function (req, file, callback) {
    callback(null, "./static/uploads");
  },
  filename: function (req, file, callback) {
    callback(
      null,
      file.fieldname + "-" + Date.now() + path.extname(file.originalname)
    );
  },
});
const upload = multer({ storage: storage });

router.put("/blogs/addlike/:id", async function (req, res, next) {
  const conn = await pool.getConnection();
  // Begin transaction
  await conn.beginTransaction();

  try {
    let [
      rows,
      fields,
    ] = await conn.query("SELECT `like` FROM `blogs` WHERE `id` = ?", [
      req.params.id,
    ]);
    let like = rows[0].like + 1;

    await conn.query("UPDATE `blogs` SET `like` = ? WHERE `id` = ?", [
      like,
      req.params.id,
    ]);

    await conn.commit();
    res.json({ like: like });
  } catch (err) {
    await conn.rollback();
    return res.status(500).json(err);
  } finally {
    console.log("finally");
    conn.release();
  }
});

// router.post("/blogs", isLoggedIn, upload.array("myImage", 5), async function (req, res, next) {

//   const title = req.body.title;
//   const content = req.body.content;
//   const status = req.body.status;
//   const pinned = req.body.pinned;

//   // Begin transaction
//   const conn = await pool.getConnection();
//   await conn.beginTransaction();
//   console.log(title)
//   try {
//     // let results = await conn.query(
//     //   "INSERT INTO blogs(title, content, status, pinned, `like`, create_date, create_by_id) " +
//     //   "VALUES(?, ?, ?, ?, 0, CURRENT_TIMESTAMP, ?);",
//     //   [title, content, status, pinned, req.user.id]
//     // );
//     // const blogId = results[0].insertId;

//     // req.files.forEach((file, index) => {
//     //   let path = [blogId, file.path.substring(6), index == 0 ? 1 : 0];
//     //   pathArray.push(path);
//     // });

//     // await conn.query(
//     //   "INSERT INTO images(blog_id, file_path, main) VALUES ?;",
//     //   [pathArray]
//     // );

//     await conn.commit();
//     res.send("success!");
//   } catch (err) {
//     await conn.rollback();
//     return res.status(400).json(err);
//   } finally {
//     conn.release();
//   }
// });

router.post("/blogs", isLoggedIn, upload.array("myImage", 5), async function (req, res, next) {
  const accountnumber = req.body.accountnumber;
  const interest = req.body.interest;
  // const firstname = req.body.firstname;
  // const lastname = req.body.lastname;
  // const sex = req.body.sex;
  // const status = req.body.status;
  // const age = req.body.age;
  // const salary = req.body.salary;
  const cardType = req.body.cardType;

  // Begin transaction
  const conn = await pool.getConnection();
  await conn.beginTransaction();
  var today = new Date();
  var dates = today.getFullYear()+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');
  var exp_date = (today.getFullYear()+2)+'-'+(today.getMonth()+1).toString().padStart(2, '0')+'-'+today.getDate().toString().padStart(2, '0');

  try {
    if (cardType == 'CREDIT_ACCOUNT'){
      let maxnumber = await conn.query("SELECT max(card_number) as maxnum FROM credit_card")
      let lastnumber = (parseInt(maxnumber[0][0].maxnum)+1).toString().padStart(16, '0')
      await conn.query(
        'INSERT INTO credit_account(account_number) VALUES(?)',
        [accountnumber]
      );
      await conn.query(
        'INSERT INTO credit_card(card_number, `limit`, outstanding_balance, `status`, interest, issue_date, exp_date, account_number) VALUES(?, 0, 0, ?, ?, ?, ?, ?)',
        [lastnumber, "Active", interest, dates, exp_date, accountnumber]
      );
    }
    else{
      let maxnumber = await conn.query("SELECT max(card_number) as maxnum FROM debit_card")
      let lastnumber = (parseInt(maxnumber[0][0].maxnum)+1).toString().padStart(16, '0')
      await conn.query(
        "INSERT INTO debit_card(card_number, limit_per_day, status, issue_date, exp_date, emp_id, account_number) " +
        "VALUES(?, 0, ?, ?, ?, ?, ?);",
        [lastnumber, "Active", dates, exp_date, 1, accountnumber]
      );
    }

    await conn.commit();
    res.send("success!");
  } catch (err) {
    await conn.rollback();
    return res.status(400).json(err);
  } finally {
    conn.release();
  }
});

router.get("/blogs/:id", function (req, res, next) {
  // Query data from 3 tables
  const promise1 = pool.query("SELECT * FROM credit_card WHERE account_number=?", [
    req.params.id,
  ]);
  const promise2 = pool.query("SELECT * FROM debit_card WHERE account_number=?", [
    req.params.id,
  ]);

  // Use Promise.all() to make sure that all queries are successful
  Promise.all([promise1, promise2])
    .then((results) => {
      const [creditCard, blogFields] = results[0];
      const [debitCard, commentFields] = results[1];
      res.json({
        creditCard: creditCard,
        debitCard: debitCard,
      });
    })
    .catch((err) => {
      return res.status(500).json(err);
    });
});

router.put("/card/:id", isLoggedIn, blogOwner, upload.array("myImage", 5), async function (req, res, next) {
  // Your code here
  const cardLimit = req.body.cardLimit
  const cardIssue = req.body.cardIssue
  const cardExp = req.body.cardExp
  const cardStatus = req.body.cardStatus
  const cardType = req.body.cardType

  const conn = await pool.getConnection()
  await conn.beginTransaction();

  try {
    if(cardType=='CREDIT_ACCOUNT'){
      const cardOSB = req.body.cardOSB
      const cardInterest = req.body.cardInterest
      await conn.query(
        "UPDATE credit_card SET `limit`=?, outstanding_balance=?, `status`=?, interest=?, issue_date=?, exp_date=? WHERE account_number = ?",
        [cardLimit, cardOSB, cardStatus, cardInterest, cardIssue, cardExp, req.params.id]
      )
    }
    else{
      await conn.query(
        "UPDATE debit_card SET limit_per_day=?, status=?, issue_date=?, exp_date=? WHERE account_number = ?",
        [cardLimit, cardStatus, cardIssue, cardExp, req.params.id]
      )
    }

    await conn.commit()
    res.send("success!");
  } catch (err) {
    await conn.rollback();
    next(err);
  } finally {
    console.log('finally')
    conn.release();
  }
  return;
});

router.delete("/blogs/:id", isLoggedIn, blogOwner, async function (req, res, next) {
  // Your code here
  const conn = await pool.getConnection();
  // Begin transaction
  await conn.beginTransaction();

  try {
    // Check that there is no comments
    const [
      rows1,
      fields1,
    ] = await conn.query(
      "SELECT COUNT(*) FROM `comments` WHERE `blog_id` = ?",
      [req.params.id]
    );
    console.log(rows1);

    if (rows1[0]["COUNT(*)"] > 0) {
      return res
        .status(400)
        .json({ message: "Cannot delete blogs with comments" });
    }

    //Delete files from the upload folder
    const [
      images,
      imageFields,
    ] = await conn.query(
      "SELECT `file_path` FROM `images` WHERE `blog_id` = ?",
      [req.params.id]
    );
    const appDir = path.dirname(require.main.filename); // Get app root directory
    console.log(appDir)
    images.forEach((e) => {
      const p = path.join(appDir, 'static', e.file_path);
      fs.unlinkSync(p);
    });

    // Delete images
    await conn.query("DELETE FROM `images` WHERE `blog_id` = ?", [
      req.params.id,
    ]);
    // Delete the selected blog
    const [
      rows2,
      fields2,
    ] = await conn.query("DELETE FROM `blogs` WHERE `id` = ?", [
      req.params.id,
    ]);

    if (rows2.affectedRows === 1) {
      await conn.commit();
      res.status(204).send();
    } else {
      throw "Cannot delete the selected blog";
    }
  } catch (err) {
    console.log(err)
    await conn.rollback();
    return res.status(500).json(err);
  } finally {
    conn.release();
  }
});

exports.router = router;
