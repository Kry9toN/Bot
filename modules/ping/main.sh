#!/bin/bash
#
# Copyright (C) 2020 KryPtoB's KBot
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

module_ping() {
        START=$(($(date +%s%N)/1000000))
        local MESSAGE_ID=$(tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "Pong !!!" --reply_to_message_id "$(tg_get_message_id "$@")" | jq .result.message_id)
        END=$(($(date +%s%N)/1000000))
        DIFF=$(($END - $START))
        tg_edit_message_text --chat_id "$(tg_get_chat_id "$@")" --message_id "$MESSAGE_ID" --text "$DIFF ms"
}
