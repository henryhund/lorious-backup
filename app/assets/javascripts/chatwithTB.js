//(function(){

var vid_obj = {};

vid_obj.connected = false;
vid_obj.waiting_to_connect = false;

vid_obj.timerNumb = 0;

function sessionConnectedHandler(event) {

    $("#wrapper").append("<div id='myPublisherDiv'></div>");
    vid_obj.publisher = TB.initPublisher(vid_obj.api_key, 'myPublisherDiv', {width: "100%", height: "100%"});
    vid_obj.session.publish(vid_obj.publisher);
    
    // Subscribe to streams that were in the session when we connected
    vid_obj.subscribeToStreams(event.streams);
};

function streamCreatedHandler(event) {
  // Subscribe to any new streams that are created
  vid_obj.subscribeToStreams(event.streams);
};

function streamDestroyedHandler(event){
  for (var i = 0; i < event.streams.length; i++){
    if (event.streams[i].connection.connectionId != vid_obj.session.connection.connectionId){
      $("#remoteView").remove();
    }
  }
}

function exceptionHandler(event){
  alert("Exception: " + event.code + "::" + event.message);
}

vid_obj.subscribeToStreams = function(streams) {
    
    //console.log('new stream')
    
    for (var i = 0; i < streams.length; i++) {
    
        //console.log(streams[i].connection.connectionId);
        
        // Make sure we don't subscribe to ourself
        if (streams[i].connection.connectionId == vid_obj.session.connection.connectionId) {
            return;
        }
        
        if($("#remoteView").length == 0){
            var div = $('<div id="remoteView"></div>');
          $('#wrapper').append($(div));
        }
        
        vid_obj.remoteStream = streams[i];
        
        vid_obj.subscriber = vid_obj.session.subscribe(streams[i], 'remoteView', {width: '100%', height: '100%'});
    }
    
};


vid_obj.timerCount = function(){

    
    if(Object.keys(vid_obj.session.connections).length > 1){
    
        vid_obj.timerNumb++;
        
        $('#video_timer_seconds').html(vid_obj.timerNumb);
    
        if(vid_obj.connected == false){
            vid_obj.reportAction('connect');
            vid_obj.connected = true;
        }

    }else{
    
        if(vid_obj.connected == true){
            vid_obj.reportAction('disconnect');
            vid_obj.connected = false;
        }
    }

};

vid_obj.reportAction = function(the_action){

    $.ajax({ 
      type: 'post', 
    url: '/report_listener', 
    cache: false,
    //dataType: 'json',
    data: {
      'user_id': 'userX',
        'session_id' : vid_obj.session_id,
        'action': the_action
    }
  });
};

vid_obj.activate = function(){
    
    // Enable console logs for debugging
    //TB.setLogLevel(TB.DEBUG);
    
    // Initialize session, set up event listeners, and connect
    vid_obj.session = TB.initSession(vid_obj.session_id);
    
    vid_obj.session.addEventListener('sessionConnected', sessionConnectedHandler);
    vid_obj.session.addEventListener('streamCreated', streamCreatedHandler);
    vid_obj.session.addEventListener('streamDestroyed', streamDestroyedHandler);
    
    vid_obj.session.connect(vid_obj.api_key, vid_obj.token);
    
    if (screenfull.enabled) {
        
        $('#go_fullscreen').click(function(){
        
            screenfull.request(document.getElementById('wrapper'));
            
        });
        
        $(document).on(screenfull.raw.fullscreenchange, function () {
            if (screenfull.isFullscreen && !$('#wrapper').hasClass('wrapper_fullscreen')) {
                
                console.log('adding class "wrapper_fullscreen" to #wrapper');
                $('#wrapper').addClass('wrapper_fullscreen');
            
            }else if(!screenfull.isFullscreen && $('#wrapper').hasClass('wrapper_fullscreen')){
            
                console.log('removing class "wrapper_fullscreen" to #wrapper');
                
                $('#wrapper').removeClass('wrapper_fullscreen');
            
            }
            
      });
        
        
    }
    
    $('#disconnect_button').click(function(){
    
        //vid_obj.session.unsubscribe(vid_obj.remoteStream);
        //vid_obj.session.unpublish(vid_obj.publisher);
        vid_obj.session.disconnect();
        
        
        $('#disconnect_button').attr('disabled', 'disabled');
        
        $('#disconnect_button').html('Disconnected');
    
    });
    
    vid_obj.sessionTimer = window.setInterval(vid_obj.timerCount, 1000);
    
};


//});
