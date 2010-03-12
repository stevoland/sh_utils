#!/bin/bash
PV=5.2
PN='AskApache Bash Profile Script'

#> source askapache.sh to use
############################################################################################################################################################
# 2009-08-23
#
# Copyright (C) 2009 www.AskApache.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
############################################################################################################################################################



#------------------------------------------------------------------------------------------------------------------------------------------------------------
# The first digit selects the set user ID (4) and set group ID (2) and sticky (1) attributes.
# The second digit selects permissions for the user who owns the file: read (4), write (2), and execute (1)
# The third selects permissions for other users in the file's group, with the same values
# The fourth for other users not in the file's group, with the same values.
# see man chmod, help umask
#------------------------------------------------------------------------------------------------------------------------------------------------------------
umask 0022


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Trapping Signals to Catch Errors
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1      2      3       4      5       6       7      8      9       10      11      12      13      14      15      17      18      19      20      21
# SIGHUP SIGINT SIGQUIT SIGILL SIGTRAP SIGABRT SIGBUS SIGFPE SIGKILL SIGUSR1 SIGSEGV SIGUSR2 SIGPIPE SIGALRM SIGTERM SIGCHLD SIGCONT SIGSTOP SIGTSTP SIGTTIN
# see man bash, man signal, help trap
#------------------------------------------------------------------------------------------------------------------------------------------------------------
trap 'echo -e "\n\n\n!!! TERMINATED SIG: [$?] AT LINE:$LINENO AFTER $SECONDS SECONDS !!!\n"|tee -a $SSH_TTY; dirty_exit' 1 2 13 15 19 20 21 22 EXIT




# for non-interactive shells
[[ -z "$PS1"  ]] && return



#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Advanced Shell Limits
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# -S      use the `soft' resource limit
# -H      use the `hard' resource limit
# -a      all current limits are reported
# -c      the maximum size of core files created
# -d      the maximum size of a process's data segment
# -f      the maximum size of files created by the shell
# -l      the maximum size a process may lock into memory
# -m      the maximum resident set size
# -n      the maximum number of open file descriptors
# -p      the pipe buffer size
# -s      the maximum stack size
# -t      the maximum amount of cpu time in seconds
# -u      the maximum number of user processes
# -v      the size of v
# see man getrlimit, help ulimit
#------------------------------------------------------------------------------------------------------------------------------------------------------------
ulimit -S -c 0 # Don't want any coredumps



#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Advanced Shell (set)tings
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# e [errexit] Exit immediately if a command exits with a non-zero status.
# B [braceexpand] The shell will perform brace expansion.
# h [hashall] Remember the location of commands as they
# f [noglob]      Disable file name generation (globbing).
# H [histexpand]  Enable ! style history substitution.
# v [verbose]     Print shell input lines as they are read.
# x [xtrace]      Print commands and their arguments as they are executed.
# n [noexec]      Read commands but do not execute them.
# [history] Enable command history
# see man bash, help set
#------------------------------------------------------------------------------------------------------------------------------------------------------------
set +C +f +H +v +x +n -b -h -i -m -B


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Advanced Shell (shopt)ions
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# cdable_vars             an argument to the cd builtin command that is not a directory is assumed to be the name of a variable dir to change to.
# cdspell                 minor errors in the spelling of a directory component in a cd command will be corrected.
# checkhash               bash checks that a command found in the hash table exists before execute it.  If no longer exists, a path search is performed.
# checkwinsize            bash checks the window size after each command and, if necessary, updates the values of LINES and COLUMNS.
# cmdhist                 bash attempts to save all lines of a multiple-line command in the same history entry.  Allows re-editing of multi-line commands.
# dotglob                 bash includes filenames beginning with a `.' in the results of pathname expansion.
# execfail                a non-int shell will not exit if it cannot execute the file specified as an argument to the exec builtin command, like int sh.
# expand_aliases          aliases are expanded as described above under ALIASES.  This option is enabled by default for interactive shells.
# extglob                 the extended pattern matching features described above under Pathname Expansion are enabled.
# histappend              the history list is appended to the file named by the value of the HISTFILE variable when shell exits, no overwriting the file.
# hostcomplete            and readline is being used, bash will attempt to perform hostname completion when a word containing a @ is being completed
# huponexit               bash will send SIGHUP to all jobs when an interactive login shell exits.
# interactive_comments    allow a word beginning with # to cause that word and all remaining characters on that line to be ignored in an interactive shell
# lithist                 if cmdhist option is enabled, multi-line commands are saved to the history with embedded newlines rather than using semicolon
# login_shell             shell sets this option if it is started as a login shell (see INVOCATION above).  The value may not be changed.
# mailwarn                file that bash is checking for mail has been accessed since the last checked, ``The mail in mailfile has been read'' is displayed.
# no_empty_cmd_completion bash will not attempt to search the PATH for possible completions when completion is attempted on an empty line.
# nocaseglob              bash matches filenames in a case-insensitive fashion when performing pathname expansion (see Pathname Expansion above).
# nullglob                bash allows patterns which match no files (see Pathname Expansion above) to expand to a null string, rather than themselves.
# progcomp                the programmable completion facilities (see Programmable Completion above) are enabled.  This option is enabled by default.
# promptvars              prompt strings undergo variable and parameter expansion after being expanded as described in PROMPTING above.
# shift_verbose           the shift builtin prints an error message when the shift count exceeds the number of positional parameters.
# sourcepath              the source (.) builtin uses the value of PATH to find the directory containing the file supplied as an argument.
# xpg_echo                the echo builtin expands backslash-escape sequences by default.
# see man bash, help shopt
#------------------------------------------------------------------------------------------------------------------------------------------------------------
shopt -s histappend cmdhist extglob no_empty_cmd_completion


#----------------------------
# CUSTOM SETTING VARIABLES
#----------------------------
export HOME=/home/`whoami`;
export SHELL=/bin/bash
export TZ='America/Indianapolis'
export HOST=`uname -n`

PATH=$HOME/bin:$HOME/sbin:/bin:/etc:/sbin:/usr/X11R6/bin:/usr/bin:/usr/bin/mh:/usr/libexec:/usr/local/bin:/usr/sbin:/etc/X11:/etc/X11/xinit:$HOME/.gem/ruby/1.8/bin
PATH=${PATH}:/usr/local/dh/apache/template/bin:/usr/local/dh/apache2/template/bin:/usr/local/dh/apache2/template/build:/usr/local/dh/apache2/template/sbin
export PATH=${PATH}:/usr/local/dh/bin:/usr/local/dh/java/bin:/usr/local/dh/java/jre/bin:/usr/local/php5/bin:.


#----------------------------
# LIBS / COMPILES
#----------------------------
LDFLAGS="-L${HOME}/lib -L/lib -L/usr/lib -L/usr/lib/libc5-compat -L/lib/libc5-compat -L/usr/i486-linuxlibc1/lib -L/usr/X11R6/lib"
LD_LIBRARY_PATH=$HOME/lib
CPPFLAGS="-I${HOME}/include"
export LDFLAGS LD_LIBRARY_PATH CPPFLAGS

#----------------------------
# MAIL, PROGRAMS
#----------------------------
export MAILCHECK=360
export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/nano
export BROWSER=~/bin/lynx
export LYNX_CFG=~/.lynx/lynx.cfg
export LOCATE_PATH=~/var/locatedb





#------------------------------------------------------------------------------------------------------------------------------------------------------------
# PROMPT
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# \a     an ASCII bell character (07)
# \d     the date in "Weekday Month Date" format (e.g., "Tue May 26")
# \D{format}  the format is passed to strftime(3) and the result is inserted into the prompt string;
# \e     an ASCII escape character (033)
# \h     the hostname up to the first `.'
# \H     the hostname
# \j     the number of jobs currently managed by the shell
# \l     the basename of the shell's terminal device name
# \n     newline
# \r     carriage return
# \s     the name of the shell, the basename of $0 (the portion following the final slash)
# \t     the current time in 24-hour HH:MM:SS format
# \T     the current time in 12-hour HH:MM:SS format
# \@     the current time in 12-hour am/pm format
# \A     the current time in 24-hour HH:MM format
# \u     the username of the current user
# \v     the version of bash (e.g., 2.00)
# \V     the release of bash, version + patchelvel (e.g., 2.00.0)
# \w     the current working directory
# \W     the basename of the current working directory
# \!     the history number of this command
# \#     the command number of this command
# \$     if the effective UID is 0, a #, otherwise a $
# \nnn   the character corresponding to the octal number nnn
# \\     a backslash
# \[     begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt
# \]     end a sequence of non-printing characters
#------------------------------------------------------------------------------------------------------------------------------------------------------------
export PS1="\n[$?]\e[1;37m[\e[0;32m\u\e[0;35m@\e[0;32m\h\e[1;37m]\e[1;37m[\e[0;31m\w\e[1;37m]($SHLVL:\!)\n\[${X}\]\$ "

# If set, the value is executed as a command prior to issuing each primary prompt.
export PROMPT_COMMAND='echo -ne "\033]0;`whoami`@$HOSTNAME:${PWD/#$HOME/~} ${SSH_TTY/\/dev\//} [`uptime|sed -e "s/.*: \([^,]*\).*/\1/" -e "s/ //g"`]\007"'

# used by functions below
export RJ=0;declare -a CC;
export R='\033[0;00m';
export X='\033[1;37m';
export L1=$(seq -s_ 1 75|tr -d [0-9])
export L2=$(echo $L1|tr '_' ' ')



#------------------------------------------------------------------------------------------------------------------------------------------------------------
# personalized colors
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Attribute codes:        00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:       30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes: 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
# NORMAL 00       # global default, although everything should be something.
# FILE 00         # normal file
# DIR 01;34       # directory
# LINK 01;36      # symbolic link.
# FIFO 40;33      # pipe
# SOCK 01;35      # socket
# DOOR 01;35      # door
# BLK 40;33;01    # block device driver
# CHR 40;33;01    # character device driver
# ORPHAN 40;31;01 # symlink to nonexistent file
# EXEC 01;32      # executables
function asetup_ls()
{
  eval "`dircolors -b`"
  LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31"
  LS_COLORS="${LS_COLORS}:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31"
  LS_COLORS="${LS_COLORS}:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35"
  LS_COLORS="${LS_COLORS}:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35"
  LS_COLORS="${LS_COLORS}:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.cpio=01;31"
  export LS_COLORS="${LS_COLORS}:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.htaccess=01;31:*.htpasswd=01;31:*.htpasswda1=01;31:*config.php=01;31:*wp-config.php=01;31:";
  unset LS_OPTIONS
}
function asetup_colors(){ for i in `seq 0 7`;do ii=$(($i+7));CC[$i]="\033[1;3${i}m";CC[$ii]="\033[0;3${i}m";done;CC[15]="\033[30;42m"; }
function ascript_title()
{
  clear; lin 0;
  echo -e "| ${CC[2]}             ___       __    ___                 __                     ${CC[0]} |"
  echo -e "| ${CC[2]}            / _ | ___ / /__ / _ | ___  ___ _____/ /  ___                ${CC[0]} |"
  echo -e "| ${CC[9]}           / __ |(_-</  '_// __ |/ _ \/ _ \`/ __/ _ \/ -_)               ${CC[0]} |"
  echo -e "| ${CC[9]}          /_/ |_/___/_/\_\/_/ |_/ .__/\_,_/\__/_//_/\__/                ${CC[0]} |"
  echo -e "| ${CC[9]}                               /_/                                      ${CC[0]} |";
  lin 1; lin 2 "${1:-Custom Bash Environment} Version ${2:-4.1}"; lin 3;sleep 1;
}


#----------------------------
# HISTORY SETUP
#----------------------------
function asetup_history()
{
  HISTMASTER=$HOME/backups/.history/combined.log
  HISTCONTROL='ignoreboth'
  HISTIGNORE='clear:ll:./_sbackup.sh:./_logview.sh:&:ps:updatedb:top'
  HISTSIZE=5000000
  HISTFILESIZE=5000000
  HISTFILE=$HOME/.bash_history
  export HISTMASTER HISTCONTROL HISTIGNORE HISTSIZE HISTFILESIZE HISTFILE
}
function h1(){ cat $HISTFILE $HISTMASTER | command grep $1 | sort | uniq | command grep --color=always $1; }
function h2(){ cat $HISTFILE $HISTMASTER | command grep $1 | sort | uniq; }










function asetup_aliases()
{

  pm "\tla - show hidden files"
  pm "\tla - sort by extension"
  pm "\tla - sort by size"
  pm "\tlc - sort by change time"
  pm "\tlu - sort by access time"
  pm "\tlr - recursive ls"
  pm "\tlt - sort by date"

  #---------------
  # ls aliases
  #---------------
  C=' --color=auto'
  alias la="command ls -Al${C}"      # show hidden files
  alias lx="command ls -lAXB${C}"    # sort by extension
  alias lk="command ls -lASr${C}"    # sort by size
  alias lc="command ls -lAcr${C}"    # sort by change time
  alias lu="command ls -lAur${C}"    # sort by access time
  alias lr="command ls -lAR${C}"     # recursive ls
  alias lt="command ls -lAtr${C}"    # sort by date
  alias vdir="command ls${C} --format=long"
  alias dir="command ls${C} --format=vertical"

  #---------------
  # safety aliases
  #---------------
  alias chmod='command chmod -c'
  alias mkdir='command mkdir -pv'
  alias rm='command rm -v'
  alias cp='command cp -v'
  alias mv='command mv -v'

  #---------------
  # func aliases
  #---------------
  alias who='command who -ar -pld'
  alias tree='command tree -Csuflapi'

  alias pp='command ps -HAcl -F S -A f'
  alias p='command ps -HAcl -F S -A f|uniq -W3'
  alias ps1='command ps -lFA'
  alias ps2='command ps -H'
  alias df='command df -iTa'

  alias n="${EDITOR}"
  alias inice='ionice -c3 -n7 nice'
  alias chmod='command chmod -c'
  alias mkdir='command mkdir -pv'
  alias rm='command rm -v'
  alias tree='tree -Csuflapi'
  alias vim='vim --noplugin'
  alias lll="stat -c %a\ %N\ %G\ %U \$PWD/*|sort"
  alias ps2='command ps -H'
  alias ps1='command ps -lFA'
  alias killphp='pkill -9 -f php.cgi\|php5.cgi\|php-cgi\|php\|php4.cgi;pkill -13 -f php.cgi\|php5.cgi\|php-cgi\|php\|php4.cgi'
  alias dsiz='du -sk * | sort -n --'
  alias du='du -kh'
  alias df='df -kTh'
  alias man='man -H'
  alias ldconfig="ldconfig -v -f ${HOME}/etc/ld.so.conf -C ${HOME}/etc/ld.so.cache"
}










###########################################################################--=--=--=--=--=--=--=--=--=--=--#
###
### FUNCTIONS
###
###########################################################################==-==-==-==-==-==-==-==-==-==-==#
function clean_exit(){ lin 0;lin 1;lin 2 "COMPLETED SUCCESSFULLY";lin 1;lin 3; }
function dirty_exit(){ echo "See ya.."; }
function set_window_title(){ echo -e "\033]0; ${1:-$USER@$HOST - $SHLVL} \007"; }
function pd(){ echo -e  "\n ${CC[15]} ${1:-DONE} $R\n\n" >$SSH_TTY; }
function cont(){ local ans; echo -en "\n ${CC[15]}[ ${1:-Press any key to continue} ]$R\n"; read -n 1 ans; }
function do_sleep (){ echo -en "${CC[6]}${3:-.}" >$SSH_TTY;while [[ -d /proc/$RJ ]];do sleep ${2:-3};echo -en "${3:-.}" >$SSH_TTY;done;echo -e "${CC[0]}" >$SSH_TTY&&sleep 1&&pd; }
function pwd(){ command pwd -LP "$@" | sed -e 's#/.greer##g'; }
function kill_jobs(){ for i in `jobs -p`; do kill -9 $i; done; }
function beep_alarm(){ local i; for i in `seq 0 ${1:-5}`;do echo -en "\a" && sleep 1; done; }
function lin(){ case ${1:-1} in 0)echo -e "\n$R $L1"; ;; 1)echo -e "|$L2|"; ;; 2)echo -en "|${CC[34]}";echo -en "${2:-1}"|sed -e :a -e 's/^.\{1,72\}$/ & /;ta' -e "s/\(.*\)/\1/";echo -e "${R} |" ;; 3)echo -e "$R $L1$R\n\n"; ;; esac; }
function mp3info(){ ls *.mp3 |xargs -ix 2>&1 ffmpeg -i x|grep -v "^Must" |grep -v "built\|libavutil\|libavcodec\|configuration\|FFmpeg\|libavformat"; }
function tailit(){ clear;echo "p e a ma md all | FILENAME"; sh ${HOME}/scripts/logview.sh "${2:-askapache.com}" "${1:-all}"; }
function pm(){ local S I=${1:-3};S=$SSH_TTY;echo -en "$R\n";case ${2:-0} in 0)echo -en "${CC[6]}==> $X$I$R" >$S; ;; 3)echo -e "\n\n${CC[4]}:: $X$I$R\n" >$S; ;; esac; }
function yes_no(){ local a YN=65; echo -en "${1:-Answer} [y/n] "; read -n 1 a; case $a in [yY]) YN=0; ;; esac; return $YN; }
function l(){ command ls -AhFp --color=auto "$@"; }
function ll(){ command ls -lABls1c --color=auto "$@"; }
function stat1(){ local D=${1:-$PWD/*}; stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N ${D} |sed -e 's/ [0-9:]\{8\}\.[0-9]\{9\} -[0-9]\+//g' |tr  -d "\`\'"|sort -r; }
function stat2(){ local D=${1:-$PWD/*}; stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N ${D} |sed -e 's/\.[0-9]\{9\} -[0-9]\+//g'|tr  -d "\`\'"|sort -r; }




#--=--=--=--=--=--=--=--=--=--=--#
# processes
#==-==-==-==-==-==-==-==-==-==-==#
function ps(){ [[ -z "$1" ]] && command ps -Hacl -F S -A f && return; command ps "$@"; }
function make_nice(){ pm "Making Nice $$"; pm 0 0; command renice ${1:-19} -p $$; pd; }
function make_ionice(){ pm "Making IONice $$"; pm 0 0; command ionice -c${1:-3} -n7 -p $$; pd; }
function dump_ps_environment() { command ps aux | grep ${USER:0:3} | awk '{print $2}' | xargs -t -ipid cat /proc/pid/environ; }
function procinfo1(){ PI=($(strace -s1 procinfo -a 2>&1|sed -e '/^op/!d' -e '/pro/!d' -e '/= -1/d'|sed -e 's%o.*"/proc/\(.*\)".*% \1%g')); for i in ${PI[*]}; do echo -e "\n---===[  /proc/$i  ]\n" && cat /proc/$i && echo -e "\n\n"; done; }

function pss(){
  local U PPS PL PX PXX UUS=( $(command ps uax|awk '{print $1}'|command tail -n +2|sort|uniq) ); UL=$((${#UUS[@]} - 1))
  exec 6>&1; exec > ~/proc.$$
  ps aux | grep ${USER:0:3} | awk '{print $2}' | xargs -t -ipid cat /proc/pid/environ
  for UX in $(seq 0 1 $UUS); do U=${UUS[$UX]}; PPS=( $(pgrep -u ${U}) ); PL=$((${#PPS[@]} - 1));
   for PX in $(seq 0 1 $PL); do PXX=${PPS[$PX]};echo -e "\n\n\n----- PROCESS ID: ${PXX} -----\n\n";cat /proc/${PXX}/cmdline 2>/dev/null || echo;echo -e "\n\n"; command tree -Csuflapi /proc/Q/${PXX};done
  done
  exec 1>&6 6>&-; cat ~/proc.$$ | more
}




function ashow_motd() { echo -e "\n\n${CC[2]}`head -n 7 /etc/motd | tail -n 6`${R}\n"; }
function ashow_calendar() { echo -en "\n${CC[5]}"; sed = $(echo /usr/share/calendar/calendar*) | sed -n "/$(date +%m\\/%d\\\|%b\*\ %d)/p";echo -en "${R}"; }
function ashow_fortune() { echo -en "\n${CC[6]}";/usr/games/fortune -s;echo -en "${R}"; }

function askapache(){
  asetup_history && asetup_colors && ascript_title "$PV" "$PN" &&  asetup_aliases && asetup_ls && ashow_motd;
  make_nice && make_ionice 3


  pm "Users"
  pm "Logged In" 3;         command who -ar -pld
  pm "Current Limits" 3;    ulimit -a
  sleep 1


  pm "Machine stats";
  pm "uptime" 3;        uptime
  pm "Users" 3;         who
  sleep 1

  pm "Networking"
  pm "interfaces" 3;    ip -o addr|sed -e 's/ \{1,\}/\t/g'
  pm "Sockets" 3;       head -n 2 /proc/net/sockstat
  pm "Networking Stats" 3; ss -s
  pm "Routing Information" 3; netstat -r
  sleep 1

  pm "Disk"
  pm "Mounts" 3;        command df -hai
  pm "IO Scheduling" 3; for d in /sys/block/[a-z][a-z][a-z]*/queue/*; do [[ -d $d ]] && tree $d; echo "$d => $(cat $d)";done
  pm "I/O on Disks";    iostat -p ALL
  sleep 1

  pm "Processes";
  pm "process tree" 3;  command ps -HAcl -F S -A f | uniq -w3
  pm "procinfo" 3;      procinfo|head -n 13|tail -n 11
  sleep 1

  ashow_calendar && ashow_fortune
}