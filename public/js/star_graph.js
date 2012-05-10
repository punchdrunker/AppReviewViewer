function render_graph(data){
    var canvas = document.getElementById('star_graph');

    if(canvas.getContext){
        var context = canvas.getContext('2d');
        data_to_graph(context, data);
    }
}

function data_to_graph(context, data){  
    var colors = ["#5BB75B", "#0074CC", "#49AFCD", "#FAA732", "#DA4F49"];
    var graph_width = 600;
    var graph_height = 60;
    var y_offset = 0;

    var offset = 0;
    for(var i = 0; i < data.length; i++){
        data[i].color = colors[i];
        data[i].startValue = offset;
        offset += data[i].value;
    }

    // 幅、x座標、y座標の取得
    data.forEach(function(obj){
        obj._width = obj.value / offset * graph_width;
        obj._x = obj.startValue / offset * graph_width;
        obj._y = y_offset;
    });

    data.forEach(function(obj){
        context.fillStyle = obj.color;
        context.fillRect(obj._x, obj._y, obj._width, graph_height);
    });
}
