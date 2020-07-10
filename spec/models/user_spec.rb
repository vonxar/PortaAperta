require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  # 名前が空欄で登録できない→名前を空欄で登録したらfalse
  # バリデーションしていない状態で失敗→設定したら成功
  # 登録できるかできないか 登録できたら失敗
  # エラーメッセージがなければ失敗

  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
    subject { test_user.valid? }
    context 'nameカラム' do
      let(:test_user) { user }
      it '空欄でないこと' do
        test_user.name = ''
        is_expected.to eq false;
      end
      it '1文字以上であること' do
        test_user.name = Faker::Lorem.characters(number:0)
        is_expected.to eq false;
      end
      it '20文字以下であること' do
        test_user.name = Faker::Lorem.characters(number:21)
        is_expected.to eq false;
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Portfolioモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:portfolios).macro).to eq :has_many
      end
    end
    context 'Favoritesモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'favorite_portfoliosモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorite_portfolios).macro).to eq :has_many
      end
    end
    context 'likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'reply_commentsモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:reply_comments).macro).to eq :has_many
      end
    end
    context 'active_notificationsモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:active_notifications).macro).to eq :has_many
      end
    end
     context 'passive_notificationsモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:passive_notifications).macro).to eq :has_many
      end
    end
  end
end
# アソシエーションのテスト