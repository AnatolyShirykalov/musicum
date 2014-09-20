admin_pw = "FKBSZJWI"
User.destroy_all
User.create!(email: 'admin@musicum.ru', password: admin_pw, password_confirmation: admin_pw)
