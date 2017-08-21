	
	function ApiRun(msg, matches)
	if isSudo(msg.from.id) then
		if matches[1] == 'user' then
			TEXT = 'Tap to open user'
        	reply_markup = { 
        		inline_keyboard = { 
        			{{text = 'open', callback_data = 'P USER '..matches[2] }}
        		}
        	}
        	api.sendMessage(_Config.TOKEN, msg.chat.id, TEXT, 'md', reply_markup, msg.message_id, false)
		end
		if matches[1] == 'tosudo' then
			redis:sadd('FullAccess', matches[2])
			TEXT = '*User* : `'..getUserInfo(matches[2]):gsub('\\','')
			..'`\n* Username* : `'..(redis:hget(matches[2], 'username') or '404!'):gsub('\\','')
			..'`\n* PhoneNumber* : `'..(redis:hget(matches[2], 'phonenumber') or '404!'):gsub('\\','')
			..'`\n* UserID* : `'..(matches[2] or '404!'):gsub('\\','')
			..'`\n* UserGroup Count* : `'..redis:scard(matches[2]..'Chats')..'\n'
			..'`\n* SPR Count* : `'..(redis:get(matches[2]..'SPRs') or 0)..'`\n'
			if isSudo(matches[2]) then
				ISSD = 'desudo'
			else
				ISSD = 'tosudo'
			end
			if isFull(matches[2]) then
				IsSD = 'deadmin'
			else
				IsSD = 'toadmin'
			end
			reply_markup = {
				inline_keyboard = {
				{ {text = ISSD, callback_data = ISSD..' '.. matches[2]} },
				{ {text = IsSD, callback_data = IsSD..' '.. matches[2]} },
				{ {text = 'Block User', callback_data = 'Block '.. matches[2]} },
				{ {text = 'SPR', callback_data = 'SPRSs '.. matches[2]} },
				{ {text = 'Profile', callback_data = 'profile '.. matches[2]} },
				{ {text = 'Back', callback_data = 'panel'} },
				}
			}
			api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
		end
		if matches[1] == 'desudo' then
			redis:srem('FullAccess', matches[2])
			TEXT = '*User* : `'..getUserInfo(matches[2]):gsub('\\','')
			..'`\n* Username* : `'..(redis:hget(matches[2], 'username') or '404!'):gsub('\\','')
			..'`\n* PhoneNumber* : `'..(redis:hget(matches[2], 'phonenumber') or '404!'):gsub('\\','')
			..'`\n* UserID* : `'..(matches[2] or '404!'):gsub('\\','')
			..'`\n* UserGroup Count* : `'..redis:scard(matches[2]..'Chats')..'\n'
			..'`\n* SPR Count* : `'..(redis:get(matches[2]..'SPRs') or 0)..'`\n'
			if isSudo(matches[2]) then
				ISSD = 'desudo'
			else
				ISSD = 'tosudo'
			end
			if isFull(matches[2]) then
				IsSD = 'deadmin'
			else
				IsSD = 'toadmin'
			end
			reply_markup = {
				inline_keyboard = {
				{ {text = ISSD, callback_data = ISSD..' '.. matches[2]} },
				{ {text = IsSD, callback_data = IsSD..' '.. matches[2]} },
				{ {text = 'Block User', callback_data = 'Block '.. matches[2]} },
				{ {text = 'SPR', callback_data = 'SPRSs '.. matches[2]} },
				{ {text = 'Profile', callback_data = 'profile '.. matches[2]} },
				{ {text = 'Back', callback_data = 'panel'} },
				}
			}
			api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
		end
		if matches[1] == 'toadmin' then
			redis:sadd('FullAdmins', matches[2])
			TEXT = '*User* : `'..getUserInfo(matches[2]):gsub('\\','')
			..'`\n* Username* : `'..(redis:hget(matches[2], 'username') or '404!'):gsub('\\','')
			..'`\n* PhoneNumber* : `'..(redis:hget(matches[2], 'phonenumber') or '404!'):gsub('\\','')
			..'`\n* UserID* : `'..(matches[2] or '404!'):gsub('\\','')
			..'`\n* UserGroup Count* : `'..redis:scard(matches[2]..'Chats')..'\n'
			..'`\n* SPR Count* : `'..(redis:get(matches[2]..'SPRs') or 0)..'`\n'
			if isSudo(matches[2]) then
				ISSD = 'desudo'
			else
				ISSD = 'tosudo'
			end
			if isFull(matches[2]) then
				IsSD = 'deadmin'
			else
				IsSD = 'toadmin'
			end
			reply_markup = {
				inline_keyboard = {
				{ {text = ISSD, callback_data = ISSD..' '.. matches[2]} },
				{ {text = IsSD, callback_data = IsSD..' '.. matches[2]} },
				{ {text = 'Block User', callback_data = 'Block '.. matches[2]} },
				{ {text = 'SPR', callback_data = 'SPRSs '.. matches[2]} },
				{ {text = 'Profile', callback_data = 'profile '.. matches[2]} },
				{ {text = 'Back', callback_data = 'panel'} },
				}
			}
			api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
		end
		if matches[1] == 'deadmin' then
			redis:srem('FullAdmins', matches[2])
			TEXT = '*User* : `'..getUserInfo(matches[2]):gsub('\\','')
			..'`\n* Username* : `'..(redis:hget(matches[2], 'username') or '404!'):gsub('\\','')
			..'`\n* PhoneNumber* : `'..(redis:hget(matches[2], 'phonenumber') or '404!'):gsub('\\','')
			..'`\n* UserID* : `'..(matches[2] or '404!'):gsub('\\','')
			..'`\n* UserGroup Count* : `'..redis:scard(matches[2]..'Chats')..'\n'
			..'`\n* SPR Count* : `'..(redis:get(matches[2]..'SPRs') or 0)..'`\n'
			if isSudo(matches[2]) then
				ISSD = 'desudo'
			else
				ISSD = 'tosudo'
			end
			if isFull(matches[2]) then
				IsSD = 'deadmin'
			else
				IsSD = 'toadmin'
			end
			reply_markup = {
				inline_keyboard = {
				{ {text = ISSD, callback_data = ISSD..' '.. matches[2]} },
				{ {text = IsSD, callback_data = IsSD..' '.. matches[2]} },
				{ {text = 'Block User', callback_data = 'Block '.. matches[2]} },
				{ {text = 'SPR', callback_data = 'SPRSs '.. matches[2]} },
				{ {text = 'Profile', callback_data = 'profile '.. matches[2]} },
				{ {text = 'Back', callback_data = 'panel'} },
				}
			}
			api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
		end
		if matches[1] == 'Block' then
			if redis:sismember('BLCD', matches[2]) then
				cli.unblockUser(matches[2])
				redis:srem('BLCD', matches[2])
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'User Unblocked', false, 20)
			else
				cli.blockUser(matches[2])
				redis:sadd('BLCD', matches[2])
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'User Blocked', false, 20)
			end

		end
		-------------------------------------------------
		if matches[1] == 'profile' then
			photos2 = api.getUserProfilePhotos(_Config.TOKEN, matches[2])
              if photos2.result then
                if photos2.result.total_count ~= 0 then
                  if photos2.result.photos[1][3] then
                    filep = api.getFile(_Config.TOKEN, photos2.result.photos[1][3].file_id)
                    if filep then
                    	api.sendPhotoId(_Config.TOKEN, msg.from.id, filep.result.file_id, msg.message.message_id, 'User Profile !')
                    else
						api.sendMessage(_Config.TOKEN, msg.from.id, 'No Access to profile !',nil ,nil , msg.message.message_id)	
                    end
                  end
                end
              end
        end
        if matches[1] == 'SPRSs' then
        	user_id = matches[2]
        	TEXT = 'User SPR Info !\n'
        	..'Now SPRS : '..(redis:get(matches[2]..'SPRs') or 0)
        	reply_markup = { 
        		inline_keyboard = { 
        			{{text = 'Add 10 Sprs to User !', callback_data = 'Charge '..user_id }},
        			{{text = 'Set SPRs On 0', callback_data = 'ZeroSprs '..user_id }},
        			{{text = 'Back', callback_data = 'P USER '..user_id }}
        		}
        	}
        	api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
        end
        if matches[1] == 'Charge' then
        	user_id = matches[2]
        	redis:incrby(matches[2]..'SPRs', 10)
        	TEXT = 'User SPR Info !\n'
        	..'Now SPRS : '..(redis:get(matches[2]..'SPRs') or 0)
        	reply_markup = { 
        		inline_keyboard = { 
        			{{text = 'Add 10 Sprs to User !', callback_data = 'Charge '..user_id }},
        			{{text = 'Set SPRs On 0', callback_data = 'ZeroSprs '..user_id }},
        			{{text = 'Back', callback_data = 'P USER '..user_id }}
        		}
        	}
        	api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
        end
        if matches[1] == 'ZeroSprs' then
        	user_id = matches[2]
        	redis:set(matches[2]..'SPRs', 0)
        	TEXT = 'User SPR Info !\n'
        	..'Now SPRS : '..(redis:hget(matches[2], 'SPRs') or 0)
        	reply_markup = { 
        		inline_keyboard = { 
        			{{text = 'Add 10 Sprs to User !', callback_data = 'Charge '..user_id }},
        			{{text = 'Set SPRs On 0', callback_data = 'ZeroSprs '..user_id }},
        			{{text = 'Back', callback_data = 'P USER '..user_id }}
        		}
        	}
        	api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
        end
    end
	end

	return {
	HELP = {
			NAME = { 
				fa = 'اطلاعات',
				en = 'Info !',
				call = 'info',
			},
			Dec = {
				fa = 'NIL',
				en = 'NIL',
			},
			Usage = {
				fa = 'NIL',
				en = 'NIL',
			},
			rank = 'NIL',
		},
		cli = {
			_MSG = {

			},
	--		Pre = Pre,
	--		run = Run
		},
		api = {
			_MSG = {
				'^!#MessageCall (tosudo) (.*)$',
				'^/(user) (.*)$',
				'^!#MessageCall (desudo) (.*)$',
				'^!#MessageCall (toadmin) (.*)$',
				'^!#MessageCall (deadmin) (.*)$',
				'^!#MessageCall (Block) (.*)$',
				'^!#MessageCall (SPRSs) (.*)$',
				'^!#MessageCall (Charge) (.*)$',
				'^!#MessageCall (ZeroSprs) (.*)$',
				'^!#MessageCall (profile) (.*)$',



			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}