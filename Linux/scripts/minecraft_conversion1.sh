#!/bin/bash
######################################################################################################################################################
# ファイル   : minecraft_conversion1.sh |                                                                                                            #
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
ERR_MESSAGE_01="コピーに失敗しました。"
ERR_MESSAGE_02="パッチに失敗しました。"
#*****************************************************************************************************************************************************
# 変数エリア
#*****************************************************************************************************************************************************
# 環境変数設定
## ワークフォルダ
WORK_DIR="${HOME}"/MyServerTest/Linux/kubernetes/custom/minecraft
## 変換対象フォルダ
CONVERSION_FOLDER1=/mnt/share/k8s/minecraft/proxy
CONVERSION_FOLDER2=/mnt/share/k8s/minecraft/server1
CONVERSION_FOLDER3=/mnt/share/k8s/minecraft/server2
## BungeeCordConfig
CONVERSION_FILE_NAME1=config.yml
COPY_FILE_NAME1=server-icon.png
CONVERSION_FULL_PATH1="${CONVERSION_FOLDER1}"/"${CONVERSION_FILE_NAME1}"
COPY_TO_FULL_PATH1="${CONVERSION_FOLDER1}"/"${COPY_FILE_NAME1}"
BACKUP_FULL_PATH1="${CONVERSION_FOLDER1}"/"${CONVERSION_FILE_NAME1}_bk"
WORK_FULL_PATH1="${WORK_DIR}"/"${CONVERSION_FILE_NAME1}_1"
COPY_FROM_FULL_PATH1="${WORK_DIR}"/img/"${COPY_FILE_NAME1}"
## ServerConfig
CONVERSION_FILE_NAME2=spigot.yml
CONVERSION_FULL_PATH2_1="${CONVERSION_FOLDER2}"/"${CONVERSION_FILE_NAME2}"
CONVERSION_FULL_PATH2_2="${CONVERSION_FOLDER3}"/"${CONVERSION_FILE_NAME2}"
BACKUP_FULL_PATH2_1="${CONVERSION_FOLDER2}"/"${CONVERSION_FILE_NAME2}_bk"
BACKUP_FULL_PATH2_2="${CONVERSION_FOLDER3}"/"${CONVERSION_FILE_NAME2}_bk"
WORK_FULL_PATH2_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME2}_2_1"
WORK_FULL_PATH2_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME2}_2_2"

# STEPセット
NSTEP=""
RSTEP=$1
if [ "${RSTEP}" = "" ]; then
  NSTEP="JOBSTART"
else
  NSTEP="${RSTEP}"
fi
#*****************************************************************************************************************************************************
# JOBSTART_前準備
#*****************************************************************************************************************************************************
while true;do
  case "${NSTEP}" in
    "JOBSTART")
      NSTEP="STEP010"
    ;;
#*****************************************************************************************************************************************************
# STEP010
#*****************************************************************************************************************************************************
    "STEP010")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${CONVERSION_FULL_PATH1}" "${BACKUP_FULL_PATH1}" && cp -p "${CONVERSION_FULL_PATH1}" "${WORK_FULL_PATH1}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP020"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP020
#*****************************************************************************************************************************************************
    "STEP020")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      yq eval -i 'del(.servers.lobby)' "${WORK_FULL_PATH1}" && \
      yq eval -i '.servers.server1 = {"motd": "&1Just another BungeeCord - Forced Host", "address": "minecraft.server1.com:25565", "restricted": false}' "${WORK_FULL_PATH1}" && \
      yq eval -i '.servers.server2 = {"motd": "&1Just another BungeeCord - Forced Host", "address": "minecraft.server2.com:25565", "restricted": false}' "${WORK_FULL_PATH1}" && \
      yq eval -i '.listeners[0].motd = "§9<<<§a Welcome§b To§b§l§o minecraft.gamer-iris.com§6 Server§9 >>>§r\n     §9♦§d Server§e on§a Paper/k8s§2 by§b§l§o Gamer-Iris§9 ♦"' "${WORK_FULL_PATH1}" && \
      yq eval -i '.listeners[0].priorities[0] = "server1"' "${WORK_FULL_PATH1}" && \
      yq eval -i '.listeners[0].host = "0.0.0.0:25565"' "${WORK_FULL_PATH1}" && \
      yq eval -i '.ip_forward = true' "${WORK_FULL_PATH1}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP030"
      else
        echo "${ERR_MESSAGE_02}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP030
#*****************************************************************************************************************************************************
    "STEP030")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${WORK_FULL_PATH1}" "${CONVERSION_FULL_PATH1}" && \
      cp -p "${COPY_FROM_FULL_PATH1}" "${COPY_TO_FULL_PATH1}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP040"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP040
#*****************************************************************************************************************************************************
    "STEP040")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${CONVERSION_FULL_PATH2_1}" "${BACKUP_FULL_PATH2_1}" && cp -p "${CONVERSION_FULL_PATH2_1}" "${WORK_FULL_PATH2_1}" && \
      cp -p "${CONVERSION_FULL_PATH2_2}" "${BACKUP_FULL_PATH2_2}" && cp -p "${CONVERSION_FULL_PATH2_2}" "${WORK_FULL_PATH2_2}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP050"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP050
#*****************************************************************************************************************************************************
    "STEP050")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      yq eval -i '.settings.bungeecord = true' "${WORK_FULL_PATH2_1}" && \
      yq eval -i '.settings.bungeecord = true' "${WORK_FULL_PATH2_2}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP060"
      else
        echo "${ERR_MESSAGE_02}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP060
#*****************************************************************************************************************************************************
    "STEP060")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${WORK_FULL_PATH2_1}" "${CONVERSION_FULL_PATH2_1}" && \
      cp -p "${WORK_FULL_PATH2_2}" "${CONVERSION_FULL_PATH2_2}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="JOBEND"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
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

# WORK内容の削除
rm -r "${WORK_FULL_PATH1}"
rm -r "${WORK_FULL_PATH2_1}"
rm -r "${WORK_FULL_PATH2_2}"

# 呼出し元へリターンコードを返却
exit ${JOB_RTN_CD}