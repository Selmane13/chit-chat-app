const mysql = require('mysql2');
const express = require('express');

require('dotenv').config();
const crypto = require('crypto');
const userController = require('./controllers/user_controller');
const conversationController = require('./controllers/conversation_controller');
const messageController = require('./controllers/message_controller');
const socketIO = require('socket.io'); // Import socket.io
const http = require('http'); // Import http module
const multer = require('multer')
const JWTKey = process.env.JWT_SECRET_KEY;
const admin = require('firebase-admin');

const serviceAccount = require('./controllers/service_account_key/chit-chat-aef02-firebase-adminsdk-d0cyb-39bfc07796.json'); // Update the path to your private key

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const messaging = admin.messaging();

const app = express();

app.use(express.json());
//const server = http.createServer(app);
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'images');
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
var upload = multer({ storage: storage });
app.use('/images', express.static(__dirname + '/images'));
//app.use('/test', express.static('test'));



// Connect to the MySQL server
userController.connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL server: ', err);
        return;
    } else {
        const port = process.env.PORT || 5000;
        const server = app.listen(port, () => {
            console.log(`Server listening ${port}`);
        });
        const io = socketIO(server, {
            cors: { transports: ['websocket'] }

        });
        io.on("connect_error", (e) => {
            console.log(e);
        });
        io.on('connection', (socket) => {
            console.log('A user connected:', socket.id);

            socket.on('send_message', (data) => {
                const mssg = {
                    "conversation_id": data.conversation_id,
                    "sender_id": data.sender_id,
                    "message_content": data.message_content
                };
                messageController.insertMssgDB(mssg).then((result) => {
                    const resultData = {
                        "conversation_id": data.conversation_id,
                        "sender_id": data.sender_id,
                        "message_content": data.message_content,
                        "message_id": result.insertId,
                        "timestamp": new Date()
                    };
                    io.emit("receive_message", resultData);
                    //console.log("message sent");
                }).catch((err) => {
                    console.log(err);
                });
                let deviceToken;
                userController.getDeviceToken(data.receiver_id).then((res) => {
                    deviceToken = res;
                    //console.log("device token " + deviceToken);
                    sendMessageToDevice(deviceToken, data.senderUsername, data.message_content);

                }).catch((err) => {
                    console.log(err);
                });

            });
        });

    }
});

const sendMessageToDevice = (deviceToken, title, body) => {
    const message = {
        notification: {
            title: title,
            body: body,
        },
        token: deviceToken,
    };

    messaging.send(message)
        .then((response) => {
            //console.log('Notification sent successfully:', response);
        })
        .catch((error) => {
            console.error('Error sending notification:', error);
        });
};




//register endpoint
app.post("/account/register", userController.createUser);

//login endpoint
app.post('/account/login', userController.login);


//delete account
app.delete('/account/delete', userController.deleteUser);

// Create conversation endpoint
app.post('/conversation/create', conversationController.createConversation);


//get conversation
app.get('/conversation/get', conversationController.getConversation);

//get all conversations
app.get('/conversation/get-all/:user_id', conversationController.getAllConversations);

//delete conversation
app.delete('/conversation/delete/:conversation_id', conversationController.deleteConversation);

//delete message
app.delete('/message/delete/:message_id', messageController.deleteMssg);


//send message endpoint
app.post('/message/send', messageController.createMssg);

//get a message
app.get('/message/get/:message_id', messageController.getMssg);

//get all messages of a conversation
app.get('/conversation/:conversation_id/messages/:sender_id', messageController.getAllMssgs);

//get all participants of a conversation
app.get('/participant/get-all/:conversation_id', conversationController.getParticipantsOfConversation);


//edit username
app.put("/account/edit/username", userController.updateUsername);

//edit email
app.put("/account/edit/email", userController.updateEmail);

//edit phone
app.put("/account/edit/phone", userController.updatePhone);

//search users
app.get("/search_users/:username", userController.searchUsers);

//update img
app.post('/account/updateImg', upload.single('img'), (req, res) => {
    if (!req.file) {
        res.status(400).send({ "error": 'No file uploaded' });
    } else {
        const query = "UPDATE users SET img = ? WHERE user_id = ?"
        userController.connection.query(query, [req.file.path, req.body.user_id], (err, result) => {
            if (err) {
                console.log(err);
            } else {
                res.send({ "filePath": req.file.path });
            }
        })
    }
});

//get user
app.get('/account/getUser/:user_id', userController.getUser);

//remove deviceToken
app.put('/account/deviceToken-remove', userController.removeDeviceToken);



