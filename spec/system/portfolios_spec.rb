require 'rails_helper'

describe '投稿のテスト' do
  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:portfolio) { create(:portfolio, user: user) }
  let!(:portfolio2) { create(:portfolio, user: user2) }
  before do
  	visit new_user_session_path
  	fill_in 'user[name]', with: user.name
  	fill_in 'user[password]', with: user.password
  	click_button 'Log in'
  end
  describe 'サイドバーのテスト' do
		context '表示の確認' do
		  it '投稿と表示される' do
	    	expect(page).to have_content '投稿一覧'
		  end
		  it 'ログインが表示される' do
		  	expect(page).to have_content 'ログインしました。'
		  end
		#   it '投稿に成功する' do
		#   	fill_in 'portfolio[title]',"123456789"
		#   	fill_in 'portfolio[body]', "12345678901234567890"
		#   	click_button 'portfolio登録'
		#   	expect(page).to have_content '投稿'
		#   end
		#   it '投稿に失敗する' do
		#   	click_button 'portfolio登録'
		#   	expect(page).to have_content 'error'
		#   	expect(current_path).to eq('/portfolio')
		#   end
		end
  end

  describe '編集のテスト' do
  	context '自分の投稿の編集画面への遷移' do
  	  it '遷移できる' do
	  		visit edit_portfolio_path(portfolio)
	  		expect(edit_portfolio_path(portfolio.id)).to eq('/portfolios/' + portfolio.id.to_s + '/edit')
	  	end
	  end
		context '他人の投稿の編集画面への遷移' do
		  it '遷移できない' do
		    visit edit_portfolio_path(portfolio2)
		    expect(edit_portfolio_path(portfolio2.id)).to eq('/portfolios/' + portfolio2.id.to_s + '/edit')
		  end
		end
		context '表示の確認' do
			before do
				visit edit_portfolio_path(portfolio)
			end
			it '編集と表示される' do
				expect(page).to have_content('編集')
			end
			it 'titleフィールドが表示される' do
				expect(page).to have_field 'portfolio[title]'
			end
			it 'Backが表示される' do
				expect(page).to have_content('Back')
			end
		end
		context 'フォームの確認' do
			it '編集に成功する' do
				visit edit_portfolio_path(portfolio)
				click_button '編集保存'
				expect(page).to have_content '反映'
				expect(top_path).to eq '/top'
			end
			it '編集に失敗する' do
				visit edit_portfolio_path(portfolio)
				fill_in 'portfolio[title]', with: ''
				click_button '編集保存'
				expect(current_path).to eq '/portfolios/' + portfolio.id.to_s
			end
		end
	end

  describe '一覧画面のテスト' do
  	before do
  		visit top_path
  	end
  	context '表示の確認' do
  		it '投稿一覧と表示される' do
  			expect(page).to have_content '投稿一覧'
  		end
  		it '自分と他人の画像のリンク先が正しい' do
  			expect(page).to have_link '', href: user_path(portfolio.user)
  			expect(page).to have_link '', href: user_path(portfolio2.user)
  		end
  	end
  end

  describe '詳細画面のテスト' do
  	context '自分・他人共通の投稿詳細画面の表示を確認' do
  		it 'ポートフォリオ詳細と表示される' do
  			visit portfolio_path(portfolio)
  			expect(page).to have_content 'ポートフォリオ詳細'
  		end
  		it 'ユーザー画像・名前のリンク先が正しい' do
  			visit portfolio_path(portfolio)
  			expect(page).to have_link portfolio.user.name, href: user_path(portfolio.user)
  		end
  		it '投稿のtitleが表示される' do
  			visit portfolio_path(portfolio)
  			expect(page).to have_content portfolio.title
  		end
  		it '訪問回数が表示される' do
  			visit portfolio_path(portfolio)
  			expect(page).to have_content portfolio.impressionist_count
  		end
  	end
  	context '自分の投稿詳細画面の表示を確認' do
  		it '投稿の編集リンクが表示される' do
  			visit portfolio_path(portfolio)
  			expect(page).to have_link '編集', href: edit_portfolio_path(portfolio)
  		end
  		it '投稿の削除リンクが表示される' do
  			visit portfolio_path(portfolio)
  			expect(page).to have_link '削除', href: portfolio_path(portfolio,portfolio_destroy: 1)
  		end
  	end
  	context '他人の投稿詳細画面の表示を確認' do
  		it '投稿の編集リンクが表示されない' do
  			visit portfolio_path(portfolio2)
  			expect(page).to have_no_link '編集', href: edit_portfolio_path(portfolio2)
  		end
  		it '投稿の削除リンクが表示されない' do
  			visit portfolio_path(portfolio2)
  			expect(page).to have_no_link '削除', href: portfolio_path(portfolio2)
  		end
  	end
  end
end