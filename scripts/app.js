$(document).ready(function(){
    $('#carousel-gallery').touchCarousel({
        itemsPerPage: 1,				
        scrollbar: true,
        scrollbarAutoHide: true,
        scrollbarTheme: "dark",				
        pagingNav: false,
        snapToItems: false,
        scrollToLast: true,
        useWebkit3d: true,				
        loopItems: false
    });
});