	
	function Run(msg, matches)
		if #matches > 1 then
		if matches[1]:lower() == 'import' and isFull(msg.sender_user_id_) then
			link = matches[2]:gsub('t.me', 'telegram.me')
				tdcli_function ({
   					ID = "ImportChatInviteLink",
    				invite_link_ = link
  				}, function(C,G)  end, nil)
		end
	end
	end

	function ApiRun(msg, matches)
		if matches[1] == 'get gp' then
			if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
				reply_markup = {
					inline_keyboard = { 
						{ {text = 'Back', callback_data = 'startpage'} }
					}
				}	
				TEXT = 'لینک گروه خود را بفرستید... !\nگروه های رایگان امکان کمتری نسبت به وی ای پی ها  دارند   !'
			else
				reply_markup = {
					inline_keyboard = { 
						{ {text = 'Back', callback_data = 'startpage'} }
					}
				}	
				TEXT = 'Send Group Link !!!!\nBTW in free group Members must be higher than 1k !'
			end
			redis:set(msg.from.id..'GettingsGroup!', 'free')
			api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
		end
	end
	function ApiPre(msg, Type)
		if msg.text then
			if msg.chat.type == 'private' then
				if redis:get(msg.from.id..'GettingsGroup!') == 'vip' or redis:get(msg.from.id..'GettingsGroup!') == 'free' then
					link = { msg.text:gsub('t.me', 'telegram.me'):match('(https://telegram.me/joinchat/%S+)') }
					GPTYPE = redis:get(msg.from.id..'GettingsGroup!')
				--	redis:del(msg.from.id..'GettingsGroup!')
					if #link > 0 then
						if GPTYPE == 'vip' then
							Time = tonumber(redis:get('Count:'..msg.from.id)) * 30 * 24 * 60 * 60 + tonumber(os.time())
							cli.checkChatInviteLink(link[1], function (Arg, data)
								redis:sadd(msg.from.id..'Chats', data.chat_id_)
								redis:hset(data.chat_id_, 'isVIP', Time)
							end, nil)
								tdcli_function ({
   									ID = "ImportChatInviteLink",
    								invite_link_ = link[1]
  								}, function(C, G)  
  									if G.ID == 'Error' then
  										if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
											return 'خطا !!\n :'..G.message_
										else
											return 'Error !!\n :'..G.message_
										end
  									end
  								end, nil)
  								cli.checkChatInviteLink(link[1], function (Arg, data)
								redis:sadd(msg.from.id..'Chats', data.chat_id_)
								redis:hset(data.chat_id_, 'isVIP', Time)
							end, nil)
  							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								return 'ربات ضد لینک با نام: آنتی اسپم مگابات به گروه اضافه شد !\n ربات را مدیر کنید تا امکان مدیریت گروه را پیدا کند !'
							else
								return 'I Joined This Group!\nMake bot Admin to Start its Work !'
							end
							redis:del(msg.from.id..'GettingsGroup!')
						elseif GPTYPE == 'free' then
					stats = api.getChatMember(_Config.TOKEN, '@groupkadeirani', msg.from.id).result.status
					if stats and stats == 'member' or stats and stats == 'adminstrator' or stats == 'creator' then
							tdcli_function ({
   									ID = "ImportChatInviteLink",
    								invite_link_ = link[1]
  								}, function(C, G)  
  								VarDump(G)
  									if G.ID == 'Error' then
  										if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
											return 'خطا !!\n :'..G.message_
										else
											return 'Error !!\n :'..G.message_
										end
  									end
  								end, nil)
							cli.checkChatInviteLink(link[1], function (Arg, data)
								redis:sadd(msg.from.id..'Chats', data.chat_id_)
								redis:hset(data.chat_id_, 'isVIP', Time)
							end, nil)
							if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
								return 'ربات ضد لینک با نام: آنتی اسپم مگابات به گروه اضافه شد !\n ربات را مدیر کنید تا امکان مدیریت گروه را پیدا کند !'
							else
								return 'I Joined This Group!\nMake bot Admin to Start its Work !'
							end
						redis:del(msg.from.id..'GettingsGroup!')
					else
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							return 'ابتدا در کانال ما جوین شوید و دوباره لینک گروه خود را ارسال کنید  \n @groupkadeirani'
						else
							return 'First join our channel \n @groupkadeirani'
						end
					end
						end
					else
						if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
							return 'در متن بالا لینک یافت نشد !🙄'
						else
							return 'No Link Found in your Message !🙄'
						end
					end
				else
				end
			end
		end
	end

	return {
	HELP = {
			NAME = { 
				fa = 'دریافت گروه',
				en = 'Get/Buy Group !',
				call = 'getgroup',
			},
			Dec = {
				fa = 'دریافت گروه',
				en = 'Get Group !',
			},
			Usage = {
				fa = 'از دکمه "دریافت گروه" در پیوی ربات @untispams_megabot\\_bot برای دریافت ربات برای گروه خود استفاده کنید !',
				en = 'Use Butten "Grt Group" in @untispams_megabot\\_bot\'s private to Grt Group :P',
			},
			rank = 'NIL',
		},

		cli = {
			_MSG = {
				'^([iI]mport) (.*)$'
			},
	--		Pre = Pre,
			run = Run
		},
		api = {
			_MSG = {
				'!#MessageCall (get gp)',
				'!#MessageCall (get VIPGP)',
				'!#MessageCall (get FREEGP)',
				'!#MessageCall (SPRPayment)',
				'!#MessageCall (ViewPayment)',
				'!#MessageCall (acspt) (.*)',
			},
			Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}