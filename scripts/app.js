$(document).ready(function(){
    
    var touchEnabled = document.documentElement.className.indexOf('no-touch') == '-1' ? true : false;
    
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
    }
    
});