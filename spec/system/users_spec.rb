require 'rails_helper'

describe 'ユーザー認証のテスト' do
  describe 'ユーザー新規登録' do
    before do
      visit new_user_registration_path
    end
    context '新規登録画面に遷移' do
      it '新規登録に成功する' do
        fill_in 'user[name]', with: Faker::Internet.username(specifier: 5)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'Sign up'

        expect(page).to have_content '新規登録が完了しました'
      end
      it '新規登録に失敗する' do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button 'Sign up'

        expect(page).to have_content 'エラー'
      end
    end
  end
  describe 'ユーザーログイン' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context 'ログイン画面に遷移' do
      let(:test_user) { user }
      it 'ログインに成功する' do
        fill_in 'user[name]', with: test_user.name
        fill_in 'user[password]', with: test_user.password
        click_button 'Log in'

        expect(page).to have_content 'ログインしました'
      end

      it 'ログインに失敗する' do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'

        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end

describe 'ユーザーのテスト' do
  let(:user) { create(:user) }
  let!(:test_user2) { create(:user) }
  let!(:portfolio) { create(:portfolio, user: user) }
  let!(:portfolio2) { create(:portfolio, user: test_user2) }
  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end
  describe 'サイドバーのテスト' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it 'マイページと表示される' do
        expect(page).to have_content('マイページ')
      end
      it '新規投稿表示される' do
        expect(page).to have_content('新規投稿')
      end
      it '自己紹介が表示される' do
        expect(page).to have_content(user.introduction)
      end
      it '編集リンクが表示される' do
        visit user_path(user)
        expect(page).to have_link '', href: edit_user_path(user)
      end
    end
  end

  describe '編集のテスト' do
    context '自分の編集画面への遷移' do
      it '遷移できる' do
        visit edit_user_path(user)
        expect(current_path).to eq('/users/' + user.id.to_s + '/edit')
      end
    end
    context '他人の編集画面への遷移' do
      it '遷移できない' do
        visit edit_user_path(test_user2)
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
    end

    context '表示の確認' do
      before do
        visit edit_user_path(user)
      end
      it 'ユーザー編集と表示される' do
        expect(page).to have_content('ユーザー編集')
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '編集に成功する' do
        click_button '登録'
        expect(page).to have_content 'プロフィールを更新しました'
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
      it '編集に失敗する' do
        fill_in 'user[name]', with: ''
        click_button '登録'
        expect(page).to have_content '失敗しました'
				#もう少し詳細にエラー文出したい
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it '投稿一覧と表示される' do
        expect(page).to have_content('投稿一覧')
      end
      it '自分と他の人の名前が表示される' do
        expect(page).to have_content portfolio.user.name
        expect(page).to have_content portfolio2.user.name
      end
    end
  end
  describe '詳細画面のテスト' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it '他人のユーザー名前と表示される' do
        visit user_path(test_user2)
        expect(page).to have_content(test_user2.name)
      end
      it '投稿一覧のユーザーの画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧のtitleのリンク先が正しい' do
        expect(page).to have_link portfolio.image, href: portfolio_path(portfolio)
      end
      it '投稿一覧の本文を表示される' do
        click_button '本文を表示'
      end
      it 'ユーザーのintroductionが表示される' do
        expect(page).to have_content(user.introduction)
      end
    end
  end
end
