window.onload = getLocation();
locationFlag = 0;
setTimeout(getLocation, 300000);

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
  }

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
        $("#latitude").val(userLat);
        $("#longitude").val(userLng);
        locationFlag = 1;
        form.disabled = "enable";
        $('#submit_TL').css('background-color','#FFBB55');
        $('#submit_TL').css('color','#333');
      } else {
        　   alert("位置情報が取得できないため、表示できません。\nトップページに戻ります");
        location.href="/";
        console.log(status);
      }
    });
  }
}
$('#room_name').focus();
function ShowLength( str ) {
  document.getElementById("inputlength").innerHTML = str.length + "/45";
  form = document.getElementById("submit");
  if (str.length > 45 || locationFlag == 0){
    form.disabled = "disabled";
    $('#submit_TL').css('background-color','rgba(50,50,50,0.1)');
    $('#submit_TL').css('color','#888');
  }else{
    if (str.length < 46 && locationFlag == 1){
      form.disabled = "";
      $('#submit_TL').css('background-color','#FFBB55');
      $('#submit_TL').css('color','#333');
    }
  }
}