# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Example User",
            email: "example@railstutorial.org",
            password: "foobar",
            password_confirmation: "foobar")


9.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email:  email,
              password:               password,
              password_confirmation:  password
        )
end

# カテゴリー
Category.create!(
[
	{
		name: "Webサービス・アプリ"
	},
	{
		name: "行政・NPO・ボランティア"
	},
	{
		name: "アート・デザイン"
	},
  {
    name: "アニメ・ゲーム・おもちゃ"
  },
  {
    name: "飲食・食品"
  },
  {
    name: "その他"
  }
]
)

# ポートフォリオ
Portfolio.create!(
[
	{
		user_id: 1,
		title: "utopeer",
		body: "長野の山葵をモチーフに緑で配色した、ECサイトです。山葵ちゃんが隠れてます、マウスオーバーで見つけてね。クリックすると何か起きるかも。。。",
    image: open("./db/images/port1.png"),
    category_id: 1
	},
	{
		user_id: 1,
		title: "webcats",
		body: "ねこ",
    image: open("./db/images/port2.png"),
    category_id: 1
	},
	{
		user_id: 1,
		title: "ellegrden",
		body: "バンド",
    image: open("./db/images/port3.png"),
    category_id: 1
	},
	{
		user_id: 2,
		title: "ピフビ村",
		body: "村",
    image: open("./db/images/port4.png"),
    category_id: 1
	},
	{
		user_id: 2,
		title: "謙虚な肉食系",
		body: "肉",
    image: open("./db/images/port5.png"),
    category_id: 1
	},
	]
	)