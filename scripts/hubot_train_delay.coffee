# Description:
#   Search and show your train time in Japan
#
# Dependencies:
#   "cheerio-httpcli", ""
#
# Configuration:
#   None
#
# Commands:
#   hubot delay <name>
#   hubot 電車遅延 <name>
#
# Author:
#   nobukichi

client = require "cheerio-httpcli"

TRAIN_URL = "http://transit.loco.yahoo.co.jp/traininfo/area/4/"

module.exports = (robot) ->

  # 路線が見つからないときのメッセージ
  notFoundLine = () ->
    """
知らない路線です。
#{TRAIN_URL}
から探してください。
"""
  # 絞込できないときのメッセージ
  manyLine = (lines) ->
    candidates = lines.map((line) -> "*#{line.text}*").join('\n')
    """
絞り込めませんね。下のどれかでしょうか？
#{candidates}
"""

  # 情報取得
  getInfo = (msg) ->

    client.fetch(TRAIN_URL, {} ,(err, $, res) ->
      lines = $("#mdAreaMajorLine .elmTblLstLine > table tr a")
      .toArray()
      .map((a) -> { text: $(a).text(), href: a.attribs.href })
      .filter((a) ->  a.text.search(msg.match[2]) != -1)

      return msg.send notFoundLine() if lines.length == 0
      return msg.send manyLine(lines) if lines.length > 1
      client.fetch(lines[0].href, {}, (err, $, res) ->
        msg.send "#{$('h1.title').text()}: #{$('#mdServiceStatus').text()}"
      )
    )

  # hubotに対しての反応を記述
  robot.respond /(delay|電車遅延) ([^ ]+)/i, (msg) ->
    msg.send "電車遅延を検索中です"
    getInfo(msg)