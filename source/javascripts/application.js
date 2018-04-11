$(document).ready(function(){
  // var options = {
  //   cmsEndpoint: CRDS.media.cms,
  //   appEndpoint: CRDS.media.app,
  //   imgEndpoint: CRDS.media.img,
  //   crdsCookiePrefix: CRDS.media.prefix
  // };

  // var header = new CRDS.SharedHeader(options);
  //     header.render();

  // var foot = new CRDS.SharedFooter(options);

  imgix.onready(function() {
    var initializeImgix = function(selector) {
      imgix.fluid({
        fluidClass: selector,
        updateOnResizeDown: true,
        updateOnPinchZoom: true,
        pixelStep: 10,
        autoInsertCSSBestPractices: true
      });
    }
    initializeImgix('imgix-fluid');
    initializeImgix('imgix-fluid-bg');
  });
});
