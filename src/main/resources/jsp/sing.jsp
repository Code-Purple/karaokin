<html>
	<head>
		<script src="../js/jquery.min.js"></script>
		<script src="../js/textarea-helper.js"></script>
		<script src="../js/web-speech-test.js"></script>

		<link rel="stylesheet" type="text/css" href="../css/karaoke.css">
	</head>
    <body>
        <div class="target">
        </div>
        <audio src="${mp3url}" autoplay="autoplay" controls></audio>
    <div id="word-box">
            <input type="button" id="enable-speech" value="Start Singing" /> <input
                type="button" id="disable-speech" value="Stop Singing"
                onclick="CheckLyrics()" />
            <p>
                <textarea id="speech-page-content" name="pageContent"></textarea>
    </div>
    </body>
    <script type="text/javascript">
$(function() {
        var buildWord = function(data) {
            var left = '';
            if(data.marginleft) {
                left = 'marginleft';
            }
            var container = $('<span />', {'class': ['word', data.gender, left].join(' ')});
            var bgText = $('<span />', {'html': data.word});
            var bg = $('<span />', {'class': 'bg', 'html': bgText});
            var fg = $('<span />', {'class': 'fg', 'html': data.word});

            container.append(bg);
            container.append(fg);

            setTimeout(function() {
                bg.animate({'width': '100%'}, data.duration);
            }, data.start);

            return container;
        };

        var kickoff = function(timeline) {
        	console.log(timeline);
            var target = $('.target');

            var i = 0;
            var start = new Date().getTime();

            var f = function() {
                var breakIdx = null;

                var now = new Date().getTime();
                while(i < timeline.length && timeline[i].action != 'break') {
                    var data = timeline[i];
                    target.append(buildWord({word: data.part,  gender: 'girl',  start: data.start - (now - start),  duration: data.dur, marginleft: data.marginleft}));
                    i++;
                }


                var next = timeline[i];
                if (next !== undefined) {
                    i++;
                    var dur = next.start - (now - start);
                    setTimeout(function() {
                        target.empty();

                        next = timeline[i];
                        if(next !== undefined && next.action !== 'end') {
                            f();
                        }
                    }, dur);
                    console.info('dur:', dur);
                }
            };

            f();
        };

        $.get('/api/songs/${id}', function(data) {
                var audio = $('audio');
                audio.on('playing', function() {
                    var delay = data[0].delay || 0;
                    setTimeout(function() {
                        kickoff(data);
                    }, delay);
                });
                audio[0].play();
        });
});
    </script>
    
	<script>
	function CheckLyrics()
	{
		document.song.title.value = locate	
		var text = document.song.title.value
		
		var saidLyrics = $('#speech-page-content').val();
		var client = new XMLHttpRequest();
		var lyrics = "";
		
		client.open('GET', 'api/songs/${id}/lyrics');
		
		client.onreadystatechange = function() {
			if (client.readyState==4)
			{
				lyrics = client.responseText;
				var n = lyrics.length;
				var m = saidLyrics.length;
				console.log(n);
				console.log(m);
				value = getEditDistance(lyrics, saidLyrics);
				console.log(value);
				var score = (1-value/n) * 100;
				alert("Great job! You scored " + score + "%!");
			}
		}
		client.send();	
	}
	
	// Compute the edit distance between the two given strings
	function getEditDistance(a, b) {
	  if(a.length === 0) return b.length; 
	  if(b.length === 0) return a.length; 
	 
	  var matrix = [];
	 
	  // increment along the first column of each row
	  var i;
	  for(i = 0; i <= b.length; i++){
	    matrix[i] = [i];
	  }
	 
	  // increment each column in the first row
	  var j;
	  for(j = 0; j <= a.length; j++){
	    matrix[0][j] = j;
	  }
	 
	  // Fill in the rest of the matrix
	  for(i = 1; i <= b.length; i++){
	    for(j = 1; j <= a.length; j++){
	      if(b.charAt(i-1) == a.charAt(j-1)){
	        matrix[i][j] = matrix[i-1][j-1];
	      } else {
	        matrix[i][j] = Math.min(matrix[i-1][j-1] + 1, // substitution
	                                Math.min(matrix[i][j-1] + 1, // insertion
	                                         matrix[i-1][j] + 1)); // deletion
	      }
	    }
	  }
	 
	  return matrix[b.length][a.length];
	};
	</script>

    <form name="song">
        <input type="hidden" name="title">
    </form>

    <script>
        var locate = window.location
        document.song.title.value = locate
        
        var text = document.song.title.value
        
        function delineate(str)
        {
            point = str.lastIndexOf("=");
            return(str.substring(point+1,str.length));
        }
        </script>
    
</html>
