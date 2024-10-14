######################################################################################################################################################
# ファイル   : sshExec.py               |                                                                                                            #
#                                       |                                                                                                            #
#----------------------------------------------------------------------------------------------------------------------------------------------------#
# [修正履歴]                            |                                                                                                            #
# V-001      : 2024/10/14               | Gamer-Iris   新規作成                                                                                      #
#                                       |                                                                                                            #
######################################################################################################################################################



# [環境設定エリア]
######################################################################################################################################################
# OS関連のモジュール
import sys

# ssh関連のモジュール
import paramiko

# yaml関連のモジュール
import yaml

# [定数定義エリア]
######################################################################################################################################################
# ssh関連のコマンド定数
SSH_CMD_APP_NOTICE1       = "PASSWORD=`cat /home/"
SSH_CMD_APP_NOTICE2       = "/MyServer/Linux/settings/settings.yml | yq eval '.password'` && cd /home/"
SSH_CMD_APP_NOTICE3       = "/MyServer/Linux/appnotice && echo $PASSWORD | sudo -S python3 ./appNotice.py"
SSH_CMD_SPACE             = " "



# [変数定義エリア]
######################################################################################################################################################
# settings.yml内容
settingsYaml              = []

# ssh関連のコマンド変数
sshCmdArg1                = ""
sshCmdArg2                = ""
sshCmdArg3                = ""



# [前処理内容エリア]
######################################################################################################################################################



# [処理内容エリア]
######################################################################################################################################################
# sshExecクラス
# @param  -
# 
# 
class sshExec:

    ##################################################################################################################################################
    # sampleメソッド
    # @param  self               : self
    # 
    # 
    def sample(self):
        print(self.function)

    ##################################################################################################################################################
    # sshCmd実行メソッド
    # @param  self               : self
    # @param  cmd                : コマンド内容
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def sshCmd(self, cmd):
        try:
            # settings.yml内容が空か確認 → settings.yml内容を取得
            global settingsYaml
            if not settingsYaml:
                self.setSettingsYaml()
                settingsYaml = self.getSettingsYaml()

            # ssh接続
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            hostname = settingsYaml["appnotice"]["host"]
            port = settingsYaml["appnotice"]["port"]
            username = settingsYaml["appnotice"]["username"]
            password = settingsYaml["appnotice"]["password"]
            ssh.connect(hostname, port, username, password, timeout=5.0)

            # コマンドの実行
            stdin, stdout, stderr = ssh.exec_command(cmd)

            # 実行結果のstdoutとstderrを読み出す
            for o in stdout:
                print(o)
            for e in stderr:
                print(e)

            # ssh接続断
            ssh.close()
            del ssh, stdin, stdout, stderr

            # コンソール出力
            print('ssh is succesed')

            # Trueを返却
            return True

        # エラーハンドリング時処理
        except Exception as e:
            # エラー内容を出力
            print(e)

            # Falseを返却
            return False

    ##################################################################################################################################################
    # sshAppNotice実行メソッド
    # @param  self               : self
    # @param  programName        : プログラム名
    # @param  noticeMessage1     : 通知メッセージ
    # @param  noticeMessage2     : エラーメッセージ
    # @return True               : True（正常終了時）
    # @return False              : False（異常終了時）
    def sshAppNotice(self, programName, noticeMessage1, noticeMessage2):
        try:
            # settings.yml内容が空か確認 → settings.yml内容を取得
            global settingsYaml
            if not settingsYaml:
                self.setSettingsYaml()
                settingsYaml = self.getSettingsYaml()

            # ssh接続
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            hostname = settingsYaml["appnotice"]["host"]
            port = settingsYaml["appnotice"]["port"]
            username = settingsYaml["appnotice"]["username"]
            password = settingsYaml["appnotice"]["password"]
            ssh.connect(hostname, port, username, password, timeout=5.0)

            # コマンドの実行
            sshCmdArg1 = SSH_CMD_SPACE + "'" + programName + "'"
            sshCmdArg2 = SSH_CMD_SPACE + "$'"+ noticeMessage1 + "'"
            sshCmdArg3 = SSH_CMD_SPACE + "$'"+ noticeMessage2 + "'"
            cmd = SSH_CMD_APP_NOTICE1 + username + SSH_CMD_APP_NOTICE2 + username + SSH_CMD_APP_NOTICE3 + sshCmdArg1 + sshCmdArg2 + sshCmdArg3
            stdin, stdout, stderr = ssh.exec_command(cmd)

            # 実行結果のstdoutとstderrを読み出す
            for o in stdout:
                print(o)
            for e in stderr:
                print(e)

            # ssh接続断
            ssh.close()
            del ssh, stdin, stdout, stderr

            # コンソール出力
            print('ssh is succesed')

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
    # @return settings.yml       : settings.yml内容
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
    cmd = sys.argv[1]

    # アプリ通知メソッドの呼出し
    sshExec = sshExec()
    sshExec.sshCmd(cmd)
