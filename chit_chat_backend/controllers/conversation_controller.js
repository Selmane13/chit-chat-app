const mysql = require('mysql2');
const userController = require('./user_controller');


const insertConversation = (participants, conversation_name) => {
    return new Promise((resolve, reject) => {
        const query1 = 'INSERT INTO conversations (conversation_name,creator_user_id) VALUES (?, ?)';
        const query2 = 'INSERT INTO participants(user_id , conversation_id) VALUES (? ,?)';
        userController.connection.query(query1, [conversation_name, participants.creator_user_id], (err, result) => {
            if (err) {
                reject(err);
            } else {
                const conversationId = result.insertId;
                userController.connection.query(query2, [participants.creator_user_id, conversationId], (err2, res2) => {
                    if (err2) {
                        reject(err2);
                    } else {
                        userController.connection.query(query2, [participants.second_user_id, conversationId], (err3, res3) => {
                            if (err3) {
                                reject(err3);
                            } else {

                                const conversationInfo = {
                                    conversationId,
                                    particpantId1: res2.insertId,
                                    particpantId2: res3.insertId
                                };
                                resolve(conversationInfo);
                            }
                        })
                    }
                })
            }
        });
    });
};


const createConversation = (req, res) => {
    const participants = req.body.participants;
    const conversation_name = req.body.conversation_name
    insertConversation(participants, conversation_name)
        .then((result) => {
            res.status(200).send(result);
        })
        .catch((err) => {
            console.log(err);
        })

};

const getConversation = (req, res) => {
    const conversation_id = req.body.conversation_id;
    const query = 'SELECT * FROM conversations WHERE conversation_id =  ?';
    userController.connection.query(query, conversation_id, (err, result) => {
        if (err) {
            console.log(err);

        } else {
            res.status(200).send(result);
        }
    })
};

const getAllConversations = (req, res) => {

    //userController.verifyJwt()
    getConversationsOfUser(req.params.user_id)
        .then((conversations) => {

            let query;
            let results = [];
            if (conversations.length == 0) {
                res.status(401).send(results);
            } else {
                if (conversations != null) {

                    conversations.forEach((element, index) => {
                        query = 'SELECT * FROM conversations WHERE conversation_id = ?';

                        userController.connection.query(query, element, (err, result) => {
                            if (err) {

                                console.log("err in conversation.forEach: " + err);
                            } else {

                                results.push(result[0]);
                                if (index == conversations.length - 1) {
                                    res.status(200).json(results);
                                }
                            }
                        });

                    });


                }
            }
        })
        .catch((err) => {
            console.log("Error in getAllConversations: " + err);
        });
};

const getConversationsOfUser = (user_id) => {
    return new Promise((resolve, reject) => {
        const query = "SELECT * FROM participants WHERE user_id = ?";
        userController.connection.query(query, [user_id], (err, res) => {
            if (err) {
                console.log("Error in getConversationsOfUser: " + err);
                reject(err);
            } else {
                const conversations = res.map((element) => element.conversation_id);
                resolve(conversations);
            }
        });
    });
};

const deleteConversation = (req, res) => {
    const conversation_id = req.params.conversation_id;

    //delete participants first
    const deleteParticipantsQuery = 'DELETE FROM participants WHERE conversation_id = ?';
    userController.connection.query(deleteParticipantsQuery, conversation_id, (err, result) => {
        if (err) {
            console.log(err);
            res.status(500).json({ error: 'Internal server error' });
        } else {
            // Delete messages related to the conversation first
            const deleteMessagesQuery = 'DELETE FROM messages WHERE conversation_id = ?';
            userController.connection.query(deleteMessagesQuery, conversation_id, (err, result) => {
                if (err) {
                    console.log(err);
                    res.status(500).json({ error: 'Internal server error' });
                } else {
                    // Delete the conversation
                    const deleteConversationQuery = 'DELETE FROM conversationss WHERE conversation_id = ?';
                    userController.connection.query(deleteConversationQuery, conversation_id, (err, result) => {
                        if (err) {
                            console.log(err);
                            res.status(500).json({ error: 'Internal server error' });
                        } else {
                            res.status(200).json({ message: 'Conversation deleted successfully' });
                        }
                    });
                }
            });
        }
    })
};

const getParticipantsOfConversation = (req, res) => {
    const conversation_id = req.params.conversation_id;
    const query = "SELECT * FROM participants WHERE conversation_id = ?";
    userController.connection.query(query, [conversation_id], (err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.status(200).send(result);
        }
    })
}

module.exports = {
    createConversation,
    getConversation,
    getAllConversations,
    deleteConversation,
    getParticipantsOfConversation
}