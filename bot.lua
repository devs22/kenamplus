serpent = require('serpent')
serp = require 'serpent'.block
http = require("socket.http")
https = require("ssl.https")
http.TIMEOUT = 10
lgi = require ('lgi')
JSON = require('dkjson')
redis = (loadfile "./libs/JSON.lua")()
redis = (loadfile "./libs/redis.lua")()
database = Redis.connect('127.0.0.1', 6379)
notify = lgi.require('Notify')
tdcli = dofile('tdcli.lua')
notify.init ("Telegram updates")
chats = {1126643850}
day = 86400
--###############################--
bot_id = {144729558}
sudo_users = {30742221,30262506,144729558}

--##########GetMessage###########--
local function getMessage(chat_id, message_id,callback)
  tdcli_function ({
    ID = "GetMessage",
    chat_id_ = chat_id,
    message_id_ = message_id
  }, callback, nil)
end

--###############################--
function is_sudo(msg)
local var = false
for v,user in pairs(sudo_users) do
  if user == msg.sender_user_id_ then
    var = true
  end
end
return var
end
--###############################--
function is_owner(msg)
local var = false
local group_mods = redis:get('owners:'..msg.chat_id_)
if group_mods == tostring(msg.sender_user_id_) then
  var = true
end
for v, user in pairs(sudo_users) do
  if user == msg.sender_user_id_ then
    var = true
  end
end
return var
end
--###############################--
function is_momod(msg)
local var = false
if redis:sismember('mods:'..msg.chat_id_,msg.sender_user_id_) then
  var = true
end
if redis:get('owners:'..msg.chat_id_) == tostring(msg.sender_user_id_) then
  var = true
end
for v, user in pairs(sudo_users) do
  if user == msg.sender_user_id_ then
    var = true
  end
end
return var
end
--###############################--
function is_banned(user_id, chat_id)
    local var = false
	local hash = 'bot:banned:'..chat_id
    local banned = database:sismember(hash, user_id)
	 if banned then
	    var = true
	 end
    return var
end

function is_gbanned(user_id)
  local var = false
  local hash = 'bot:gbanned:'
  local banned = database:sismember(hash, user_id)
  if banned then
    var = true
  end
  return var
end
--###############################--
function is_muted(user_id, chat_id)
    local var = false
	local hash = 'bot:muted:'..chat_id
    local banned = database:sismember(hash, user_id)
	 if banned then
	    var = true
	 end
    return var
end

function is_gmuted(user_id, chat_id)
    local var = false
	local hash = 'bot:gmuted:'..chat_id
    local banned = database:sismember(hash, user_id)
	 if banned then
	    var = true
	 end
    return var
end
--###############################--
function is_gbanned(msg)
local var = false
local chat_id = msg.chat_id_
local user_id = msg.sender_user_id_
local hash = 'gbanned:'
local banned = redis:sismember(hash, user_id)
if banned then
  var = true
end
return var
end
--###############################--
function vardump(value)
  print(serpent.block(value, {comment=false}))
end
function run(data,edited_msg)
local msg = data.message_
if edited_msg then
  msg = data
end
-- vardump(msg)
local input = msg.content_.text_
local chat_id = msg.chat_id_
local user_id = msg.sender_user_id_
local botgp = redis:get("addedgp"..chat_id)
local wlcmsg = "wlc"..chat_id
local setwlc = "setwlc"..chat_id
local floodMax = "floodMax"..chat_id
local floodTime = "floodTime"..chat_id
local mutehash = 'muteall:'..chat_id
local hashflood = "flood"..chat_id
local hashbot = "bot"..chat_id
local hashlink = "link"..chat_id
local hashtag = "tag"..chat_id
local hashusername = "username"..chat_id
local hashforward = "forward"..chat_id
local hasharabic = "arabic"..chat_id
local hashtgservice = "tgservice"..chat_id
local hasheng = "eng"..chat_id
local hashbadword = "badword"..chat_id
local hashedit = "edit"..chat_id
local hashinline = "inline"..chat_id
local hashemoji = "emoji"..chat_id
local hashall = "all"..chat_id
local hashsticker = "sticker"..chat_id
local hashgif = "gif"..chat_id
local hashcontact = "contact"..chat_id
local hashphoto = "photo"..chat_id
local hashaudio = "audio"..chat_id
local hashvoice = "voice"..chat_id
local hashvideo = "video"..chat_id
local hashdocument = "document"..chat_id
local hashtext1 = "text"..chat_id
if not botgp and not is_sudo(msg) then
  return false
end
if msg.chat_id_ then
  local id = tostring(msg.chat_id_)
  if id:match('-100(%d+)') then
    chat_type = 'super'
  elseif id:match('^(%d+)') then
    chat_type = 'user'
  else
    chat_type = 'group'
  end
end
-- Coded By saadmusic - [Channel : @kenamch] - [Telegarm : @saad7m]
-------------------------------------------------------------------------------------------
if redis:get(mutehash) == 'Enable' and not is_momod(msg) then
  tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.sticker_ and redis:get(hashsticker) == 'Enable' and not is_momod(msg) then
  tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.animation_ and redis:get(hashgif) == 'Enable' and not is_momod(msg) then
   tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.contact_ and redis:get(hashgif) == 'Enable' and not is_momod(msg) then
  tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.photo_ and redis:get(hashgif) == 'Enable' and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.audio_ and redis:get(hashaudio) == 'Enable' and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.voice_ and redis:get(hashvoice) == 'Enable' and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.video_ and redis:get(hashvideo) == 'Enable' and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.content_.document_ and redis:get(hashdocument) == 'Enable' and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.forward_info_ and redis:get(hashforward) == 'Enable' and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
if msg.via_bot_user_id_ ~= 0 and redis:get(hashinline) == 'Enable' and not is_momod(msg) then
  tdcli.deleteMessages(chat_id, {[0] = msg.id_})
end
-- Coded By saadmusic - [Channel : @kenamch] - [Telegarm : @saad7m]
local floodMax = redis:get('floodMax') or 10
local floodTime = redis:get('floodTime') or 150
if msg and redis:get(hashflood) == 'Enable' and not is_momod(msg) then
  local hash = 'flood:'..msg.sender_user_id_..':'..msg.chat_id_..':msg-num'
  local msgs = tonumber(redis:get(hash) or 0)
  if msgs > (floodMax - 1) then
    tdcli.changeChatMemberStatus(msg.chat_id_, msg.sender_user_id_, "Kicked")
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم _'..msg.sender_user_id_..' تم الطرد بسبب التكرار!', 1, 'md')
    redis:setex(hash, floodTime, msgs+1)
  end
end

-- Coded By saadmusic - [Channel : @kenamch] - [Telegarm : @saad7m]
if msg.content_.ID == "MessageText" then
  local is_link_msg = input:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or input:match("[Tt].[Mm][Ee]/")
  if redis:get(hashlink) and is_link_msg and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  end
  if redis:get(hashtag) and input:match("#") and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  end
  if redis:get(hashusername) and input:match("@") and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})

  end
  if redis:get(hasharabic) and input:match("[\216-\219][\128-\191]") and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  end
  local is_english_msg = input:match("[a-z]") or input:match("[A-Z]")
  if redis:get(hasheng) and msg.content_.text_ and is_english_msg and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  end
  local is_fosh_msg = input:match("عير") or input:match("كس") or input:match("منيوج") or input:match("85") or input:match("كحبه") or input:match("طيز") or input:match("ديوس") or input:match("فرخ") or input:match("كواد") or input:match("نيجه") or input:match("سکس") or input:match("kir") or input:match("kos") or input:match("kon") or input:match("nne") or input:match("nnt")
  if redis:get(hashbadword) and is_fosh_msg and not is_momod(msg) then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  end
  local is_emoji_msg = input:match("😀") or input:match("😬") or input:match("😁") or input:match("😂") or  input:match("😃") or input:match("😄") or input:match("😅") or input:match("☺️") or input:match("🙃") or input:match("🙂") or input:match("😊") or input:match("😉") or input:match("😇") or input:match("😆") or input:match("😋") or input:match("😌") or input:match("😍") or input:match("😘") or input:match("😗") or input:match("😙") or input:match("😚") or input:match("🤗") or input:match("😎") or input:match("🤓") or input:match("🤑") or input:match("😛") or input:match("😏") or input:match("😶") or input:match("😐") or input:match("😑") or input:match("😒") or input:match("🙄") or input:match("🤔") or input:match("😕") or input:match("😔") or input:match("😡") or input:match("😠") or input:match("😟") or input:match("😞") or input:match("😳") or input:match("🙁") or input:match("☹️") or input:match("😣") or input:match("😖") or input:match("😫") or input:match("😩") or input:match("😤") or input:match("😲") or input:match("😵") or input:match("😭") or input:match("😓") or input:match("😪") or input:match("😥") or input:match("😢") or input:match("🤐") or input:match("😷") or input:match("🤒") or input:match("🤕") or input:match("😴") or input:match("💋") or input:match("❤️")
  if redis:get(hashemoji) and is_emoji_msg and not is_momod(msg)  then
    tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  end
end
--###############################-- Coded By saadmusic - [Channel : @kenamch] - [Telegarm : @saad7m]
local text = msg.content_.text_
if text and text:match('[QWERTYUIOPASDFGHJKLZXCVBNM]') then
   text = text:lower()
 end
if msg.content_.ID == "MessageText" then
  msg_type = 'text'
  if msg_type == 'text' and text and text:match('^[/$#!]') then
    text = text:gsub('^[/$!#]','')
  end
end
if text == "p r" and is_sudo(msg) then
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*تم تنشيط البوت عزيزي*',1, 'html')
  io.popen("pkill tg")
end
    if text == "كينام" then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*  عود ها تفضل شرايد 🖕😑*',1, 'md')
  end
if text == "بوت" then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*  عود ها تفضل شرايد 🖕😑*',1, 'md')
  end
local hashadd = "addedgp"..chat_id
if text == "add" and is_sudo(msg) then
  if botgp then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*المجموعه مضافه بالفعل 😾👊*', 1, 'md')
  else
    redis:set(hashadd, true)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '* تم اضافة المجموعه 😸🙌️*', 1, 'md')
  end
end
if text == "rem" and is_sudo(msg) then
  if not botgp then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*المجموعة ليست مضافة!*', 1, 'md')
  else
    redis:del(hashadd, true)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '* تم ازلة المجموعة داحو 😂✋*', 1, 'md')
  end
end

if text == "setowner" and is_owner(msg) and msg.reply_to_message_id_ then
  function setowner_reply(extra, result, success)
    redis:del('owners:'..result.chat_id_)
    redis:set('owners:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم *'..result.sender_user_id_..'* الان مالك المجموعة', 1, 'md')
  end
  getMessage(chat_id,msg.reply_to_message_id_,setowner_reply,nil)
end
if text == "owners" then
  local hash = 'owners:'..chat_id
  local owner = redis:get(hash)
  if owner == nil then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'لا يوجد مشرفين حاليا ', 1, 'md')
  end
  local owner_list = redis:get('owners:'..chat_id)
  text = '* مالك المجموعة:* '..owner_list
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text and text:match('^setowner (.*)') and not text:find('@') and is_sudo(msg) then
  local so = {string.match(text, "^setowner (.*)$")}
  redis:del('owners:'..chat_id)
  redis:set('owners:'..chat_id,so[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..so[1]..' الان مالك المجموعة', 1, 'md')
end
if text and text:match('^setowner (.*)') and text:find('@') and is_owner(msg) then
  local sou = {string.match(text, "^setowner (.*)$")}
  function Inline_Callback_(arg, data)
    redis:del('owners:'..chat_id)
    redis:set('owners:'..chat_id,sou[1])
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..sou[1]..' الان مالك المجموعة', 1, 'md')
  end
  tdcli_function ({ID = "SearchPublicChat",username_ =sou[1]}, Inline_Callback_, nil)
end

 
if text == "promote" and is_sudo(msg) and msg.reply_to_message_id_ then
  function setmod_reply(extra, result, success)
    redis:sadd('mods:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..result.sender_user_id_..' تمت الترقيه', 1, 'md')
  end
 getMessage(chat_id,msg.reply_to_message_id_,setmod_reply,nil)
end
if text == "demote" and is_sudo(msg) and msg.reply_to_message_id_ then
  function remmod_reply(extra, result, success)
    redis:srem('mods:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..result.sender_user_id_..' لم يعد مدير', 1, 'md')
  end
  getMessage(chat_id,msg.reply_to_message_id_,remmod_reply,nil)
end
if text and text:match('^promote (.*)') and not text:find('@') and is_sudo(msg) then
  local pm = {string.match(text, "^promote (.*)$")}
  redis:sadd('mods:'..chat_id,pm[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..pm[1]..' تمت الترقيه', 1, 'md')
end
if text and text:match('^demote (.*)') and not text:find('@') and is_sudo(msg) then
  local dm = {string.match(text, "^demote (.*)$")}
  redis:srem('mods:'..chat_id,dm[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..dm[1]..' لم يعد مدير', 1, 'md')
end
if text == "modlist" then
  if redis:scard('mods:'..chat_id) == 0 then
   text = "المجموعة خاليه من المدراء !"
  else
  text = "قائمة المدراء\n"
  for k,v in pairs(redis:smembers('mods:'..chat_id)) do
    text = text.."<b>"..k.."</b> - <b>"..v.."</b>\n"
  end
end
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
--[[
if txet == "ban" and is_momod(msg) then
  function ban_reply(extra, result, success)
 redis:sadd('banned:'..result.chat_id_,result.sender_user_id_)
 tdcli.changeChatMemberStatus(result.chat_id_, result.sender_user_id_, 'Kicked')
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'کاربر '..result.sender_user_id_..' به لیست افراد بن شده اضافه شد', 1, 'md')
  end
getMessage(chat_id,reply,ban_reply,nil)
end
end
if text and text:match('^ban (.*)') and not text:find('@') and is_momod(msg) then
  local ki = {string.match(text, "^ban (.*)$")}
redis:sadd('banned:'..chat_id,ki[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'کاربر '..ki[1]..' به لیست افراد بن شده اضافه شد', 1, 'md')
  tdcli.changeChatMemberStatus(chat_id, ki[1], 'Kicked')
end
if text and text:match('^ban @(.*)') and is_momod(msg) then
  local ku = {string.match(text, "^ban @(.*)$")}
redis:sadd('banned:'..chat_id,ku[1])
  function Inline_Callback_(arg, data)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'کاربر '..ku[1]..' به ��یست افراد بن شده اضافه شد', 1, 'html')
    tdcli.changeChatMemberStatus(chat_id, data.id_, 'Kicked')
  end

if txet == "unban" and is_momod(msg) then
  function unban_reply(extra, result, success)
 redis:srem('banned:'..result.chat_id_,result.sender_user_id_)

    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'کاربر '..result.sender_user_id_..' از لیست افراد بن شده حذف شد', 1, 'md')
  end
  getMessage(chat_id,reply,unban_reply,nil)
end
if text and text:match('^unban (.*)') and not text:find('@') and is_momod(msg) then
  local ki = {string.match(text, "^unban (.*)$")}
redis:srem('banned:'..chat_id,ub[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'کاربر '..ub[1]..' از لیست افراد بن شده حذف شد', 1, 'md')
end
if text and text:match('^unban @(.*)') and is_momod(msg) then
  local ku = {string.match(text, "^unban @(.*)$")}
redis:srem('banned:'..chat_id,unb[1])
  function Inline_Callback_(arg, data)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'کاربر '..unb[1]..' از لیست افراد بن شده حذف شد', 1, 'html')
  end
  tdcli_function ({ID = "SearchPublicChat",username_ =unb[1]}, Inline_Callback_, nil)
end
]]--
if text == "banlist" then

  if redis:scard('banned:'..chat_id) == 0 then
   text = "قائمة المحضورين خاليه"
  else
  text = "قائمة المحضورين\n"
  for k,v in pairs(redis:smembers('banned:'..chat_id)) do
    text = text.."<b>"..k.."</b> - <b>"..v.."</b>\n"
  end
end
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
if text == "muteuser" and is_momod(msg) and msg.reply_to_message_id_ then
  function setmute_reply(extra, result, success)
    redis:sadd('muteusers:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..result.sender_user_id_..' تم الكتم', 1, 'md')
  end
getMessage(chat_id,msg.reply_to_message_id_,setmute_reply,nil)
end
if text == "unmuteuser" and is_momod(msg) and msg.reply_to_message_id_ then
  function demute_reply(extra, result, success)
    redis:srem('muteusers:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..result.sender_user_id_..' تم رفع الكتم عنه', 1, 'md')
  end
  getMessage(chat_id,msg.reply_to_message_id_,demute_reply,nil)
end
if text and text:match("^muteuser (%d+)") and is_momod(msg) then
  local mt = {string.match(text, "^muteuser (%d+)$")}
  redis:sadd('muteusers:'..chat_id,mt[1])
     tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..mt[1]..' تم الكتم', 1, 'md')
end
if text and text:match('^unmuteuser (%d+)$') and is_momod(msg) then
  local umt = {string.match(text, "^muteuser (%d+)$")}
  redis:srem('muteusers:'..chat_id,umt[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..umt[1]..' تم رفع الكتم عنه', 1, 'md')
end
if text == "mutelist" then
  if redis:scard('muteusers:'..chat_id) == 0 then
   text = "المجموعه خاليه من المكتومين"
  else
  text = "قائمة المكتومين\n"
  for k,v in pairs(redis:smembers('muteusers:'..chat_id)) do
    text = text.."<b>"..k.."</b> - <b>"..v.."</b>\n"
  end
end
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'html')
end
if text and text:match("^clean (.*)$") and is_momod(msg) then
  local txt = {string.match(text, "^(clean) (.*)$")}
  if txt[2] == 'banlist' then
    redis:del('banned:'..msg.chat_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم حذف قائمة المحضورين_', 1, 'md')
  end
  if txt[2] == 'modlist' then
    redis:del('mods:'..msg.chat_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم حذف جميع المدراء _', 1, 'md')
  end
  if txt[2] == 'mutelist' then
    redis:del('muted:'..msg.chat_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم حذف قائمة المكتومين_', 1, 'md')
  end

end
if text == "delall" and msg.reply_to_message_id_ then
  function delall(extra, result, success)
    tdcli.deleteMessagesFromUser(result.chat_id_, result.sender_user_id_)
  end
  getMessage(chat_id, msg.reply_to_message_id_, delall, nil)
end
if text and text:match('^setlink (.*)/joinchat/(.*)') and is_owner(msg) then
  local l = {string.match(text, '^setlink (.*)/joinchat/(.*)')}
  redis:set('gplink'..chat_id,"https://t.me/joinchat/"..l[2])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'تم حفظ رابط المجموعه عزيزي.', 1, 'html')
end
if text == "link"  and is_momod(msg) then
  local linkgp = redis:get('gplink'..chat_id)
  if not linkgp then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '<code>لم يتم تعيين رابط للمجموعه.</code>\n<code>عليك ارسال رابط جديد مع الامر</code>\n<b>/setlink</b> <i>و الرابط</i>', 1, 'html')
    return
  else
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '<b>رابط المجموعة :</b>\n'..linkgp, 1, 'html')
  end
end
if text and text:match('^setrules (.*)') and is_owner(msg) then redis:set('gprules'..chat_id,text:match('^setrules (.*)'))
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*تم وضع القوانين عزيزي*', 1, 'md')
end
if text == "rules" then
  rules = redis:get('gprules'..chat_id)
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '<b>قوانین المجموعة :</b>\n'..rules, 1, 'html')
end
if text and text:match('^setname (.*)$')  and is_momod(msg)  then
  local matches = {string.match(text, '^setname (.*)$')}
  tdcli.changeChatTitle(chat_id, matches[1])
end
if text == "leave" and is_sudo(msg) then
  function botid(a,b,c)
    tdcli.changeChatMemberStatus(chat_id, b.id_, "Left")
  end
  tdcli.getMe(botid, nil)
end
if text == "settings" and is_momod(msg)  then
  local text = "————————\n_📛اعدادات المجموعة📛_ \n————————\n◾️قفل الروابط : "..(redis:get(hashlink) or "Disabled").."\n◾️️قفل‌التكرار :  "..(redis:get(hashflood) or "Disabled").."\n◾️قفل‌التوجيه :  "..(redis:get(hashforward) or "Disabled").."\n◾️قفل‌التاك(#) "..(redis:get(hashtag) or "Disabled").."\n◾️قفل‌یوزرنیم(@) : "..(redis:get(hashusername) or "Disabled").."\n◾️قفل‌البوتات : "..(redis:get(hashbot) or "Disabled").."\n◾️قفل‌الدخول والخروج "..(redis:get(hashtgservice) or "Disabled").."\n◾️قفل‌عربی/فارسي : "..(redis:get(hasharabic) or "Disabled").."\n◾️قفل‌انگلش : "..(redis:get(hasheng) or "Disabled").."\n" 
  text = text.."◾️️قفل‌الفواحش : "..(redis:get(hashbadword) or "Disabled").."\n◾️قفل‌الجهات :  "..(redis:get(hashcontact) or "Disabled").."\n◾️قفل‌الملسقات :  "..(redis:get(hashsticker) or "Disabled").."\n" 
  text = text.."◾️قفل‌کیبورد‌انلاین : "..(redis:get(hashinline) or "Disabled").."\n◾️قفل‌ایموجي : "..(redis:get(hashemoji) or "Disabled").."\n" 
  text = text.."————————\n_📛قائمة المنع📛_\n————————\n◾️الصور المتحركه : "..(redis:get(hashgif) or "Disabled").."\n◾️قفل الصور : "..(redis:get(hashphoto) or "Disabled").."\n◾️قفل الصوت : "..(redis:get(hashaudio) or "Disabled").."\n" 
  text = text.."◾️قفل البصمات : "..(redis:get(hashvoice) or "Disabled").."\n◾️قفل الفديو : "..(redis:get(hashvideo) or "Disabled").."\n◾️قفل الملفات : "..(redis:get(hashdocument) or "Disabled").."\n◾️قفل الكتابه : "..(redis:get(hashtext1) or "Disabled").."\n"
     text = text.."————————\n_📛اعدادات اخرى📛_\n————————\n◾️زمن كتم التكرار : *"..floodTime.."*\n◾️عدد التكرار : *"..floodMax.."*\n\nقناة البوت : @kenamch"
        text = string.gsub(text, "Enable", "✅")
        text = string.gsub(text, "Disabled", "⛔️")
        text = string.gsub(text, ":", "*>*")
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "lock flood" and is_momod(msg) then
if redis:get(hashflood) == "Enable" then
  local text = "✔️التكرار بالفعل مقفل✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashflood ,"Enable")
  local text = "*✔️تم قفل التكرار✔️*"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock flood"  and is_momod(msg) then
if not redis:get(hashflood) == "Enable" then
  local text = "✔️التكرار بالفعل مفتوح✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashflood)
  local text = "✔️تم فتح التكرار✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock bots" and is_momod(msg) then
if redis:get(hashbot) == "Enable" then
  local text = "✔️البوتات مقفوله بالفعل✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashbot ,"Enable")
  local text = "✔️تم قفل البوتات✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock bots"  and is_momod(msg) then
if not redis:get(hashbot) == "Enable" then
  local text = "✔️اضافة البوتات غير مقفله✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashbot)
  local text = "✔️تم فتح اضافة البوتات✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock tgservice" and is_momod(msg) then
if redis:get(hashtgservice) == "Enable" then
  local text = "الدخول والخروج مقفل بالفعل"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashtgservice ,"Enable")
  local text = "✔️تم قفل الدخول والخروج✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock tgservice"  and is_momod(msg) then
if not redis:get(hashtgservice) == "Enable" then
  local text = "✔️الدخول والخروج مفتوح بالفعل✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashtgservice)
  local text = "✔️تم فتح الدخول والخروج✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "اقفل الروابط" and is_momod(msg)  then
if redis:get(hashlink) == "Enable" then
local text = "  وروح خالتي قافلن لتلح ☹️🖖"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashlink ,"Enable")
  local text = "  عود قفلتهن تريد شي بعد🙁"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "افتح الروابط" and is_momod(msg)  then
if not redis:get(hashlink) == "Enable" then
local text = "✔️الروابط بالفعل مفتوحه✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashlink)
  local text = " فتحتهن راح يطيح حظك👆😹"
   tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock tag" and is_momod(msg)  then
if redis:get(hashtag) == "Enable" then
local text = "✔️التاك[#]بالفعل مقفل✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashtag ,"Enable")
  local text = "✔️تم قفل[#]التاك✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock tag"  and is_momod(msg) then
if not redis:get(hashtag) == "Enable" then
local text = "✔️التاك[#]بالفعل مفتوح️✔️️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashtag)
    local text = "✔️تم فتح[#]التاك ✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock username" and is_momod(msg)  then
if redis:get(hashusername) == "Enable" then
local text = "✔️ال(@)معرف بالفعل مقفل✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashusername ,"Enable")
  local text = "✔️تم قفل ال(@)معرف✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock username" and is_momod(msg)  then
if not redis:get(hashusername) == "Enable" then
local text = "✔️ال(@)معرف بالفعل مفتوح✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashusername)
  local text = "✔️تم فتح ال(@)معرف✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "اقفل التوجيه"  and is_momod(msg) then
if redis:get(hashforward) == "Enable" then
local text = "التوجيه مقفول لتلح ☹️🖐"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashforward ,"Enable")
  local text = "تم قفل التوجيه 🖕😉"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "افتح التوجيه" and is_momod(msg)  then
if not redis:get(hashforward) == "Enable" then
local text = "✔️اعادة التوجيه مفتوح✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashforward)
  local text = "انفتح راح تاكل اعوج😹"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock arabic"  and is_momod(msg) then
if redis:get(hasharabic) == "Enable" then
local text = "✔️العربية بالفعل مقفله✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hasharabic ,"Enable")
  local text = "✔️تم قفل اللغه العربيه✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock arabic"  and is_momod(msg) then
if not redis:get(hasharabic) == "Enable" then
local text = "العربيه ليست مقفله"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hasharabic)
  local text = "✔️تم فتح اللغه العربيه✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock english"  and is_momod(msg) then
if redis:get(hasheng) == "Enable" then
local text = "✔️الانكلش بالفعل مقفل✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hasheng ,"Enable")
  local text = "✔️تم قفل الانكلش✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock english"  and is_momod(msg) then
if not redis:get(hasheng) == "Enable" then
local text = "✔️الانكلش بالفعل مفتوح✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hasheng)
  local text = "✔️تم فتح الانكلش✔️"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "lock fosh"  and is_momod(msg) then
if redis:get(hashbadword) == "Enable" then
local text = "✔️قفل الفواحش مفعل✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashbadword ,"Enable")
  local text = "✔️تم قفل الفواحش✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "افتح الفواحش" and is_momod(msg)  then
if not redis:get(hashbadword) == "Enable" then
local text = "✔️الفواحش غير مقفوله✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashbadword)
  local text = "✔️تم فتح الفواحش✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock inline" and is_momod(msg)  then
if redis:get(hashinline) == "Enable" then
local text = "✔️الاعلانات الشفافه مقفوله✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashinline ,"Enable")
  local text = "✔️تم قفل الاعلانات الشفافه✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock inline" and is_momod(msg)  then
if not redis:get(hashinline) == "Enable" then
local text = "✔️الاعلانات الشفافه مفتوحه✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashinline)
  local text = "✔️تم فتح الاعلانات الشفافه✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock emoji" and is_momod(msg)  then
if redis:get(hashemoji) == "Enable" then
local text = "قفل ایموجي (😄) مفعل"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashemoji ,"Enable")
  local text = "تم قفل (😄) الايموجي"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "unlock emoji" and is_momod(msg)  then
if not redis:get(hashemoji) == "Enable" then
local text = "قفل الايموجي (😄) غير مفعل"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashemoji)
  local text = "تم فتح (😄) الايموجي"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock contact" and is_momod(msg)  then
if redis:get(hashcontact) == "Enable" then
local text = "✔️الجهات مقفوله بالفعل✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashcontact ,"Enable")
  local text = "✔️تم قفل جهات الاتصال✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock contact" and is_momod(msg)  then
if not redis:get(hashcontact) == "Enable" then
local text = "✔️الجهات بالفعل مفتوحه✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashcontact)
  local text = "✔️تم فتح مشاركة الجهات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "lock sticker" and is_momod(msg)  then
if redis:get(hashcontact) == "Enable" then
local text = "✔️الملسقات مقفوله بالفعل✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashsticker ,"Enable")
  local text = "✔️تم قفل الملسقات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if text == "unlock sticker" and is_momod(msg)  then
if not redis:get(hashcontact) == "Enable" then
local text = "✔️الملسقات ليست مقفوله✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashsticker)
  local text = "✔️تم فتح الملسقات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if text == "mute gif" and is_momod(msg)  then
  redis:set(hashgif ,"Enable")
  local text = "✔️تم قفل الصور المتحركه✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute gif"  and is_momod(msg) then
  redis:del(hashgif)
  local text = "✔️تم فتح الصور المتحركه✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "mute photo"  and is_momod(msg) then
  redis:set(hashphoto ,"Enable")
  local text = "✔️تم قفل ارسال الصور✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute photo"  and is_momod(msg) then
  redis:del(hashphoto)
  local text = "✔️تم فتح ارسال الصور✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "mute audio"  and is_momod(msg) then
  redis:set(hashaudio ,"Enable")
    local text = "✔️تم قفل الاصوات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute audio"  and is_momod(msg) then
  redis:del(hashaudio)
  local text = "✔️تم فتح الاصوات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "mute voice" and is_momod(msg)  then
  redis:set(hashvoice ,"Enable")
  local text = "✔️تم قفل البصمات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute voice" and is_momod(msg)  then
  redis:del(hashvoice)
  local text = "✔️تم فتح البصمات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "mute video" and is_momod(msg)  then
  redis:set(hashvideo ,"Enable")
  local text = "✔️تم قفل الفديو✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute video" and is_momod(msg)  then
  redis:del(hashvideo)
  local text = "✔️تم فتح الفديو✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "mute document" and is_momod(msg)  then
  redis:set(hashdocument ,"Enable")
  local text = "✔️تم قفل الملفات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute document" and is_momod(msg)  then

  redis:del(hashdocument)
  local text = "✔️تم فتح الملفات✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "mute text" and is_momod(msg)  then
  redis:set(hashtext1 ,"Enable")
  local text = "✔️تم قفل النصوص✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == "unmute text" and is_momod(msg)  then
  redis:del(hashtext1)
  local text = "✔️تم فتح النصوص✔"
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if text == 'pin' and is_momod(msg)  then
  tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
end
if text == "unpin" and is_momod(msg)  then
  tdcli.unpinChannelMessage(chat_id, 1)
end
if text == "help"  and is_momod(msg) then
help = [[
💠 kenam-bot Help 💠
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🔹!setname {لوضع أسم }
🔹!setphoto {لوضع صورة }
🔹!setrules {لوضع قوانين }
🔹!setabout {لوضع وصف }
🔹!promote {لرفع ادمن}
🔹!demote {لإنزال ادمن}
🔹!link {لأضهار الرابط }
🔹!newlink {رابط جديد}
🔹!setlink {عمل رابط يدوي} 
🔹!kick {لطرد عضو}
🔹!ban {لحظر عضو}

🔐 أوامر القفل 🔐
🔒!lock member {قفل الأضافة}
🔓!unlock member {السماح بالأضافة}
🔒!lock links {قفل الروابط}
🔓!unlock links {السماح بالروابط}
🔒!lock spam {قفل الرسائل الطويلة}
🔓!unlock spam {السماح بالرسائل الطويلة}
🔒!lock arabic {قفل التكلم باللغة العربية}
🔓!unlock arabic {السماح بالتكلم باللغة العربية}
🔒!lock sticker {قفل الملصقات} 
🔓!unlock sticker {السماح بالملصقات}
🔒!lock contacts {قفل جهات الإتصال}
🔓!unlock contacts {السماح بجهات الإتصال}
🔒!lock flood {قفل التكرار}
🔅!setflood + عدد تكرار الرسائل
🔓!unlock flood {السماح بالتكرار}
🔒!lock forwerd {قفل إعادة التوجيه}
🔓!unlock forwerd {فتح إعادة التوجيه}
⛔️!fiter + الكلمة المراد حظرها
✅unfiter+ فتح الكلمة المحظورة
🗑!del{لحذف رسالة بالرد}

🔕اوامر الكتم🔕
🔕!mute gifs {كتم الصور المتحركة}
🔔!unmute gifs{إلغاء الكتم عن الصور المتحركة}
🔕!mute audio {كتم إرسال الصوتيات}
🔔!unmute audio {إلغاء الكتم عن الصوتيات}  
🔕!mute video {كتم إرسال الفديوات} 
🔔!unmite video {إلغاء الكتم عن الفديوات}
🔕!mute all {كتم المحادثة}
🔔!unmute all {إلغاء الكتم عن المحادثة}
🔕!muteuser {لكتم العضو}
🔔!clean mutelist {إلغاء الكتم عن الاعضاء}
🔕!mute photo { لكتم إرسال الصور}
🔔!unmute photo {إلغاء الكتم عن الصور}

🚩أوامر عامة🚩
🔸!rules {لإظهار قوانين المجموعة}
🔸!about {لإظهار وصف المجموعة }
🔸!modlist {لأضهار قائمة الأدمنية }
🔸!kickme {للخروج من المجموعة}
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🌐 @saad7m  🌐 ;) مطور البوت
🌐 @kenamch 🌐 ;)  قناة البوت
]]
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, help, 1, 'md')
end
if text == "del" and is_momod(msg)  then
  tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  tdcli.deleteMessages(chat_id,{[0] = reply_id})
end
if text == "gpinfo" and is_momod(msg)  then
  function info(arg,data)
    -- vardump(data)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1,  "📢*معلومات saad7m المجموعه*📢\n👲_تعداد الادمن :_ *"..data.administrator_count_.."*\n👥_عدد الاعضاء:_ *"..data.member_count_.."*\n👿_عدد المطرودين :_ *"..data.kicked_count_.."*\n🆔_ايدي المجموعه :_ *"..data.channel_.id_.."*\n\n📢قناة البوت : @kenamch", 1, 'md')
  end
  tdcli.getChannelFull(chat_id, info, nil)
end
if text and text:match("^getpro (.*)$") then
  profilematches = {string.match(text, "^getpro (.*)$")}
  local function dl_photo(arg,data)
    tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_, nil)
  end
  tdcli.getUserProfilePhotos(user_id, profilematches[1] - 1, profilematches[1], dl_photo, nil)
end
if text and text:match('^setfloodtime (.*)$') and is_owner(msg) then
 redis:set('floodTime',text:match('setfloodtime (.*)'))
          tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم ضبط زمن كتم التكرار على_ : *'..text:match('setfloodtime (.*)')..'*', 1, 'md')
        end
if text and text:match('^setflood (.*)$') and is_owner(msg) then
    redis:set('floodMax',text:match('setflood (.*)'))
          tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم ضبط عدد التكرارالى_ : *'..text:match('setflood (.*)')..'*', 1, 'md')
        end
if text == "id" then
  function dl_photo(arg,data)
    local text = 'ایدي المجموعه : ['..msg.chat_id_:gsub('-100','').."]\nایدي المستخدم  : ["..msg.sender_user_id_.."]\nتعداد الصور : ["..data.total_count_.."]\nقناة البوت : @kenamch"
    tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_, text)
  end
  tdcli.getUserProfilePhotos(user_id, 0, 1, dl_photo, nil)
end
end
function tdcli_update_callback(data)
if (data.ID == "UpdateNewMessage") then
  run(data)
elseif data.ID == "UpdateMessageEdited" then
  local function edited_cb(arg, data)
    run(data,true)
  end
  getMessage(data.chat_id_, data.message_id_, edited_cb, nil)
elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({ID="GetChats", offset_order_="9223372036854775807", offset_chat_id_=0, limit_=20}, dl_cb, nil)    
  end
end