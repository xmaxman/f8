	
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
	require('Ranks')
	
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
	_Config = {
		Logs = '-1001077442365', -- A Channel/User/Chat To Send Bot Logs ! (Api Bot Most Be in that Chat !)
		TOKEN = '426546927:AAHtowOBB1HTe3ZLKSHmltJq72X798_UmZ4',--'252875954:AAGBc3lpOG7BHTbVVN4Ung-WqhE3WagSdco',
		MainSudo = 330396392,
		Sudo = {
			330396392,
			330396392
		}
	}

	function LoadPlugins ()
		_Config = dofile('./Config.lua')
		plugins = {}
		PLUGINSTABLE = _Config.Plugins
		local ERROR_TEXT_PL1 = '*Error(s) In Last Reload !*'
			print (clr.blue .. clr.onred .. clr.underscore .. ' > Loading Plugins ...'..clr.clear)
		for k,v in pairs(PLUGINSTABLE) do
			print (clr.blue .. clr.onred .. clr.underscore .. ' > Loading Plugin '..clr.clear ..clr.red .. clr.onblue .. v ..clr.clear ..' ...')
			local ok, err =  pcall(function() 
     			local t = loadfile("./Plugins/"..v..'.lua')() 
      			plugins[v] = t 
     		end)
     		if not ok then
     			print (clr.red .. clr.ongreen .. clr.underscore .. ' > Error in Plugin : >> '..clr.clear ..clr.red .. clr.onblue .. v ..clr.clear ..' ...')
     			ERROR_TEXT_PL1 = ERROR_TEXT_PL1..'\n\nPlugin : `' .. v .. '` \nError TEXT :> \n```'..io.popen("lua ./Plugins/"..v..'.lua'):read('*all') .. '``` \n '
     		else
     			ERROR_TEXT_PL1 = ERROR_TEXT_PL1..'\n\nPlugin : `' .. v .. '` \nNo Error !\n'
     			print (clr.red .. clr.ongreen .. clr.underscore .. ' > Plugin : >> '..clr.clear ..clr.red .. clr.onblue .. v ..clr.clear ..' Loaded Success !...')
     		end
		end
		api.sendMessage(tostring(_Config.TOKEN), tostring(_Config.Logs), ERROR_TEXT_PL1 .. '\n', 'md')	
	end
	------------------------------------------ Loadplugins :\

    --Api
    function MatchPatterns2 (pattern, text) 
		if text then
			local matches = { text:match(pattern) }
	  		if next(matches) then
        		return matches
      		end
      	else

      	end
    end
    function MatchPlugin2 (plugin, msg, text)
    	for k, v in pairs(plugin.api._MSG) do
    		local matches = (MatchPatterns2 ( v, text ) or {})
    		if plugin.api.run then
    			local result = plugin.api.run(msg, matches)
    			if result then
    				api.sendMessage(tostring(_Config.TOKEN), msg.chat.id, result, 'md', nil, msg.message_id)  
    			end
    		end
    	end
    end
    function RunMatches2 (msg, text)
    	for k, v in pairs(plugins) do
    		MatchPlugin2 (v, msg, text)
    	end
    end
    -------------Cli Check Patterns >>
    function MessagePre2 ( msg , type)
    	for k, v in pairs(plugins) do
    		if v.api.Pre then
    			local result = v.api.Pre(msg, type)
    			if result then
    				api.sendMessage(tostring(_Config.TOKEN), msg.chat.id, result, 'md', nil, msg.message_id)  
    			end
    		end
    	end
    end
------------------------------------------------------------------------------------
    function MarkScape(text)
		Result = text:gsub('_', '\\_')
				 :gsub('`', '\\`')
				 :gsub('*', '\\*')
		return Result
	end

	function VarDump(Value)
		print(clr.red.. '\n------------Start-------------- \n' ..clr.reset)
		print(clr.blue..serpent.block(Value,{comment=false})..clr.reset)
		print(clr.red.. '\n------------Stop -------------- \n' ..clr.reset)
	end

	function getUserInfo(user_ID)
		if redis:hget(user_ID, 'username') then
    		USER = redis:hgetall(user_ID)
			if USER.username then
   				return '@'..MarkScape(USER.username).. ' - '.. user_ID
			elseif USER.firstname then
   				return MarkScape(USER.firstname).. ' - '.. user_ID
    		else
    			return user_ID
			end
		else
			redis:del(user_ID)
    		return user_ID
		end
		return user_ID
	end



	
	LoadPlugins ()
    function MessageInput(msg, type)
    --	VarDump(msg)
    	MessagePre2(msg, type)
    		redis:sadd('Users', msg.from.id)
    		redis:del(msg.from.id)
    		if msg.from.username then
    			redis:hset(msg.from.id, 'username', msg.from.username)
			end
			if msg.from.first_name then
    			redis:hset(msg.from.id, 'firstname', msg.from.first_name)
			end

    	if type == 'Message' then
    		text = msg.text
    	elseif type == 'Inline' then
    		text = '!#MessageQuery '..msg.query
    	elseif type == 'CallBack' then
    		text = '!#MessageCall '..msg.data
    	else
    		text = msg.text 
    	end
		RunMatches2(msg, text)
    end
    last_update = 0 or last_update
    LastCron = 0 or LastCron
    function tdcli_update_callback(data)  
      if data then
        data = nil
      end
		--while true do
	   cli.setAlarm(1)
			local response = api.getUpdates(_Config.TOKEN, last_update+1)
			if response then 
    			for i,v in ipairs(response.result) do 
      				last_update = v.update_id 
      			--	VarDump(v)
      				if v.edited_message then 
        				MessageInput(v.edited_message, 'Edited') 
      				elseif v.message then 
        				MessageInput(v.message, 'Message') 
    				elseif v.callback_query then 
    				    MessageInput(v.callback_query, 'CallBack')
    				elseif v.inline_query then 
    				    MessageInput(v.inline_query, 'Inline') 
    				end 
    			end 
  			else 
  				print('Error, Cant Get New Updates !')
  			end 
		--end
	end