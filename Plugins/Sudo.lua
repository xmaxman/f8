	
	function Run(msg, matches)
		if #matches > 0 then
			if isSudo(msg.sender_user_id_) then
				if matches[1]:lower() == 'reload' then
					LoadPlugins ()
					return '> `Bot Reloaded Success` !\n*See Logs in* @F80\\_Logs *!*'
				end
				if matches[1]:lower() == 'reloadapi' then
				--	LoadPlugins ()
					cli.sendInline(_Config.ApiUserNAME, msg.chat_id_, msg.id_, 'reload', 0)
				end
			else
				return '> *مقام شما به شما اجازه این کار را نمیدهد !*'
			end
		end
	end

	function Pre(msg)

	end

	function Cron()

	end

	function ApiRun(msg, matches)
		if #matches > 0 then
			if matches[1]:lower() == 'start' then
				if isSudo(msg.from.id) then
					reply_markup = {
						inline_keyboard = {
							{
								{ text = 'باز کردن پنل مدیریت !', callback_data = 'AdminPanel' }
							}
						}
					}
					api.sendMessage(_Config.TOKEN, msg.chat.id, 'شما مدیر هستید !', 'md', reply_markup, msg.message_id, false)
				else
					reply_markup = {
						inline_keyboard = {
							{
								{ text = 'شارژ گروه', callback_data = 'Buy Group' }
							},
							{
								{ text = 'گروه های شما', callback_data = 'My Group' }
							},
							{
								{ text = 'افزودن ربات در گروه', callback_data = 'Add Bot' }
							}
						}
					}
					api.sendMessage(_Config.TOKEN, msg.chat.id, 'سلام !\nخوش آمدید ...\nشما میتوانید از دکمه های زیر استفاده کنید !...', 'md', reply_markup, msg.message_id, false)
				end
			end
			if msg.query then
				if isSudo(msg.from.id) then
					if matches[1]:lower() == 'reload' then
					--	LoadPlugins ()
						RESULTS = {
							{
								type = 'article',
								id = '0',
								description = 'Bot Reloaded !',
								title = 'Reload !',
								input_message_content = {
									message_text = 'برای بارگذاری ربات بر روی دکمه پایین تاچ کنید !',
									parse_mode = 'Markdown',
									disable_web_page_preview = true
								},
								reply_markup = {
									inline_keyboard = {
										{
											{ text='بارگذاری !', callback_data='reload' }
										}
									}
								},
								--thumb_url = '',
							}
						}
						api.answerInlineQuery(_Config.TOKEN, msg.id, JSON.encode(RESULTS), 0, true, 'استارت کردن ربات !', 'start')
					end
				else

				end
			elseif msg.data then
				if isSudo(msg.from.id) then
					if matches[1]:lower() == 'reload' then
						VarDump(msg)
						api.answerCallbackQuery(_Config.TOKEN, msg.id, 'ربات بارگذاری شد !', true)
						LoadPlugins ()
					end
				else
					api.answerCallbackQuery(_Config.TOKEN, msg.id, 'شما دسترسی انجام این کار را ندارید !', true)
				end
			end
		end
	end

	function ApiPre(msg, type)

	end
	return {
	HELP = {
			NAME = { 
				fa = 'Stats',
				en = 'Stats !',
				call = 'stats',
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
				--Patterns :)
				'^[/!#]([Rr]eload)$',
				'^([Rr]eload)$',
				'^[/!#]([Rr]eloadapi)$',
				'^([Rr]eloadapi)$',
			},
	--		Pre = Pre,
			run = Run
		},
		api = {
			_MSG = {
				--Patterns :)
				'!#MessageQuery ([Rr]eload)$',
				'!#MessageCall ([Rr]eload)$',
				--'^([Ss]tart)$',
				--'^[!/#]([Ss]tart)$',
			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'F80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}