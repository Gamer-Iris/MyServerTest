######################################################################################################################################################
# ファイル   : appNotice.py             |                                                                                                            #
#                                       |                                                                                                            #
#----------------------------------------------------------------------------------------------------------------------------------------------------#
# [修正履歴]                            |                                                                                                            #
# V-001      : 2024/10/14               | Gamer-Iris   新規作成                                                                                      #
#                                       |                                                                                                            #
######################################################################################################################################################



# [環境設定エリア]
######################################################################################################################################################
# OS関連のモジュール
import requests
import sys

# yaml関連のモジュール
import yaml

# [定数定義エリア]
######################################################################################################################################################



# [変数定義エリア]
######################################################################################################################################################
# settings.yml内容
settingsYaml              = []



# [前処理内容エリア]
######################################################################################################################################################



# [処理内容エリア]
######################################################################################################################################################
# appNoticeクラス
# @param  -
# 
# 
class appNotice:

    ##################################################################################################################################################
    # sampleメソッド
    # @param  self               : self
    # 
    # 
    def sample(self):
        print(self.function)

    ##################################################################################################################################################
    # アプリ通知メソッド
    # @param  self               : self
    # @param  programName        : プログラム名
    # @param  noticeMessage1     : 通知メッセージ
    # @param  noticeMessage2     : エラーメッセージ
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def aplNotice(self, programName, noticeMessage1, noticeMessage2):
        try:
            # settings.yml内容が空か確認 → settings.yml内容を取得
            global settingsYaml
            if not settingsYaml:
                self.setSettingsYaml()
                settingsYaml = self.getSettingsYaml()

            # 送信メッセージ作成
            message = '\r\n' + "【プログラム名】" + '\r\n' + programName + '\r\n' + "【通知内容】" + '\r\n' + noticeMessage1
            if noticeMessage2 != "":
                message = message + '\r\n' + "【エラー内容】" + '\r\n' + noticeMessage2
            ## Discordメッセージ作成
            discordMessage = {"content": message}

            # アプリ通知
            ## Discord通知
            requests.post(settingsYaml["discord"]["url"], discordMessage)

            # コンソール出力
            print('aplNotice is succesed')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # settings.yml内容セットメソッド
    # @param  self               : self
    # 
    # 
    def setSettingsYaml(self):

        # settings.yml内容セット
        global settingsYaml
        with open('../settings/settings.yml', 'r') as yml:
            settingsYaml = yaml.safe_load(yml)

    ##################################################################################################################################################
    # settings.yml内容ゲットメソッド
    # @param  self               : self
    # @return settings.yml      : settings.yml内容
    # 
    def getSettingsYaml(self):

        # settings.yml内容ゲット
        return settingsYaml

######################################################################################################################################################
# インスタンス生成
# @param  -
# 
# 
if __name__ == '__main__':
    # プログラム名
    programName    = ""
    # 通知メッセージ
    noticeMessage1 = ""
    # エラーメッセージ
    noticeMessage2 = ""
    
    # 各メッセージのセット
    for index, item in enumerate(sys.argv):
      if index == 1:
        # プログラム名のセット
        programName    = sys.argv[index]
      elif index == 2:
        # 通知メッセージのセット
        noticeMessage1 = sys.argv[index]
      elif index == 3:
        # エラーメッセージのセット
        noticeMessage2 = sys.argv[index]

    # アプリ通知メソッドの呼出し
    appNotice = appNotice()
    appNotice.aplNotice(programName, noticeMessage1, noticeMessage2)
