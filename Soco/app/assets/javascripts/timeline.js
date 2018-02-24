window.onload = getLocation();

setInterval(update, 10000);
setInterval(getLocation, 300000);

$(function(){
  $("#test").html("Hello World!")
});
$(function() {
  var topBtn = $('#pagetop');
  topBtn.hide();
  $(window).scroll(function () {
    if ($(this).scrollTop() > 100) {
      topBtn.fadeIn();
    } else {
      topBtn.fadeOut();
    }
  });

  topBtn.click(function () {
    $('body,html').animate({
      scrollTop: 0
    }, 500);
    return false;
  });
});
$('#upfile').change(function(){
  if (this.files.length > 0) {
    var file = this.files[0];
    var reader = new FileReader();
    reader.readAsDataURL(file);
    console.log(reader);
    reader.onload = function() {
      var height = 500;
      $('#thumbnail').attr('src', reader.result );
      var image = reader.result;
      document.getElementById('image').value=image;
    }
  }
});
function escapeHTML(str) {
  return str.replace(/&/g, '&amp;')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;')
  .replace(/'/g, '&#039;');
}

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
        $("#loading").css("display", "none");
        checkLocation();
      } else {
        $("#loading").css("display", "none");
      }
    });
  }
}
function displayTime(unixTime) {
  var date = new Date(unixTime)
  var diff = new Date().getTime() - date.getTime()
  var d = new Date(diff);

  if (d.getUTCFullYear() - 1970) {
    return d.getUTCFullYear() - 1970 + 'years'
  } else if (d.getUTCMonth()) {
    return d.getUTCMonth() + 'months'
  } else if (d.getUTCDate() - 1) {
    return d.getUTCDate() - 1 + 'days'
  } else if (d.getUTCHours()) {
    return d.getUTCHours() + 'hours'
  } else if (d.getUTCMinutes()) {
    return d.getUTCMinutes() + 'minutes'
  } else {
    return 'less than a minute'
  }
}

function ShowLength( str ) {
  document.getElementById("inputlength").innerHTML = str.length + "/200";
  form = document.getElementById("submit");
  if (str.length > 200 || locationFlag == 0){
    form.disabled = "disabled";
    $('#submit_label').css('background-color','rgba(50,50,50,0.1)');
    $('#submit_label').css('color','#888');
  }else{
    if (str.length < 201 && locationFlag == 1){
      form.disabled = "";
      $('#submit_label').css('background-color','#FFBB55');
      $('#submit_label').css('color','#333');
    }
  }
}

function submitWait(){
  form = document.getElementById("submit");
  form.disabled = "disabled";
  $('#submit_label').css('background-color','rgba(50,50,50,0.1)');
  $('#submit_label').css('color','#888');
}

function update(){
  $.ajax({
    url: location.href,
    type: 'GET',
    data: {
      last_id: last_id
    },
    dataType: 'json'
  })
  .then(function(data){
    if(data.length > 0){
      $.each(data, function(i, data){
        var content = escapeHTML(data['content']);
        var image = null;
        content = content.replace(/\r?\n/g, '<br>');
        if (content.match(/&gt;&gt;\d*/)){
          var anchor = "" + content.match(/&gt;&gt;\d*/);
          content = content.replace(/&gt;&gt;\d*/,'<a class="anchor_link" href="#' + '">>>' + anchor.substr( 8 ) + '</a>')
        }
        postId[data['id']] = counts;
        if(data['image'] == null){
          var image = '';
        } else{
          var image = '<a href="' + data['image'] + '" target="_blank"><img src="' + data['image'] + '"　target="_blank" src="' + data['image'] + '"></a>';
        }

        if(data['simvalue'] > 0.49){
          var similarity = data['similarity'];
          $('#timeline').prepend('<div class="post"><div class="text_body">' + content + '</div>' + image + ' <div class="text_data">'  + postId[data['id']] + ' : less than a minute  <a href="#' + similarity  + '"> >>' + postId[data['similarity']]  + '</a></div> </div>');
        }else{
          $('#timeline').prepend('<div class="post"><div class="text_body">' + content + '</div> ' + image + '<div class="text_data">'  + postId[data['id']] + ' : less than a minute </div> </div>');
        }
        last_id = data['id'];
      })
    }
  })
}