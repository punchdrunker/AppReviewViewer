function render_graph(data){
    var GRAPH_HEIGHT = 60;
    var GRAPH_WIDTH = 600;
    var COLORS = ["#5BB75B", "#0074CC", "#49AFCD", "#FAA732", "#DA4F49"];
    var graphElement = $("#evaluation_graph");
    var totalScore = 0;

    var render = function() {
        for (var i = 0; i < data.length; i++) {
            totalScore += parseInt(data[i].value, 10);
        }

        for (var i = 0; i < data.length; i++) {
            var cell = $("<div>");
            cell.css({
                "background-color": COLORS[i],
                "display": "inline-block",
                "width": Math.floor(GRAPH_WIDTH * data[i].value / totalScore) + "px",
                "height": "60px"
            });
            graphElement.append(cell);
        }
    };

    var render_caption = function() {
        for (var i = 0; i < data.length; i++) {
           var caption = $("<div>");
            caption.css({
                "display": "inline-block"
            });

            var rect = $("<span>");
            rect.css({
                "background-color": COLORS[i],
                "display": "inline-block",
                "width": "10px",
                "height": "10px"
            });
            caption.append(rect);
            caption.append(":");

            for (var j = data.length; j > i; j--) {
                caption.append('&#9733;');
            }

            if (i < data.length - 1) {
                caption.append('&nbsp;/&nbsp;');
            }
            $("#evaluation_graph_caption").append(caption);
        }
    };

    render();
    render_caption();
}
