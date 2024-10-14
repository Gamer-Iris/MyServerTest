#!/bin/bash
######################################################################################################################################################
# ファイル   : minecraft_start.sh       |                                                                                                            #
# (引数)     : RSTEP                    | (リスタートするジョブステップを指定)                                                                       #
# (復帰値)   : 0                        | (正常終了)                                                                                                 #
#            : 10                       | (異常終了)                                                                                                 #
#                                       |                                                                                                            #
#----------------------------------------------------------------------------------------------------------------------------------------------------#
# [修正履歴]                            |                                                                                                            #
# V-001      : 2024/10/14               | Gamer-Iris   新規作成                                                                                      #
#                                       |                                                                                                            #
######################################################################################################################################################

#*****************************************************************************************************************************************************
# 定数エリア
#*****************************************************************************************************************************************************
# フラグ
JOB_RTN_CD=0
ABEND_FLG=0
RTN_CD=0

# エラーメッセージ設定
ERR_MESSAGE_01="サーバー起動に失敗しました。"
ERR_MESSAGE_02="サーバー起動がタイムアウトしました。"
#*****************************************************************************************************************************************************
# 変数エリア
#*****************************************************************************************************************************************************
# ジョブネーム設定
JOB_NAME=$(basename $0 | sed -e 's/.sh//g')

# 環境変数設定
USERNAME=`cat ~/MyServerTest/Linux/settings/settings.yml | yq eval '.username'`
PASSWORD=`cat ~/MyServerTest/Linux/settings/settings.yml | yq eval '.password'` && echo "${PASSWORD}" | sudo -S true
KEY=`cat ~/MyServerTest/Linux/settings/settings.yml | yq eval '.key'`
APPNOTICE_USER=`cat ~/MyServerTest/Linux/settings/settings.yml | yq eval '.appnotice.user'`
APPNOTICE_HOST=`cat ~/MyServerTest/Linux/settings/settings.yml | yq eval '.appnotice.host'`
TIMEOUT_DURATION=300
START_TIME=$(date +%s)
END_TIME=$((START_TIME + TIMEOUT_DURATION)) 
GREP_PATTERN='\[.*\] \[Server thread/INFO\]: Done \([0-9.]+s\)! For help, type "help"'

# 変数初期化
RESULT=""
LOG_TIME=0
LOG_TIME_SEC=0

# STEPセット
NSTEP=""
RSTEP=$1
if [ "${RSTEP}" = "" ]; then
  NSTEP="JOBSTART"
else
  NSTEP="${RSTEP}"
fi

# アプリ通知関連
JOB_NAME_APP_NOTICE="${USERNAME}"_"$(basename $0)"
APP_NOTICE_DIR=/home/"${APPNOTICE_USER}"/MyServerTest/Linux/appnotice
function appNotice () 
{
if [ "${USERNAME}" = "${APPNOTICE_USER}" ]; then
  # アプリ通知 引数：$1（通知内容）、$2（エラー内容）
  cd "${APP_NOTICE_DIR}" && sudo python3 ./appNotice.py "${JOB_NAME_APP_NOTICE}" "$1" "$2"
else
  # アプリ通知 引数：$1（通知内容）、$2（エラー内容）
  ssh -i "${KEY}" "${APPNOTICE_USER}"@"${APPNOTICE_HOST}" "cd "${APP_NOTICE_DIR}" && echo "${PASSWORD}" | sudo -S python3 ./appNotice.py "${JOB_NAME_APP_NOTICE}" "$1" "$2""
fi
}

# ログ関連
LOG_DIR1=/var/log/"$(echo "${JOB_NAME}" | sed -e 's/_.*//g')"
LOG_DIR2=/mnt/share/k8s/minecraft/server1/logs
LOG_DIR3=/mnt/share/k8s/minecraft/server2/logs
LOG_FILE1="$(basename $0 | sed -e 's/.sh//g').log"
LOG_FILE2=latest.log
LOG_FILE3=latest.log
if [ ! -e "${LOG_DIR1}" ]; then
  sudo mkdir -m 777 "${LOG_DIR1}"
fi
function log () 
{
  LOG="${LOG_DIR1}"/"${LOG_FILE1}"
  time=[$(date '+%Y/%m/%d %T')]
  # 正常終了時のログ出力 引数：$1
  sudo echo -e "${time}" "$1" | sudo tee -a ${LOG}
  if [[ $2 != "" ]]; then
    # 異常終了時のログ出力 引数：$2
    sudo echo -e "$2" | sudo tee -a ${LOG}
  fi
}
#*****************************************************************************************************************************************************
# JOBSTART_前準備
#*****************************************************************************************************************************************************
appNotice START ""
log "${JOB_NAME}"_START
while true;do
  case "${NSTEP}" in
    "JOBSTART")
      NSTEP="STEP010"
    ;;
#*****************************************************************************************************************************************************
# STEP010
#*****************************************************************************************************************************************************
    "STEP010")
      log "${JOB_NAME}"_"${NSTEP}"_START

      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      RESULT=$(kubectl apply -f ~/MyServerTest/Linux/kubernetes/custom/minecraft/minecraft-proxy.yml && \
               kubectl apply -f ~/MyServerTest/Linux/kubernetes/custom/minecraft/minecraft-deployment.yml)
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [ -n "${RESULT}" ]; then
        log "${RESULT}"
      fi
      if [[ ${RTN_CD} -eq 0 ]]; then
        log "${JOB_NAME}"_"${NSTEP}"_END
        NSTEP="STEP020"
      else
        ABEND_FLG=1
        appNotice "${NSTEP}"_ABBEND "${ERR_MESSAGE_01}"
        log "${JOB_NAME}"_"${NSTEP}"_ABBEND "${ERR_MESSAGE_01}"
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP020
#*****************************************************************************************************************************************************
    "STEP020")
      log "${JOB_NAME}"_"${NSTEP}"_START

      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      RESULT=$(while [[ $(date +%s) -lt ${END_TIME} ]]; do
                 line=$(cat "${LOG_DIR2}/${LOG_FILE2}" "${LOG_DIR3}/${LOG_FILE3}" | grep -P "${GREP_PATTERN}" | awk '{print $1}' | tr -d '[]' | while read -r l; do
                   LOG_TIME_SEC=$(date -d "$l" +%s 2>/dev/null)
                   if [[ -n ${LOG_TIME_SEC} && ${LOG_TIME_SEC} -ge ${START_TIME} ]]; then
                     echo "$l"
                     break
                   fi
                 done)
                 if [[ -n "$line" ]]; then
                   echo "$line"
                   break
                 fi
                 sleep 10
               done)
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [ -n "${RESULT}" ]; then
        log "${RESULT}"
      fi
      if [[ ${RTN_CD} -eq 0 && -n "${RESULT}" ]]; then
        log "${JOB_NAME}"_"${NSTEP}"_END
        NSTEP="JOBEND"
      else
        ABEND_FLG=1
        appNotice "${NSTEP}"_ABBEND "${ERR_MESSAGE_02}"
        log "${JOB_NAME}"_"${NSTEP}"_ABBEND "${ERR_MESSAGE_02}"
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# JOBEND_ループを抜ける
#*****************************************************************************************************************************************************
    "JOBEND")
      break
    ;;
  esac
done
#*****************************************************************************************************************************************************
# 後片付け
#*****************************************************************************************************************************************************
# アベンドフラグが立っているか確認
if [ ${ABEND_FLG} -eq 1 ]; then
  # リターンコードのセット
  JOB_RTN_CD=10
fi

# 呼出し元へリターンコードを返却
appNotice END ""
log "${JOB_NAME}"_END
exit ${JOB_RTN_CD}
