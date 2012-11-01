/**
 * USAGE:
 * phantomjs rank.js [index]
 *
 */
var args = require("system").args;

if (args.length!=2) {
    console.log('usage this.js [paging_number]');
    phantom.exit();
}

var index = args[1];

var urls = [
'https://play.google.com/store/apps/collection/topselling_free',
'https://play.google.com/store/apps/collection/topselling_free?start=24&num=24',
'https://play.google.com/store/apps/collection/topselling_free?start=48&num=24',
'https://play.google.com/store/apps/collection/topselling_free?start=72&num=24',
'https://play.google.com/store/apps/collection/topselling_free?start=96&num=24',
] ;

var page = require('webpage').create();

page.onConsoleMessage = function(msg) {
    console.log(msg);
};

page.open(urls[index], function(status) {
    if (status !== "success") {
        console.log("Unable to access network");
    }
    else {
        var test = page.evaluate(function (n) {
            var ul = document.getElementsByClassName('snippet-list container-snippet-list')[0];
            var list = ul.getElementsByTagName('li');
            var count = list.length;
            for (var i = 0; i < count; ++i) {
                var rank = 1 + i + (parseInt(n) * 24);
                var app_id = list[i].getAttribute('data-docid');
                var title = list[i].getElementsByTagName('a')[1].title;
                var developer = list[i].getElementsByTagName('a')[2].text;
                var rating = list[i].getElementsByClassName('ratings')[0].title;
                var link = list[i].getElementsByTagName('a')[0].href;
                var thumb = list[i].getElementsByTagName('img')[0].src;

                var data_array = [];
                data_array.push('"' + rank + '"');
                data_array.push('"' + app_id + '"');
                data_array.push('"' + title + '"');
                data_array.push('"' + developer + '"');
                data_array.push('"' + rating + '"');
                data_array.push('"' + link + '"');
                data_array.push('"' + thumb + '"');
                var data = data_array.join(",");
                console.log(data);
            }
            return 0;
        }, index);
    }
    phantom.exit();
});
