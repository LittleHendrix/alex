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
    }
    
});