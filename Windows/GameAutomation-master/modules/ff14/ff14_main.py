######################################################################################################################################################
# ファイル   : ff14_main.py             |                                                                                                            #
#                                       |                                                                                                            #
#----------------------------------------------------------------------------------------------------------------------------------------------------#
# [修正履歴]                            |                                                                                                            #
# V-001      : 2024/10/14               | Gamer-Iris   新規作成                                                                                      #
#                                       |                                                                                                            #
######################################################################################################################################################



# [環境設定エリア]
######################################################################################################################################################
# sshExecのモジュール
from sshExec import sshExec

# GameAutomationのモジュール
from GameAutomation import GameAutomation

# OS関連のモジュール
import os
import glob



# [定数定義エリア]
######################################################################################################################################################



# [変数定義エリア]
######################################################################################################################################################



# [前処理内容エリア]
######################################################################################################################################################



# [処理内容エリア]
######################################################################################################################################################
# ff14_mainクラス
# @param  GameAutomation         : GameAutomation
# 
# 
class ff14_main(GameAutomation, sshExec):

    ##################################################################################################################################################
    # initメソッド
    # @param  self               : self
    # 
    # 
    def __init__(self):
        super(ff14_main, self).__init__()
        self.function = "ff14_main"

    ##################################################################################################################################################
    # sampleメソッド
    # @param  self               : self
    # 
    # 
    def sample(self):
        print(self.function)

    ##################################################################################################################################################
    # 制作１メソッド
    # @param  self               : self
    # @param  waittime1          : 1コマンド目の所要時間
    # @param  loopCount          : ループ回数
    def production1(self, waittime1, loopCount):

        # 画面切り替え用に5秒sleep
        self.sleep(wait_time = 5)

        # 指定回数ループさせる
        for i in range(loopCount):
            try:

                # num0押下
                self.keyPress(wait_time = 1, target_key = 'num0')

                # num0押下
                self.keyPress(wait_time = 1, target_key = 'num0')

                # 4押下
                self.keyPress(wait_time = 1, target_key = '4')

                # 1コマンド目の所要時間までsleep
                self.sleep(waittime1)

            # エラーハンドリング時処理
            except (FF14UniqueException, SystemExit, KeyboardInterrupt, GeneratorExit, Exception) as e:
                self.FF14UniqueExceptionHandling(e)

    ##################################################################################################################################################
    # 制作２メソッド
    # @param  self               : self
    # @param  waittime1          : 1コマンド目の所要時間
    # @param  waittime2          : 2コマンド目の所要時間
    # @param  loopCount          : ループ回数
    def production2(self, waittime1, waittime2, loopCount):

        # 画面切り替え用に5秒sleep
        self.sleep(5)

        # 指定回数ループさせる
        for i in range(loopCount):
            try:

                # num0押下
                self.keyPress(wait_time = 1, target_key = 'num0')

                # num0押下
                self.keyPress(wait_time = 1, target_key = 'num0')

                # 4押下
                self.keyPress(wait_time = 1, target_key = '4')

                # 1コマンド目の所要時間までsleep
                self.sleep(waittime1)

                # 5押下
                self.keyPress(wait_time = 1, target_key = '5')

                # 2コマンド目の所要時間までsleep
                self.sleep(waittime2)

            # エラーハンドリング時処理
            except (FF14UniqueException, SystemExit, KeyboardInterrupt, GeneratorExit, Exception) as e:
                self.FF14UniqueExceptionHandling(e)

    ##################################################################################################################################################
    # ff14独自例外キャッチ時処理
    # @param  self               : self
    # @param  e                  : Exception
    # @return True               : True（正常終了時）
    # @raise  FF14UniqueException: FF14UniqueException（異常終了時）
    def FF14UniqueExceptionHandling(self, e):

        # 独自例外発行
        raise FF14UniqueException("roopの為、処理中断")



# [例外処理内容エリア]
######################################################################################################################################################
# ff14独自例外クラス
# @param  Exception              : Exception
# 
# 
class FF14UniqueException(Exception):
    pass
