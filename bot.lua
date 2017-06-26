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
chats = {}
day = 86400
--###############################--
sudo_users = {30742221,0} --- ايدي المطورين

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
if text == "rel" and is_sudo(msg) then
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*تم تنشيط البوت عزيزي*',1, 'html')
  io.popen("pkill tg")
end
if text == "بوت" or text == "كينام" then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*  عود ها تفضل شرايد 🖕😑*',1, 'md')
  end
 --------------------
local hashadd = "addedgp"..chat_id
if (text == "add" or text == "تفعيل") and is_sudo(msg) then
  if botgp then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*المجموعه مضافه بالفعل 😾👊*', 1, 'md')
  else
    redis:set(hashadd, true)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '* تم اضافة المجموعه 😸🙌️*', 1, 'md')
  end
end
if (text == "rem" or text == "تعطيل") and is_sudo(msg) then
  if not botgp then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '*المجموعة ليست مضافة!*', 1, 'md')
  else
    redis:del(hashadd, true)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '* تم ازلة المجموعة داحو 😂✋*', 1, 'md')
  end
end

if (text == "setowner" or text == "رفع مشرف") and is_sudo(msg) and msg.reply_to_message_id_ then
  function setowner_reply(extra, result, success)
    redis:del('owners:'..result.chat_id_)
    redis:set('owners:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم *'..result.sender_user_id_..'* الان مالك المجموعة', 1, 'md')
  end
  getMessage(chat_id,msg.reply_to_message_id_,setowner_reply,nil)
end
if text == "owners" or text == "المشرف" then
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

 
if (text == "promote" or text == "رفع مدير") and is_owner(msg)and msg.reply_to_message_id_ then
  function setmod_reply(extra, result, success)
    redis:sadd('mods:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..result.sender_user_id_..' تمت الترقيه', 1, 'md')
  end
 getMessage(chat_id,msg.reply_to_message_id_,setmod_reply,nil)
end
if (text == "demote" or text == "حذف مدير") and is_owner(msg) and msg.reply_to_message_id_ then
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
if text == "modlist" or text == "المدراء" then
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
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم'..result.sender_user_id_..' تم الحضر', 1, 'md')
  end
getMessage(chat_id,reply,ban_reply,nil)
end
end
if text and text:match('^ban (.*)') and not text:find('@') and is_momod(msg) then
  local ki = {string.match(text, "^ban (.*)$")}
redis:sadd('banned:'..chat_id,ki[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..ki[1]..' تم الحضر', 1, 'md')
  tdcli.changeChatMemberStatus(chat_id, ki[1], 'Kicked')
end
if text and text:match('^ban @(.*)') and is_momod(msg) then
  local ku = {string.match(text, "^ban @(.*)$")}
redis:sadd('banned:'..chat_id,ku[1])
  function Inline_Callback_(arg, data)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم'..ku[1]..' تم الحضر', 1, 'html')
    tdcli.changeChatMemberStatus(chat_id, data.id_, 'Kicked')
  end

if txet == "unban" and is_momod(msg) then
  function unban_reply(extra, result, success)
 redis:srem('banned:'..result.chat_id_,result.sender_user_id_)

    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم'..result.sender_user_id_..' تم رفع الحضر عنه', 1, 'md')
  end
  getMessage(chat_id,reply,unban_reply,nil)
end
if text and text:match('^unban (.*)') and not text:find('@') and is_momod(msg) then
  local ki = {string.match(text, "^unban (.*)$")}
redis:srem('banned:'..chat_id,ub[1])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم'..ub[1]..' تم رفع الحضر عنه', 1, 'md')
end
if text and text:match('^unban @(.*)') and is_momod(msg) then
  local ku = {string.match(text, "^unban @(.*)$")}
redis:srem('banned:'..chat_id,unb[1])
  function Inline_Callback_(arg, data)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم'..unb[1]..' تم رفع الحضر عنه', 1, 'html')
  end
  tdcli_function ({ID = "SearchPublicChat",username_ =unb[1]}, Inline_Callback_, nil)
end
]]--
if text == "banlist" or text == "المحضورين" then

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
if (text == "muteuser" or text == "كتم") and is_momod(msg) and msg.reply_to_message_id_ then
  function setmute_reply(extra, result, success)
    redis:sadd('muteusers:'..result.chat_id_,result.sender_user_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'المستخدم '..result.sender_user_id_..' تم الكتم', 1, 'md')
  end
getMessage(chat_id,msg.reply_to_message_id_,setmute_reply,nil)
end
if (text == "unmuteuser" or text == "الغاء كتم") and is_momod(msg) and msg.reply_to_message_id_ then
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
if text == "mutelist" or text == "المكتومين" then
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
  if txt[2] == 'banlist' or txt[2] == 'المحضورين' then
    redis:del('banned:'..msg.chat_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم حذف قائمة المحضورين_', 1, 'md')
  end
  if txt[2] == 'modlist' or text == "المدراء" then
    redis:del('mods:'..msg.chat_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم حذف جميع المدراء _', 1, 'md')
  end
  if txt[2] == 'mutelist' or text == "المكتومين" then
    redis:del('muted:'..msg.chat_id_)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '_تم حذف قائمة المكتومين_', 1, 'md')
end

end
if (text == "delall" or text == "مسح الكل") and msg.reply_to_message_id_ then
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
---------------------
if text and text:match('^ضع رابط (.*)/joinchat/(.*)') and is_owner(msg) then
  local l = {string.match(text, '^ضع رابط (.*)/joinchat/(.*)')}
  redis:set('gplink'..chat_id,"https://t.me/joinchat/"..l[2])
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'تم حفظ رابط المجموعه عزيزي.', 1, 'html')
end
if (text == "link"or text == "الرابط" )and is_momod(msg) then
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
if text == "rules" or text == "القوانين" then
  rules = redis:get('gprules'..chat_id)
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, '<b>قوانین المجموعة :</b>\n'..rules, 1, 'html')
end
if text and text:match('^setname (.*)$')  and is_momod(msg)  then
  local matches = {string.match(text, '^setname (.*)$')}
  tdcli.changeChatTitle(chat_id, matches[1])
end
if (text == "leave" or text == "غادر" )and is_sudo(msg) then
  function botid(a,b,c)
    tdcli.changeChatMemberStatus(chat_id, b.id_, "Left")
  end
  tdcli.getMe(botid, nil)
end
if (text == "settings" or text == "اعدادات" )and is_momod(msg)  then
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
if (text == "lock flood" or text == "قفل التكرار" )and is_momod(msg) then
if redis:get(hashflood) == "Enable" then
  local text = "✔️التكرار بالفعل مقفل✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashflood ,"Enable")
  local text = "*✔️تم قفل التكرار✔️*\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock flood" or text == "فتح التكرار" )and is_momod(msg) then
if not redis:get(hashflood) == "Enable" then
  local text = "✔️التكرار بالفعل مفتوح✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashflood)
  local text = "✔️تم فتح التكرار✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock bots" or text == "قفل البوتات" )and is_momod(msg) then
if redis:get(hashbot) == "Enable" then
  local text =  "✔️البوتات مقفوله بالفعل✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashbot ,"Enable")
  local text = "✔️تم قفل البوتات✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock bots" or text == "فتح البوتات" )and is_momod(msg) then
if not redis:get(hashbot) == "Enable" then
  local text = "✔️اضافة البوتات غير مقفله✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashbot)
  local text = "✔️تم فتح اضافة البوتات✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock tgservice" or text == "قفل الاضافه") and is_momod(msg) then
if redis:get(hashtgservice) == "Enable" then
  local text = "الدخول والخروج مقفل بالفعل\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashtgservice ,"Enable")
  local text = "✔️تم قفل الدخول والخروج✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock tgservice" or text == "فتح الاضافه" )and is_momod(msg) then
if not redis:get(hashtgservice) == "Enable" then
  local text = "✔️الدخول والخروج مفتوح بالفعل✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashtgservice)
  local text = "✔️تم فتح الدخول والخروج✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock links" or text == "قفل الروابط" )and is_momod(msg)  then
if redis:get(hashlink) == "Enable" then
local text = "  وروح خالتي قافلن لتلح ☹️🖖\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashlink ,"Enable")
  local text = "  عود قفلتهن تريد شي بعد🙁\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock links" or text == "فتح الروابط" )and is_momod(msg)  then
if not redis:get(hashlink) == "Enable" then
local text = "✔️الروابط بالفعل مفتوحه✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashlink)
  local text = " فتحتهن راح يطيح حظك👆😹\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
   tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock tag"or text == "قفل التاك" )and is_momod(msg)  then
if redis:get(hashtag) == "Enable" then
local text = "✔️التاك[#]بالفعل مقفل✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashtag ,"Enable")
  local text = "✔️تم قفل[#]التاك✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock tag" or text == "فتح التاك" )and is_momod(msg) then
if not redis:get(hashtag) == "Enable" then
local text = "✔️التاك[#]بالفعل مفتوح️✔️️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashtag)
    local text = "✔️تم فتح[#]التاك ✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock username" or text == "قفل المعرف" )and is_momod(msg)  then
if redis:get(hashusername) == "Enable" then
local text = "✔️ال(@)معرف بالفعل مقفل✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashusername ,"Enable")
  local text = "✔️تم قفل ال(@)معرف✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock username" or text == "فتح المعرف" )and is_momod(msg)  then
if not redis:get(hashusername) == "Enable" then
local text = "✔ال(@)معرف بالفعل مفتوح✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashusername)
  local text = "✔️تم فتح ال(@)معرف✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock fwd"or text == "قفل التوجيه" ) and is_momod(msg) then
if redis:get(hashforward) == "Enable" then
local text = "التوجيه مقفول لتلح ☹️🖐\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashforward ,"Enable")
  local text = "تم قفل التوجيه 🖕😉\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock fwd" or text == "فتح التوجيه" )and is_momod(msg)  then
if not redis:get(hashforward) == "Enable" then
local text = "✔️اعادة التوجيه مفتوح✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashforward)
  local text = "انفتح راح تاكل اعوج😹\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock arabic" or text == "قفل العربيه" ) and is_momod(msg) then
if redis:get(hasharabic) == "Enable" then
local text = "✔️العربية بالفعل مقفله✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hasharabic ,"Enable")
  local text = "✔️تم قفل اللغه العربيه✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock arabic" or text == "فتح العربيه" )and is_momod(msg) then
if not redis:get(hasharabic) == "Enable" then
local text = "العربيه ليست مقفله\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hasharabic)
  local text = "✔️تم فتح اللغه العربيه✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock english" or text == "قفل الانكلش")  and is_momod(msg) then
if redis:get(hasheng) == "Enable" then
local text = "✔️الانكلش بالفعل مقفل✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hasheng ,"Enable")
  local text = "✔️تم قفل الانكلش✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock english" or text == "فتح الانكلش")  and is_momod(msg) then
if not redis:get(hasheng) == "Enable" then
local text = "✔️الانكلش بالفعل مفتوح✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hasheng)
  local text = "✔️تم فتح الانكلش✔️\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "lock fosh" or text == "قفل الفواحش" )and is_momod(msg) then
if redis:get(hashbadword) == "Enable" then
local text = "✔️قفل الفواحش مفعل✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashbadword ,"Enable")
  local text = "✔️تم قفل الفواحش✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock fosh" or text == "فتح الفواحش" )and is_momod(msg)  then
if not redis:get(hashbadword) == "Enable" then
local text = "✔️الفواحش غير مقفوله✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashbadword)
  local text = "✔️تم فتح الفواحش✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock inline" or text == "قفل الشفافه" )and is_momod(msg)  then
if redis:get(hashinline) == "Enable" then
local text = "✔️الاعلانات الشفافه مقفوله✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashinline ,"Enable")
  local text = "✔️تم قفل الاعلانات الشفافه✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock inline" or text == "فتح الشفافه" )and is_momod(msg)  then
if not redis:get(hashinline) == "Enable" then
local text = "✔️الاعلانات الشفافه مفتوحه✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashinline)
  local text = "✔️تم فتح الاعلانات الشفافه✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock emoji" or text == "قفل السمايل" )and is_momod(msg)  then
if redis:get(hashemoji) == "Enable" then
local text = "قفل ایموجي (😄) مفعل\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashemoji ,"Enable")
  local text = "تم قفل (😄) الايموجي\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "unlock emoji" or text == "فتح السمايل" )and is_momod(msg)  then
if not redis:get(hashemoji) == "Enable" then
local text = "قفل الايموجي (😄) غير مفعل\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashemoji)
  local text = "تم فتح (😄) الايموجي\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock contact" or text == "قفل الجهات" )and is_momod(msg)  then
if redis:get(hashcontact) == "Enable" then
local text = "✔️الجهات مقفوله بالفعل✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashcontact ,"Enable")
  local text = "✔️تم قفل جهات الاتصال✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock contact" or text == "فتح الجهات" )and is_momod(msg)  then
if not redis:get(hashcontact) == "Enable" then
local text = "✔️الجهات بالفعل مفتوحه✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashcontact)
  local text = "✔️تم فتح مشاركة الجهات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end

if (text == "lock sticker" or text == "قفل الملسقات" )and is_momod(msg)  then
if redis:get(hashcontact) == "Enable" then
local text = "✔️الملسقات مقفوله بالفعل✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:set(hashsticker ,"Enable")
  local text = "✔️تم قفل الملسقات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
if (text == "unlock sticker" or text == "فتح الملسقات" )and is_momod(msg)  then
if not redis:get(hashcontact) == "Enable" then
local text = "✔️الملسقات ليست مقفوله✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
else
  redis:del(hashsticker)
  local text = "✔️تم فتح الملسقات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
end
--------Coded By saadmusic - [Channel : @kenamch] - [Telegarm : @saad7m]
if (text == "lock gif" or text == "قفل المتحركه" )and is_momod(msg)  then
  redis:set(hashgif ,"Enable")
  local text = "✔️تم قفل الصور المتحركه✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock gif" or text == "فتح المتحركه" ) and is_momod(msg) then
  redis:del(hashgif)
  local text = "✔️تم فتح الصور المتحركه✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "lock photo" or text == "قفل الصور" ) and is_momod(msg) then
  redis:set(hashphoto ,"Enable")
  local text = "✔️تم قفل ارسال الصور✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock photo" or text == "فتح الصور" ) and is_momod(msg) then
  redis:del(hashphoto)
  local text = "✔️تم فتح ارسال الصور✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "lock audio" or text == "قفل الصوت" ) and is_momod(msg) then
  redis:set(hashaudio ,"Enable")
    local text = "✔️تم قفل الاصوات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock audio" or text == "فتح الصوت" ) and is_momod(msg) then
  redis:del(hashaudio)
  local text = "✔️تم فتح الاصوات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "lock voice" or text == "قفل البصمات" )and is_momod(msg)  then
  redis:set(hashvoice ,"Enable")
  local text = "✔️تم قفل البصمات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock voice" or text == "فتح البصمات" )and is_momod(msg)  then
  redis:del(hashvoice)
  local text = "✔️تم فتح البصمات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "lock video" or text == "قفل الفديو" )and is_momod(msg)  then
  redis:set(hashvideo ,"Enable")
  local text = "✔️تم قفل الفديو✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock video" or text == "فتح الفديو" )and is_momod(msg)  then
  redis:del(hashvideo)
  local text = "✔️تم فتح الفديو✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "lock document" or text == "قفل الملفات" )and is_momod(msg)  then
  redis:set(hashdocument ,"Enable")
  local text = "✔️تم قفل الملفات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock document" or text == "فتح الملفات" )and is_momod(msg)  then

  redis:del(hashdocument)
  local text = "✔️تم فتح الملفات✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "lock text" or text == "قفل النص" )and is_momod(msg)  then
  redis:set(hashtext1 ,"Enable")
  local text = "✔️تم قفل النصوص✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
if (text == "unlock text" or text == "فتح النص" )and is_momod(msg)  then
  redis:del(hashtext1)
  local text = "✔️تم فتح النصوص✔\n\n*OяƊєя Ɓу : *"..msg.sender_user_id_
  tdcli.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, 'md')
end
-------------saad7m
if (text == 'pin' or text == "تثبيت") and is_momod(msg)  then
  tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
end
if (text == "unpin" or text == "الغاء تثبيت" )and is_momod(msg)  then
  tdcli.unpinChannelMessage(chat_id, 1)
end
---------------------------------------HELP----------------
if (text == "help" or text == "مساعده" or text == "الاوامر") and is_momod(msg) then
local saad = [[
💠 kenam-plus Help 💠
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🔶 `!mod help`
⚙️》`اوامر الادمن`
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🔷 `!lock1`
⚙️》`قفل1`
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🔶 `!lock2`
⚙️》`قفل2`
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🔷 `!sudo help`
⚙️》`اوامر المطور`
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
‼ ملاحضه ‼ 
الاوامر وقوائم المساعدة تعمل باللغه الانكلش والعربية👇
ويمكنك نسخ الامر بمجرد اللمس عليه 👆🏻

 قفل-1-2   👉👈  lock1-2
︻︻︻︻︻︻︻︻︻︻︻︻︻︻
🌐 @saad7m  🌐 ;) مطور البوت
🌐 @kenamch 🌐 ;)  قناة البوت
]]
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
---------------------
if (text == "lock1" or text == "قفل1") and is_momod(msg) then
local saad = [[
🔐قفل1🔛lock1!🔐
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔸قفل الروابط
🔸فتح الروابط
🔹lock links
🔸unlock links
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔸قفل الصوت
🔸فتح الصوت 
🔹lock links
🔸unlock links
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹قفل التاك
🔸فتح التاك
🔹lock tag
🔸unlock tag
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔸قفل السمايل
🔸فتح السمايل
🔹 lock emoji
🔸 unlock emoji
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔸قفل الفواحش
🔸فتح الفواحش
🔹 lock fosh
🔸 unlock fosh
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹قفل العربيه
🔸فتح العربيه
🔹lock arabic
🔸unlock arabic
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹قفل البوتات
🔸فتح البوتات
🔹lock bots
🔸unlock bots
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹قفل التكرار
🔸فتح التكرار
🔹lock flood
🔸unlock flood
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄ 
🌐 @saad7m  🌐 ;) مطور البوت
🌐 @kenamch 🌐 ;)  قناة البوت
]]
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
--------------------
if (text == "lock2" or text == "قفل2") and is_momod(msg) then
local saad = [[
🔐قفل2🔛lock2!🔐
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل المتحركه
🔸 فتح المتحركه
🔹 !lock gif
🔸 !unlock gif
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل الصور
🔸 فتح الصور
 🔹 !lock photo
🔸  !unlock photo
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل الملفات
🔸 فتح الملفات
🔹 !lock document 
🔸 !unlock document
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل الملسقات
🔸 فتح الملسقات
🔹  !lock sticker
🔸 !unlock sticker
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل الفديو
🔸 فتح الفديو
🔹 !lock video
🔸 !unlock video
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل النص
🔸 فتح النص
🔹 !lock text
🔸 !unlock text
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل التوجيه
🔸 فتح التوجيه
🔹  !lock fwd
🔸  !unlock fwd
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل البصمات
🔸 فتح البصمات
🔹  !lock voice
🔸 !unlock voice
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹 قفل الجهات
🔸 فتح الجهات
🔹  !lock contact
🔸 !unlock contact
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🔹قفل  الشفافه
🔸فتح الشفافه
🔹 !lock inline
🔸 !unlock inline
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🌐 @saad7m  🌐 ;) مطور البوت
🌐 @kenamch 🌐 ;)  قناة البوت
]]
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
--------------------
if (text == "mod help" or text == "اوامر الادمن") and is_momod(msg) then
local saad = [[
🔶اوامر الادمن🔛mod help!🔶
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !promote [username|id|reply] 
🔷 رفع مدير【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !demote [username|id|reply] 
🔷 حذف مدير【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !setflood [1-50]
🔷 ضع تكرار【50-1】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !muteuser [username|id|reply] 
🔷 كتم【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !unmuteuser [username|id|reply] 
🔷 الغاء كتم【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !ban [username|id|reply] 
🔷 حضر【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !unban [username|id|reply] 
🔷 الغاء حضر【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !id [reply]
🔶 ایدي 【بالرد】 
 ﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !set[rules | name | link | about ]
🔶 ضع 【قوانین | اسم | رابط | وصف 】
 ﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !clean [bans | mods | bots | rules | about | silentlist | filterlist | 
🔷 حذف 【 المحضورين| المدراء | القوانين | المكتومين |  】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !pin [reply]
🔶 تثبيت 【بالرد لثبيت رساله】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !unpin [reply]
🔷 الغاء تثبيت【 لالغاء تثبيت رساله】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !settings
🔷  اعدادات
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !mutelist
🔷 المكتومين
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !banlist
🔷 المحضورين
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !owners
🔶 المشرف
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !modlist 
🔷 المدراء
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !rules
🔶 القوانين
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !about
🔷  الوصف
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !id
🔶 ایدي
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !gpinfo
🔷  معلومات
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !link
🔶  رابط
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
‼️ ملاحضه ‼️
الاوامر وقوائم المساعدة تعمل باللغه الانكلش والعربيه 👇

 اعدادات    👉👈   settings!                
 ﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🌐 @saad7m  🌐 ;) مطور البوت
🌐 @kenamch 🌐 ;)  قناة البوت
]]
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
--------------------
if (text == "sudo help" or text == "اوامر المطور" )and is_owner(msg) then
local saad = [[
🔰 اوامر المطور - @saad7m 🔰
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
✩》 !setowner [username|id|reply] 
🔷 رفع مشرف【بالمعرف| بالايدي| بالرد】
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
⚜️ !add
✰》 [تفعيل]لتفعيل البوت
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
⚜️ !rem
✰》 [تعطيل]لتعطيل البوت
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
⚜️ !leave 
✰》 خروج البوت[غادر]
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
⚜️ !leave [GroupID]
✰》 اخراج البوت عبر الايدي
﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄
🌐 @saad7m  🌐 ;) مطور البوت
🌐 @kenamch 🌐 ;)  قناة البوت
]]
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
--------------------
if (text == "del" or text == "مسح") and is_momod(msg)  then
  tdcli.deleteMessages(chat_id, {[0] = msg.id_})
  tdcli.deleteMessages(chat_id,{[0] = reply_id})
end
if (text == "gpinfo" or text == "معلومات") and is_momod(msg)  then
  function info(arg,data)
    -- vardump(data)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1,  "📢*معلومات 🌴 المجموعه*📢\n👲_تعداد الادمن :_ *"..data.administrator_count_.."*\n👥_عدد الاعضاء:_ *"..data.member_count_.."*\n👿_عدد المطرودين :_ *"..data.kicked_count_.."*\n🆔_ايدي المجموعه :_ *"..data.channel_.id_.."*\n\n📢قناة البوت : @kenamch", 1, 'md')
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
------------------------------reply-----------------------
if text == "هلو" or text == "هلاو" then
saad = "هلوات حبي شلونك 😊☘️"
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "شلونكم" then
saad = "تمام يعمري وانته😽🍃"
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "تمام" or text == "الحمدلله" then
saad = "عساها دوم مو يوم 🌝✨"
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "دوم" then
saad = "تدوم احبابك غلاي 😌🖐🏿"
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "احبك" then
saad = "وآنـي ۿـم احبـك ياعيـن عيـني ¦ 😻🍃ء"
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "اعشقك" then
saad = " اؤوؤف شۿـال جفـاف ¦ 😹😻'ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "اكرهك" then
saad = " ﭘــﺱ انـﻲ احبـک┋😞💖ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "تكرهني" then
saad =  " طـبعاً مـا اكـرهك ¦ 😹✨'ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "باي" then
saad = " اﻟﻟـﮧ'ه ويـاك حيـاتي┋💛💭ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "جاو" then
saad = " اﻟﻟـﮧ'ه ويـاك حيـاتي┋💛💭ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "سلام" then
saad = " سـلامات حـﺒﯥ┋💝✨ "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "هاي" then
saad = " هـايـات يـروحـي┋🌸😻'ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "مرحبا" then
saad =  " مـراحـݕ ياۿـلا┋ 💖😻'ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "انجب" then
saad =  " انت انجب حيوان ¦ 😹✨'ء "
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
if text == "سعد" then
saad = "فديته المطور ماتي¦ 😻✨"
tdcli.sendMessage(msg.chat_id_, msg.id_, 1, saad, 1, 'md')
end
------------------------------------------saad7m-------------------------------------
if text == "id" or text == "ايدي" then
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
