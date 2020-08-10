#!/bin/bash
#
# Copyright (C) 2020 KtyPtoN's KBot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Source variables and basic functions
source variables.sh
source base/telegram_base.sh
source base/telegram_get.sh
source base/get.sh
source base/telegram_send.sh

module_trigger() {

# Trigger agrument
trigger_parse_arguments() {
  while [ "${#}" -gt 0 ]; do
  	case "${1}" in
          -h | --help )
  		trigger_help "$@"
  		;;
          -p | --project )
  		PROJECT="${2}"
  		;;
          -s | --sync )
  		SYNC="${2}"
  		;;
          -cc | --ccache )
  		CCACHE="${2}"
  		;;
          -c | --clean )
  		CLEAN="${2}"
  		;;
          -b | --build )
  		TYPE="${2}"
  		;;
  	  -d | --device )
  		DEVICE="${2}"
  		;;
  	  -t | --target )
  		TARGET="${2}"
  		;;
  	  -j | --job)
  		JOB="${2}"
  		;;
          -sf | --sourceforge)
                SF="${2}"
                ;;
          -s | --server)
                SERVER="${2}"
  		shift
  		;;
  	esac
  	shift
  done
}

trigger_parse_arguments $(tg_get_command_arguments "$@")

trigger_help() {
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "$2

Usage: \`!trigger [arguments] [value]\`
 \`-s\` (sync yes/no) (optional)
 \`-cc\` (ccache yes/no/clean) (optional)
 \`-c\` (clean yes/no/installclean) (optional)
 \`-d\` (device) (required)
 \`-b\` (build type user/userdebug/eng) (optional)
 \`-t\` (traget komodo/SystemUI/Settings) (optional)
 \`-job\` (paralel build 1-8) (optional)
 \`-sf\` (sourforge upload test/release) (optional)" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
	exit
}

if [ "$PROJECT" = "" ]; then
  PROJECT=komodo-release
fi

if [ "$SYNC" = "" ]; then
  SYNC=yes
fi

if [ "$CCACHE" = "" ]; then
  CCACHE=yes
fi

if [ "$CLEAN" = "" ]; then
  CLEAN=yes
fi

if [ "$TYPE" = "" ]; then
  TYPE=userdebug
fi

if [ "$TARGET" = "" ]; then
  TARGET=bacon
fi

if [ "$JOB" = "" ]; then
  JOB=8
fi

if [ "$SF" = "" ]; then
  SF=test
fi

if [ "$SERVER" = "" ]; then
  SERVER=master
fi

if [ "$TOKEN_JENKINS" = "" ]; then
  tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "fatal: error: token Jenkins not available in variable" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
  exit
elif [ "$DEVICE" = "" ]; then
  trigger_help "$@" "Missing, arguments -d (device) is required"
  exit
else
# Post api
  curl https://jenkins.komodo-os.my.id/job/$PROJECT/buildWithParameters \
  --user komodo-os:$TOKEN_JENKINS \
  --form re_sync=$SYNC \
  --form use_ccache=$CCACHE \
  --form make_clean=$CLEAN \
  --form device_codename=$DEVICE \
  --form build_type=$TYPE \
  --form target_command=$TARGET \
  --form jobs=$JOB \
  --form upload_to_sf=$SF \
  --form server=$SERVER

  tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "Successful trigger jenkins for $DEVICE.
We wish you a successful build and land safely" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
fi

}
