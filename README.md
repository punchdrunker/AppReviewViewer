AppReviewViewer
=============

AppStoreのレビューをスクレイピングしてDBに保存したり表示したりするツールです。
Sinatraベースです。

機能
-------
* 登録したアプリのレビューをAppStoreからスクレイピングしてsqlite3なDBに保存
* 保存したレビューの一覧表示
* ★の数を集計してグラフ表示
* 頻出キーワードを抽出表示(mecab-rubyインストールしてれば)

依存ライブラリ
-------
以下のrubygemsを利用しているので、installが必要です。
* json
* nokogiri
* sequel
* sqlite3
* sinatra
* sinatra-reloader
* sinatra-sequel

以下は任意
* mecab-ruby(version 0.98 only)

mecab-rubyは0.98のみの対応ですが、インストールしてあると頻出キーワードの一覧とか出せます。
mecab-rubyは無くても動作するはずです。

使い方
-------
以下のコマンドで起動します

    $ ruby app.rb

http://localhost:4567 にアクセスして、左メニューからアプリを登録します。

APP IDはAppStoreとかGooglePlayのURLに含まれているアプリID(twitterのiOSアプリであれば333903271、GooglePlayだとcom.twitter.android)で、

APP NAMEは何でもいいです。

アプリを登録したら以下のコマンドでレビューを収集します

    $ ruby scripts/fetch.rb

終了後、再度http://localhost:4567にアクセスすると、レビューの一覧が表示されます

License
-------
BSDライセンスで提供します。なので、一切無保証です。

BSD-LICENSED Copyright (c) 2011, punchdrunker.org All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the punchdrunker.org nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
