const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const jsonwebtoken = require('jsonwebtoken');
require('dotenv').config();
const JWTKey = process.env.JWT_SECRET_KEY;




const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'chat-App-DB',
});

const checkUserExists = (email) => {
    return new Promise((resolve, reject) => {
        const query = 'SELECT * FROM Users WHERE email = ?';
        connection.query(query, email, (error, results) => {
            if (error) {
                reject(error);
            } else {
                resolve(results.length > 0);
            }
        });
    });
};


const verifyJwt = (req, res, next) => {
    const token = req.headers.Authorization;

    if (!token) {
        return res.status(401).json({ error: 'No token provided' });
    }

    jwt.verify(token, JWTKey, (err, decoded) => {
        if (err) {
            return res.status(401).json({ error: 'Invalid token' });
        }

        // Token is valid
        req.params.user_id = decoded.userId; // Store the user ID in the request object
        next(); // Proceed to the next middleware or route handler
    });
};

const createUser = (req, res) => {
    let insertData = req.body;

    checkUserExists(insertData.email)
        .then((userExists) => {
            if (!userExists) {
                bcrypt.hash(insertData.password, 10, (error, password) => {
                    if (error) {
                        console.log(error);
                    } else {
                        const query = "INSERT INTO users SET ?";
                        insertData.password = password;
                        connection.query(query, insertData, (err, result) => {
                            if (err) {
                                console.error('Error inserting data: ', err);
                                res.status(1).send("errrr");
                            } else {
                                res.status(200).send({ "insertId": result.insertId });
                            }
                        });
                    }
                })
            } else {
                res.statusCode = 409;
                res.statusMessage = "User already exists";
                res.send();
            }
        })
        .catch((err) => {
            console.log(err);
            return res.status(500).json({ error: 'Internal server error' });
        });
};

const login = (req, res) => {
    const data = req.body;
    const query = "SELECT * FROM Users WHERE email = ?";
    connection.query(query, [data.email], (err, result) => {
        if (err) {
            console.log(err);
        } else {
            if (result.length === 0) {
                console.log("wrong credentials")
            } else {
                const user = result[0];
                bcrypt.compare(data.password, user.password, (error, match) => {
                    if (error) {
                        console.log(error);
                    } else if (!match) {
                        console.log("wrong password");
                    } else {
                        const query2 = 'UPDATE Users SET deviceToken = ? WHERE user_id = ? ';
                        connection.query(query2, [data.deviceToken, result[0].user_id], (err2, result2) => {
                            if (err2) {
                                console.log(err2);
                            } else {
                                const token = jsonwebtoken.sign({ userId: user.user_id, email: user.email }, JWTKey, { expiresIn: '1h' });
                                res.send({
                                    "Authorization": token,
                                    "user_id": result[0].user_id,
                                    "username": result[0].username,
                                    "phone": result[0].phone,
                                    "img": result[0].img,
                                    "password": result[0].password
                                });
                            }
                        });


                    }
                })
            }
        }


    })
};

const getDeviceToken = (user_id) => {
    return new Promise((resolve, reject) => {
        const query = "SELECT deviceToken FROM Users WHERE user_id = ?";
        connection.query(query, user_id, (err, result) => {
            if (err) {
                reject(err);
            } else {
                resolve(result[0].deviceToken);
            }
        })
    })

}

const deleteUser = (req, res) => {
    const user_id = req.body.user_id;
    const query = 'DELETE FROM Users WHERE user_id = ?';
    connection.query(query, user_id, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.status(200).send(result);
        }
    })
};

const updateUsername = (req, res) => {
    const username = req.body.username;
    const user_id = req.body.user_id;
    const query = `UPDATE Users SET username = ? WHERE user_id = ?`;

    // Execute the query
    connection.query(query, [username, user_id], (err, result) => {
        if (err) {
            console.error('Error updating record:', err);
            res.status(403).send({
                "edited": false
            })
        } else {
            res.status(200).send({
                "edited": true
            })
        }

    });
};

const updateEmail = (req, res) => {
    const email = req.body.email;
    const user_id = req.body.user_id;
    const query = `UPDATE Users SET email = ? WHERE user_id = ?`;

    // Execute the query
    connection.query(sql, [email, user_id], (err, result) => {
        if (err) {
            console.error('Error updating record:', err);
            res.status(403).send({
                "edited": false
            })
        } else {
            res.status(200).send({
                "edited": true
            })
        }

    });
};

const updatePhone = (req, res) => {
    const phone = req.body.phone;
    const user_id = req.body.user_id;
    const query = `UPDATE Users SET phone = ? WHERE user_id = ?`;

    // Execute the query
    connection.query(sql, [phone, user_id], (err, result) => {
        if (err) {
            console.error('Error updating record:', err);
            res.status(403).send({
                "edited": false
            })
        } else {
            res.status(200).send({
                "edited": true
            })
        }

    });
};

const searchUsers = (req, res) => {
    const username = req.params.username;
    const query = `SELECT username,user_id,img FROM Users WHERE username LIKE ?  LIMIT 10 `;
    connection.query(query, [`%${username}%`], (err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.status(200).send(result);
        }
    })
}

const getUser = (req, res) => {
    const user_id = req.params.user_id;
    const query = 'SELECT username,img,user_id FROM Users WHERE user_id = ?';
    connection.query(query, [user_id], (err, result) => {
        if (err) {
            console.log(err);

        } else {
            res.status(200).send(result);
        }
    })
}

module.exports = {
    connection,
    checkUserExists,
    verifyJwt,
    createUser,
    login,
    deleteUser,
    updateUsername,
    updateEmail,
    updatePhone,
    searchUsers,
    getUser,
    getDeviceToken
};
