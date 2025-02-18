$(document).ready(function () {
  setTimeout(function() {
    $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.JPG'],a[href$='.png'],a[href$='.gif'],a[href$='.webp'],a[href$='.mp4']")
    .removeClass("image-popup my-popup");
    
    $("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.JPG'],a[href$='.png'],a[href$='.gif'],a[href$='.webp'],a[href$='.mp4']")
    .addClass("my-popup");
    
    $(".my-popup").magnificPopup({
      type: 'image',
      tLoading: "Loading media #%curr%...",
      gallery: {
        enabled: true,
        navigateByImgClick: true,
        preload: [0, 1], // Will preload 0 - before current, and 1 after the current image
      },
      image: {
        tError: '<a href="%url%">Media #%curr%</a> could not be loaded.',
      },
      removalDelay: 500, // Delay in milliseconds before popup is removed
      // Class that is added to body when popup is open.
      // make it unique to apply your CSS animations just to this exact popup
      mainClass: "mfp-zoom-in",
      
      callbacks: {
        beforeOpen: function () {
          // just a hack that adds mfp-anim class to markup
          this.st.image.markup = this.st.image.markup.replace(
            "mfp-figure",
            "mfp-figure mfp-with-anim"
          );
        },
        
        elementParse: function(item) {
          if(item.el.attr('href').endsWith('.mp4')) {
            item.type = 'inline';
            const videoId = 'video-' + Math.random().toString(36).substr(2, 9);
            item.src = `<div class="mfp-figure">
              <div class="mfp-video-container">
                <video controls autoplay id="${videoId}">
                  <source src="${item.el.attr('href')}" type="video/mp4">
                  Your browser does not support the video tag.
                </video>
              </div>
            </div>`;
          }
        },

        beforeClose: function() {
          // Pause any playing videos before closing
          const video = this.content.find('video')[0];
          if (video) {
            video.pause();
          }
        },

        change: function() {
          // Pause previous video when navigating
          const prevVideo = this.content.find('video')[0];
          if (prevVideo) {
            prevVideo.pause();
          }
        }
       },
      
      // mainClass: 'mfp-with-zoom',
      // zoom: {
      //   enabled: true
      // },
      
      // closeOnContentClick: true,
      midClick: true, // allow opening popup on middle mouse click. Always set it to true if you don't provide alternative source.
    });
  }, 100);
});