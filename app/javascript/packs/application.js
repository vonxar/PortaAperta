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