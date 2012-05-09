AppReviewViewer
=============

AppStoreのレビューをスクレイピングしてDBに保存したり表示したりするツールです。
Sinatraベースです。

依存ライブラリ
-------
以下のrubygemsを利用しているので、installが必要です。
* nokogiri
* sequel
* sqlite3
* sinatra
* sinatra-reloader

以下は任意
* mecab-ruby(version 0.98 only)

mecab-rubyは0.98のみの対応ですが、インストールしてあると頻出キーワードの一覧とか出せます。
mecab-rubyは無くても動作するはずです。

使い方
-------
以下のコマンドで起動します

`$ ruby app.rb`

http://localhost:4567 にアクセスして、左メニューからアプリを登録します。
APP IDはAppStoreのURLに含まれているアプリID(twitterであれば333903271)で、
APP NAMEは何でもいいです。

アプリを登録したら以下のコマンドでレビューを収集します

`$ ruby fetch.rb`

終了後、再度
http://localhost:4567
にアクセスすると、レビューの一覧が表示されます
