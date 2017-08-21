
http = require "socket.http"
StatsGET = function (X)
	if X == 'OK' then
 		return '🗽Allow | آزاد است'
 	elseif X == 'DEL' then
		return '🗑Clean | حذف'
	elseif X == 'WARN' then
		return '⚠️Warn | اخطار'
	else
		return X
	end
end
ChangeStats = function(X, Y)
	
	chat_id = Y
	Stats = X
	GP = redis:hgetall(chat_id)
	if redis:hget(Y, X) == 'OK' then
		NewStats = 'DEL'
	elseif redis:hget(Y, X) == 'DEL' then
		NewStats = 'WARN'
	elseif redis:hget(Y, X) == 'WARN' then
		NewStats = 'OK'
	else
		NewStats = 'DEL'
	end

	redis:hset(Y, Stats, NewStats)
end
	function Run(msg, matches)
		if matches[1] == 'settings' then
			if isMod(msg.sender_user_id_, msg.chat_id_) then
				cli.sendInline(_Config.ApiUserNAME, msg.chat_id_, msg.id_, 'SettingsGroupShowMeButTrue '..(msg.chat_id_ or msg.chat_id_ or msg.to.id or '-100TEST'), 0)
			else
				if (redis:get(user_id..'Lang') or 'fa') == 'fa' then
					return 'دسترسی مجاز نیست !'
				else
					return 'No Access !'
				end
			end
		end
	end
	function ApiRun(msg, matches)
		if #matches > 0 then
			if msg.query then
				if matches[1] == 'SettingsGroupShowMeButTrue' then
						chat_id = matches[2]
						user_id = msg.from.id
						GP = redis:hgetall(chat_id)
						if (redis:get(chat_id..'Lang') or 'fa') == 'fa' then
							TEXT = URL.escape('*گروه* : `'..chat_id..'`\n'
							..'*صاحب* : `'..getUserInfo( GP.Owner or 'بدون صاحب' )..'`\n'
							..'*اطلاعات گروه :*\n'
							..'*تعداد مدیران* : `'..MarkScape( GP.AdminCount or '0' )..'`\n'
							..'*تعداد اعضا* : `'..MarkScape( GP.MembersCount or '0' )..'`\n'
							..'*تعداد لیست سیاه* : `'..MarkScape( GP.Blocked or '0' )..'`\n'
							..'*درباره گروه* : \n`'..MarkScape( GP.About or '' )..'`\n'
							..'*نام گروه* : `'..MarkScape( GP.Title or '' )..'`\n'
							..'*لینک گروه* : `'..MarkScape( GP.GroupLink or 'لینکی موجود نیست' )..'`\n')
							Desc = 'نمایش اطلاعات گروه'
							Title = 'گروه : '..( GP.Title or '' )
							TEXT_Key = 'نمایش تنظیمات'
							TEXT_Start = 'استارت ربات'
						else
							TEXT = URL.escape('*Group* : `'..chat_id..'`\n'
							..'*Owner* : `'..getUserInfo( GP.Owner or 'NoOwner' )..'`\n'
							..'*ChatInfo :*\n'
							..'*Admin Count* : `'..MarkScape( GP.AdminCount or '0' )..'`\n'
							..'*Members Count* : `'..MarkScape( GP.MembersCount or '0' )..'`\n'
							..'*Blocked Count* : `'..MarkScape( GP.Blocked or '0' )..'`\n'
							..'*Group About* : \n`'..MarkScape( GP.About or '' )..'`\n'
							..'*Group Title* : `'..MarkScape( GP.Title or '' )..'`\n'
							..'*Group Link* : `'..MarkScape( GP.GroupLink or '' )..'`\n')
							Desc = 'Show Group Info !'
							Title = 'Group : '..( GP.Title or '' )
							TEXT_Start = 'Start Bot'
							TEXT_Key = 'Edit Group'
						end
						RESULTS = {
							{
								type = 'article',
								id = '0',
								description = Desc,
								title = Title,
								input_message_content = {
									message_text = TEXT,
									parse_mode = 'Markdown',
									disable_web_page_preview = true
								},
								reply_markup = {
									inline_keyboard = {
										{
											{ text = TEXT_Key, callback_data = 'settings '..chat_id }
										}
									}
								},
								--thumb_url = '',
							}
						}
						api.answerInlineQuery(_Config.TOKEN, msg.id, JSON.encode(RESULTS), 0, true, TEXT_Start, 'start')
				end

				if matches[1] == 'Group' then
					if tonumber(msg.from.id) == (301684103) or isMod(msg.from.id, matches[2]) then
						chat_id = matches[2]
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
						end
						RESULTS = {
							{
								type = 'article',
								id = '0',
								description = Desc,
								title = Title,
								input_message_content = {
									message_text = TEXT,
									parse_mode = 'Markdown',
									disable_web_page_preview = true
								},
								reply_markup = {
									inline_keyboard = {
										{
											{ text = TEXT_Key, callback_data = 'settings '..chat_id }
										}
									}
								},
								--thumb_url = '',
							}
						}
						if isSudo(msg.from.id) then
							table.insert(RESULTS.reply_markup.inline_keyboard, { { text = 'Delete And Leave Group', callback_data = 'LeavE '..matches[2] } })
						end
						if isSudo(msg.from.id) then
							table.insert(RESULTS.reply_markup.inline_keyboard, { { text = 'Sharzh Panel', callback_data = 'CHP '..matches[2] } })
						end
						api.answerInlineQuery(_Config.TOKEN, msg.id, JSON.encode(RESULTS), 0, true, TEXT_Start, 'start')
					end
				end
				
			end
			----------------------------------------
			if msg.data then
				if matches[1] == 'Ranks' then
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'مقام ها و لیست ها !'
						keyboard = { 
							inline_keyboard = {
								{ { text = 'لیست مدیران !', callback_data = 'Mods '.. matches[2]} },  
								{ { text = 'لیست سکوت !', callback_data = 'Muted '.. matches[2]} }, 
								{ { text = 'لیست کلمات فیلترشده !', callback_data = 'Filter '.. matches[2]} },  
								{ 
									{ text = 'بازگشت', callback_data = 'settings '..matches[2] }
								}
							} 
						}
					else
						TEXT = 'Ranks And Lists !'
						keyboard = { 
							inline_keyboard = {
								{ { text = 'Mod List !', callback_data = 'Mods '.. matches[2]} },  
								{ { text = 'Muted List !', callback_data = 'Muted '.. matches[2]} }, 
								{ { text = 'Filterd Words !', callback_data = 'Filter '.. matches[2]} }, 
								{ 
									{ text = 'Back', callback_data = 'settings '..matches[2] }
								}
							}
						}
					end

					--------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end
				end
				--------------------------------------
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- Ranks And Lists !
						if matches[1] == 'Mods' then
							if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
								TEXT = 'لیست مدیران گروه !\nبا کلیک بر روی انها از مدیریت گروه خارجشان کنید !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Mods'..matches[2])) do
							    	table.insert(keyboard.inline_keyboard, { { text = 'کاربر : '..getUserInfo(v), callback_data = 'Demote '..v.. ' "'..matches[2]..'"' } })
							    end
							else
								TEXT = 'List Moderators !\nClick to demote each user !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Mods'..matches[2])) do
							    	table.insert(keyboard.inline_keyboard, { { text = 'User : '..getUserInfo(v), callback_data = 'Demote '..v.. ' "'..matches[2]..'"' } })
							    end
							    table.insert(keyboard.inline_keyboard, {{text='Back', callback_data = 'settings '..matches[2]}})
							end
							------------
							if msg.inline_message_id then
								api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
							else
								api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
							end
					end
						end
						if matches[1] == 'Muted' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
								TEXT = 'لیست سکوت گروه !\nبا کلیک روی هر کاربر ایشان را از لیست سکوت خارج کنید !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Muted'..matches[2])) do
							    	table.insert(keyboard.inline_keyboard, { { text = 'کاربر : '..getUserInfo(v), callback_data = 'Unmute '..v.. ' "'..matches[2]..'"' } })
							    end
							else
								TEXT = 'List Muted !\nClick to Unmute each user !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Muted'..matches[2])) do
							    	table.insert(keyboard.inline_keyboard, { { text = 'User : '..getUserInfo(v), callback_data = 'Unmute '..v.. ' "'..matches[2]..'"' } })
							    end
							end
							    table.insert(keyboard.inline_keyboard, {{text='Back', callback_data = 'settings '..matches[2]}})
							------------
							if msg.inline_message_id then
								api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
							else
								api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
							end
						end
					end
						if matches[1] == 'Filter' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
								TEXT = 'لیست کلمات ممنوعه !\nروی کلمه کلیک کنید تا از فیلتر خارج شود !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Filterlist'..matches[2])) do
							    	table.insert(keyboard.inline_keyboard, { { text = (v), callback_data = 'Unfilter '..v.. ' "'..matches[2]..'"' } })
							    end
							else
								TEXT = 'List Filterd Words !\nClick to Unfilter each Word !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Filterlist'..matches[2])) do
							    	table.insert(keyboard.inline_keyboard, { { text = (v), callback_data = 'Unfilter '..v.. ' "'..matches[2]..'"' } })
							    end
							end
							    table.insert(keyboard.inline_keyboard, {{text='Back', callback_data = 'settings '..matches[2]}})
							------------
							if msg.inline_message_id then
								api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
							else
								api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
							end
						end
					end
						----------Doing !
						if matches[1] == 'Demote' then
							if not isMod(msg.from.id, matches[3]) then
								if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
									TEXT = 'دسترسی ممنوع !'
								else
									TEXT = 'No Access !'
								end
								api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
							else

								if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
									TEXT = 'لیست مدیران گروه !\nبا کلیک بر روی انها از مدیریت گروه خارجشان کنید !'
									keyboard = { 
										inline_keyboard = { 
										}
								    }
								    for k,v in pairs(redis:smembers('Mods'..matches[3])) do
								    	table.insert(keyboard.inline_keyboard, { { text = 'کاربر : '..getUserInfo(v), callback_data = 'Demote '..v.. ' "'..matches[3]..'"' } })
								    end
								else
									TEXT = 'List Moderators !\nClick to demote each user !'
									keyboard = { 
										inline_keyboard = { 
										}
								    }
								    for k,v in pairs(redis:smembers('Mods'..matches[3])) do
								    	table.insert(keyboard.inline_keyboard, { { text = 'User : '..getUserInfo(v), callback_data = 'Demote '..v.. ' "'..matches[3]..'"' } })
								    end
								end

							    table.insert(keyboard.inline_keyboard, {{text='Back', callback_data = 'settings '..matches[3]}})
								if msg.inline_message_id then
									api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
								else
									api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
								end
							end
						end
						if matches[1] == 'Unmute' then
							if not isMod(msg.from.id, matches[3]) then
								if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
									TEXT = 'دسترسی ممنوع !'
								else
									TEXT = 'No Access !'
								end
								api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
							else

							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
								TEXT = 'لیست سکوت گروه !\nبا کلیک روی هر کاربر ایشان را از لیست سکوت خارج کنید !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Muted'..matches[3])) do
							    	table.insert(keyboard.inline_keyboard, { { text = 'کاربر : '..getUserInfo(v), callback_data = 'Unmute '..v.. ' "'..matches[3]..'"' } })
							    end
							else
								TEXT = 'List Muted !\nClick to Unmute each user !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Muted'..matches[3])) do
							    	table.insert(keyboard.inline_keyboard, { { text = 'User : '..getUserInfo(v), callback_data = 'Unmute '..v.. ' "'..matches[3]..'"' } })
							    end
							end
							    table.insert(keyboard.inline_keyboard, {{text='Back', callback_data = 'settings '..matches[3]}})
							if msg.inline_message_id then
									api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
								else
									api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
								end
							end
						end
						if matches[1] == 'Unfilter' then
							if not isMod(msg.from.id, matches[3]) then
								if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
									TEXT = 'دسترسی ممنوع !'
								else
									TEXT = 'No Access !'
								end
								api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
							else
								if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
								TEXT = 'لیست کلمات ممنوعه !\nروی کلمه کلیک کنید تا از فیلتر خارج شود !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Filterlist'..matches[3])) do
							    	table.insert(keyboard.inline_keyboard, { { text = (v), callback_data = 'Unfilter '..v.. ' "'..matches[3]..'"' } })
							    end
							else
								TEXT = 'List Filterd Words !\nClick to Unfilter each Word !'
								keyboard = { 
									inline_keyboard = { 
									}
							    }
							    for k,v in pairs(redis:smembers('Filterlist'..matches[3])) do
							    	table.insert(keyboard.inline_keyboard, { { text = (v), callback_data = 'Unfilter '..v.. ' "'..matches[3]..'"' } })
							    end
							end
							    table.insert(keyboard.inline_keyboard, {{text='Back', callback_data = 'settings '..matches[3]}})
							if msg.inline_message_id then
									api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
								else
									api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
								end
							end
						end
					-- Finished :)
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
				--------------------------------------
				if matches[1] == 'PLUS' then
					if not isMod(msg.from.id, matches[3]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						local Y = matches[2]
						local chat_id = matches[3]
						local nownum = Y
						if Y == 'FastMessageCount' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 5)
							if NUM > 9 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error BigNumber !', true)
							else
								redis:hset(chat_id, Y, NUM + 1)	
							end
						end
						if Y == 'FastMessageTime' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 2)
							if NUM > 5 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error BigNumber !', true)
							else
								redis:hset(chat_id, Y, NUM + 1)
							end
						end
						if Y == 'LongCharrC' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 400)
							if NUM > 4999 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error BigNumber !', true)
							else
								redis:hset(chat_id, Y, NUM + 25)
							end
						end
						if Y == 'ShortCharrC' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 2)
							if NUM > 18 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error BigNumber !', true)
							else
								redis:hset(chat_id, Y, NUM + 2)
							end
						end
					--end
					Group = redis:hgetall(matches[3])
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات ترافیک پیام !'
						keyboard = { inline_keyboard = {
							{ 
								{text = 'پیام سریع', callback_data = 'INFO FLOOD '..matches[3]..' F'},
								{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[3]..' F'}
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageTime '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageTime or 2).. ' محدوده زمانی',
									callback_data = 'INFO FastMessageTime '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageTime '..matches[3]..' F'
								},
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageCount '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageCount or 2)..' تعداد',
									callback_data = 'INFO FastMessageCount '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageCount '..matches[3]..' F'
								},
							},
							{ 	
								{text = 'پیام طولانی', callback_data = 'INFO LongCharr '..matches[3]..' F'},
								{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[3]..' F'} 
							},
								
							{ 
								{
									text = '➕',
									callback_data = 'PLUS LongCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.LongCharrC or 500),
									callback_data = 'INFO LongCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL LongCharrC '..matches[3]..' F'
								},
							},

							{ 
								{text = 'پیام کوتاه', callback_data = 'INFO ShortCharr '..matches[3]..' F'},
								{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[3]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS ShortCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.ShortCharrC or 5),
									callback_data = 'INFO ShortCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL ShortCharrC '..matches[3]..' F'
								},
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					else
						TEXT = 'Message Traffic Settings !'
						keyboard = { inline_keyboard = {
							{ 	
								{text = 'FaseMessage', callback_data = 'INFO FLOOD '..matches[3]..' F'},
								{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[3]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageTime '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageTime or 2)..' CheckTime',
									callback_data = 'INFO FastMessageTime '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageTime '..matches[3]..' F'
								},
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageCount '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageCount or 2)..'MessageCount',
									callback_data = 'INFO FastMessageCount '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageCount '..matches[3]..' F'
								},
							},
							{ 	
								{text = 'LongMessage', callback_data = 'INFO LongCharr '..matches[3]..' F'},
								{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[3]..' F'} 
							},
								
							{ 
								{
									text = '➕',
									callback_data = 'PLUS LongCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.LongCharrC or 500),
									callback_data = 'INFO LongCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL LongCharrC '..matches[3]..' F'
								},
							},

							{ 
								{text = 'ShortMessage', callback_data = 'INFO ShortCharr '..matches[3]..' F'},
								{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[3]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS ShortCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.ShortCharrC or 5),
									callback_data = 'INFO ShortCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL ShortCharrC '..matches[3]..' F'
								},
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					end
					--------------------------------------------------------------------------------------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end
					end
				end
				if matches[1] == 'EGUL' then
					if not isMod(msg.from.id, matches[3]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						local Y = matches[2]
						local chat_id = matches[3]
						local nownum = Y
						if Y == 'FastMessageCount' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 5)
							if NUM < 2 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error SmallNumber !', true)
							else
								redis:hset(chat_id, Y, NUM - 1)	
							end
						end
						if Y == 'FastMessageTime' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 2)
							if NUM < 2 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error SmallNumber !', true)
							else
								redis:hset(chat_id, Y, NUM - 1)
							end
						end
						if Y == 'LongCharrC' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 400)
							if NUM < 400 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error SmallNumber !', true)
							else
								redis:hset(chat_id, Y, NUM - 25)
							end
						end
						if Y == 'ShortCharrC' then
						local NUM = tonumber(redis:hget(chat_id, nownum) or 2)
							if NUM < 2 then	
								api.answerCallbackQuery(_Config.TOKEN, msg.id, 'Error SmallNumber !', true)
							else
								redis:hset(chat_id, Y, NUM - 2)
							end
						end
					--end
					Group = redis:hgetall(matches[3])
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات ترافیک پیام !'
						keyboard = { inline_keyboard = {
							{ 
								{text = 'پیام سریع', callback_data = 'INFO FLOOD '..matches[3]..' F'},
								{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[3]..' F'}
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageTime '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageTime or 2).. ' محدوده زمانی',
									callback_data = 'INFO FastMessageTime '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageTime '..matches[3]..' F'
								},
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageCount '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageCount or 2)..' تعداد',
									callback_data = 'INFO FastMessageCount '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageCount '..matches[3]..' F'
								},
							},
							{ 	
								{text = 'پیام طولانی', callback_data = 'INFO LongCharr '..matches[3]..' F'},
								{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[3]..' F'} 
							},
								
							{ 
								{
									text = '➕',
									callback_data = 'PLUS LongCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.LongCharrC or 500),
									callback_data = 'INFO LongCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL LongCharrC '..matches[3]..' F'
								},
							},

							{ 
								{text = 'پیام کوتاه', callback_data = 'INFO ShortCharr '..matches[3]..' F'},
								{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[3]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS ShortCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.ShortCharrC or 5),
									callback_data = 'INFO ShortCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL ShortCharrC '..matches[3]..' F'
								},
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					else
						TEXT = 'Message Traffic Settings !'
						keyboard = { inline_keyboard = {
							{ 	
								{text = 'FaseMessage', callback_data = 'INFO FLOOD '..matches[3]..' F'},
								{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[3]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageTime '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageTime or 2)..' CheckTime',
									callback_data = 'INFO FastMessageTime '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageTime '..matches[3]..' F'
								},
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageCount '..matches[3]..' F'
								},
								{
									text = tostring(Group.FastMessageCount or 2)..'MessageCount',
									callback_data = 'INFO FastMessageCount '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageCount '..matches[3]..' F'
								},
							},
							{ 	
								{text = 'LongMessage', callback_data = 'INFO LongCharr '..matches[3]..' F'},
								{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[3]..' F'} 
							},
								
							{ 
								{
									text = '➕',
									callback_data = 'PLUS LongCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.LongCharrC or 500),
									callback_data = 'INFO LongCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL LongCharrC '..matches[3]..' F'
								},
							},

							{ 
								{text = 'ShortMessage', callback_data = 'INFO ShortCharr '..matches[3]..' F'},
								{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[3]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS ShortCharrC '..matches[3]..' F'
								},
								{
									text = tostring(Group.ShortCharrC or 5),
									callback_data = 'INFO ShortCharrC '..matches[3]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL ShortCharrC '..matches[3]..' F'
								},
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					end
					--------------------------------------------------------------------------------------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end
					end
				end
				---------------
				if matches[1] == 'INFO' then
					if matches[4] == 'M' then
						DSDo = 'settings2'
					elseif matches[4] == 'F' then
						DSDo = 'floods'
					elseif matches[4] == 'D' then
						DSDo = 'MuteList'
					end
					if not isMod(msg.from.id, matches[3]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							keyboard = {
								inline_keyboard = {
									{ 
										{ text = 'بازگشت', callback_data = DSDo..' '..matches[3] }
									}
								}
							}
						else
							keyboard = {
								inline_keyboard = {
									{ 
										{ text = 'Back', callback_data = DSDo..' '..matches[3] }
									}
								}
							}
						end
						if matches[2] == 'FLOOD' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`پیام پشت سر هم !`\n'
								..'*اگر این آپشن قفل باشد هنگامی که یک کاربر پیام های تکراری (اسپم) ارسال کند\nکاربر از گروه اخراج میشود !*'
								..'\n`شما میتوانید تعداد پیام و محدوده زمانی رو تنظیم کنید !`'
							else
								TEXT = '`Flood & Spamming Option !`\n'
								..'*If this option stats be lock SpamMessages (some messages like each other) will be clean and sender will kick!*\n'
								..'`Also You can set the limitation in CheckTime and Check Count !`'
							end
						elseif matches[2] == 'LongCharr' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فیلتر پیام های طولانی !`\n'
								..'*اگر این آپشن قفل باشد هنگامی که کاربر پیامی ارسال میکند که تعداد کاراکترهایش بیش از مقدار تعیید شده شما باشد پیام حذف میشود !*\n'
								..'`شما میتوانید تعداد کاراکتر هارا تنظیم کنید (مضرب 25) !`'
							else
								TEXT = '`Long Messages Filtering !`\n'
								..'*If this option stats be Lock, the messages that Contains more that seted charachters, will delete !*\n'
								..'`Charachters for this option is Selectable !`'
							end
						elseif matches[2] == 'ShortCharr' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فیلتر پیام های کوتاه !`\n'
								..'*اگر این آپشن قفل باشد هنگامی که کاربر پیامی ارسال میکند که تعداد کاراکترهایش کمتر از مقدار تعیید شده شما باشد پیام حذف میشود !*\n'
								..'`شما میتوانید تعداد کاراکتر هارا تنظیم کنید (مضرب 2) !`'
							else
								TEXT = '`Shot Messages Filtering !`\n'
								..'*If this option stats be Lock, the messages that Contains less that seted charachters, will delete !*\n'
								..'`Charachters for this option is Selectable !`'
							end
						elseif matches[2] == 'Link' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فیلتر لینک`\n'
								..'*از این آپشن استفاده کنید تا از ارسال لینک در گروهتان جلوگیری شود !*'
							else
								TEXT = '`Link Filtering !`\n'
								..'*Lock this option to Clean links from your Group !*\n'
							end
						elseif matches[2] == 'Mention' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل فراخوانی !`\n'
								.."*از این آپشن استفاده کنید تا از ارسال تگ(منشن) جلوگیری کنید !*"
							else
								TEXT = '`Lock Mention`\n'
								..'*Use This Option to Avoid sending MentinoName and MentionUsernames !*'
							end
						elseif matches[2] == 'Atsign' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل یوزرنیم !`\n'
								..'*با قفل کردن این آپشن از ارسال {@} یوزرنیم در گروه خود جلوگیری کنید!*'
							else
								TEXT = '`Lock Username!`\n'
								..'*Use This option to Avoid Sending [@]Username in your groups !*'
							end
						elseif matches[2] == 'Hashtag' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`اجبر بودن هستگ !`'
								..'\n*این آپشن را فغال کنید تا پیام های بدون هستگ حذف شوند !*'
							else
								TEXT = '`Mandatory Hashtag`'
								..'\n*Use this option to Aviod sending messages without #Hashtag*'
							end
						elseif matches[2] == 'Persion' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`قفل پارسی !`'
								..'\n*ااز این آپشن برای جلو گیری از ارسال کلمات پارسی استفاده کنید !*'
							else
								TEXT = '`Lock Persian !`'
								..'\n*Use this option to Aviod send Arabic/Persian Charachters !*'
							end
						elseif matches[2] == 'English' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`قفل لاتین !`'
								..'\n*ااز این آپشن برای جلو گیری از ارسال کلمات پارسی انگلیسی کنید !*'
							else
								TEXT = '`Lock English !`'
								..'\n*Use this option to Aviod send English Charachters !*'
							end
						------------------------------------------------------
						elseif matches[2] == 'Edit' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`قفل ویرایش پیام !`'
								..'\n*با این کار از ویرایش پیام جلوگیری کنید !*'
							else
								TEXT = '`Lock Message Edit!`'
								..'\n*Use This option to Avoid Editing Message !*'
							end
						elseif matches[2] == 'Photo' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`قفل ارسال تصویر !`'
								..'\n*از این آپشن برای جلو گیری از ارسال عکس در گروه استفاده کنید !*'
							else
								TEXT = '`Lock Photo !`'
								..'\n*Use this option to Avoid sending Photos !*'
							end
						elseif matches[2] == 'Video' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل فیلم !`'
								..'\n*از این آپشن برای جلوگیری از ارسال فیلم در گروه استفاده کنید !*'
							else
								TEXT = '`Lock Video !`'
								..'\n*Use this option to Avoid sending Videos to Group !*'
							end
						elseif matches[2] == 'ShareNumber' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل اشتراک شماره تلفن!`'
								..'\n*از این آپشن برای جلوگیری از ارسال شماره تلفن استفاده کنید !*'
							else
								TEXT = '`Lock ShareNumber!`'
								..'\n*Use this option to Avoid sending Contacts to your group !*'
							end
						elseif matches[2] == 'Music' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل موسیقی !`'
								..'\n*از این آپشن برای جلوگیری از ارسال موسیقی در گروه استفاده کنید !*'
							else
								TEXT = '`Lock Music!`'
								..'\n*use this option to Avoid sending Musics in group!*'
							end
						elseif matches[2] == 'Voice' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل پیام صوتی !`'
								..'\n*با استفاده از این آپشن از ارسال پیام های صوتی در گروه جلوگیری کنید !*'
							else
								TEXT = '`Lock VoiceMessage!`'
								..'\n*Use this Option to Avoid sendig VoiceMessages to Group !*'
							end
						elseif matches[2] == 'Location' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل اشتراک مکان!`'
								..'\n*ار این آپشن برای جلوگیری از ارسال لوکیشن استفاده کنید !*'
							else
								TEXT = '`Lock Location !`'
								..'\n*Use this Option to Avoid Sending LocationMessage to Group !*'
							end
						elseif matches[2] == 'Animation' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`قفل تصویر متحرک!`'
								..'\n*ار این آپشن برای جلوگیری از ارسال تصویر متخرک استفاده کنید !*'
							else
								TEXT = '`Lock Animation!`'
								..'\n*Use this option to avoid sending Animation/Gifs to Group !*'
							end
						elseif matches[2] == 'Sticker' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '`فقل برچسب(استیکر)!`'
								..'\n* از این آپشن برای جلو گیری از ارسال برچسسب (استیکر) استفاده کنید !*'
							else
								TEXT = '` !`'
								..'\n*Use this option to Avoid sending Stickers to Group!*'
							end
						elseif matches[2] == 'Game' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '` !`'
								..'\n* !*'
							else
								TEXT = '` !`'
								..'\n* !*'
							end
						elseif matches[2] == 'Inline' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '` !`'
								..'\n* !*'
							else
								TEXT = '` !`'
								..'\n* !*'
							end
						elseif matches[2] == 'Keyboard' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '` !`'
								..'\n* !*'
							else
								TEXT = '` !`'
								..'\n* !*'
							end
						elseif matches[2] == 'Document' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '` !`'
								..'\n* !*'
							else
								TEXT = '` !`'
								..'\n* !*'
							end
						elseif matches[2] == 'Media' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '` !`'
								..'\n* !*'
							else
								TEXT = '` !`'
								..'\n* !*'
							end
						elseif matches[2] == 'Webpage' then
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								TEXT = '` !`'
								..'\n* !*'
							else
								TEXT = '` !`'
								..'\n* !*'
							end
						--------------------------------------------------
						else
							TEXT = 'Error!\n No Text Seted For This Option !'
						end
						--------------
						if msg.inline_message_id then
							api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
						else
							api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
						end
					end
				end
				------------------------------------------
				if matches[1] == 'settings' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
						TEXT = 'از دکمه ها استفاده کنید !'
						keyboard2 = {
							inline_keyboard = {
								{ 
									{ text = 'پیام های رسانه ای', callback_data = 'MuteList '..matches[2] },
								},
								{
									{ text = 'قفل های پیام', callback_data = 'settings2 '..matches[2] },
								},
								{
									{ text = 'پیام های سریع', callback_data = 'floods '..matches[2] }
								},
								{ 
									{ text = 'مقام های گروه', callback_data = 'Ranks '..matches[2] }
								},
								{ 
									{ text = 'بازگشت ', callback_data = 'P GP '..matches[2] }
								}
							}
						}
					else
						TEXT = 'Use On of buttems !'
						keyboard2 = {
							inline_keyboard = {
								{ 
									{ text = 'MuteList', callback_data = 'MuteList '..matches[2] },
									{ text = 'Locks', callback_data = 'settings2 '..matches[2] },
									{ text = 'Floods', callback_data = 'floods '..matches[2] }
								},
								{ 
									{ text = 'Group Ranks', callback_data = 'Ranks '..matches[2] }
								},
								{ 
									{ text = 'Back', callback_data = 'P GP '..matches[2] }
								}
							}
						}						
					end
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard2)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard2)
					end
				end
				end
				if matches[1] == 'floods' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						
					--end
					Group = redis:hgetall(matches[2])
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات ترافیک پیام !'
						keyboard = { inline_keyboard = {
							{ 
								{text = 'پیام سریع', callback_data = 'INFO FLOOD '..matches[2]..' F'},
								{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[2]..' F'}
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageTime '..matches[2]..' F'
								},
								{
									text = tostring(Group.FastMessageTime or 2).. ' محدوده زمانی',
									callback_data = 'INFO FastMessageTime '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageTime '..matches[2]..' F'
								},
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageCount '..matches[2]..' F'
								},
								{
									text = tostring(Group.FastMessageCount or 2)..' تعداد',
									callback_data = 'INFO FastMessageCount '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageCount '..matches[2]..' F'
								},
							},
							{ 	
								{text = 'پیام طولانی', callback_data = 'INFO LongCharr '..matches[2]..' F'},
								{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[2]..' F'} 
							},
								
							{ 
								{
									text = '➕',
									callback_data = 'PLUS LongCharrC '..matches[2]..' F'
								},
								{
									text = tostring(Group.LongCharrC or 500),
									callback_data = 'INFO LongCharrC '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL LongCharrC '..matches[2]..' F'
								},
							},

							{ 
								{text = 'پیام کوتاه', callback_data = 'INFO ShortCharr '..matches[2]..' F'},
								{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[2]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS ShortCharrC '..matches[2]..' F'
								},
								{
									text = tostring(Group.ShortCharrC or 5),
									callback_data = 'INFO ShortCharrC '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL ShortCharrC '..matches[2]..' F'
								},
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[2] }
							}
						} }
					else
						TEXT = 'Message Traffic Settings !'
						keyboard = { inline_keyboard = {
							{ 	
								{text = 'FaseMessage', callback_data = 'INFO FLOOD '..matches[2]..' F'},
								{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[2]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageTime '..matches[2]..' F'
								},
								{
									text = tostring(Group.FastMessageTime or 2)..' CheckTime',
									callback_data = 'INFO FastMessageTime '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageTime '..matches[2]..' F'
								},
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS FastMessageCount '..matches[2]..' F'
								},
								{
									text = tostring(Group.FastMessageCount or 2)..'MessageCount',
									callback_data = 'INFO FastMessageCount '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL FastMessageCount '..matches[2]..' F'
								},
							},
							{ 	
								{text = 'LongMessage', callback_data = 'INFO LongCharr '..matches[2]..' F'},
								{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[2]..' F'} 
							},
								
							{ 
								{
									text = '➕',
									callback_data = 'PLUS LongCharrC '..matches[2]..' F'
								},
								{
									text = tostring(Group.LongCharrC or 500),
									callback_data = 'INFO LongCharrC '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL LongCharrC '..matches[2]..' F'
								},
							},

							{ 
								{text = 'ShortMessage', callback_data = 'INFO ShortCharr '..matches[2]..' F'},
								{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[2]..' F'} 
							},
							{ 
								{
									text = '➕',
									callback_data = 'PLUS ShortCharrC '..matches[2]..' F'
								},
								{
									text = tostring(Group.ShortCharrC or 5),
									callback_data = 'INFO ShortCharrC '..matches[2]..' F'
								},
								{
									text = '➖',
									callback_data = 'EGUL ShortCharrC '..matches[2]..' F'
								},
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[2] }
							}
						} }
					end
					--------------------------------------------------------------------------------------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end
					end
				end
				if matches[1] == 'settings2' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						
					--end
					Group = redis:hgetall(matches[2])
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات پیام !'
						keyboard = { inline_keyboard = {
							{ 	
								{ text = 'پیوند🖇', callback_data = 'INFO Link '..matches[2]..' M' },
								{ text = StatsGET(Group.Link or 'OK'), callback_data = 'Change Link '.. matches[2]..' M' } 
							},
							{ 
								{ text = 'فراخوانی(منشن)🔊', callback_data = 'INFO Mention '..matches[2]..' M' },
								{ text = StatsGET(Group.Mention or 'OK'), callback_data = 'Change Mention '.. matches[2] ..' M'}
							},
							{ 
								{ text = 'یوزرنیم🌀', callback_data = 'INFO Atsign '..matches[2]..' M' },
								{ text = StatsGET(Group.Atsign or 'OK'), callback_data = 'Change Atsign '.. matches[2]..' M' }
							},
							{ 
								{ text = 'هشتگ#️⃣', callback_data = 'INFO Hashtag '..matches[2]..' M' },
								{ text = StatsGET(Group.Hashtag or 'OK'), callback_data = 'Change Hashtag '.. matches[2]..' M' }
							},
							{ 
								{ text = 'لاتین🇬🇧', callback_data = 'INFO English '..matches[2]..' M' },
								{ text = StatsGET(Group.English or 'OK'), callback_data = 'Change English '.. matches[2]..' M' }
							},
							{ 
								{ text = 'پارسی🇮🇷', callback_data = 'INFO Persion '..matches[2]..' M' },
								{ text = StatsGET(Group.Persion or 'OK'), callback_data = 'Change Persion '.. matches[2]..' M' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[2] }
							}
						} }
					else
						TEXT = 'Message Settings !'
						keyboard = { inline_keyboard = {
							{ 	
								{ text = 'Link 🖇', callback_data = 'INFO Link '..matches[2]..' M' },
								{ text = StatsGET(Group.Link or 'OK'), callback_data = 'Change Link '.. matches[2]..' M' } 
							},
							{ 
								{ text = 'Mention🔊', callback_data = 'INFO Mention '..matches[2]..' M' },
								{ text = StatsGET(Group.Mention or 'OK'), callback_data = 'Change Mention '.. matches[2]..' M' }
							},
							{ 
								{ text = 'Username🌀', callback_data = 'INFO Atsign '..matches[2]..' M' },
								{ text = StatsGET(Group.Atsign or 'OK'), callback_data = 'Change Atsign '.. matches[2]..' M' }
							},
							{ 
								{ text = 'Hashtag#️⃣', callback_data = 'INFO Hashtag '..matches[2]..' M' },
								{ text = StatsGET(Group.Hashtag or 'OK'), callback_data = 'Change Hashtag '.. matches[2]..' M' }
							},
							{ 
								{ text = 'English Words🇬🇧', callback_data = 'INFO English '..matches[2]..' M' },
								{ text = StatsGET(Group.English or 'OK'), callback_data = 'Change English '.. matches[2]..' M' }
							},
							{ 
								{ text = 'Persian🇮🇷', callback_data = 'INFO Persion '..matches[2]..' M' },
								{ text = StatsGET(Group.Persion or 'OK'), callback_data = 'Change Persion '.. matches[2] ..' M' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[2] }
							}
						} }
					end
					-------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end	
					end			
				end
				if matches[1] == 'MuteList' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						
					--end
					Group = redis:hgetall(matches[2])
					if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات مدیا !'
						keyboard = { inline_keyboard = {
							{ 
								{ text = 'ویرایش پیام'..'🖊', callback_data = 'INFO Edit '..matches[2] ..' D' },
								{ text = StatsGET(Group.Edit or 'OK'), callback_data = 'Change Edit '..matches[2] ..' D' }
							},
							{ 
								{ text = 'تصویر'..'🖼', callback_data = 'INFO Photo '..matches[2] ..' D' },
								{ text = StatsGET(Group.Photo or 'OK'), callback_data = 'Change Photo '..matches[2] ..' D' }
							},
							{ 
								{ text = 'فیلم'..'📽', callback_data = 'INFO Video '..matches[2] ..' D' },
								{ text = StatsGET(Group.Video or 'OK'), callback_data = 'Change Video '..matches[2] ..' D' }
							},
							{ 
								{ text = 'اشتراک شماره'..'☎️', callback_data = 'INFO ShareNumber '..matches[2] ..' D' },
								{ text = StatsGET(Group.ShareNumber or 'OK'), callback_data = 'Change ShareNumber '..matches[2] ..' D' }
							},
							{ 
								{ text = 'موسیقی'..'🎶', callback_data = 'INFO Music '..matches[2] ..' D' },
								{ text = StatsGET(Group.Music or 'OK'), callback_data = 'Change Music '..matches[2] ..' D' }
							},
							{ 
								{ text = 'پیام صوتی'..'🎤', callback_data = 'INFO Voice '..matches[2] ..' D' },
								{ text = StatsGET(Group.Voice or 'OK'), callback_data = 'Change Voice '..matches[2] ..' D' }
							},
							{ 
								{ text = 'اشتراک مکان'..'📌', callback_data = 'INFO Location '..matches[2] ..' D' },
								{ text = StatsGET(Group.Location or 'OK'), callback_data = 'Change Location '..matches[2] ..' D' }
							},
							{ 
								{ text = 'تصویر متحرک'..'🎞', callback_data = 'INFO Animation '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Animation or 'OK'), callback_data = 'Change Animation '..matches[2] ..' D' }
							},
							{ 
								{ text = 'برچسب(استیکر)'..'🎫', callback_data = 'INFO Sticker '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Sticker or 'OK'), callback_data = 'Change Sticker '..matches[2] ..' D' }
							},
							{ 
								{ text = 'بازی(@Gamee)'..'🎮', callback_data = 'INFO Game '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Game or 'OK'), callback_data = 'Change Game '..matches[2] ..' D' }
							},
							{ 
								{ text = 'درون خطی'..'➿', callback_data = 'INFO Inline '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Inline or 'OK'), callback_data = 'Change Inline '..matches[2] ..' D' }
							},
							{ 
								{ text = 'کیبورد شیشه ای'..'⌨️', callback_data = 'INFO Keyboard '..matches[2] ..' D' },
								{ text = StatsGET(Group.Keyboard or 'OK'), callback_data = 'Change Keyboard '..matches[2] ..' D' }
							},
							{ 
								{ text = 'فایل'..'📂', callback_data = 'INFO File '..matches[2] ..' D' },
								{ text = StatsGET(Group.File or 'OK'), callback_data = 'Change File '..matches[2] ..' D' }
							},
							{ 
								{ text = 'رسانه(پیام غیر متنی)'..'📺', callback_data = 'INFO Media '..matches[2] },
								{ text = StatsGET(Group.Media or 'OK'), callback_data = 'Change Media '..matches[2] ..' D' }
							},
							{ 
								{ text = 'صفحه وب'..'🔗', callback_data = 'INFO Webpage '..matches[2] ..' D' },
								{ text = StatsGET(Group.Webpage or 'OK'), callback_data = 'Change Webpage '..matches[2] ..' D' }
							},
							{ 
								{ text = 'فوروارد '..'🔗', callback_data = 'INFO Forward '..matches[2] ..' D' },
								{ text = StatsGET(Group.Forward or 'OK'), callback_data = 'Change Forward '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[2] }
							}
						} }
					else
						TEXT = 'تنظیمات مدیا !'
						keyboard = { inline_keyboard = {
							{ 
								{ text = 'Edit Message'..'🖊', callback_data = 'INFO Edit '..matches[2] ..' D' },
								{ text = StatsGET(Group.Edit or 'OK'), callback_data = 'Change Edit '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Photo'..'🖼', callback_data = 'INFO Photo '..matches[2] ..' D' },
								{ text = StatsGET(Group.Photo or 'OK'), callback_data = 'Change Photo '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Video'..'📽', callback_data = 'INFO Video '..matches[2] ..' D' },
								{ text = StatsGET(Group.Video or 'OK'), callback_data = 'Change Video '..matches[2] ..' D' }
							},
							{ 
								{ text = 'ShareNumber'..'☎️', callback_data = 'INFO ShareNumber '..matches[2] ..' D' },
								{ text = StatsGET(Group.ShareNumber or 'OK'), callback_data = 'Change ShareNumber '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Musics'..'🎶', callback_data = 'INFO Music '..matches[2] ..' D' },
								{ text = StatsGET(Group.Music or 'OK'), callback_data = 'Change Music '..matches[2] ..' D' }
							},
							{ 
								{ text = 'VoiceMessage'..'🎤', callback_data = 'INFO Voice '..matches[2] ..' D' },
								{ text = StatsGET(Group.Voice or 'OK'), callback_data = 'Change Voice '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Location'..'📌', callback_data = 'INFO Location '..matches[2] ..' D' },
								{ text = StatsGET(Group.Location or 'OK'), callback_data = 'Change Location '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Animation/Gifs'..'🎞', callback_data = 'INFO Animation '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Animation or 'OK'), callback_data = 'Change Animation '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Sticker'..'🎫', callback_data = 'INFO Sticker '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Sticker or 'OK'), callback_data = 'Change Sticker '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Inline Game'..'🎮', callback_data = 'INFO Game '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Game or 'OK'), callback_data = 'Change Game '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Inline'..'➿', callback_data = 'INFO Inline '..matches[2]  ..' D'},
								{ text = StatsGET(Group.Inline or 'OK'), callback_data = 'Change Inline '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Glass Keyboard'..'⌨️', callback_data = 'INFO Keyboard '..matches[2] ..' D' },
								{ text = StatsGET(Group.Keyboard or 'OK'), callback_data = 'Change Keyboard '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Document'..'📂', callback_data = 'INFO File '..matches[2] ..' D' },
								{ text = StatsGET(Group.File or 'OK'), callback_data = 'Change File '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Media(Non Text Messages)'..'📺', callback_data = 'INFO Media '..matches[2] },
								{ text = StatsGET(Group.Media or 'OK'), callback_data = 'Change Media '..matches[2] ..' D' }
							},
							{ 
								{ text = 'WebPage'..'🔗', callback_data = 'INFO Webpage '..matches[2] ..' D' },
								{ text = StatsGET(Group.Webpage or 'OK'), callback_data = 'Change Webpage '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Forward '..'🔗', callback_data = 'INFO Forward '..matches[2] ..' D' },
								{ text = StatsGET(Group.Forward or 'OK'), callback_data = 'Change Forward '..matches[2] ..' D' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[2] }
							}
						} }
					end
					------------------------------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end	
					end			
				end
				if matches[1] == 'Ranks' then
					if not isMod(msg.from.id, matches[2]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
						
					--end
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end
					end
				end
				if matches[1] == 'Change' then
					if not isMod(msg.from.id, matches[3]) then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							TEXT = 'دسترسی ممنوع !'
						else
							TEXT = 'No Access !'
						end
						api.answerCallbackQuery(_Config.TOKEN, msg.id, TEXT, true)
					else
------------------------------------------------------------
					chat_id = matches[3]
					ChangeStats(matches[2], chat_id)
					Group = redis:hgetall(matches[3])
					if matches[4] == 'F' then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
							TEXT = 'تنظیمات ترافیک پیام !'
							keyboard = { inline_keyboard = {
								{ 
									{text = 'پیام سریع', callback_data = 'INFO FLOOD '..matches[3]..' F'},
									{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[3]..' F'}
								},
								{ 
									{
										text = '➕',
										callback_data = 'PLUS FastMessageTime '..matches[3]..' F'
									},
									{
										text = tostring(Group.FastMessageTime or 2).. ' محدوده زمانی',
										callback_data = 'INFO FastMessageTime '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL FastMessageTime '..matches[3]..' F'
									},
								},
								{ 
									{
										text = '➕',
										callback_data = 'PLUS FastMessageCount '..matches[3]..' F'
									},
									{
										text = tostring(Group.FastMessageCount or 2)..' تعداد',
										callback_data = 'INFO FastMessageCount '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL FastMessageCount '..matches[3]..' F'
									},
								},
								{ 	
									{text = 'پیام طولانی', callback_data = 'INFO LongCharr '..matches[3]..' F'},
									{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[3]..' F'} 
								},
									
								{ 
									{
										text = '➕',
										callback_data = 'PLUS LongCharrC '..matches[3]..' F'
									},
									{
										text = tostring(Group.LongCharrC or 500),
										callback_data = 'INFO LongCharrC '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL LongCharrC '..matches[3]..' F'
									},
								},
	
								{ 
									{text = 'پیام کوتاه', callback_data = 'INFO ShortCharr '..matches[3]..' F'},
									{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[3]..' F'} 
								},
								{ 
									{
										text = '➕',
										callback_data = 'PLUS ShortCharrC '..matches[3]..' F'
									},
									{
										text = tostring(Group.ShortCharrC or 5),
										callback_data = 'INFO ShortCharrC '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL ShortCharrC '..matches[3]..' F'
									},
								},
								{ 
									{ text = 'Back', callback_data = 'settings '..matches[3] }
								}
							} }
						else
							TEXT = 'Message Traffic Settings !'
							keyboard = { inline_keyboard = {
								{ 	
									{text = 'FaseMessage', callback_data = 'INFO FLOOD '..matches[3]..' F'},
									{text = StatsGET(Group.FastMessage or 'OK'), callback_data = 'Change FastMessage '..matches[3]..' F'} 
								},
								{ 
									{
										text = '➕',
										callback_data = 'PLUS FastMessageTime '..matches[3]..' F'
									},
									{
										text = tostring(Group.FastMessageTime or 2)..' CheckTime',
										callback_data = 'INFO FastMessageTime '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL FastMessageTime '..matches[3]..' F'
									},
								},
								{ 
									{
										text = '➕',
										callback_data = 'PLUS FastMessageCount '..matches[3]..' F'
									},
									{
										text = tostring(Group.FastMessageCount or 2)..'MessageCount',
										callback_data = 'INFO FastMessageCount '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL FastMessageCount '..matches[3]..' F'
									},
								},
								{ 	
									{text = 'LongMessage', callback_data = 'INFO LongCharr '..matches[3]..' F'},
									{text = StatsGET(Group.LongCharr or 'OK'), callback_data = 'Change LongCharr '..matches[3]..' F'} 
								},
									
								{ 
									{
										text = '➕',
										callback_data = 'PLUS LongCharrC '..matches[3]..' F'
									},
									{
										text = tostring(Group.LongCharrC or 500),
										callback_data = 'INFO LongCharrC '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL LongCharrC '..matches[3]..' F'
									},
								},
	
								{ 
									{text = 'ShortMessage', callback_data = 'INFO ShortCharr '..matches[3]..' F'},
									{text = StatsGET(Group.ShortCharr or 'OK'), callback_data = 'Change ShortCharr '..matches[3]..' F'} 
								},
								{ 
									{
										text = '➕',
										callback_data = 'PLUS ShortCharrC '..matches[3]..' F'
									},
									{
										text = tostring(Group.ShortCharrC or 5),
										callback_data = 'INFO ShortCharrC '..matches[3]..' F'
									},
									{
										text = '➖',
										callback_data = 'EGUL ShortCharrC '..matches[3]..' F'
									},
								},
								{ 
									{ text = 'Back', callback_data = 'settings '..matches[3] }
								}
							} }
						end
					elseif matches[4] == 'D' then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات مدیا !'
						keyboard = { inline_keyboard = {
							{ 
								{ text = 'ویرایش پیام'..'🖊', callback_data = 'INFO Edit '..matches[3] ..' D' },
								{ text = StatsGET(Group.Edit or 'OK'), callback_data = 'Change Edit '..matches[3] ..' D' }
							},
							{ 
								{ text = 'تصویر'..'🖼', callback_data = 'INFO Photo '..matches[3] ..' D' },
								{ text = StatsGET(Group.Photo or 'OK'), callback_data = 'Change Photo '..matches[3] ..' D' }
							},
							{ 
								{ text = 'فیلم'..'📽', callback_data = 'INFO Video '..matches[3] ..' D' },
								{ text = StatsGET(Group.Video or 'OK'), callback_data = 'Change Video '..matches[3] ..' D' }
							},
							{ 
								{ text = 'اشتراک شماره'..'☎️', callback_data = 'INFO ShareNumber '..matches[3] ..' D' },
								{ text = StatsGET(Group.ShareNumber or 'OK'), callback_data = 'Change ShareNumber '..matches[3] ..' D' }
							},
							{ 
								{ text = 'موسیقی'..'🎶', callback_data = 'INFO Music '..matches[3] ..' D' },
								{ text = StatsGET(Group.Music or 'OK'), callback_data = 'Change Music '..matches[3] ..' D' }
							},
							{ 
								{ text = 'پیام صوتی'..'🎤', callback_data = 'INFO Voice '..matches[3] ..' D' },
								{ text = StatsGET(Group.Voice or 'OK'), callback_data = 'Change Voice '..matches[3] ..' D' }
							},
							{ 
								{ text = 'اشتراک مکان'..'📌', callback_data = 'INFO Location '..matches[3] ..' D' },
								{ text = StatsGET(Group.Location or 'OK'), callback_data = 'Change Location '..matches[3] ..' D' }
							},
							{ 
								{ text = 'تصویر متحرک'..'🎞', callback_data = 'INFO Animation '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Animation or 'OK'), callback_data = 'Change Animation '..matches[3] ..' D' }
							},
							{ 
								{ text = 'برچسب(استیکر)'..'🎫', callback_data = 'INFO Sticker '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Sticker or 'OK'), callback_data = 'Change Sticker '..matches[3] ..' D' }
							},
							{ 
								{ text = 'بازی(@Gamee)'..'🎮', callback_data = 'INFO Game '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Game or 'OK'), callback_data = 'Change Game '..matches[3] ..' D' }
							},
							{ 
								{ text = 'درون خطی'..'➿', callback_data = 'INFO Inline '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Inline or 'OK'), callback_data = 'Change Inline '..matches[3] ..' D' }
							},
							{ 
								{ text = 'کیبورد شیشه ای'..'⌨️', callback_data = 'INFO Keyboard '..matches[3] ..' D' },
								{ text = StatsGET(Group.Keyboard or 'OK'), callback_data = 'Change Keyboard '..matches[3] ..' D' }
							},
							{ 
								{ text = 'فایل'..'📂', callback_data = 'INFO File '..matches[3] ..' D' },
								{ text = StatsGET(Group.File or 'OK'), callback_data = 'Change File '..matches[3] ..' D' }
							},
							{ 
								{ text = 'رسانه(پیام غیر متنی)'..'📺', callback_data = 'INFO Media '..matches[3] },
								{ text = StatsGET(Group.Media or 'OK'), callback_data = 'Change Media '..matches[3] ..' D' }
							},
							{ 
								{ text = 'صفحه وب'..'🔗', callback_data = 'INFO Webpage '..matches[3] ..' D' },
								{ text = StatsGET(Group.Webpage or 'OK'), callback_data = 'Change Webpage '..matches[3] ..' D' }
							},
							{ 
								{ text = 'فوروارد '..'🔗', callback_data = 'INFO Forward '..matches[3] ..' D' },
								{ text = StatsGET(Group.Forward or 'OK'), callback_data = 'Change Forward '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					else
						TEXT = 'تنظیمات مدیا !'
						keyboard = { inline_keyboard = {
							{ 
								{ text = 'Edit Message'..'🖊', callback_data = 'INFO Edit '..matches[3] ..' D' },
								{ text = StatsGET(Group.Edit or 'OK'), callback_data = 'Change Edit '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Photo'..'🖼', callback_data = 'INFO Photo '..matches[3] ..' D' },
								{ text = StatsGET(Group.Photo or 'OK'), callback_data = 'Change Photo '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Video'..'📽', callback_data = 'INFO Video '..matches[3] ..' D' },
								{ text = StatsGET(Group.Video or 'OK'), callback_data = 'Change Video '..matches[3] ..' D' }
							},
							{ 
								{ text = 'ShareNumber'..'☎️', callback_data = 'INFO ShareNumber '..matches[3] ..' D' },
								{ text = StatsGET(Group.ShareNumber or 'OK'), callback_data = 'Change ShareNumber '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Musics'..'🎶', callback_data = 'INFO Music '..matches[3] ..' D' },
								{ text = StatsGET(Group.Music or 'OK'), callback_data = 'Change Music '..matches[3] ..' D' }
							},
							{ 
								{ text = 'VoiceMessage'..'🎤', callback_data = 'INFO Voice '..matches[3] ..' D' },
								{ text = StatsGET(Group.Voice or 'OK'), callback_data = 'Change Voice '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Location'..'📌', callback_data = 'INFO Location '..matches[3] ..' D' },
								{ text = StatsGET(Group.Location or 'OK'), callback_data = 'Change Location '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Animation/Gifs'..'🎞', callback_data = 'INFO Animation '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Animation or 'OK'), callback_data = 'Change Animation '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Sticker'..'🎫', callback_data = 'INFO Sticker '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Sticker or 'OK'), callback_data = 'Change Sticker '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Inline Game'..'🎮', callback_data = 'INFO Game '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Game or 'OK'), callback_data = 'Change Game '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Inline'..'➿', callback_data = 'INFO Inline '..matches[3]  ..' D'},
								{ text = StatsGET(Group.Inline or 'OK'), callback_data = 'Change Inline '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Glass Keyboard'..'⌨️', callback_data = 'INFO Keyboard '..matches[3] ..' D' },
								{ text = StatsGET(Group.Keyboard or 'OK'), callback_data = 'Change Keyboard '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Document'..'📂', callback_data = 'INFO File '..matches[3] ..' D' },
								{ text = StatsGET(Group.File or 'OK'), callback_data = 'Change File '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Media(Non Text Messages)'..'📺', callback_data = 'INFO Media '..matches[3] },
								{ text = StatsGET(Group.Media or 'OK'), callback_data = 'Change Media '..matches[3] ..' D' }
							},
							{ 
								{ text = 'WebPage'..'🔗', callback_data = 'INFO Webpage '..matches[3] ..' D' },
								{ text = StatsGET(Group.Webpage or 'OK'), callback_data = 'Change Webpage '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Forward '..'🔗', callback_data = 'INFO Forward '..matches[3] ..' D' },
								{ text = StatsGET(Group.Forward or 'OK'), callback_data = 'Change Forward '..matches[3] ..' D' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					end
					elseif matches[4] == 'M' then
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then 
						TEXT = 'تنظیمات پیام !'
						keyboard = { inline_keyboard = {
							{ 	
								{ text = 'پیوند🖇', callback_data = 'INFO Link '..matches[3]..' M' },
								{ text = StatsGET(Group.Link or 'OK'), callback_data = 'Change Link '.. matches[3]..' M' } 
							},
							{ 
								{ text = 'فراخوانی(منشن)🔊', callback_data = 'INFO Mention '..matches[3]..' M' },
								{ text = StatsGET(Group.Mention or 'OK'), callback_data = 'Change Mention '.. matches[3] ..' M'}
							},
							{ 
								{ text = 'یوزرنیم🌀', callback_data = 'INFO Atsign '..matches[3]..' M' },
								{ text = StatsGET(Group.Atsign or 'OK'), callback_data = 'Change Atsign '.. matches[3]..' M' }
							},
							{ 
								{ text = 'هشتگ#️⃣', callback_data = 'INFO Hashtag '..matches[3]..' M' },
								{ text = StatsGET(Group.Hashtag or 'OK'), callback_data = 'Change Hashtag '.. matches[3]..' M' }
							},
							{ 
								{ text = 'لاتین🇬🇧', callback_data = 'INFO English '..matches[3]..' M' },
								{ text = StatsGET(Group.English or 'OK'), callback_data = 'Change English '.. matches[3]..' M' }
							},
							{ 
								{ text = 'پارسی🇮🇷', callback_data = 'INFO Persion '..matches[3]..' M' },
								{ text = StatsGET(Group.Persion or 'OK'), callback_data = 'Change Persion '.. matches[3]..' M' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					else
						TEXT = 'Message Settings !'
						keyboard = { inline_keyboard = {
							{ 	
								{ text = 'Link 🖇', callback_data = 'INFO Link '..matches[3]..' M' },
								{ text = StatsGET(Group.Link or 'OK'), callback_data = 'Change Link '.. matches[3]..' M' } 
							},
							{ 
								{ text = 'Mention🔊', callback_data = 'INFO Mention '..matches[3]..' M' },
								{ text = StatsGET(Group.Mention or 'OK'), callback_data = 'Change Mention '.. matches[3]..' M' }
							},
							{ 
								{ text = 'Username🌀', callback_data = 'INFO Atsign '..matches[3]..' M' },
								{ text = StatsGET(Group.Atsign or 'OK'), callback_data = 'Change Atsign '.. matches[3]..' M' }
							},
							{ 
								{ text = 'Hashtag#️⃣', callback_data = 'INFO Hashtag '..matches[3]..' M' },
								{ text = StatsGET(Group.Hashtag or 'OK'), callback_data = 'Change Hashtag '.. matches[3]..' M' }
							},
							{ 
								{ text = 'English Words🇬🇧', callback_data = 'INFO English '..matches[3]..' M' },
								{ text = StatsGET(Group.English or 'OK'), callback_data = 'Change English '.. matches[3]..' M' }
							},
							{ 
								{ text = 'Persian🇮🇷', callback_data = 'INFO Persion '..matches[3]..' M' },
								{ text = StatsGET(Group.Persion or 'OK'), callback_data = 'Change Persion '.. matches[3] ..' M' }
							},
							{ 
								{ text = 'Back', callback_data = 'settings '..matches[3] }
							}
						} }
					end
					end
				---------------------------------
					if msg.inline_message_id then
						api.editMessageTextII(_Config.TOKEN, msg.inline_message_id, TEXT, 'md', keyboard)
					else
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
					end
				end
				
---------------------------------

				end
			end
		end
	end



	return {
		HELP = {
			NAME = { 
				fa = 'تنظیمات',
				en = 'Settings!',
				call = 'settings',
			},
			Dec = {
				fa = 'تنظیمات گروه',
				en = 'Group Settings',
			},
			Usage = {
				fa = '`Settings` : دریافت تنظیمات گروه',
				en = '`Settings` : Get Group Info And Options',
			},
			rank = 'Mod',
		},
		cli = {
			_MSG = {
				'^([Ss]ettings)$',
				'^[/!#]([Ss]ettings)$',
			},
	--		Pre = Pre,
			run = Run
		},
		api = {
			_MSG = {
				'^!#MessageCall (settings) (.*)$',
				'^!#MessageCall (Filter) (.*)$',
				'^!#MessageCall (Unfilter) (.*) "(.*)"$',
				'^!#MessageCall (Unmute) (.*) "(.*)"$',
				'^!#MessageCall (Demote) (.*) "(.*)"$',
				'^!#MessageCall (Muted) (.*)$',
				'^!#MessageCall (Mods) (.*)$',
				'^!#MessageQuery (SettingsGroupShowMeButTrue) (.*)$',
				'^!#MessageQuery (Group) (.*)$',
				'^!#MessageCall (settings2) (.*)$',
				'^!#MessageCall (Ranks) (.*)$',
				'^!#MessageCall (MuteList) (.*)$',
				'^!#MessageCall (floods) (.*)$',
				'^!#MessageCall (Change) (%S+) (%S+) ([MFD])$',
				'^!#MessageCall (INFO) (%S+) (%S+) ([MFD])$',
				'^!#MessageCall (PLUS) (.*) (.*) F$',
				'^!#MessageCall (EGUL) (.*) (.*) F$',

			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}