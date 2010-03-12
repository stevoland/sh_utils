#!/bin/bash
# SiteBack Version 3.3, 2008-12-17
# GNU Free Documentation License 1.2
# 12-17-08 - AskApache (www.askapache.com)
umask 022
 
### SHELL OPTIONS
set +o noclobber # allowed to clobber files
set +o noglob # globbing on
set +o xtrace # change to - to enable tracing
set +o verbose # change to - to enable verbose debugging
set -e # abort on first error
shopt -s extglob
 
###########################################################################--=--=--=--=--=--=--=--=--=--=--#
###
### SETTINGS
###
###########################################################################==-==-==-==-==-==-==-==-==-==-==#
 
DT=$(date +%x); DT=${DT//\/}
DTX=$(date +%x-%H%M); DTX=${DTX//\/}
BDIR=${HOME}/backups
RUN_FILE=${BDIR}/$$.bk.log
MY_CONFIG=".sbackup"
DOMAIN=;DB_NAME=;DB_USER=;DB_PASSWORD=;DB_HOST=;APP_CONFIG=;SQL_DEST=;ARC_DEST=;ENCRYPT_USER=
E_SUCCESS=0;E_YN=0;E_YES=251;E_NO=250;E_RETURN=65;C0=;C1=;C2=;C3=;C4=;C5=;C5=;C7=
 
###########################################################################--=--=--=--=--=--=--=--=--=--=--#
###
### FUNCTIONS
###
###########################################################################==-==-==-==-==-==-==-==-==-==-==#
 
#--=--=--=--=--=--=--=--=--=--=--#
# script_title
#==-==-==-==-==-==-==-==-==-==-==#
function script_title(){
 local e="\033["
 local l=' ___________________________________________________________________ '
 
 # SET WINDOW TITLE AND COLORS IF CLIENT CAPABLE
 case $TERM in xterm*|vt*|ansi|rxvt|gnome*)
 C0="${e}0m";C1="${e}1;30m";C2="${e}1;32m";C3="${e}0;32m";C4="${e}1;37m";C5="${e}1;35m";C6="${e}30;42m"
 esac
 
 echo -e "\n${C0}$l${C1}"
 echo -e "|             ${C2}___       __    ___                 __${C1}                |"
 echo -e "|            ${C2}/ _ | ___ / /__ / _ | ___  ___ _____/ /  ___${C1}           |"
 echo -e "|           ${C2}/ __ |(_-</  '_// __ |/ _ \/ _ \`/ __/ _ \/ -_)${C1}          |"
 echo -e "|          ${C3}/_/ |_/___/_/\_\/_/ |_/ .__/\_,_/\__/_//_/\__/${C1}           |"
 echo -e "|                               ${C3}/_/${C1}                                 |"
 echo -e "|                                                                   |"
 echo -e "|       ${C1}+--${C0} SITE BACKUP SCRIPT Version 3.3${C1}                          |"
 echo -e "${C0}$l\n\n"
}
 
#--=--=--=--=--=--=--=--=--=--=--#
# pm
#==-==-==-==-==-==-==-==-==-==-==#
function pm(){
 START=$(date +%s) && touch ${RUN_FILE}
 case "${2:-title}" in
  "title") echo -en "\n\n${C2}>>> ${C4}${1} ${C0} \n\n"; ;;
   "info") echo -e "${C5}=> ${C4}${1} ${C0}"; ;;
   "item") echo -e "${C4}-- ${C0}${1} "; ;;
 esac
}
 
#--=--=--=--=--=--=--=--=--=--=--#
# yes_no
#==-==-==-==-==-==-==-==-==-==-==#
function yes_no(){
 local ans
 echo -en "${1} [y/n] " ; read -n 1 ans
 case "$ans" in
  n|N) E_YN=$E_NO ;;
  y|Y) E_YN=$E_YES ;;
 esac
}
 
#--=--=--=--=--=--=--=--=--=--=--#
# do_sleep
#==-==-==-==-==-==-==-==-==-==-==#
function do_sleep (){
 local END DIFF
 echo -en "${C5}${3:-.}"; while [ -r "$RUN_FILE" ]; do sleep ${2:-3}; echo -en "${3:-.}"; done;
 echo -e "${C0}"; sleep 1; END=$(date +%s);DIFF=$(( $END - $START ))
 echo -e "\n${C6} [T: ${SECONDS}] COMPLETED IN ${DIFF} SEC ${C0} \n\n"; sleep 1;
 return 0;
}
 
#--=--=--=--=--=--=--=--=--=--=--#
# get_settings
#==-==-==-==-==-==-==-==-==-==-==#
function get_settings(){
 local cha HOSTED_SITES G GG
 clear; script_title

 if [[ -r "$MY_CONFIG" ]]; then

  OIFS=$IFS; while IFS=: read DOMAIN DOMAINROOT APP_CONFIG ENCRYPT_USER; do
   DOMAIN=${DOMAIN};
   DOMAINROOT=${DOMAINROOT};
   APP_CONFIG=${APP_CONFIG};
   ENCRYPT_USER=${ENCRYPT_USER};
   #E_YN=$E_YES;
   break
  done <${MY_CONFIG};
  IFS=$OIFS

 else

  gpg --list-keys|grep uid.*|awk '{print $2}'
  echo -en "\n What userid to use for encryption?  ";
  read -e ENCRYPT_USER; echo
 
  echo -en "\n What domain would you like to backup?  "; read -e DOMAIN; echo
 
  echo $PWD
  until [ -d "$DOMAINROOT" ]; do echo -en "\n Folder where config file is located?  ";
  read -e DOMAINROOT; echo; done
 
  [[ -r "$DOMAINROOT/config.php" ]] && APP_CONFIG=$DOMAINROOT/config.php && DOT=PHP
  [[ -r "$DOMAINROOT/wp-config.php" ]] && APP_CONFIG=$DOMAINROOT/wp-config.php && DOT=WP

  echo $PWD
  until [[ -r "$APP_CONFIG" ]]; do echo -en "\n Where is the applications config file?  "; read -e APP_CONFIG; echo; done

 fi

 
  [[ -r "$DOMAINROOT/config.php" ]] && APP_CONFIG=$DOMAINROOT/config.php && DOT=PHP
  [[ -r "$DOMAINROOT/wp-config.php" ]] && APP_CONFIG=$DOMAINROOT/wp-config.php && DOT=WP
 
  ### For phpBB
  if [[ "${DOT}" == "PHP" ]]; then
    GG=$(sed -e '/$db\(n\|u\|pa\|h\)/!d' -e "s/$db_\(name\|user\|passwd\|host\)\ =\ '\([^']*\).*\$/\1='\2';/g" -e 's/$db/DB_/g' ${APP_CONFIG});
    G=$(echo ${GG}|sed -e 's/DB_name/DB_NAME/g' -e 's/DB_user/DB_USER/g' -e 's/DB_passwd/DB_PASSWORD/g' -e 's/DB_host/DB_HOST/g');
  else
    G=$(sed -e "/define('DB_\(NAME\|USER\|PASSWORD\|HOST\)/!d" -e "s/[^']*'DB_\(NAME\|USER\|PASSWORD\|HOST\)'[^']*'\([^']*\)'.*$/DB_\1='\2';/g" ${APP_CONFIG})
  fi
  eval $G;
 
 mkdir -p ${BDIR}/${DOMAIN}
 SQL_DEST=${BDIR}/${DOMAIN}/${DOMAIN}-${DT}.sql;
 [[ -r "${SQL_DEST}.asc" ]] && SQL_DEST=${BDIR}/${DOMAIN}/${DOMAIN}-${DTX}.sql
 
 ARC_DEST=${BDIR}/${DOMAIN}/${DOMAIN}-${DT}.tgz;
 [[ -r "${ARC_DEST}.asc" ]] && ARC_DEST=${BDIR}/${DOMAIN}/${DOMAIN}-${DTX}.tgz
 
 if [[ "$E_YN" != "$E_YES" ]]; then
  for a in "DOMAIN" "DOMAINROOT" "APP_CONFIG" "ENCRYPT_USER" "DB_NAME" "DB_USER" "DB_PASSWORD" "DB_HOST"; do echo -e "${a}: ${!a}"; done
  echo; yes_no "ARE THESE SETTINGS CORRECT"
 fi
 
 while [[ "$E_YN" != "$E_YES" ]]; do
  for a in "DOMAIN" "DOMAINROOT" "APP_CONFIG" "ENCRYPT_USER" "DB_NAME" "DB_USER" "DB_PASSWORD" "DB_HOST"; do
   echo -en "\n (Enter for Default: ${!a} )\n ${a}:> "
   read -e cha; echo; [[ ${#cha} -gt 2 ]] && eval "$a"=$cha
  done
  yes_no "ARE THESE SETTINGS CORRECT"
 done
 
 echo -e "${DOMAIN}:${DOMAINROOT}:${APP_CONFIG}:${ENCRYPT_USER}" > $MY_CONFIG
}
 
#--=--=--=--=--=--=--=--=--=--=--#
# exit_cleanup
#==-==-==-==-==-==-==-==-==-==-==#
function exit_cleanup(){
 cd $OLDPWD
 [[ -r "${SQL_DEST}" ]] && rm ${SQL_DEST}
 [[ -r "${ARC_DEST}" ]] && rm ${ARC_DEST}
}
 
############################################################################################################
###
### MAIN CODE
###
############################################################################################################
 
#=# CATCH SCRIPT KILLED BY USER
trap exit_cleanup SIGHUP SIGINT SIGTERM
 
#=# MAKE MAIN SCRIPT NICE
renice 19 -p $$ &>/dev/null
 
cd `dirname $0`
 
get_settings
 
pm "CREATING SQL BACKUP"
mysqldump --opt -u${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -r ${SQL_DEST} --add-drop-table ${DB_NAME} 1>&2 &>/dev/null && sleep 2 1>&2 &>/dev/null && rm ${RUN_FILE} 2>&1&
do_sleep 1 1 ":"
 
pm "ENCRYPTING SQL BACKUP"
gpg --armor --recipient ${ENCRYPT_USER} --output ${SQL_DEST}.asc --encrypt ${SQL_DEST} 1>&2 &>/dev/null && sleep 2 1>&2 &>/dev/null && rm ${RUN_FILE} 2>&1&
do_sleep 1 1 ":"; rm ${SQL_DEST}
 
pm "CREATING ARCHIVE BACKUP"
tar -czf ${ARC_DEST} . 1>&2 &>/dev/null && rm ${RUN_FILE} 2>&1&
do_sleep 1 5 ":"
 
pm "ENCRYPTING ARCHIVE BACKUP"
gpg --armor --recipient ${ENCRYPT_USER} --output ${ARC_DEST}.asc --encrypt ${ARC_DEST} 1>&2 &>/dev/null && rm ${RUN_FILE} 2>&1&
do_sleep 1 1 ":"; rm ${ARC_DEST}
 
echo -e "${C1} __________________________________________________________________________ "
echo -e "|                                                                          |"
echo -e "|                 ${C4} COMPLETED SUCCESSFULLY ${C1}                                 |"
echo -e "${C1} __________________________________________________________________________ ${C0} \n\n"
 
cd $OLDPWD
 
exit $?
