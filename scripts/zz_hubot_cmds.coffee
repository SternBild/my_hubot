# Description:
#   list all hubot commands
#
# Dependencies:
#   ""
#
# Configuration:
#   None
#
# Commands:
#   hubot
#
# Author:
#   nobukichi

module.exports = (robot) ->

  cmds = []
  for help in robot.helpCommands()
    cmd = help.split(' ')[1]
    cmds.push cmd if cmds.indexOf(cmd) is -1


  # hubotに対しての反応を記述
  robot.respond /(.+)$/i, (msg) ->
    cmd = msg.match[1].split(' ')[0]
    return unless cmds.indexOf(cmd) is -1

    # どのコマンドにも一致しない場合の処理
    cmdList = cmds.map((cmd) -> "*#{cmd}*").join('\n')
    retMsg = """
使用できるコマンドは以下のとおりです。
#{cmdList}
"""
    msg.send retMsg