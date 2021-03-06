require 'rails_helper'

describe 'トップページのテスト' do
  let(:user) { create(:user) }
  before do
    visit root_path
  end
  describe 'ボディ部分のテスト' do
    context '表示の確認' do
      it 'ログインリンクが表示される' do
        expect(page).to have_button, action: '/users/sign_in'
      end
      it 'Sign Upリンクが表示される' do
        expect(page).to have_link href: '/users/sign_up'
      end
    end

    context 'ログインしている場合の挙動を確認' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
        visit root_path
      end
      it 'Log inリンクをクリックしたらユーザー詳細画面へ遷移する' do
        visit new_user_session_path
        expect(page).to have_content 'ログインしています'
      end
    end

    context 'ログインしていない場合の挙動を確認' do
      it 'Log inリンクをクリックしたらログイン画面へ遷移する' do
        click_button 'ログイン'
        expect(current_path).to eq(new_user_session_path)
      end
      it 'Sign Upリンクをクリックしたら新規登録画面に遷移する' do
        click_on '新規登録'
        expect(current_path).to eq(new_user_registration_path)
      end
    end
  end
end