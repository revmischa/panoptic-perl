// page changed handler
Panoptic.appInitRan = false;
Panoptic.pageChange = function(event, ui) {
    if (! Panoptic.appInitRan) {
        Panoptic.appInit();
        Panoptic.appInitRan = true;
    }
};

// jqMobile initialization
Panoptic.mobileInit = function() {
    $.mobile.pushStateEnabled = false; 
    $.mobile.hashListeningEnabled = false;
debug("mobile init");
    $(document).delegate('div', "pageshow", Panoptic.pageChange);
};
debug("init");
$(document).bind("mobileinit", Panoptic.mobileInit);

// panoptic app initialization
Panoptic.appInit = function() {
    $.mobile.hashListeningEnabled = true;
};

$(function () {
    var pageInitHandlers = {
        '#camera_view_page': Panoptic.cameraViewInit
    };
    for (var page in pageInitHandlers) {
        $(document).delegate(page, "pageshow", pageInitHandlers[page]);
    }
});

function debug(msg) {
    try {
        console.log(msg);
    } catch (x) {}
}

/////

Panoptic.cameraViewInit = function() {
console.log("cameraViewInit");
    var currentCamera = Panoptic.currentCamera;
    if (! currentCamera) {
        debug("currentCamera is missing in cameraViewInit");
        return;
    }

    debug("initted camera view");
    var rate = Panoptic.config.camera.live.snapshot_refresh_rate;
    window.setInterval(Panoptic.refreshLive, rate * 1000);
    window.setInterval(function() { Panoptic.updateCamera(currentCamera.id) }, rate * 1000);
    refreshLive();
    updateCamera(currentCamera.id);
};

Panoptic.updateCamera = function (cameraId) {
    $.ajax({
        url: "/api/rest/camera",
        success: Panoptic.gotCameraUpdate,
        data: {
            'search.id': cameraId,
            '_': Math.random(),
            'updateLive': 1
        }
    });
};

Panoptic.gotCameraUpdate = function(res) {
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
}

Panoptic.refreshLive = function() {
    $(".live_view img.snapshot").attr('src', "[% camera.s3_snapshot_uri %]&_=[% unixtime() %]");
}


