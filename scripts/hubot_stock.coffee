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
#   hubot stock :name - display stock
#
# Author:
#   nobukichi

client = require "cheerio-httpcli"

STOCK_URL = "https://stocks.finance.yahoo.co.jp/stocks/detail/?code=998407.O&d=1w"
STOCK_IMG_URL = "https://chart.yahoo.co.jp/?code=998407.O&tm=5d&vip=off"

module.exports = (robot) ->

  getStockInfo = (msg) ->
    client.fetch(STOCK_URL, {} ,(err, $, res) ->
      price = $('td.stoksPrice').eq(1).text()
      change = $('span.yjMSt').text()
      retMsg = """
日経平均株価： *#{price}*
前日比　　　： *#{change}*
#{STOCK_IMG_URL}
Yahoo!ファイナンス #{STOCK_URL}
      """
      msg.send retMsg
    )

  # hubotに対しての反応を記述
  robot.respond /(stock)$/i, (msg) ->
    getStockInfo(msg)