// page changed handler
Panoptic.appInitRan = false;
Panoptic.pageChange = function(event, ui) {
    if (! Panoptic.appInitRan) {
        Panoptic.appInit();
        Panoptic.appInitRan = true;
    }
    
    // clear current page timers
    if (Panoptic.pageTimers) {
        for (var i in Panoptic.pageTimers) {
            var timer = Panoptic.pageTimers[i];
            window.clearInterval(timer);
        }
    }
    
    // page initialization handlers go here
    var pageInitHandlers = {
        'home_page': Panoptic.homePageInit,
        'camera_list_page': Panoptic.cameraListInit,
        'edit_camera_dialog': Panoptic.cameraEditInit,
        'camera_view_page': Panoptic.cameraViewInit
    };
    if (event.target && event.target.id) {
        var handler = pageInitHandlers[event.target.id];
        // call page init handler
        if (handler)
            handler();
    }
};

// jqMobile initialization
Panoptic.mobileInit = function() {
    // $.mobile.pushStateEnabled = false; 
    // $.mobile.hashListeningEnabled = false;
    $(document).delegate('div', "pageshow", Panoptic.pageChange);
};
$(document).bind("mobileinit", Panoptic.mobileInit);

// panoptic app initialization
Panoptic.appInit = function() {
    // $.mobile.hashListeningEnabled = true;
};

$(function () {
});

Panoptic.ajaxDelete = function(uri, params, cb) {
    $.ajax({
        'url': uri,
        'data': params,
        'success': cb,
        'type': 'post',
        'headers': {
            'x-http-method-override': 'DELETE'
        }
    });
};

function debug(msg) {
    try {
        console.log(msg);
    } catch (x) {}
}

/////

Panoptic.homePageInit = function() {
    $.mobile.changePage("/camera/list");
};

Panoptic.cameraEditInit = function() {
    var cameraId = $(".delete_camera_button").data("camera-id");
    if (! cameraId) {
        debug("failed to find cameraId on delete button");
        return;
    }
    $(".delete_camera_button").click(function() {
        Panoptic.ajaxDelete("/api/rest/camera/" + cameraId, {}, function() {
            $.mobile.changePage("/camera/list");
        })
    });
};

// camera list view
Panoptic.cameraListInit = function() {
    var thumbRefresh = Panoptic.config.camera.snapshot.thumbnail_refresh_rate;
    Panoptic.setPageInterval(Panoptic.reloadCameraList, thumbRefresh * 1000);
    Panoptic.reloadCameraList();
};
Panoptic.reloadCameraList = function() {
  var cameraLoader = $(".camera_list_container .camera_list.dynamic_inner");
  $.get('/camera/list_inner', function(res) {
      if (! res || ! res.res_list) return;

      // set offscreen content to list content first, to load images and prevent flicker
      var offscreen = $(".camera_list_container .offscreen");
      offscreen.empty().html(res.res_list);

      // update list view a little later
      window.setTimeout(function() {
          cameraLoader.empty().append($(".camera_list_container .offscreen > li"));
          cameraLoader.listview('refresh');
      }, 300);
  });
};

// camera view
Panoptic.cameraViewInit = function() {
    var currentCamera = Panoptic.currentCamera;
    if (! currentCamera) {
        debug("currentCamera is missing in cameraViewInit");
        return;
    }

    var rate = Panoptic.config.camera.live.snapshot_refresh_rate;
    Panoptic.setPageInterval(Panoptic.refreshLive, rate * 1000);
    Panoptic.setPageInterval(function() { Panoptic.updateCamera(currentCamera) }, rate * 1000);
    Panoptic.refreshLive();
    Panoptic.updateCamera(currentCamera);
};

// sets a timer for the current page, clears it when leaving page
Panoptic.setPageInterval = function (callback, interval) {
    if (! Panoptic.pageTimers)
        Panoptic.pageTimers = [];
        
    var timer = window.setInterval(callback, interval);
    Panoptic.pageTimers.push(timer);
    return timer;
}

Panoptic.updateCamera = function (camera) {
    $.ajax({
        url: "/api/rest/camera",
        success: function (res) { Panoptic.gotCameraUpdate(res, camera) },
        data: {
            'search.id': camera.id,
            '_': Math.random(),
            'updateLive': 1
        }
    });
};

Panoptic.gotCameraUpdate = function(res, target) {
    if (! target) {
        debug("got camera update with null target");
        return;
    }
    
    if (! res || ! res.list || ! res.list.length) return;
    var camera = res.list[0];
    
    // find camera pane
    var cameraPane = $(".live_view.camera_" + camera.id);
    if (! cameraPane.length) return;

    // refresh image
    var cameraImg = cameraPane.find("img.snapshot");
    if (camera.s3_snapshot_uri)
        cameraImg.attr('src', camera.s3_snapshot_uri);

    // update snapshot updated time
    var timestampContainer = cameraPane.find(".last_snapshot_time_container");
    if (camera.snapshot_last_updated) {
        timestampContainer.show();
        // convert to local time
        var d = new Date(camera.snapshot_last_updated * 1000);
        timestampContainer.find(".time").text(d.toLocaleString());
    }
    
    // copy fields
    for (var f in camera) {
        target[f] = camera[f];
    }
    target.isLoaded = true;
}

Panoptic.refreshLive = function() {
    var currentCamera = Panoptic.currentCamera;
    if (! currentCamera) {
        debug("Panoptic.currentCamera missing in refreshLive");
        return;
    }
    
    if (! currentCamera.isLoaded || ! currentCamera.s3_snapshot_uri)
        return;
    
    $(".live_view img.snapshot").attr('src', currentCamera.s3_snapshot_uri + "&_=" + Math.random());
}


