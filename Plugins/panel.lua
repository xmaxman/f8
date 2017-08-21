
http = require "socket.http"

	function ApiRun(msg, matches)
		if #matches > 0 then
	if isFull(msg.from.id) then
			if matches[1] == 'panel' then
				TEXT = 'Administration Panel !'
				reply_markup = {
					inline_keyboard = { 
						{
							{ text = 'Groups', callback_data = 'P Groups' },
							{ text = 'FullAdmins', callback_data = 'P FullAdmins' }
						},
						{
							{ text = 'BotUsers', callback_data = 'P BotUsers' },
							{ text = 'Reload Bot', callback_data = 'reload' }
						},	
						{
							{ text = 'back', callback_data = 'startpage' },
						}
					}
				}
				api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
			end
			----
			if matches[1] == 'LeavE' and isSudo(msg.from.id) then
				redis:del(matches[2])
				redis:srem('Groups!',matches[2])
				cli.changeChatMemberStatus(matches[2], 301684103, 'Kicked')
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Down !', true)
			end
			if matches[1] == 'CHP' and isSudo(msg.from.id) then
				TEXT = 'Charge Panel'
				reply_markup = { inline_keyboard = { 

				{{text = '1 Mah', callback_data = 'charge1 '..matches[2]}},
				{{text = '2 Mah', callback_data = 'charge2 '..matches[2]}},
				{{text = '3 Mah', callback_data = 'charge3 '..matches[2]}},
				{{text = '4 Mah', callback_data = 'charge4 '..matches[2]}},
				{{text = 'Back', callback_data = 'settings '..matches[2]}},
				   } }

				if msg.inline_message_id then
					api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
				else
					api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
				end
			end
			if matches[1] == 'charge1' and isSudo(msg.from.id) then
				Time = 1 * 30 * 24 * 60 * 60 + tonumber(os.time())
				redis:hset(matches[2], 'isVIP', Time)
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Down !', true)
			end
			if matches[1] == 'charge2' and isSudo(msg.from.id) then
				Time = 2 * 30 * 24 * 60 * 60 + tonumber(os.time())
				redis:hset(matches[2], 'isVIP', Time)
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Down !', true)
			end
			if matches[1] == 'charge3' and isSudo(msg.from.id) then
				Time = 3 * 30 * 24 * 60 * 60 + tonumber(os.time())
				redis:hset(matches[2], 'isVIP', Time)
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Down !', true)
			end
			if matches[1] == 'charge4' and isSudo(msg.from.id) then
				Time = 4 * 30 * 24 * 60 * 60 + tonumber(os.time())
				redis:hset(matches[2], 'isVIP', Time)
				api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Down !', true)
			end
			if matches[1] == 'P' then

				if matches[2] == 'Groups' then
					reply_markup = { inline_keyboard = {} }
					for k, v in pairs(redis:smembers('Groups!')) do
						SST = 0
						TBL = { {text = 'Group : '.. (redis:hget(v, 'Title') or v), callback_data = 'P GP '..v} }
						table.insert(reply_markup.inline_keyboard, TBL)
						TBL = {}
					end
					table.insert(reply_markup.inline_keyboard, {{text = 'Main Page', callback_data = 'panel'}})
					TEXT = 'F80 Groups !'
				api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				----------------------
				if matches[2] == 'FullAdmins' then
					reply_markup = { inline_keyboard = {} }
					for k, v in pairs(redis:smembers('FullAdmins')) do

						TBL = { {text = 'USER : '..getUserInfo(v):gsub('\\','') , callback_data = 'P USER '..v} }
						table.insert(reply_markup.inline_keyboard, TBL)
						TBL = {}
					end
					table.insert(reply_markup.inline_keyboard, {{text = 'Main Page', callback_data = 'panel'}})
					TEXT = 'F80 Full Access Admins !'
				api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				--
				if matches[2] == 'BotUsers' then
					reply_markup = { inline_keyboard = {} }
					for k, v in pairs(redis:smembers('Users')) do
						TBL = { {text = 'USER : '.. getUserInfo(v):gsub('\\',''), callback_data = 'P USER '..v} }
						table.insert(reply_markup.inline_keyboard, TBL)
						TBL = {}
						if k == 9 then
							table.insert(reply_markup.inline_keyboard, { {text = 'Next Page', callback_data = 'P Nextpage '.. (k+1)} })
							break
						end
					end
					table.insert(reply_markup.inline_keyboard, {{text = 'Main Page', callback_data = 'panel'}})
					TEXT = 'F80 Users !'
				api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				if matches[2] == 'Nextpage' then
					reply_markup = { inline_keyboard = {} }
					for k, v in pairs(redis:smembers('Users')) do
						if k > tonumber(matches[3]) then
							TBL = { {text = 'USER : '.. getUserInfo(v):gsub('\\',''), callback_data = 'P USER '..v} }
							table.insert(reply_markup.inline_keyboard, TBL)
							TBL = {}
							if k == tonumber(matches[3]) + 10 then
								table.insert(reply_markup.inline_keyboard, { {text = 'Next Page', callback_data = 'P Nextpage '.. (k+1)} })
								break
							end
						end
					end
					table.insert(reply_markup.inline_keyboard, {{text = 'Main Page', callback_data = 'panel'}})
					TEXT = 'F80 Users !'
				api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				-----
				if matches[2] == 'USER' then
					TEXT = '*User* : `'..getUserInfo(matches[3]):gsub('\\','')
					..'`\n* Username* : `'..(redis:hget(matches[3], 'username') or '404!'):gsub('\\','')
					..'`\n* PhoneNumber* : `'..(redis:hget(matches[3], 'phonenumber') or '404!'):gsub('\\','')
					..'`\n* UserID* : `'..(matches[3] or '404!'):gsub('\\','')
					..'`\n* UserGroup Count* : `'..redis:scard(matches[3]..'Chats')..'\n'
					..'`\n* SPR Count* : `'..(redis:get(matches[3]..'SPRs') or 0)..'`\n'
					if isSudo(matches[3]) then
						ISSD = 'desudo'
					else
						ISSD = 'tosudo'
					end
					if isFull(matches[3]) then
						IsSD = 'deadmin'
					else
						IsSD = 'toadmin'
					end

					reply_markup = {
						inline_keyboard = {
						{ {text = ISSD, callback_data = ISSD..' '.. matches[3]} },
						{ {text = IsSD, callback_data = IsSD..' '.. matches[3]} },
						{ {text = 'Block User', callback_data = 'Block '.. matches[3]} },
						{ {text = 'SPR', callback_data = 'SPRSs '.. matches[3]} },
						{ {text = 'Profile', callback_data = 'profile '.. matches[3]} },
						{ {text = 'Back', callback_data = 'panel'} },
						}
					}
					api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				-----
				if matches[2] == 'GP' then
					

					if msg.inline_message_id then
						chat_id = matches[3]
						user_id = msg.from.id
						GP = redis:hgetall(chat_id)
						if (redis:get(user_id..'Lang') or 'fa') == 'fa' then
							TEXT = '*گروه* : `'..chat_id..'`\n'
							..'*صاحب* : `'..getUserInfo( GP.Owner or 'بدون صاحب' )..'`\n'
							..'*اطلاعات گروه :*\n'
							..'*تعداد مدیران* : `'..MarkScape( GP.AdminCount or '0' )..'`\n'
							..'*تعداد اعضا* : `'..MarkScape( GP.MembersCount or '0' )..'`\n'
							..'*تعداد لیست سیاه* : `'..MarkScape( GP.Blocked or '0' )..'`\n'
							..'*درباره گروه* : \n`'..MarkScape( GP.About or '' )..'`\n'
							..'*نام گروه* : `'..MarkScape( GP.Title or '' )..'`\n'
							..'*لینک گروه* : `'..MarkScape( GP.GroupLink or 'لینکی موجود نیست' )..'`\n'

							reply_markup = {
							inline_keyboard = {
								{ {text = 'Edit Group', callback_data = 'settings '.. matches[3]} },
							}
						}
						else
							TEXT = '*Group* : `'..chat_id..'`\n'
							..'*Owner* : `'..getUserInfo( GP.Owner or 'NoOwner' )..'`\n'
							..'*ChatInfo :*\n'
							..'*Admin Count* : `'..MarkScape( GP.AdminCount or '0' )..'`\n'
							..'*Members Count* : `'..MarkScape( GP.MembersCount or '0' )..'`\n'
							..'*Blocked Count* : `'..MarkScape( GP.Blocked or '0' )..'`\n'
							..'*Group About* : \n`'..MarkScape( GP.About or '' )..'`\n'
							..'*Group Title* : `'..MarkScape( GP.Title or '' )..'`\n'
							..'*Group Link* : `'..MarkScape( GP.GroupLink or '' )..'`\n'
							reply_markup = {
							inline_keyboard = {
								{ {text = 'Edit Group', callback_data = 'settings '.. matches[3]} },
							}
						}
						end
						if isSudo(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, { { text = 'Delete And Leave Group', callback_data = 'LeavE '..matches[3] } })
						end
						if isSudo(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, { { text = 'Sharzh Panel', callback_data = 'CHP '..matches[3] } })
						end
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', reply_markup)
					else
						chat_id = matches[3]
						user_id = msg.from.id
						GP = redis:hgetall(chat_id)
						if (redis:get(user_id..'Lang') or 'fa') == 'fa' then
							TEXT = '*گروه* : `'..chat_id..'`\n'
							..'*صاحب* : `'..getUserInfo( GP.Owner or 'بدون صاحب' )..'`\n'
							..'*اطلاعات گروه :*\n'
							..'*تعداد مدیران* : `'..MarkScape( GP.AdminCount or '0' )..'`\n'
							..'*تعداد اعضا* : `'..MarkScape( GP.MembersCount or '0' )..'`\n'
							..'*تعداد لیست سیاه* : `'..MarkScape( GP.Blocked or '0' )..'`\n'
							..'*درباره گروه* : \n`'..MarkScape( GP.About or '' )..'`\n'
							..'*نام گروه* : `'..MarkScape( GP.Title or '' )..'`\n'
							..'*لینک گروه* : `'..MarkScape( GP.GroupLink or 'لینکی موجود نیست' )..'`\n'
							Desc = 'نمایش اطلاعات گروه'
							Title = 'گروه : '..( GP.Title or '' )
							TEXT_Key = 'نمایش تنظیمات'
							TEXT_Start = 'استارت ربات'
							reply_markup = {
								inline_keyboard = {
									{ 	
										{text = 'Edit Group', callback_data = 'settings '.. matches[3]} 
									},
									{ 	
										{text = 'Back', callback_data = 'panel'} 
									},
								}
							}
						else
							TEXT = '*Group* : `'..chat_id..'`\n'
							..'*Owner* : `'..getUserInfo( GP.Owner or 'NoOwner' )..'`\n'
							..'*ChatInfo :*\n'
							..'*Admin Count* : `'..MarkScape( GP.AdminCount or '0' )..'`\n'
							..'*Members Count* : `'..MarkScape( GP.MembersCount or '0' )..'`\n'
							..'*Blocked Count* : `'..MarkScape( GP.Blocked or '0' )..'`\n'
							..'*Group About* : \n`'..MarkScape( GP.About or '' )..'`\n'
							..'*Group Title* : `'..MarkScape( GP.Title or '' )..'`\n'
							..'*Group Link* : `'..MarkScape( GP.GroupLink or '' )..'`\n'
							Desc = 'Show Group Info !'
							Title = 'Group : '..( GP.Title or '' )
							TEXT_Start = 'Start Bot'
							TEXT_Key = 'Edit Group'
							reply_markup = {
							inline_keyboard = {
								{ {text = 'Edit Group', callback_data = 'settings '.. matches[3]} },
								{ {text = 'Back', callback_data = 'panel'} },
							}
						}
						end
						if isSudo(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, { { text = 'Delete And Leave Group', callback_data = 'LeavE '..matches[3] } })
						end
						if isSudo(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, { { text = 'Sharzh Panel', callback_data = 'CHP '..matches[3] } })
						end
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
					end
				end
			end
			--
		end
		end
	end



	return {
	 	HELP = {
			NAME = { 
				fa = 'پنل',
				en = 'Panel !',
				call = 'panel',
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
				'^!#MessageCall (panel)$',
				'^!#MessageCall (charge4) (.*)$',
				'^!#MessageCall (charge3) (.*)$',
				'^!#MessageCall (charge2) (.*)$',
				'^!#MessageCall (charge1) (.*)$',
				'^!#MessageCall (CHP) (.*)$',
				'^!#MessageCall (LeavE) (.*)$',
				'^!#MessageCall (P) (.*)$',
				'^!#MessageCall (P) (.*) (.*)$',


			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}