// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
import * as Trix from "trix";

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require jquery_ujs
//= require bootstrap-tagsinput
//= require_tree .

import '../stylesheets/application'
import "bootstrap";
global.$ = jQuery;

// $(function(){
// $('.container').mouseover(function(){
//         $('.container').css({'display': 'none'});
//     });
// });
require("trix")
require("@rails/actiontext")

//userページのスクロール機能
 $(function(){
        // #で始まるリンクをクリックしたら実行されます
        $('a[href^="#"]').click(function() {
          
          // スクロールの速度
          var speed = 400; // ミリ秒で記述
          var href= $(this).attr("href");
          var target = $(href == "#" || href == "" ? 'html' : href);
          var position = target.offset().top;
          $('body,html').animate({scrollTop:position}, speed, 'swing');
          return false;
        });
   });
//-----end-----------
   
   
//画像プレビュー
   $(function(){
    // inputのidから情報の取得
    $('#portfolio_image').on('change', function (e) {
// ここから既存の画像のurlの取得
    var reader = new FileReader();
    reader.onload = function (e) {
        $(".attachment.portfolio.image.img-square.fallback").attr('src', e.target.result);
    }
// ここまで
    reader.readAsDataURL(e.target.files[0]); //取得したurlにアップロード画像のurlを挿入
});
});
//--------end----------

//タグ化機能
$(function() {
        $('input').on("keydown",function(e){
        if  (e.keyCode == 188) {
            var btn = $('#portfolio_tag_list').val();
        $('.output').append('<span class="badge badge-primary"id='+btn+'>'+btn+"    "+'<a class="remove_tag">'+'︎❌'+'</a>'+'</span>'+" ");
          $("#portfolio_tag_list").val("");
          return false;
        } });
        $('body').on('click','.badge-primary',function(){
            var id =  $(this).attr("id");
          console.log(id);
          $('#'+id).remove();
        });
});
        
$(function() {
  $("body").on('click','#tag_lists',function(){
var tags = $('.badge-primary').map(function(){
  return this.id;
}).get();
 $("#hid").val(tags);
});
});

//----------end-----------

// インクリメンタルサーチ
$(document).on('turbolinks:load', function(){ //リロードしなくてもjsが動くようにする
  $(document).on('keyup', '#search', function(e){ //このアプリケーション(document)の、formというid('#form')で、キーボードが押され指が離れた瞬間(.on('keyup'...))、eという引数を取って以下のことをしなさい(function(e))
    e.preventDefault(); //キャンセル可能なイベントをキャンセル
    var input = $.trim($(this).val()); //この要素に入力された語句を取得し($(this).val())、前後の不要な空白を取り除いた($.trim(...);)上でinputという変数に(var input =)代入
    if (input.length !== 0){
    $.ajax({ //ajax通信で以下のことを行います
      url: '/portfolios/search', //urlを指定
      type: 'GET', //メソッドを指定
      data: ('word=' + input), //コントローラーに渡すデータを'word=input(入力された文字のことですね)'にするように指定
      processData: false, //おまじない
      contentType: false, //おまじない
      dataType: 'json' //データ形式を指定
    })
      .done(function(data){//データを受け取ることに成功したら、dataを引数に取って以下のことする(dataには@usersが入っている状態ですね)
      $('#result').find('li').remove();  //idがresultの子要素のliを削除する
        if(data.length !== 0){
      $(data).each(function(i, user){ //dataをuserという変数に代入して、以下のことを繰り返し行う(単純なeach文ですね)
        $('#result').append('<li>' + '<a class="search_a"  href="/users/'+user.id+'">'+ user.name +'</a>'+ '</li>')//resultというidの要素に対して、<li>ユーザーの名前</li>を追加する。
      });
      } else {  $('#result').append('<li>' + "一致するユーザーがありません" + '</li>')
      }
    });
    } else{
    $('#result').find('li').remove();
    }
  });
});

//---------end------------


