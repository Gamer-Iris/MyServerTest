######################################################################################################################################################
# ファイル   : GameAutomation.py        |                                                                                                            #
#                                       |                                                                                                            #
#----------------------------------------------------------------------------------------------------------------------------------------------------#
# [修正履歴]                            |                                                                                                            #
# V-001      : 2024/10/14               | Gamer-Iris   新規作成                                                                                      #
#                                       |                                                                                                            #
######################################################################################################################################################



# [環境設定エリア]
######################################################################################################################################################
# PyAutoGUIのモジュール
import pyautogui

# OS関連のモジュール
import requests
import time

# yaml関連のモジュール
import yaml

# [定数定義エリア]
######################################################################################################################################################
# アプリ再起動時の画像パス
ALL_CLEAR                 = './img/all_clear.PNG'


# [変数定義エリア]
######################################################################################################################################################
# settings.yml内容
settingsYaml              = []



# [前処理内容エリア]
######################################################################################################################################################



# [処理内容エリア]
######################################################################################################################################################
# GameAutomationクラス
# @param  -
# 
# 
class GameAutomation:

    ##################################################################################################################################################
    # sampleメソッド
    # @param  self               : self
    # 
    # 
    def sample(self):
        print(self.function)

    ##################################################################################################################################################
    # 指定秒数スリープメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def sleep(self, wait_time):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # コンソール出力
            print('wait is succesed')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # 指定キー押下メソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  target_key         : 指定キー
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def keyPress(self, wait_time, target_key):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 指定キーを押下
            pyautogui.press(target_key)

            # コンソール出力
            print(target_key + 'is keypressed')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # 指定キーダウンメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  target_key         : 指定キー
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def keyDown(self, wait_time, target_key):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 指定キーをキーダウン
            pyautogui.keyDown(target_key)

            # コンソール出力
            print(target_key + 'is keydowned')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # 指定キーアップメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  target_key         : 指定キー
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def keyUp(self, wait_time, target_key):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 指定キーをキーアップ
            pyautogui.keyUp(target_key)

            # コンソール出力
            print(target_key + 'is keyuped')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # クリックメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  img_x              : x座標
    # @param  img_y              : y座標
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def click(self, wait_time, img_x, img_y):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 現在位置を取得
            loc = pyautogui.position()

            # 検索画像位置をクリック
            pyautogui.click(img_x, img_y)

            # 初期値へ移動
            pyautogui.moveTo(loc[0], loc[1], duration = 0)

            # コンソール出力
            print('click from ({:4}, {:4})'.format(img_x, img_y))

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # 検索画像クリックメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  img_path           : 検索画像
    # @param  conf               : 検索画像の精度
    # @param  offset             : ズレ度合
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def serch_click_image(self, wait_time, img_path, conf, offset):
        try:

            # 指定時間までsleep
            time.sleep(wait_time)

            # 現在位置を取得
            loc = pyautogui.position()

            # 検索画像の位置を特定
            img_x, img_y = pyautogui.locateCenterOnScreen(img_path, grayscale = True, confidence = conf)

            # オフセット分を計算
            img_x = img_x + offset[0]
            img_y = img_y + offset[1]

            # 検索画像位置をクリック
            pyautogui.click(img_x, img_y)

            # 初期値へ移動
            pyautogui.moveTo(loc[0], loc[1], duration = 0)

            # コンソール出力
            print('{:50} is clicked from ({:4}, {:4}) to ({:4}, {:4})'.format(img_path, img_x, img_y, offset[0], offset[1]))

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # ドラッグメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  img_x              : x座標
    # @param  img_y              : y座標
    # @param  offset             : ズレ度合
    # @param  drag_time          : ドラッグ時間
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def drag(self, wait_time, img_x, img_y, offset, drag_time):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 現在位置を取得
            loc = pyautogui.position()

            # 対象位置へ移動
            pyautogui.moveTo(img_x, img_y, duration = 0)

            # ドラッグ操作
            pyautogui.dragTo(img_x + offset[0], img_y + offset[1], drag_time, button = 'left')

            # 初期値へ移動
            pyautogui.moveTo(loc[0], loc[1], duration = 0)

            # コンソール出力
            print('drag from ({:4}, {:4}) to ({:4}, {:4})'.format(img_x, img_y, offset[0], offset[1]))

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # 検索画像ドラッグメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  img_path           : 検索画像
    # @param  conf               : 検索画像の精度
    # @param  offset             : ズレ度合
    # @param  drag_time          : ドラッグ時間
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def serch_drag_image(self, wait_time, img_path, conf, offset, drag_time):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 現在位置を取得
            loc = pyautogui.position()

            # 検索画像の位置を特定
            img_x, img_y = pyautogui.locateCenterOnScreen(img_path, grayscale = True, confidence = conf)

            # 対象位置へ移動
            pyautogui.moveTo(img_x, img_y, duration = 0)

            # ドラッグ操作
            pyautogui.dragTo(img_x + offset[0], img_y + offset[1], drag_time, button = 'left')

            # 初期値へ移動
            pyautogui.moveTo(loc[0], loc[1], duration = 0)

            # コンソール出力
            print('{:50} is draged from ({:4}, {:4}) to ({:4}, {:4})'.format(img_path, img_x, img_y, offset[0], offset[1]))

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # 画像検索メソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  img_path           : 検索画像
    # @param  conf               : 検索画像の精度
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def serch_image(self, wait_time, img_path, conf):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 検索画像の位置取得
            img_x, img_y = pyautogui.locateCenterOnScreen(img_path, grayscale = True, confidence = conf)

            # コンソール出力
            print('{:50} is serched from ({:4}, {:4})'.format(img_path, img_x, img_y))

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # マウスカーソール位置取得メソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def serch_mouce_cursor_position(self, wait_time):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 現在位置を取得
            loc = pyautogui.position()

            # 初期値へ移動
            pyautogui.moveTo(loc[0], loc[1], duration = 0)

            # コンソール出力
            print('x座標：' + str(loc[0]))
            print('y座標：' + str(loc[1]))

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # タスクキルメソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  conf               : 検索画像の精度
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def taskKill(self, wait_time, conf):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # ホーム画面移行
            self.keyPress(wait_time, target_key = 'f2')

            # タスクキル処理
            flag1 = False
            num1 = 0
            while (flag1 is False):
                # 指定文言を確認 → クリック
                flag1 = self.serch_click_image(wait_time, ALL_CLEAR, conf = conf, offset = (0, 0))
                
                # 指定文言を未確認 → 待機
                if(flag1 is False):
                    if(num1 < 20):
                        self.keyPress(wait_time, target_key = 'up')
                        num1+=1
                        continue
                    else:
                        # Falseを返却
                        return False

            # コンソール出力
            print('taskKill is succesed')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # アプリ再起動メソッド
    # @param  self               : self
    # @param  wait_time          : 待機時間
    # @param  img_path           : 検索画像
    # @param  conf               : 検索画像の精度
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def aplReboot(self, wait_time, img_path, conf):
        try:
            # 指定時間までsleep
            time.sleep(wait_time)

            # 再立ち上げ処理
            flag1 = False
            num1 = 0
            while (flag1 is False):
                # 指定アイコンを確認 → クリック
                flag1 = self.serch_click_image(wait_time, img_path, conf = conf, offset = (0, 0))
                
                # 指定アイコンを未確認 → 待機
                if(flag1 is False):
                    if(num1 < 20):
                        # 指定時間までsleep
                        time.sleep(wait_time)
                        num1+=1
                        continue
                    else:
                        # Falseを返却
                        return False

            # コンソール出力
            print('aplReboot is succesed')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False
