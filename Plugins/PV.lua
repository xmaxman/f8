	
	function Pre(msg)
		if not msg.USER.user_.type_.ID == 'UserTypeBot' then
			if not tostring(msg.chat_id_ or msg.sender_user_id_):match('-') then
			cli.deleteChatHistory((msg.chat_id_ or msg.sender_user_id_), 1)
					text = '> `Hello !`\n'
					..'*I\'m megabot\'s GroupManager bot *!\n'
					..'_My Name Is F80 !_\n'
					..'`Message to` @untispams\\_megabot\\_megabot `to Get More Information !`\n'
					..'`-----------------`\n'
					.."> `سلام !`\n"
					..'*من ربات مدیریت گروه آنتی اسپم مگابات هستم !*\n'
					..'`برای دریافت اطلاعات بیشتر به` @untispams\\_megabot\\_megabot `پیام دهید !`\n'
					..'@untispams\\_megabot\\_Company !\n'
				return text
			end
		else
			cli.deleteChatHistory((msg.chat_id_ or msg.sender_user_id_), 1)
		end
	end

	function ApiRun(msg, matches)
		if #matches > 0 then
			if matches[1]:lower() == 'start' then
				if msg.chat.type == 'private' then
				redis:sadd('USERSSS', msg.from.id)
					if (redis:get(msg.chat.id..'Lang') or 'fa') == 'fa' then
						TEXT = '`سلام !`\n'
						..'> *خوش آمدید !*\n'
						..'> _برای استفاده از من از دستورات زیر استفاده کنید !_'
						reply_markup = {
							inline_keyboard = {
								{{text = '💯ضد لینک کردن گروه  به صورت ویژه💯', callback_data = 'buy spr'}},
								{{text = '🆓ضد لینک کردن ربات به صورت رایگان🆓', url = 't.me/Zd_link_robot'}},
								{ {text = '⁉️آموزش استفاده از ربات⁉️', callback_data='Learn'} },
								{ {text = '‍‍‍‍👮پشتیبانی👮 ', callback_data='Support'} },
								{
									{text = 'Change Language to English', callback_data = 'change lang'}
								}
							}
						}
						if redis:scard(msg.from.id..'Chats') > 0 then
							table.insert(reply_markup.inline_keyboard, {{text='گروه های شما', callback_data = 'groups'}})
						end
						if isFull(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, {{text='پنل مدیریت', callback_data = 'panel'}})
						end
					else
						TEXT = '`Hello Sir !`\n'
						..'> *Welcome !*\n'
						..'> _Use Buttens!_'
						reply_markup = {
							inline_keyboard = {
									{{text = 'Buy Group', callback_data = 'buy spr'}},
									{{text = 'Get Free Group', url = 't.me/Zd_link_robot'}},
								{ {text = 'How to use ?', callback_data='Learn'} },
								{ {text = 'Support', callback_data='Support'} },
								{
									{text = 'تغییر زبان به فارسی !', callback_data = 'change lang'}
								}
							}
						}
						if redis:scard(msg.from.id..'Chats') > 0 then
							table.insert(reply_markup.inline_keyboard, {{text='Group List', callback_data = 'groups'}})
						end
						if isFull(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, {{text='Panel', callback_data = 'panel'}})
						end
					end
						api.sendMessage(_Config.TOKEN, msg.chat.id, TEXT, 'md', reply_markup, msg.message_id, false)
				else
					reply_markup = { inline_keyboard = { { {text = 'Start | شروع', url = 't.me/@untispams_megabot?start'} } } }
					TEXT = '`من را در خصوصی استارت بزن :)\n'
					..'Start Me in Private !`'
					api.sendMessage(_Config.TOKEN, msg.chat.id, TEXT, 'md', reply_markup, msg.message_id, false)
				end
			end
		end
		if msg.data then
			if #matches > 0 then
				if matches[1] == 'buy spr' then
					if (redis:get(msg.message.chat.id..'Lang') or 'fa') == 'fa' then
						text = 'پلن خود را انتخاب کنید !'
					else
						text = 'Select Your Plan'
					end
						keyboard = {
							inline_keyboard = { 
								{
									{ 
										text = 'یک ماهه (5هزارتومان)',
										callback_data = '1 SPR'
								    }
								},{
								    { 
										text = 'دو ماهه (9هزارتومان)',
										callback_data = '2 SPR'
								    }
								},
								{
									{ 
										text = 'سه ماهه (13هزارتومان)',
										callback_data = '3 SPR'
								    }
								},{
								    { 
										text = 'چهار ماهه (17هزارتومان)',
										callback_data = '4 SPR'
								    }
								},
								
								{
									{ 
										text = 'Back|بازگشت',
										callback_data = 'startpage'
									}
								},
							}
						}
						api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, text, 'md', keyboard)
				end
				----------------------------------
				if matches[1] == 'startpage' then
					redis:del(msg.from.id..'PV:Getting')
					if (redis:get(msg.message.chat.id..'Lang') or 'fa') == 'fa' then
						TEXT = '`سلام !`\n'
						..'> *خوش آمدید !*\n'
						..'> _برای استفاده از من از دستورات زیر استفاده کنید !_'
						reply_markup = {
							inline_keyboard = {
								{{text = '💯ضد لینک کردن گروه به صورت ویژه💯', callback_data = 'buy spr'}},
								{{text = '🆓ضد لینک کردن ربات به صورت رایگان🆓', url = 't.me/Zd_link_robot'}},
								{ {text = '⁉️آموزش استفاده از ربات⁉️', callback_data='Learn'} },
								{ {text = '👮پشتیبانی👮 ', callback_data='Support'} },
								{
									{text = 'Change Language to English', callback_data = 'change lang'}
								}
							}
						}
						if redis:scard(msg.from.id..'Chats') > 0 then
							table.insert(reply_markup.inline_keyboard, {{text='گروه های شما', callback_data = 'groups'}})
						end
						if isFull(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, {{text='پنل مدیریت', callback_data = 'panel'}})
						end
					else
						TEXT = '`Hello Sir !`\n'
						..'> *Welcome !*\n'
						..'> _Use Buttens!_'
						reply_markup = {
							inline_keyboard = {
									{{text = 'Buy Group', callback_data = 'buy spr'}},
									{{text = 'Get Free Group', url = 't.me/Zd_link_robot'}},
								{ {text = 'How to use ?', callback_data='Learn'} },
								{ {text = 'Support', callback_data='Support'} },
								{
									{text = 'تغییر زبان به فارسی !', callback_data = 'change lang'}
								}
							}
						}
						if redis:scard(msg.from.id..'Chats') > 0 then
							table.insert(reply_markup.inline_keyboard, {{text='Group List', callback_data = 'groups'}})
						end
						if isFull(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, {{text='Panel', callback_data = 'panel'}})
						end
					end
					api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				----------------------------------
				if matches[1] == 'change lang' then
					if (redis:get(msg.message.chat.id..'Lang') or 'fa') == 'fa' then
						redis:set(msg.message.chat.id..'Lang','en')
					else
						redis:set(msg.message.chat.id..'Lang','fa')
					end
					----------------------------------------------------------------
					if (redis:get(msg.message.chat.id..'Lang') or 'fa') == 'fa' then
						TEXT = '`سلام !`\n'
						..'> *خوش آمدید !*\n'
						..'> _برای استفاده از من از دستورات زیر استفاده کنید !_'
						reply_markup = {
							inline_keyboard = {
								{{text = '💯ضد لینک کردن گروه به صورت ویژه💯', callback_data = 'buy spr'}},
								{{text = '🆓ضد لینک کردن ربات به صورت رایگان🆓', url = 't.me/Zd_link_robot'}}	,			
								{ {text = '⁉️آموزش استفاده از ربات⁉️', callback_data='Learn'} },
								{ {text = '👮پشتیبانی👮', callback_data='Support'} },
								{
									{text = 'Change Language to English', callback_data = 'change lang'}
								}
							}
						}
						if redis:scard(msg.from.id..'Chats') > 0 then
							table.insert(reply_markup.inline_keyboard, {{text='گروه های شما', callback_data = 'groups'}})
						end
						if isFull(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, {{text='پنل مدیریت', callback_data = 'panel'}})
						end
					else
						TEXT = '`Hello Sir !`\n'
						..'> *Welcome !*\n'
						..'> _Use Buttens!_'
						reply_markup = {
							inline_keyboard = {
									{{text = 'Buy Group', callback_data = 'buy spr'}},
									{{text = 'Get Free Group', url = 't.me/Zd_link_robot'}},
								{ {text = 'How to use ?', callback_data='Learn'} },
								{ {text = 'Support', callback_data='Support'} },
								{
									{text = 'تغییر زبان به فارسی !', callback_data = 'change lang'}
								}
							}
						}
						if redis:scard(msg.from.id..'Chats') > 0 then
							table.insert(reply_markup.inline_keyboard, {{text='Group List', callback_data = 'groups'}})
						end
						if isFull(msg.from.id) then
							table.insert(reply_markup.inline_keyboard, {{text='Panel', callback_data = 'panel'}})
						end
					end
					api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end

				if matches[1] == 'Learn' then
					TEXT = [[✅خب خوشحالم از اینکه بهترین ربات ضد لینک در تلگرام رو برای مدیریت گروه خودتون انتخاب کردید.🌹

اموزش استفاده از ربات آنتی اسپم مگابات:

1⃣برای ضد لینک کردن و ضد هک کردن  گروهتون ابتدا گزینه ی 💯ضد لینک کردن گروه به صورت ویژه💯 رو انتخاب کنید بعد پرداخت هزینه ی ماهانه و موفق بودن پرداخت از شما درخواست میشه لینک گروه رو به ربات بدید بعد از ارسال لینک گروهتون، ربات ما با نام 📛آنتی اسپم مگابات📛عضو گروه شما میشود اما برای اینکه توانایی مدیریت گروه شما را داشته باشد باید ⁉️ربات در گروه شما مدیر باشه ⁉️پس ربات رو مدیر کنید .

2⃣بعد از اینکه ربات را در خود مدیر کردید حالا میتونید اونو کنترل کنید برای اینکار باید از نوشته های زیر استفاده کنید:

/help   👈👉دستور هلپ 
⁉️و دستور اصلی برای تنظیم ربات:
/settings

پس از ارسال دستور بقیش دیگه راحته با کلیک روی هر گزینه تنطیمات اون بخش براتون باز میشه و راحت میتونید ربات رو تنظیم کنید برای مدیریت گروه🌹

✅⭕️نکته: ربات های رایگان از امکانات و سرعت کمتری نسبت به ربات های وی آی پی ها دارند و دارای تبلیغات نیز هستند پیشنهاد ما اینه حتما از ربات وی آی پی استفاده  کنید🌹

❤️با آرزوی گروهی بدون اسپم❤️]]
					reply_markup = {
							inline_keyboard = {
								{
									{text = 'Back', callback_data = 'startpage'}
								},
							}
						}
					api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
				--------------
				if matches[1] == 'Support' then
					TEXT = 'پیام خود را ارسال کنید تا تیم پشتیبانی پاسخ دهد!'
					redis:set(msg.from.id..'PV:Getting',true)
					reply_markup = {
							inline_keyboard = {
								{
									{text = 'Back', callback_data = 'startpage'}
								},
							}
						}
					api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', reply_markup)
				end
			end	
		end
	end
	function ApiPre(msg, Type)
		if msg.text then
			if redis:get(msg.from.id..'PV:Getting') then
				api.forwardMessage(_Config.TOKEN, _Config.MainSudo, msg.from.id, msg.message_id)
				api.sendMessage(_Config.TOKEN, msg.from.id, 'ارسال شد منتظر جواب بمانید !', 'md', {inline_keyboard = {{ {text = 'end chat', callback_data = 'startpage'}},}}, 0)
			end
			if msg.from.id == _Config.MainSudo then
				if msg.reply_to_message then
					api.sendMessage(_Config.TOKEN, msg.reply_to_message.forward_from.id, msg.text, 'md', {inline_keyboard = {{ {text = 'end chat', callback_data = 'startpage'}},}}, 0)
				end
			end
		end
	end
	return {
	HELP = {
			NAME = { 
				fa = 'پیوی',
				en = 'Pv !',
				call = 'PV',
			},
			Dec = {
				fa = 'پیلاگین خصوصی',
				en = 'Private Message',
			},
			Usage = {
				fa = 'از این پلاگین در چت خصوصی @untispams_megabot\\_megabot استفاده کنید !',
				en = 'Use This Plugin in @untispams_megabot\\_megabot\'s Private :-)',
			},
			rank = 'NIL',
		},
		cli = {
			_MSG = {
				--Patterns :)
				'^(.*)$'
			},
			Pre = Pre,
	--		run = Run
		},
		api = {
			_MSG = {
				--Patterns :)
				'^([Ss]tart)$',
				'^!#MessageCall (startpage)$',
				'^!#MessageCall (buy spr)$',
				'^!#MessageCall (change lang)$',
				'^!#MessageCall (rules)$',
				'^!#MessageCall (Learn)$',
				'^!#MessageCall (Support)$',
				'^[/!#]([Ss]tart)$',
				'^([Ss]tart) (.*)$',
				'^[/!#]([Ss]tart) (.*)$',
			},
			Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}