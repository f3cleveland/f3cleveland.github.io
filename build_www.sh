#!/bin/bash -debug
#
# Build a static website for uploading to github

H_HOME=/Users/jbartlett/sandbox/paxbadges

INDEXHTML=${H_HOME}/index.html.NEW
INDEXHTML_REAL=${H_HOME}/index.html

NOJSON_REAL=${H_HOME}/nojson.js
NOJSON=${NOJSON_REAL}.NEW

PRINT=/dev/null
#PRINT=/dev/stdout
PAX_BADGES=( "Badge3" "Badge4" "Badge5" "Badge6" "Badge7" "Badge8" "Badge9" "Badge10" "BadgeA" "BadgeB" "BadgeX" )


build_nojson(){
#"<div class='SHOW-ALL-BADGES ANCHOR BUBBLE-GUBBY ft f '><a href=badges/badges.html><img width='80px' height='80px' src='badges/Badge3.png' alt='Badge3'/><span class='tooltiptext'><p class='filename'><em>Name: </em>birthmonth</p><p class='category'><em>Category: </em>september</p><p class='filetype'><em>Type: </em>.gif</p></span></div>"


	echo "var nojson = [" > $NOJSON

		
	CVS_INDEX=7
	while [ "x${PAX_BADGES[$B_CNT]}" != x ]; do	
		echo "Looking for PAX who earned ${PAX_BADGES[$B_CNT]}"
		OUT_BADGES="SHOW-ALL-BADGES"
		while read -d $'\n' -r line; do 

			#"2023-01-04",Anchor,James Anchor Bartlett,U03D7E1AQ2Y,U020HKE1JJ0,f3clecuyahogaheights,11,76,27,36,7,1,0,1,2,1,1

			PAX=$(echo $line | awk -F',' '{printf"%s", $2}' | tr '[:space:]' '-' | tr '[:punct:]' '-' );
			PAX_UPPER=$(echo "${PAX}" | tr '[:lower:]' '[:upper:]' )

			VALUE=$(echo "${line}" | awk -F "," -v col=${CVS_INDEX} 'NR==1 {print $col}')
			if [ $VALUE -gt 0 ]; then
				OUT_BADGES="$OUT_BADGES $PAX_UPPER"
			#else
			#	echo "$PAX:  $VALUE"
			fi

		done < pax.csv 
	
	        echo "${PAX_BADGES[$B_CNT]}: $OUT_BADGES"
		echo "\"<div class='${OUT_BADGES}'><a href=badges/badges.html><img width='80px' height='80px' src='badges/${PAX_BADGES[$B_CNT]}.png' alt='${PAX_BADGES[$B_CNT]}'/></div>\"" >> $NOJSON
		echo "," >> $NOJSON

		B_CNT=$(($B_CNT+1))
		CVS_INDEX=$(($CVS_INDEX+1))



	done

	echo "];" >> $NOJSON

}


build_index_html(){


	INDEX_HEAD=$INDEXHTML.head
	INDEX_END=$INDEXHTML.end

	PAX_head=PAX.head
	PAX_mid=PAX.mid
	PAX_end=PAX.end

	rm -f $INDEXHTML
	rm -f $INDEX_HEAD
	rm -f $INDEX_END
	rm -f $PAX_head
	rm -f $PAX_mid
	rm -f $PAX_end

cat > $INDEX_HEAD  << EOF
<!DOCTYPE html>
<head>
		<title> PAXBadges</title>
		<meta charset="utf-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel='stylesheet' type='text/css' href='https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css' />
		<link rel='stylesheet' type='text/css' href='jquery-ui.icon-font.min.css' />
		<link rel='stylesheet' type='text/css' href='badgerbadger.css' />
		<script type="text/javascript" src='https://code.jquery.com/jquery-3.4.1.min.js'></script>
		<script type="text/javascript" src='https://code.jquery.com/ui/1.12.1/jquery-ui.min.js'></script>
		<script type="text/javascript" src="https://unpkg.com/infinite-scroll@3/dist/infinite-scroll.pkgd.min.js"></script>
		<script type="text/javascript" src='https://unpkg.com/isotope-layout@3/dist/isotope.pkgd.min.js'></script>
		<script type="text/javascript" src='https://cdn.jsdelivr.net/npm/lodash@4.17.15/lodash.min.js'></script>
	</head>

	<body>
		<div id='header'>
			<h1 class='main-title'>F3 Cleveland PAX Badges </h1>
			<h4 class='badge-counter'></h4>
		</div>

		<a href='#' class='float info-button'>
			<i class='ui-icon ui-icon-circle-b-help my-float'></i>
		</a>
		<div class="label-container info-container">
			<i class="ui-icon ui-icon-caret-2-e label-arrow"></i>
			<div class="label-text">About PAX badges</div>
		</div>

		<a href='#' class='float nav-button'>
			<i class='ui-icon ui-icon-search my-float'></i>
		</a>
		<div class="label-container nav-container">
			<div class="label-text">Toggle search panel</div>
			<i class="ui-icon ui-icon-caret-2-w label-arrow"></i>
		</div>

		<div id='loadsplash'>
			<h3>Loading...</h3>
			<p>Preparing PAX badges, please be patient!</p>
		</div>

		<div id='accordion' class='preloader'>
			<h3>PAXBadges</h3>
			<div>
				<p>A fun way to acknowledge your acomplishments</p>
			</div>
		</div>

EOF
cat > $PAX_head  << EOF
  <div id="PAX-NAME">
		<div class='filters preloader' id='controls'>
			<div class='ui-group filter-group'>
				<h6>PAX</h6>
				<p><input type='text' class='quicksearch' placeholder='Search' /></p>
				<div class='ui-group filter-cats'>
				<div class='button-group js-radio-button-group' data-filter-group='pax'>
					<button class='button is-checked' data-filter='.SHOW-ALL-BADGES'>SHOW-ALL-BADGES</button>
EOF

	CNT=0; 
	while read -d $'\n' -r line; do 
		PAX=$(echo $line | awk -F',' '{printf"%s", $2}' | tr '[:space:]' '-' | tr '[:punct:]' '-' );
		PAX_UPPER=$(echo "${PAX}" | tr '[:lower:]' '[:upper:]' )
	 	echo "					<button class='button' data-filter='.${PAX_UPPER}'>${PAX}</button>" >> $PAX_mid
	done < pax.csv 



cat > $PAX_end  << EOF
				</div>
			</div>
			</div>	
		</div>
		</div>

EOF

cat > $INDEX_END  << EOF

		<div class='grid'>
			<!-- badges go here! -->
		</div>

		<div class="page-load-status">
		  <div class="loader-ellips infinite-scroll-request">
		    <span class="loader-ellips__dot"></span>
		    <span class="loader-ellips__dot"></span>
		    <span class="loader-ellips__dot"></span>
		    <span class="loader-ellips__dot"></span>
		  </div>
		</div>

		<script src='nojson.js'></script>
		<script src='badgerbadger.js'></script>
	</body>

</html>
EOF



cat ${INDEX_HEAD} > $INDEXHTML
cat ${PAX_head} >> $INDEXHTML
cat ${PAX_mid} >> $INDEXHTML
cat ${PAX_end} >> $INDEXHTML
cat ${PAX_end} >> $INDEXHTML
cat ${INDEX_END} >> $INDEXHTML


}


build_index_html
build_nojson

