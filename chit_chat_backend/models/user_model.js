

class UserModel {
    constructor(user_id, username, email, password, phone, registration_date) {
        this.user_id = user_id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.registration_date = registration_date;
    }
}


module.exports = UserModel;