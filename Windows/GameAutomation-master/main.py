######################################################################################################################################################
# ファイル   : main.py                  |                                                                                                            #
#                                       |                                                                                                            #
#----------------------------------------------------------------------------------------------------------------------------------------------------#
# [修正履歴]                            |                                                                                                            #
# V-001      : 2024/10/14               | Gamer-Iris   新規作成                                                                                      #
#                                       |                                                                                                            #
######################################################################################################################################################



# [環境設定エリア]
######################################################################################################################################################
# OS関連のモジュール
import os
import glob
import sys
import pprint
import traceback
sys.path.append("../ssh")
sys.path.append("./modules")
from logging import ERROR, error, getLogger, FileHandler, DEBUG, Formatter
pprint.pprint(sys.path)

# sshExecのモジュール
from sshExec import sshExec

# GameAutomationのモジュール
from GameAutomation import GameAutomation



# [定数定義エリア]
######################################################################################################################################################
# 引数チェック時のメッセージ
INVALID_ARGUMENT_MESSAGE1     = "引数は最低限4つ指定してください。"
INVALID_ARGUMENT_MESSAGE2     = "引数の第4引数以降は数値を入力してください。"
INVALID_ARGUMENT_MESSAGE3     = "引数の第2引数に想定しないゲーム名が指定されました。"
INVALID_ARGUMENT_MESSAGE4     = "引数の第3引数に想定しない処理名が指定されました。"
INVALID_ARGUMENT_MESSAGE5     = "引数の第4引数以降に想定しない引数が指定されました。"

# 共通内容
## ゲーム名
GAME_PUBLIC                   = "PUBLIC"

# FF14内容
## ゲーム名
GAME_FF14                     = "FF14"
## 製作１
PRODUCTION1                   = "製作１"
## 製作２
PRODUCTION2                   = "製作２"

# FGO内容
## ゲーム名
GAME_FGO                      = "FGO"
## 周回
ORBIT                         = "周回"
## フレンドポイント召喚
FRIEND_POINT_SUMMON           = "フレンドポイント召喚"
## イベントボックスオープン
EVENT_BOX_OPEN                = "イベントボックスオープン"

# アプリ通知時のメッセージ
APP_NOTTICE_MESSAGE1          = "処理が開始されました。"
APP_NOTTICE_MESSAGE2          = "処理が正常終了しました。"
APP_NOTTICE_MESSAGE3          = "処理に異常が発生しました。"
APP_NOTTICE_MESSAGE4          = "処理を強制終了させます。"



# [変数定義エリア]
######################################################################################################################################################
# 引数の最大値
argCount                      = 0



# [前処理内容エリア]
######################################################################################################################################################
# ログ初期化
for file in glob.glob('log/*.log'):
    os.remove(file)

# スクリーンショット初期化
for file in glob.glob('.screenshot*.png'):
    os.remove(file)

# ログ出力設定
## フォーマッター設定
formatter = Formatter('[%(levelname)s]%(asctime)s-%(message)s(%(filename)s)')
logger = getLogger(__name__)
## ハンドラー設定
handler = FileHandler('log/result.log')
handler.setLevel(DEBUG)
handler.setFormatter(formatter)
## エラーハンドラー設定
error_handler = FileHandler('log/error.log')
error_handler.setLevel(ERROR)
error_handler.setFormatter(formatter)
## ロガー設定
logger.setLevel(DEBUG)
logger.addHandler(handler)
logger.addHandler(error_handler)

# [処理内容エリア]
######################################################################################################################################################
try:
    # 以下、メインルーチン
    if __name__ == "__main__":
        # インスタンス生成
        sshExec_obj = sshExec()
        GameAutomation_obj = GameAutomation()

        # 入力チェック
        ## 第4引数まで指定されていることを未確認 → エラーメッセージ1出力
        argCount = len(sys.argv)
        if argCount < 4:
            raise Exception(INVALID_ARGUMENT_MESSAGE1)
        ## 第4引数以降の数値チェックがエラー → エラーメッセージ2出力
        for i in range(argCount):
            if i >= 3:
                if not sys.argv[i].isnumeric():
                    raise Exception(INVALID_ARGUMENT_MESSAGE2)

        # アプリ通知
        message = APP_NOTTICE_MESSAGE1
        programName = os.path.basename(__file__)
        sshExec_obj.sshAppNotice(programName = programName, noticeMessage1 = message, noticeMessage2 = "")

        # 実行ゲーム名の取得
        gameName = sys.argv[1]
        
        # 実行内容の取得
        executionContent = sys.argv[2]

        print("=========================")
        # PUBLIC内容（マウスポインタ取得用）
        if gameName == GAME_PUBLIC:
            GameAutomation_obj.serch_mouce_cursor_position(wait_time = int(sys.argv[3]))

        # FF14内容
        elif gameName == GAME_FF14:
            # FF14用に環境設定
            sys.path.append("./modules/ff14")
            from ff14_main import ff14_main

            # 実行内容の確認
            ## インスタンス生成
            ff14_obj = ff14_main()
            ## 製作１
            if executionContent == PRODUCTION1:
                # 処理開始
                if argCount == 5:
                    # 制作１メソッドの呼び出し
                    ff14_obj.production1(waittime1 = int(sys.argv[3]), loopCount= int(sys.argv[4]))

                # 入力チェック
                ## 第4引数以降が不正の場合 → エラーメッセージ5出力
                else:
                    raise Exception(INVALID_ARGUMENT_MESSAGE5)

            ## 製作２
            elif executionContent == PRODUCTION2:
                # 処理開始
                if argCount == 6:
                    # 制作２メソッドの呼び出し
                    ff14_obj.production2(waittime1 = int(sys.argv[3]), waittime2 = int(sys.argv[4]), loopCount= int(sys.argv[5]))

                # 入力チェック
                ## 第4引数以降が不正の場合 → エラーメッセージ5出力
                else:
                    raise Exception(INVALID_ARGUMENT_MESSAGE5)

            # 入力チェック
            ## 第3引数が不正の場合 → エラーメッセージ4出力
            else:
                raise Exception(INVALID_ARGUMENT_MESSAGE4)

        # FGO内容
        elif gameName == GAME_FGO:
            # FGO用に環境設定
            sys.path.append("./modules/fgo")
            from fgo_main import fgo_main

            # 実行内容の確認
            ## インスタンス生成
            fgo_obj = fgo_main()
            ## イベント周回
            if executionContent == ORBIT:
                # 処理開始
                if argCount == 4:
                    # マップ番号セットメソッドの呼び出し
                    setMapNumber = sys.argv[3]
                    fgo_obj.setMapNumber(setMapNumber)

                    # 周回メソッドの呼び出し
                    fgo_obj.orbit()

                # 入力チェック
                ## 第4引数以降が不正の場合 → エラーメッセージ5出力
                else:
                    raise Exception(INVALID_ARGUMENT_MESSAGE5)

            ## フレンドポイント召喚
            elif executionContent == FRIEND_POINT_SUMMON:
                # 処理開始
                if argCount == 4:
                    # フレンドポイント召喚メソッドの呼び出し
                    fgo_obj.friendPointSummon()

                # 入力チェック
                ## 第4引数以降が不正の場合 → エラーメッセージ5出力
                else:
                    raise Exception(INVALID_ARGUMENT_MESSAGE5)

            ## イベントボックスオープン
            elif executionContent == EVENT_BOX_OPEN:
                # 処理開始
                if argCount == 4:
                    # イベントボックスオープンメソッドメソッドの呼び出し
                    fgo_obj.eventBoxOpen()

                # 入力チェック
                ## 第4引数以降が不正の場合 → エラーメッセージ5出力
                else:
                    raise Exception(INVALID_ARGUMENT_MESSAGE5)

            # 入力チェック
            ## 第3引数が不正の場合 → エラーメッセージ4出力
            else:
                raise Exception(INVALID_ARGUMENT_MESSAGE4)

        # 入力チェック
        ## 第2引数が不正の場合 → エラーメッセージ3出力
        else:
            raise Exception(INVALID_ARGUMENT_MESSAGE3)

        print("=========================")

        # アプリ通知
        message = APP_NOTTICE_MESSAGE2
        programName = os.path.basename(__file__)
        sshExec_obj.sshAppNotice(programName = programName, noticeMessage1 = message, noticeMessage2 = "")

# エラーハンドリング時処理
except (SystemExit, KeyboardInterrupt, GeneratorExit, Exception) as e:
    # ログ出力
    t = traceback.format_exc()
    logger.debug(t)
    logger.error(t)

    # コンソール出力
    print(e)
    print("=========================")

    # アプリ通知
    message = APP_NOTTICE_MESSAGE3 + '\r\n' + APP_NOTTICE_MESSAGE4
    programName = os.path.basename(__file__)
    sshExec_obj.sshAppNotice(programName = programName, noticeMessage1 = message, noticeMessage2 = str(e))
    
    # 異常終了（終了コード10）を呼び出し元にreturn
    sys.exit(10)
