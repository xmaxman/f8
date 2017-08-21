	
	----------------------------
	--[[
	
		Last Version,
		Last Update.
		# Farvardin 1396 
		# Reload Life
		# SprCpu Company
	
	]]
	------------------------
	--Insert Redis Data Base :)
	utf8 = require 'lua-utf8'

	function RedisDb()
		local Redis = require 'redis'
		local FakeRedis = require 'fakeredis'
			local params = {
  				host = os.getenv('REDIS_HOST') or '127.0.0.1',
  				port = tonumber(os.getenv('REDIS_PORT') or 6379)
			}
		local database = 0
		local password = nil
		Redis.commands.hgetall = Redis.command('hgetall', {
  			response = function(reply, command, ...)
    		local new_reply = { }
    			for i = 1, #reply, 2 do new_reply[reply[i]] = reply[i + 1] end
    			return new_reply
  			end
		})
		local redis = nil
			local ok = pcall(function()
  				redis = Redis.connect(params)
			end)
		if not ok then
  			local fake_func = function()
    			print('\27[31mCan\'t connect with Redis, install/configure it!\27[39m')
  			end
  		fake_func()
  		fake = FakeRedis.new()
  			print('\27[31mRedis addr: '..params.host..'\27[39m')
  			print('\27[31mRedis port: '..params.port..'\27[39m')
  			redis = setmetatable({fakeredis=true}, {
  			__index = function(a, b)
    				if b ~= 'data' and fake[b] then
      					fake_func(b)
    				end
    			return fake[b] or fake_func
  			end })
		else
 	 	if password then
    		redis:auth(password)
  		end
  		if database then
    		redis:select(database)
  		end
		end
		return redis
	end
	---------------------------
	-- insert Some packages 
	https = require "ssl.https"
	json = require "dkjson"
	serpent = require "serpent"
	URL = require 'socket.url'
	JSON = dofile('./dkjson.lua')
	clr = require 'term.colors'
	redis = RedisDb()
	cli = dofile('./Lib.lua').cli
	api = dofile('./Lib.lua').api
	----------------------------
	function LoadPlugins ()
		_Config = dofile('./Config.lua')
	end
	------------------------------------------ Loadplugins :\
    -----------------------------------------------------------------------------------------
    	require('Ranks')
    -----------------------------------------------------------------------------------------
    function MarkScape(text)
		Result = text:gsub('_', '\\_')
				 :gsub('`', '\\`')
				 :gsub('*', '\\*')
		return Result
	end

	function getUserInfo(user_ID)
		if redis:hget(user_ID, 'username') then
    		USER = redis:hgetall(user_ID)
			if USER.username then
   				return (USER.username).. ' - '.. user_ID
			elseif USER.firstname then
   				return (USER.firstname).. ' - '.. user_ID
    		else
    			return user_ID
			end
		else
			redis:del(user_ID)
    		return user_ID
		end
		return user_ID
	end

	utf = require 'lua-utf8'

	function VarDump(Value)
		print(clr.red.. '\n------------Start-------------- \n' ..clr.reset)
		print(clr.blue..serpent.block(Value,{comment=false})..clr.reset)
		print(clr.red.. '\n------------Stop -------------- \n' ..clr.reset)
	end
	LoadPlugins ()
	function DoMessage(msg)
		if msg then
		--	VarDump(msg)
		
		
			chat_id = msg.chat_id_ 
			user_id = msg.sender_user_id_
			Group = redis:hgetall(chat_id)
			msg_id = msg.id_
			TEXT = (msg.content_.text_ or msg.content_.caption_ or ' ')
			if tostring(chat_id):match('-') then
				redis:sadd('Groups!', msg.chat_id_)
			end
			cli.getChannelFull(chat_id, 
					function (arg, data)
						redis:hset(arg, 'AdminCount', data.administrator_count_)
						redis:hset(arg, 'MembersCount', data.member_count_)
						redis:hset(arg, 'Blocked', data.kicked_count_)
						redis:hset(arg, 'About', data.about_)
						if data.invite_link_ then
							redis:hset(arg, 'GroupLink', data.invite_link_)
						end
					end,
					chat_id)
				cli.getChannelMembers(chat_id, 'Administrators', 0, 100, 
					function (Arg, data)
						for k, v in pairs(data.members_) do
							if v.status_.ID == 'ChatMemberStatusCreator' then
								redis:hset(Arg, 'Owner', v.user_id_)
								redis:sadd('Mods'..Arg, v.user_id_)
							end
							if v.status_.ID == 'ChatMemberStatusEditor' then
								redis:sadd('Mods'..Arg, v.user_id_)
							end
						end
					end, chat_id)
				cli.getChat(chat_id,
					function (arg, data)
						if data.title_ then
							redis:hset(arg, 'Title', data.title_)
						end
					end,
					chat_id
				)
				


			if not isMod(user_id, chat_id) then
				for k,v in pairs(redis:smembers('Filterlist'..chat_id)) do
					if TEXT:find(v) then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				end
				if redis:sismember('Mutelist'..chat_id, user_id) then
					if not isMod(user_id, chat_id) then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				end

				if Group.MuteAll == 'DEL' then
					cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
				elseif Group.MuteAll == 'true' then
					cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
				elseif Group.MuteAll == 'WARN' then
					cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					if not redis:get(user_id..chat_id..'MUTEALL') then
						if Group.Language == 'FA' then
							text = 'کاربر : '.. getUserInfo(user_id).. ' این گروه در حالت سکوت است لطفا پیام ندهید !'
							cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
						else
							text = 'User : '.. getUserInfo(user_id).. ' Dont Send Messages Please !'
							cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
						end
						redis:setex(user_id..chat_id..'MUTEALL', 120, true)
					end
					redis:hincrby (user_id..chat_id, 'Muteall', 1)
					if tonumber(redis:hget (user_id..chat_id, 'Muteall') or 0 ) > 10 then
						cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
						redis:hset (user_id..chat_id, 'Muteall', 0)
					end
				end
				-----------------------------------------
				if Group.Link == 'DEL' then
					if TEXT:lower():match('t.me') or TEXT:lower():match('telegram.me') or TEXT:lower():match('telegram.dog') or TEXT:lower():match('telegra.ph') then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Link == 'WARN' then
					if TEXT:lower():match('t.me') or TEXT:lower():match('telegram.me') or TEXT:lower():match('telegram.dog') or TEXT:lower():match('telegra.ph') then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Link') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال لینک در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Links Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Link', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Link', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Link') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Link', 0)
						end
					end
				end
				-----------------------------------
				if Group.Mention == 'DEL' then
					if #msg.content_.entities_ > 0 then
						for k ,v in pairs(msg.content_.entities_) do
							if v.ID == "MessageEntityMentionName" or v.ID == "MessageEntityMention" then
								cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
							end
						end
					end
				elseif Group.Mention == 'WARN' then
					if #msg.content_.entities_ > 0 then
						for k ,v in pairs(msg.content_.entities_) do
							if v.ID == "MessageEntityMentionName" or v.ID == "MessageEntityMention" then
							cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Mention') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال منشن(تگ) در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Mention Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Mention', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Mention', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Mention') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Mention', 0)
						end
						end
							end
					end
				end
				-----------------------------------
				if Group.Atsign == 'DEL' then
					if TEXT:lower():match('@')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Atsign == 'WARN' then
					if TEXT:lower():match('@')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Atsign') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال یوزرنیم[@] در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send [@]Username Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Atsign', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Atsign', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Atsign') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Atsign', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Hashtag == 'DEL' then
					if TEXT:lower():match('#')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Hashtag == 'WARN' then
					if TEXT:lower():match('#')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Hashtag') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال هشتگ[#] در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send [#]Hashtag Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Hashtag', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Hashtag', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Hashtag') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Hashtag', 0)
						end
					end
				end
				-----------------------------------------
				if Group.English == 'DEL' then
					if TEXT:lower():match('[a-z]')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.English == 'WARN' then
					if TEXT:lower():match('[a-z]')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'English') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال کاراکتر های لاتین در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send EnglishWords Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'English', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'English', 1)
						if tonumber(redis:hget (user_id..chat_id, 'English') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'English', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Persion == 'DEL' then
					if TEXT:lower():match('[\216-\219][\128-\191]')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Persion == 'WARN' then
					if TEXT:lower():match('[\216-\219][\128-\191]')  then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Persion') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال کاراکتر های پارسی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Persian Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Persion', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Persion', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Persion') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Persion', 0)
						end
					end
				end
				-----------------------------------------
-------------------------------------------------------------------------------------Mute List !
				if Group.Edit == 'DEL' then
					if msg.edit_date_ ~= 0 then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Edit == 'WARN' then
					if msg.edit_date_ ~= 0 then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Edit') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ویرایش پیام در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Edit Your Messages Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Edit', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Edit', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Edit') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Edit', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Photo == 'DEL' then
					if msg.content_.ID == 'MessagePhoto' then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Photo == 'WARN' then
					if msg.content_.ID == 'MessagePhoto' then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Photo') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال عکس در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send PhotoMessages Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Photo', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Photo', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Photo') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Photo', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Video == 'DEL' then
					if msg.content_.ID == 'MessageVideo' then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Video == 'WARN' then
					if msg.content_.ID == 'MessageVideo' then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Video') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال فیلم در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send VideoMessages Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Video', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Video', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Video') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Video', 0)
						end
					end
				end
				-----------------------------------------
				if Group.ShareNumber == 'DEL' then
					if msg.content_.ID == "MessageContact" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.ShareNumber == 'WARN' then
					if msg.content_.ID == "MessageContact" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'ShareNumber') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال شماره تلفن در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Contact Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'ShareNumber', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'ShareNumber', 1)
						if tonumber(redis:hget (user_id..chat_id, 'ShareNumber') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'ShareNumber', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Music == 'DEL' then
					if msg.content_.ID == "MessageAudio" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Music == 'WARN' then
					if msg.content_.ID == "MessageAudio" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Music') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال موسیقی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Music Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Music', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Music', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Music') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Music', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Voice == 'DEL' then
					if msg.content_.ID == "MessageVoice" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Voice == 'WARN' then
					if msg.content_.ID == "MessageVoice" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Voice') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال پیام صوتی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Voice Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Voice', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Voice', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Voice') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Voice', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Location == 'DEL' then
					if msg.content_.ID == "MessageLocation" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Location == 'WARN' then
					if msg.content_.ID == "MessageLocation" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Location') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال مکان در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Location Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Location', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Location', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Location') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Location', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Animation == 'DEL' then
					if msg.content_.ID == "MessageAnimation" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Animation == 'WARN' then
					if msg.content_.ID == "MessageAnimation" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Animation') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال انیمیشن در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Animation Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Animation', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Animation', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Animation') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Animation', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Sticker == 'DEL' then
					if msg.content_.ID == "MessageSticker" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Sticker == 'WARN' then
					if msg.content_.ID == "MessageSticker" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Sticker') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال برچسب در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Sticker Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Sticker', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Sticker', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Sticker') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Sticker', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Game == 'DEL' then
					if msg.content_.ID == "MessageGame" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Game == 'WARN' then
					if msg.content_.ID == "MessageGame" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Game') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال بازی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Game Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Game', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Game', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Game') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Game', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Inline == 'DEL' then
					if msg.via_bot_user_id_ ~= 0 then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Inline == 'WARN' then
					if msg.via_bot_user_id_ ~= 0 then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Inline') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال درون خطی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Inline Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Inline', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Inline', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Inline') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Inline', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Keyboard == 'DEL' then
					if msg.reply_markup_ then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Keyboard == 'WARN' then
					if msg.reply_markup_ then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Keyboard') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال کیبورد در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Keyboard Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Keyboard', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Keyboard', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Keyboard') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Keyboard', 0)
						end
					end
				end
				-----------------------------------------
				if Group.File == 'DEL' then
					if msg.content_.ID == "MessageDocument" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.File == 'WARN' then
					if msg.content_.ID == "MessageDocument" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'File') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال فایل در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send File Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'File', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'File', 1)
						if tonumber(redis:hget (user_id..chat_id, 'File') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'File', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Media == 'DEL' then
					if msg.content_.ID ~= "MessageText" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Media == 'WARN' then
					if msg.content_.ID ~= "MessageText" then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Media') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال پیام غیر متنی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Media Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Media', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Media', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Media') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Media', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Webpage == 'DEL' then
					if msg.content_.web_page_ then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Webpage == 'WARN' then
					if msg.content_.web_page_ then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Webpage') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال صفخه وب در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send Webpage Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Webpage', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Webpage', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Webpage') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Webpage', 0)
						end
					end
				end
				-----------------------------------------
				if Group.Forward == 'DEL' then
					if msg.forward_info_ or msg.forward_info_.chat_id_ then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.Forward == 'WARN' then
					if msg.forward_info_ or msg.forward_info_.chat_id_ then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'Forward') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال پیام فورواردشده در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send ForwardedMessages Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'Forward', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'Forward', 1)
						if tonumber(redis:hget (user_id..chat_id, 'Forward') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'Forward', 0)
						end
					end
				end
				-----------------------------------------
				-----------------------------------------
				--Save Group Data
				
				-------------------------------------------
				-------------------------------------------
				local function CheckFlood(msg) 
					chat_id = (msg.chat_id_ or msg.sender_user_id_)
					user_id = msg.sender_user_id_
					msg_id = msg.id_ 
					reply_id = msg.reply_to_message_id_
					settings = redis:hgetall(msg.chat_id_)

					---------------------------------------
					if not isMod(msg.sender_user_id_, msg.chat_id_) then
						hash = 'user:'..user_id..':'..chat_id..':fldcount'
						redis:incr(hash)
						if redis:get('fld:'..chat_id..':u:'..user_id) == 'ss' then
							if settings.FastMessage ~= 'OK' then
								if tonumber(redis:get(hash)) > tonumber((settings.FastMessageCount or 5)) then
									redis:set(hash, 0)
									cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
									if Group.Language == 'FA' then
										text = 'کاربر : '.. getUserInfo(user_id).. ' به دلیل ارسال پیام مکرر اخراج شد !'
										cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
									else
										text = 'User : '.. getUserInfo(user_id).. ' kicked for spamming !'
										cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
									end
								else
									redis:incrby(hash, 1)
								end
							end
						else
							redis:set(hash, 0)
							redis:setex('fld:'..chat_id..':u:'..user_id, (settings.FastMessageTime or 2), 'ss')
						end
					end
				end
				CheckFlood(msg)
				if Group.LongCharr == 'DEL' then
					if utf.len(TEXT) > (tonumber(Group.LongCharrC) or 500) then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.LongCharr == 'WARN' then
					if utf.len(TEXT) > (tonumber(Group.LongCharrC) or 500) then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'LongCharr') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال پیام پیام طولانی در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send LongMessages Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'LongCharr', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'LongCharr', 1)
						if tonumber(redis:hget (user_id..chat_id, 'LongCharr') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'LongCharr', 0)
						end
					end
				end
				if Group.ShortCharr == 'DEL' then
					if utf.len(TEXT) < (tonumber(Group.ShortCharrC) or 2) then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
					end
				elseif Group.ShortCharr == 'WARN' then
					if utf.len(TEXT) < (tonumber(Group.ShortCharrC) or 2) then
						cli.deleteMessages(msg.chat_id_, {[0] = msg.id_})
						if not redis:get(user_id..chat_id..'ShortCharr') then
							if Group.Language == 'FA' then
								text = 'کاربر : '.. getUserInfo(user_id).. ' از ارسال پیام کوتاه در این گروه خود داری کنید !'
								cli.sendMention(chat_id, user_id, msg_id, text, 8, utf.len(getUserInfo(user_id)))
							else
								text = 'User : '.. getUserInfo(user_id).. ' Dont Send ShorMessages Here Please !'
								cli.sendMention(chat_id, user_id, msg_id, text, 7, utf.len(getUserInfo(user_id)))
							end
							redis:setex(user_id..chat_id..'ShortCharr', 120, true)
						end
						redis:hincrby (user_id..chat_id, 'ShortCharr', 1)
						if tonumber(redis:hget (user_id..chat_id, 'ShortCharr') or 0 ) > 10 then
							cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
							redis:hset (user_id..chat_id, 'ShortCharr', 0)
						end
					end
				end
				
------------------------------------------------------------------------------------------------
			end

		end
	end

	function tdcli_update_callback(data)  

		if data.ID == 'UpdateMessageEdited' then
			cli.getMessage(data.chat_id_, data.message_id_,
				function (A, D) 
					DoMessage(D)
				end,
				nil
			)
		elseif data.ID == 'UpdateNewMessage' then
				if not data.message_.is_post_ then
							msg = data.message_
							DoMessage(msg)
				end
		elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
       		tdcli_function ({ID="GetChats",offset_order_="9223372036854775807",offset_chat_id_=0,limit_=20},function(A,D) end,nil)
		end
	end