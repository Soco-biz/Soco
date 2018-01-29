// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//*= require jquery
//= require jquery_ujs
//= require turbolinks
//*= require_tree .

  window.onload = getLocation();

function getLocation(){
  var geocoder;
  navigator.geolocation.getCurrentPosition(is_success,is_error);
  function is_success(position) {
    var gpsLat = position.coords.latitude;
    var gpsLng = position.coords.longitude;
    gmap_init(gpsLat,gpsLng);
  }
  function is_error(error) {
    var result = "";
    switch(error.code) {
      case 1:
      result = '位置情報の取得が許可されていません';
      break;
      case 2:
      result = '位置情報の取得に失敗';
      break;
      case 3:
      result = 'タイムアウト';
      break;
    }
    $("#loading").css("display", "none");
    $("#alert").css("display", "block");
  }

// googlemap init
function gmap_init(gpsLat,gpsLng) {
  var geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(gpsLat,gpsLng);

  geocoder.geocode({'latLng':latlng},function(results,status){
    if (status == google.maps.GeocoderStatus.OK) {
      console.log(results[1].formatted_address);
      result  = '現在地の取得に成功<br>';
      result += '経度：' + gpsLat + '<br>';
      result += '緯度：' + gpsLng + '<br>';
      result += '住所：' + results[0].formatted_address + '<br>';
      userLat = gpsLat;
      userLng = gpsLng;
      $("#loading").css("display", "none");
      roomlist();
    } else {
      $("#loading").css("display", "none");
      $("#alert").css("display", "block");

      console.log(status);
    }
  });
}
}

function roomlist(){
  parseFloat(userLat);
  parseFloat(userLng);
  $.ajax({
    url: location.href,
    type: 'GET',
    data: {
      longitude: userLng,
      latitude: userLat
    },
    dataType: 'json'
  })
  .then(function(data){
    if(data.length > 0){
      $.each(data, function(i, data){
        if(lockedRoomId != data['id']){
        $('#roomlist').append('<a href="/rooms/'+ data['id']  + '?name=' + data['name'] + '"><li>' + data['name'] + '</li></a>');
      }
      })
    }
  })
}
var lockedRoom = function(){
  parseFloat(userLat);
  parseFloat(userLng);
  $.ajax({
    url: location.href,
    type: 'GET',
    data: {
      longitude: userLng,
      latitude: userLat
    },
    dataType: 'json'
  })
  .then(function(data){
    if(data.length > 0){
      $.each(data, function(i, data){
        $('#roomlist').prepend('<a href="/rooms/'+ data['id']  + '?name=' + data['name'] + '"><li>' + data['name'] + '</li></a>');
      })
    }
  })
}