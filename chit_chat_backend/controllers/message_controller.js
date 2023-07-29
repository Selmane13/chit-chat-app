const mysql = require('mysql2');
const userController = require('./user_controller');


const deleteMssg = (req, res) => {
    const message_id = req.params.message_id;
    const query = 'DELETE FROM Messages WHERE message_id = ?';
    userController.connection.query(query, message_id, (err, result) => {
        if (err) {
            console.log(err);
            res.status(500).json({ error: 'Internal server error' });
        } else {
            res.status(200).json({ message: 'Message deleted successfully' });
        }
    })
};

const createMssg = (req, res) => {
    const messageData = req.body;
    insertMssgDB(messageData)
        .then((result) => {
            res.status(200).send({ "insertId": result.insertId });
        }
        ).catch((err) => {
            console.log(err);
        });
}

const insertMssgDB = (data) => {
    return new Promise((resolve, reject) => {
        const query = 'INSERT INTO Messages SET ?';
        userController.connection.query(query, data, (err, result) => {
            if (err) {

                reject(err);
            } else {
                resolve(result);
            }
        });
    }
    );
}

const getMssg = (req, res) => {
    const message_id = req.params.message_id;
    console.log(req.params.message_id);
    const query = 'SELECT * FROM Messages WHERE message_id =  ?';
    userController.connection.query(query, message_id, (err, result) => {
        if (err) {
            console.log(err);

        } else {
            res.send(result);
        }
    })
};

const getAllMssgs = (req, res) => {
    const conversation_id = req.params.conversation_id;
    const sender_id = req.params.sender_id;
    const query = 'SELECT * FROM Messages WHERE conversation_id = ? AND sender_id = ?';
    userController.connection.query(query, [conversation_id, sender_id], (err, result) => {
        if (err) {
            console.log(err);

        } else {
            result.sort((a, b) => b.timestamp - a.timestamp);
            res.status(200).send(result);
        }
    })
};

module.exports = {
    deleteMssg,
    createMssg,
    getMssg,
    getAllMssgs,
    insertMssgDB
}