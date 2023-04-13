//-------------init-----------------//
$( function() {
    $("#accordion").accordion({
      heightStyle: "content"
    }).slideToggle('fast',function(){
      $('#accordion').removeClass('preloader');
    });
    $('#controls').slideToggle('fast',function(){
      $('#controls').removeClass('preloader');
    });
  });

$('.my-float').hover(
    function(){$(this).addClass('rotate')},
    function(){$(this).removeClass('rotate')}
  );

$('.info-button').click(function(){
  $('#accordion').slideToggle();
});
$('.nav-button').click(function(){
  $('#controls').slideToggle();
});



(function(){

  const vw = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
  const vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
  var bc = (vw/80)*(vh/80).toFixed(0)  // # of badges that fit viewport!
  var badgeTotal = nojson.length;
  var badgeCount = (bc>960) ? 960 : bc;  // limited by content max-width...
  var buttonFilters = {}; // store filter for each group
  var buttonFilter = '.SHOW-ALL-BADGES';
  var qsRegex; // quick search regex
  var badgeCounter = $('.badge-counter');

  //--------------helpers-----------------//  

  // flatten object by concatting values
  function concatValues( obj ) {
    var value = '';
    for ( var prop in obj ) {
      value += obj[ prop ];
    }
    return value;
  }

  function updateCounter(){
    if ( buttonFilter == '.SHOW-ALL-BADGES' )
	    badgeCounter.text( 'Showing All ' + badgeTotal + ' Badges to earn!');
    else 

            //display = buttonFilter.replace("-", " " ).replace(".", "")
	    badgeCounter.text( buttonFilter.replace("-", " " ).replace(".", "") + ' Earned ' + iso.filteredItems.length + ' of ' + badgeTotal + ' .');
    

  }

  //----------------core-----------------//

  var $badges = $('.grid');

  // init isotope
  $badges.isotope({
    itemSelector: '.SHOW-ALL-BADGES',
    layoutMode: 'fitRows',
    stagger: 2,
    transitionDuration: 100,
    filter: function() {
      var $this = $(this);
      var searchResult = qsRegex ? $this.is( qsRegex ) : true;
      var buttonResult = buttonFilter ? $this.is( buttonFilter.toUpperCase() ) : true;
      return searchResult && buttonResult;
    }
  });

  var iso = $badges.data('isotope');

  // init infinite scroll
  $badges.infiniteScroll({
    path: 'page{{#}}',
    loadOnScroll: false,
    itemSelector:'.SHOW-ALL-BADGES',
    outlayer: iso,
    scrollThreshold:300,
  });


  //-------------search/filter--------------//

  // use value of search field to filter
  var $quicksearch = $('.quicksearch').keyup( _.debounce( function() {
    var $this = $(this);

    console.log( 'qs.val() ' + $quicksearch.val() )

    //console.log( qsRegex )
    //var filterGroup = $buttonGroup.attr('data-filter-group');
    // set filter for group
    //var $buttonFilters = $this.attr('data-filter');
    //var $buttonGroup = $this.parents('.data-filter');
    //console.log( $buttonGroup )

    //findButtone = $buttonGroup.find($quicksearch.val())
    //console.log( findButtone )

    var tmpbuttonFilter = '.' + concatValues( $quicksearch.val() ).replace(" ","-")
    matchMe =  tmpbuttonFilter.toUpperCase();  
    parentDOM = document.getElementById("PAX-NAME");
    var className = parentDOM.getElementsByClassName("button");
    
    var isCheckIdx=-1
    var found = 0
    for(var index=0;index < className.length;index++){
      //foo.getAttribute('data-total-count');    
      //console.log( index + ' .data-filter=' + className[index].getAttribute('data-filter') ); 
      //console.log( 'className ' + className[index].className );
      
      if ( className[index].className == "button is-checked" ){
        console.log(index + ' is checked ' +  className[index].getAttribute('data-filter') );
        isCheckIdx=index;
      }
      
      if (  className[index].getAttribute('data-filter')  == matchMe ) {
      	console.log('MATCH ' + index + ' .data-filter=' + className[index].getAttribute('data-filter') ); 
        //parentDOM.getElementsByClassName("button is-checked").removeClass('is-checked');
        className[index].className = "button is-checked"
        //className[index].removeClass('is-checked');
	//className[index].getAttribute('data-filter') );       
        found=1
      }
    }
    if ( isCheckIdx > -1 && found ) {
      console.log('found, unchecking');
      className[isCheckIdx].className = "button";
      buttonFilter = tmpbuttonFilter;

      //console.log( 'butnFilter = ' + buttonFilter );
      window.scrollTo(0, 0);
      $badges.isotope();
      updateCounter();
    }
  }, 1000));



  $('.filters').on( 'click', '.button', function() {
    var $this = $(this);
    // get group key
    var $buttonGroup = $this.parents('.button-group');
    //var filterGroup = $buttonGroup.attr('data-filter-group');
    buttonFilters = $this
     .attr('data-filter');
    buttonFilter = concatValues( buttonFilters );
    console.log( buttonFilter )
    // Isotope arrange
    window.scrollTo(0, 0);
    $badges.isotope();
    updateCounter();
  });

  // button is-checked checker
  $('.button-group').each( function( i, buttonGroup ) {
    var $buttonGroup = $( buttonGroup );
    $buttonGroup.on( 'click', 'button', function() {
      $buttonGroup.find('.is-checked').removeClass('is-checked');
      $( this ).addClass('is-checked');
    });
  });

  $('.button').mousedown(function(){
    $('.page-load-status').removeClass('preloader');
  })

  $badges.on('arrangeComplete', function(event,filteredItems){
    $('.page-load-status').addClass('preloader');
  });


  //append first screen of badges!
  $(window).on('load',function(){
    var freshBadges = $(nojson.splice(0,badgeCount).join('')); // from nojson.js
    freshBadges.imagesLoaded().always(function(){
      $badges.append(freshBadges).isotope('appended',freshBadges);
      $('.SHOW-ALL-BADGES').removeClass('preloader');
      $('.page-load-status').addClass('preloader');
      $('#loadsplash').addClass('preloader');
      $badges.isotope('shuffle');
      updateCounter();
    });
  });


  // load badges on scroll!
  $(window).on('scrollThreshold.infiniteScroll', _.throttle(function(){
    $('.page-load-status').removeClass('preloader');
    var freshBadges = $(nojson.splice(0,badgeCount).join('')); // from nojson.js
    freshBadges.imagesLoaded(function(){
      $('.page-load-status').addClass('preloader');
      $badges.append(freshBadges).isotope('appended',freshBadges);
      $('.SHOW-ALL-BADGES').removeClass('preloader');
      updateCounter();
    });
  }, 5000));

})();
