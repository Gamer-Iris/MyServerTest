#!/bin/bash
######################################################################################################################################################
# ファイル   : minecraft_conversion2.sh |                                                                                                            #
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
## DB関連
DATABASES_OSS=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.oss'`
DATABASES_OSS_LOWERCASE="${DATABASES_OSS,,}"
DATABASES_ADDRESS=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.address'`
DATABASES_DATABASE1_DATABASENAME=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database1.databasename'`
DATABASES_DATABASE1_USERNAME=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database1.username'`
DATABASES_DATABASE1_PASSWORD=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database1.password'`
DATABASES_DATABASE2_DATABASENAME=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database2.databasename'`
DATABASES_DATABASE2_USERNAME=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database2.username'`
DATABASES_DATABASE2_PASSWORD=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database2.password'`
DATABASES_DATABASE3_DATABASENAME=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database3.databasename'`
DATABASES_DATABASE3_USERNAME=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database3.username'`
DATABASES_DATABASE3_PASSWORD=`cat ~/MyServer/Linux/settings/settings.yml | yq eval '.databases.database3.password'`
## ワークフォルダ
WORK_DIR="${HOME}"/MyServer/Linux/kubernetes/custom/minecraft
## 変換対象フォルダ
CONVERSION_FOLDER1=/mnt/share/k8s/minecraft/proxy
CONVERSION_FOLDER2=/mnt/share/k8s/minecraft/server1
CONVERSION_FOLDER3=/mnt/share/k8s/minecraft/server2
## BlueMapConfig
CONVERSION_FILE_NAME1=core.conf
CONVERSION_FILE_NAME2_1=$(
  basename "$(
    find "${CONVERSION_FOLDER2}/plugins/BlueMap/maps" -maxdepth 1 -type f -name '*.conf' \
    | grep -E '[^/]+_[0-9]+(_[0-9]+)?\.conf$' | sort | tail -n 1)")
CONVERSION_FILE_NAME2_2=$(
  basename "$(
    find "${CONVERSION_FOLDER3}/plugins/BlueMap/maps" -maxdepth 1 -type f -name '*.conf' \
    | grep -E '[^/]+_[0-9]+(_[0-9]+)?\.conf$' | sort | tail -n 1)")
CONVERSION_FILE_NAME3_1=$(
  basename "$(
    find "${CONVERSION_FOLDER2}/plugins/BlueMap/maps" -maxdepth 1 -type f -name '*.conf' \
    | grep -E '[^/]+_[0-9]+(_[0-9]+)?_nether\.conf$' | sort | tail -n 1)")
CONVERSION_FILE_NAME3_2=$(
  basename "$(
    find "${CONVERSION_FOLDER3}/plugins/BlueMap/maps" -maxdepth 1 -type f -name '*.conf' \
    | grep -E '[^/]+_[0-9]+(_[0-9]+)?_nether\.conf$' | sort | tail -n 1)")
CONVERSION_FILE_NAME4_1=$(
  basename "$(
    find "${CONVERSION_FOLDER2}/plugins/BlueMap/maps" -maxdepth 1 -type f -name '*.conf' \
    | grep -E '[^/]+_[0-9]+(_[0-9]+)?_the_end\.conf$' | sort | tail -n 1)")
CONVERSION_FILE_NAME4_2=$(
  basename "$(
    find "${CONVERSION_FOLDER3}/plugins/BlueMap/maps" -maxdepth 1 -type f -name '*.conf' \
    | grep -E '[^/]+_[0-9]+(_[0-9]+)?_the_end\.conf$' | sort | tail -n 1)")
CONVERSION_FILE_NAME5=resource.conf
CONVERSION_FILE_NAME6=resource_nether.conf
CONVERSION_FILE_NAME7=resource_the_end.conf
CONVERSION_FILE_NAME8=spawn.conf
CONVERSION_FILE_NAME9=sql.conf
CONVERSION_FULL_PATH1_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/"${CONVERSION_FILE_NAME1}"
CONVERSION_FULL_PATH1_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/"${CONVERSION_FILE_NAME1}"
CONVERSION_FULL_PATH2_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME2_1}"
CONVERSION_FULL_PATH2_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME2_2}"
CONVERSION_FULL_PATH3_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME3_1}"
CONVERSION_FULL_PATH3_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME3_2}"
CONVERSION_FULL_PATH4_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME4_1}"
CONVERSION_FULL_PATH4_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME4_2}"
CONVERSION_FULL_PATH5_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME5}"
CONVERSION_FULL_PATH5_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME5}"
CONVERSION_FULL_PATH6_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME6}"
CONVERSION_FULL_PATH6_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME6}"
CONVERSION_FULL_PATH7_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME7}"
CONVERSION_FULL_PATH7_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME7}"
CONVERSION_FULL_PATH8_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME8}"
CONVERSION_FULL_PATH8_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME8}"
CONVERSION_FULL_PATH9_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/storages/"${CONVERSION_FILE_NAME9}"
CONVERSION_FULL_PATH9_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/storages/"${CONVERSION_FILE_NAME9}"
BACKUP_FULL_PATH1_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/"${CONVERSION_FILE_NAME1}_bk"
BACKUP_FULL_PATH1_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/"${CONVERSION_FILE_NAME1}_bk"
BACKUP_FULL_PATH2_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME2_1}_bk"
BACKUP_FULL_PATH2_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME2_2}_bk"
BACKUP_FULL_PATH3_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME3_1}_bk"
BACKUP_FULL_PATH3_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME3_2}_bk"
BACKUP_FULL_PATH4_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME4_1}_bk"
BACKUP_FULL_PATH4_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/maps/"${CONVERSION_FILE_NAME4_2}_bk"
BACKUP_FULL_PATH9_1="${CONVERSION_FOLDER2}"/plugins/BlueMap/storages/"${CONVERSION_FILE_NAME9}_bk"
BACKUP_FULL_PATH9_2="${CONVERSION_FOLDER3}"/plugins/BlueMap/storages/"${CONVERSION_FILE_NAME9}_bk"
WORK_FULL_PATH1_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME1}_1_1"
WORK_FULL_PATH1_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME1}_1_2"
WORK_FULL_PATH2_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME2_1}_2_1"
WORK_FULL_PATH2_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME2_2}_2_2"
WORK_FULL_PATH3_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME3_1}_3_1"
WORK_FULL_PATH3_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME3_2}_3_2"
WORK_FULL_PATH4_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME4_1}_4_1"
WORK_FULL_PATH4_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME4_2}_4_2"
WORK_FULL_PATH5_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME5}_5_1"
WORK_FULL_PATH5_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME5}_5_2"
WORK_FULL_PATH6_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME6}_6_1"
WORK_FULL_PATH6_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME6}_6_2"
WORK_FULL_PATH7_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME7}_7_1"
WORK_FULL_PATH7_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME7}_7_2"
WORK_FULL_PATH8_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME8}_8_1"
WORK_FULL_PATH8_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME8}_8_2"
WORK_FULL_PATH9_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME9}_9_1"
WORK_FULL_PATH9_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME9}_9_2"
## ChunkyConfig
CONVERSION_FILE_NAME10=config.yml
CONVERSION_FULL_PATH10_1="${CONVERSION_FOLDER2}"/plugins/Chunky/"${CONVERSION_FILE_NAME10}"
CONVERSION_FULL_PATH10_2="${CONVERSION_FOLDER3}"/plugins/Chunky/"${CONVERSION_FILE_NAME10}"
BACKUP_FULL_PATH10_1="${CONVERSION_FOLDER2}"/plugins/Chunky/"${CONVERSION_FILE_NAME10}_bk"
BACKUP_FULL_PATH10_2="${CONVERSION_FOLDER3}"/plugins/Chunky/"${CONVERSION_FILE_NAME10}_bk"
WORK_FULL_PATH10_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME10}_10_1"
WORK_FULL_PATH10_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME10}_10_2"
## LuckPermsConfig
CONVERSION_FILE_NAME11=config.yml
CONVERSION_FULL_PATH11_1="${CONVERSION_FOLDER1}"/plugins/LuckPerms/"${CONVERSION_FILE_NAME11}"
CONVERSION_FULL_PATH11_2="${CONVERSION_FOLDER2}"/plugins/LuckPerms/"${CONVERSION_FILE_NAME11}"
CONVERSION_FULL_PATH11_3="${CONVERSION_FOLDER3}"/plugins/LuckPerms/"${CONVERSION_FILE_NAME11}"
BACKUP_FULL_PATH11_1="${CONVERSION_FOLDER1}"/plugins/LuckPerms/"${CONVERSION_FILE_NAME11}_bk"
BACKUP_FULL_PATH11_2="${CONVERSION_FOLDER2}"/plugins/LuckPerms/"${CONVERSION_FILE_NAME11}_bk"
BACKUP_FULL_PATH11_3="${CONVERSION_FOLDER3}"/plugins/LuckPerms/"${CONVERSION_FILE_NAME11}_bk"
WORK_FULL_PATH11_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME11}_11_1"
WORK_FULL_PATH11_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME11}_11_2"
WORK_FULL_PATH11_3="${WORK_DIR}"/"${CONVERSION_FILE_NAME11}_11_3"
## LunaChat
CONVERSION_FILE_NAME12=config.yml
CONVERSION_FULL_PATH12_1="${CONVERSION_FOLDER2}"/plugins/LunaChat/"${CONVERSION_FILE_NAME12}"
CONVERSION_FULL_PATH12_2="${CONVERSION_FOLDER3}"/plugins/LunaChat/"${CONVERSION_FILE_NAME12}"
BACKUP_FULL_PATH12_1="${CONVERSION_FOLDER2}"/plugins/LunaChat/"${CONVERSION_FILE_NAME12}_bk"
BACKUP_FULL_PATH12_2="${CONVERSION_FOLDER3}"/plugins/LunaChat/"${CONVERSION_FILE_NAME12}_bk"
WORK_FULL_PATH12_1="${WORK_DIR}"/"${CONVERSION_FILE_NAME12}_12_1"
WORK_FULL_PATH12_2="${WORK_DIR}"/"${CONVERSION_FILE_NAME12}_12_2"

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
      cp -p "${CONVERSION_FULL_PATH1_1}" "${BACKUP_FULL_PATH1_1}" && cp -p "${CONVERSION_FULL_PATH1_1}" "${WORK_FULL_PATH1_1}" && \
      cp -p "${CONVERSION_FULL_PATH1_2}" "${BACKUP_FULL_PATH1_2}" && cp -p "${CONVERSION_FULL_PATH1_2}" "${WORK_FULL_PATH1_2}" && \
      cp -p "${CONVERSION_FULL_PATH2_1}" "${BACKUP_FULL_PATH2_1}" && cp -p "${CONVERSION_FULL_PATH2_1}" "${WORK_FULL_PATH2_1}" && \
      cp -p "${CONVERSION_FULL_PATH2_2}" "${BACKUP_FULL_PATH2_2}" && cp -p "${CONVERSION_FULL_PATH2_2}" "${WORK_FULL_PATH2_2}" && \
      cp -p "${CONVERSION_FULL_PATH3_1}" "${BACKUP_FULL_PATH3_1}" && cp -p "${CONVERSION_FULL_PATH3_1}" "${WORK_FULL_PATH3_1}" && \
      cp -p "${CONVERSION_FULL_PATH3_2}" "${BACKUP_FULL_PATH3_2}" && cp -p "${CONVERSION_FULL_PATH3_2}" "${WORK_FULL_PATH3_2}" && \
      cp -p "${CONVERSION_FULL_PATH4_1}" "${BACKUP_FULL_PATH4_1}" && cp -p "${CONVERSION_FULL_PATH4_1}" "${WORK_FULL_PATH4_1}" && \
      cp -p "${CONVERSION_FULL_PATH4_2}" "${BACKUP_FULL_PATH4_2}" && cp -p "${CONVERSION_FULL_PATH4_2}" "${WORK_FULL_PATH4_2}" && \
      cp -p "${CONVERSION_FULL_PATH9_1}" "${BACKUP_FULL_PATH9_1}" && cp -p "${CONVERSION_FULL_PATH9_1}" "${WORK_FULL_PATH9_1}" && \
      cp -p "${CONVERSION_FULL_PATH9_2}" "${BACKUP_FULL_PATH9_2}" && cp -p "${CONVERSION_FULL_PATH9_2}" "${WORK_FULL_PATH9_2}" && \
      cp -p "${WORK_FULL_PATH2_1}" "${WORK_FULL_PATH5_1}" && \
      cp -p "${WORK_FULL_PATH2_1}" "${WORK_FULL_PATH8_1}" && \
      cp -p "${WORK_FULL_PATH2_2}" "${WORK_FULL_PATH5_2}" && \
      cp -p "${WORK_FULL_PATH2_2}" "${WORK_FULL_PATH8_2}" && \
      cp -p "${WORK_FULL_PATH3_1}" "${WORK_FULL_PATH6_1}" && \
      cp -p "${WORK_FULL_PATH3_2}" "${WORK_FULL_PATH6_2}" && \
      cp -p "${WORK_FULL_PATH4_1}" "${WORK_FULL_PATH7_1}" && \
      cp -p "${WORK_FULL_PATH4_2}" "${WORK_FULL_PATH7_2}"
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
      sed -i 's/accept-download: false/accept-download: true/' "${WORK_FULL_PATH1_1}" && \
      sed -i 's/accept-download: false/accept-download: true/' "${WORK_FULL_PATH1_2}" && \
      sed -i 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH2_1}" && \
      sed -i 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH2_2}" && \
      sed -i 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH3_1}" && \
      sed -i 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH3_2}" && \
      sed -i 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH4_1}" && \
      sed -i 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH4_2}" && \
      sed -i -e 's/world: "[^"]*"/world: "resource"/' \
             -e 's/name: "[^"]* (overworld)"/name: "resource (overworld)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH5_1}" && \
      sed -i -e 's/world: "[^"]*"/world: "resource"/' \
             -e 's/name: "[^"]* (overworld)"/name: "resource (overworld)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH5_2}" && \
      sed -i -e 's/world: "[^"]*_nether"/world: "resource_nether"/' \
             -e 's/name: "[^"]*_nether (the_nether)"/name: "resource_nether (the_nether)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH6_1}" && \
      sed -i -e 's/world: "[^"]*_nether"/world: "resource_nether"/' \
             -e 's/name: "[^"]*_nether (the_nether)"/name: "resource_nether (the_nether)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH6_2}" && \
      sed -i -e 's/world: "[^"]*_the_end"/world: "resource_the_end"/' \
             -e 's/name: "[^"]*_the_end (the_end)"/name: "resource_the_end (the_end)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH7_1}" && \
      sed -i -e 's/world: "[^"]*_the_end"/world: "resource_the_end"/' \
             -e 's/name: "[^"]*_the_end (the_end)"/name: "resource_the_end (the_end)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH7_2}" && \
      sed -i -e 's/world: "[^"]*"/world: "spawn"/' \
             -e 's/name: "[^"]* (overworld)"/name: "spawn (overworld)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH8_1}" && \
      sed -i -e 's/world: "[^"]*"/world: "spawn"/' \
             -e 's/name: "[^"]* (overworld)"/name: "spawn (overworld)"/' \
             -e 's/storage: "file"/storage: "sql"/' "${WORK_FULL_PATH8_2}" && \
      sed -i "s|connection-url: \"jdbc:mysql://localhost:3306/bluemap?permitMysqlScheme\"|connection-url: \"jdbc:mysql://${DATABASES_ADDRESS}:3306/${DATABASES_DATABASE1_DATABASENAME}?permitMysqlScheme\"|" "${WORK_FULL_PATH9_1}" && \
      sed -i "s/user: \"root\"/user: \"${DATABASES_DATABASE1_USERNAME}\"/" "${WORK_FULL_PATH9_1}" && \
      sed -i "s/password: \"\"/password: \"${DATABASES_DATABASE1_PASSWORD}\"/" "${WORK_FULL_PATH9_1}" && \
      sed -i "s|connection-url: \"jdbc:mysql://localhost:3306/bluemap?permitMysqlScheme\"|connection-url: \"jdbc:mysql://${DATABASES_ADDRESS}:3306/${DATABASES_DATABASE2_DATABASENAME}?permitMysqlScheme\"|" "${WORK_FULL_PATH9_2}" && \
      sed -i "s/user: \"root\"/user: \"${DATABASES_DATABASE2_USERNAME}\"/" "${WORK_FULL_PATH9_2}" && \
      sed -i "s/password: \"\"/password: \"${DATABASES_DATABASE2_PASSWORD}\"/" "${WORK_FULL_PATH9_2}"
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
      cp -p "${WORK_FULL_PATH1_1}" "${CONVERSION_FULL_PATH1_1}" && \
      cp -p "${WORK_FULL_PATH1_2}" "${CONVERSION_FULL_PATH1_2}" && \
      cp -p "${WORK_FULL_PATH2_1}" "${CONVERSION_FULL_PATH2_1}" && \
      cp -p "${WORK_FULL_PATH2_2}" "${CONVERSION_FULL_PATH2_2}" && \
      cp -p "${WORK_FULL_PATH3_1}" "${CONVERSION_FULL_PATH3_1}" && \
      cp -p "${WORK_FULL_PATH3_2}" "${CONVERSION_FULL_PATH3_2}" && \
      cp -p "${WORK_FULL_PATH4_1}" "${CONVERSION_FULL_PATH4_1}" && \
      cp -p "${WORK_FULL_PATH4_2}" "${CONVERSION_FULL_PATH4_2}" && \
      cp -p "${WORK_FULL_PATH5_1}" "${CONVERSION_FULL_PATH5_1}" && \
      cp -p "${WORK_FULL_PATH5_2}" "${CONVERSION_FULL_PATH5_2}" && \
      cp -p "${WORK_FULL_PATH6_1}" "${CONVERSION_FULL_PATH6_1}" && \
      cp -p "${WORK_FULL_PATH6_2}" "${CONVERSION_FULL_PATH6_2}" && \
      cp -p "${WORK_FULL_PATH7_1}" "${CONVERSION_FULL_PATH7_1}" && \
      cp -p "${WORK_FULL_PATH7_2}" "${CONVERSION_FULL_PATH7_2}" && \
      cp -p "${WORK_FULL_PATH8_1}" "${CONVERSION_FULL_PATH8_1}" && \
      cp -p "${WORK_FULL_PATH8_2}" "${CONVERSION_FULL_PATH8_2}" && \
      cp -p "${WORK_FULL_PATH9_1}" "${CONVERSION_FULL_PATH9_1}" && \
      cp -p "${WORK_FULL_PATH9_2}" "${CONVERSION_FULL_PATH9_2}"
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
      cp -p "${CONVERSION_FULL_PATH10_1}" "${BACKUP_FULL_PATH10_1}" && cp -p "${CONVERSION_FULL_PATH10_1}" "${WORK_FULL_PATH10_1}" && \
      cp -p "${CONVERSION_FULL_PATH10_2}" "${BACKUP_FULL_PATH10_2}" && cp -p "${CONVERSION_FULL_PATH10_2}" "${WORK_FULL_PATH10_2}"
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
      yq eval -i '.continue-on-restart = true' "${WORK_FULL_PATH10_1}" && \
      yq eval -i '.force-load-existing-chunks = true' "${WORK_FULL_PATH10_1}" && \
      yq eval -i '.continue-on-restart = true' "${WORK_FULL_PATH10_2}" && \
      yq eval -i '.force-load-existing-chunks = true' "${WORK_FULL_PATH10_2}"
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
      cp -p "${WORK_FULL_PATH10_1}" "${CONVERSION_FULL_PATH10_1}" && \
      cp -p "${WORK_FULL_PATH10_2}" "${CONVERSION_FULL_PATH10_2}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP070"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP070
#*****************************************************************************************************************************************************
    "STEP070")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${CONVERSION_FULL_PATH11_1}" "${BACKUP_FULL_PATH11_1}" && cp -p "${CONVERSION_FULL_PATH11_1}" "${WORK_FULL_PATH11_1}" && \
      cp -p "${CONVERSION_FULL_PATH11_2}" "${BACKUP_FULL_PATH11_2}" && cp -p "${CONVERSION_FULL_PATH11_2}" "${WORK_FULL_PATH11_2}" && \
      cp -p "${CONVERSION_FULL_PATH11_3}" "${BACKUP_FULL_PATH11_3}" && cp -p "${CONVERSION_FULL_PATH11_3}" "${WORK_FULL_PATH11_3}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP080"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP080
#*****************************************************************************************************************************************************
    "STEP080")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      yq eval -i '.use-server-uuid-cache = true' "${WORK_FULL_PATH11_1}" && \
      yq eval -i ".storage-method = \"${DATABASES_OSS}\"" "${WORK_FULL_PATH11_1}" && \
      yq eval -i ".data.address = \"${DATABASES_ADDRESS}\"" "${WORK_FULL_PATH11_1}" && \
      yq eval -i ".data.database = \"${DATABASES_DATABASE3_DATABASENAME}\"" "${WORK_FULL_PATH11_1}" && \
      yq eval -i ".data.username = \"${DATABASES_DATABASE3_USERNAME}\"" "${WORK_FULL_PATH11_1}" && \
      yq eval -i ".data.password = \"${DATABASES_DATABASE3_PASSWORD}\"" "${WORK_FULL_PATH11_1}" && \
      yq eval -i '.server = "server1"' "${WORK_FULL_PATH11_2}" && \
      yq eval -i '.use-server-uuid-cache = true' "${WORK_FULL_PATH11_2}" && \
      yq eval -i ".storage-method = \"${DATABASES_OSS}\"" "${WORK_FULL_PATH11_2}" && \
      yq eval -i ".data.address = \"${DATABASES_ADDRESS}\"" "${WORK_FULL_PATH11_2}" && \
      yq eval -i ".data.database = \"${DATABASES_DATABASE3_DATABASENAME}\"" "${WORK_FULL_PATH11_2}" && \
      yq eval -i ".data.username = \"${DATABASES_DATABASE3_USERNAME}\"" "${WORK_FULL_PATH11_2}" && \
      yq eval -i ".data.password = \"${DATABASES_DATABASE3_PASSWORD}\"" "${WORK_FULL_PATH11_2}" && \
      yq eval -i '.server = "server2"' "${WORK_FULL_PATH11_3}" && \
      yq eval -i '.use-server-uuid-cache = true' "${WORK_FULL_PATH11_3}" && \
      yq eval -i ".storage-method = \"${DATABASES_OSS}\"" "${WORK_FULL_PATH11_3}" && \
      yq eval -i ".data.address = \"${DATABASES_ADDRESS}\"" "${WORK_FULL_PATH11_3}" && \
      yq eval -i ".data.database = \"${DATABASES_DATABASE3_DATABASENAME}\"" "${WORK_FULL_PATH11_3}" && \
      yq eval -i ".data.username = \"${DATABASES_DATABASE3_USERNAME}\"" "${WORK_FULL_PATH11_3}" && \
      yq eval -i ".data.password = \"${DATABASES_DATABASE3_PASSWORD}\"" "${WORK_FULL_PATH11_3}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP090"
      else
        echo "${ERR_MESSAGE_02}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP090
#*****************************************************************************************************************************************************
    "STEP090")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${WORK_FULL_PATH11_1}" "${CONVERSION_FULL_PATH11_1}" && \
      cp -p "${WORK_FULL_PATH11_2}" "${CONVERSION_FULL_PATH11_2}" && \
      cp -p "${WORK_FULL_PATH11_3}" "${CONVERSION_FULL_PATH11_3}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP100"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP100
#*****************************************************************************************************************************************************
    "STEP100")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${CONVERSION_FULL_PATH12_1}" "${BACKUP_FULL_PATH12_1}" && cp -p "${CONVERSION_FULL_PATH12_1}" "${WORK_FULL_PATH12_1}" && \
      cp -p "${CONVERSION_FULL_PATH12_2}" "${BACKUP_FULL_PATH12_2}" && cp -p "${CONVERSION_FULL_PATH12_2}" "${WORK_FULL_PATH12_2}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP110"
      else
        echo "${ERR_MESSAGE_01}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP110
#*****************************************************************************************************************************************************
    "STEP110")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      yq eval -i '.japanizeType = "GoogleIME"' "${WORK_FULL_PATH12_1}"&& \
      yq eval -i '.japanizeType = "GoogleIME"' "${WORK_FULL_PATH12_2}"
      # RETURN----------------------------------------------------------------------------------------------------------------------------------------
      RTN_CD=$?
      if [[ ${RTN_CD} -eq 0 ]]; then
        NSTEP="STEP120"
      else
        echo "${ERR_MESSAGE_02}"
        ABEND_FLG=1
        NSTEP="JOBEND"
        break
      fi
    ;;
#*****************************************************************************************************************************************************
# STEP120
#*****************************************************************************************************************************************************
    "STEP120")
      # EXEC------------------------------------------------------------------------------------------------------------------------------------------
      cp -p "${WORK_FULL_PATH12_1}" "${CONVERSION_FULL_PATH12_1}" && \
      cp -p "${WORK_FULL_PATH12_2}" "${CONVERSION_FULL_PATH12_2}"
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
rm -r "${WORK_FULL_PATH1_1}"
rm -r "${WORK_FULL_PATH1_2}"
rm -r "${WORK_FULL_PATH2_1}"
rm -r "${WORK_FULL_PATH2_2}"
rm -r "${WORK_FULL_PATH3_1}"
rm -r "${WORK_FULL_PATH3_2}"
rm -r "${WORK_FULL_PATH4_1}"
rm -r "${WORK_FULL_PATH4_2}"
rm -r "${WORK_FULL_PATH5_1}"
rm -r "${WORK_FULL_PATH5_2}"
rm -r "${WORK_FULL_PATH6_1}"
rm -r "${WORK_FULL_PATH6_2}"
rm -r "${WORK_FULL_PATH7_1}"
rm -r "${WORK_FULL_PATH7_2}"
rm -r "${WORK_FULL_PATH8_1}"
rm -r "${WORK_FULL_PATH8_2}"
rm -r "${WORK_FULL_PATH9_1}"
rm -r "${WORK_FULL_PATH9_2}"
rm -r "${WORK_FULL_PATH10_1}"
rm -r "${WORK_FULL_PATH10_2}"
rm -r "${WORK_FULL_PATH11_1}"
rm -r "${WORK_FULL_PATH11_2}"
rm -r "${WORK_FULL_PATH11_3}"
rm -r "${WORK_FULL_PATH12_1}"
rm -r "${WORK_FULL_PATH12_2}"

# 呼出し元へリターンコードを返却
exit ${JOB_RTN_CD}
