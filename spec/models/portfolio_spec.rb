require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  let(:user) { create(:user) }
  let!(:portfolio) { build(:portfolio, user_id: user.id) }
  context "データが正しく保存される" do
    before do
      @portfolio = Portfolio.new
      @portfolio.title = "Hello WebCamp"
      @portfolio.body = "今日も晴れです。"
      @portfolio.user_id = "1"
      @portfolio.id = "1"
      @portfolio.image_id = "1"
      @portfolio.save
    end
    it "全て入力してあるので保存される" do
      expect(@portfolio).to be_valid
    end
  end
end

require 'rails_helper'

RSpec.describe 'Portfolioモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:portfolio) { build(:portfolio, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        portfolio.title = ''
        expect(portfolio.valid?).to eq false;
      end
    end
    context 'bodyカラム' do
      it '空欄でないこと' do
        portfolio.body = ''
        expect(portfolio.valid?).to eq false;
      end
      it '200文字以下であること' do
        portfolio.title = "123456789"
        expect(portfolio.valid?).to eq true;
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Portfolio.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    
    context 'いいねモデルとの関係' do
      it '1:Nとなっている' do
        expect(Portfolio.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    
     context 'お気に入りモデルとの関係' do
      it '1:Nとなっている' do
        expect(Portfolio.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    
     context 'コメントモデルとの関係' do
      it '1:Nとなっている' do
        expect(Portfolio.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    
     context '通知モデルとの関係' do
      it '1:Nとなっている' do
        expect(Portfolio.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
    
  end
end