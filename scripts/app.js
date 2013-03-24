$(document).ready(function(){
    
    var touchEnabled = Modernizr.touch;
        
    if (touchEnabled) {
        var el = document.getElementsByClassName('touchcarousel-item'),
            myTaps = [];
        $.each(el, function(index, value) {
            myTaps[index] = new Tap(value);
            value.addEventListener('tap', tapDidOccur, false);
            function tapDidOccur (e) {
                $(this).toggleClass('tapped');
            }
        });
        // remove the iCal link on event page as it's not supported on iOS devices
        var iCalLnk = $('#ical_export');
        iCalLnk.remove();
        
    }
    
});