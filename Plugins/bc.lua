	function Run(msg, matches)
		if matches[1] == 'f2a' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('Groups!')) do
				cli.forwardMessages(v, msg.chat_id_, {[0] = msg.reply_to_message_id_}, 1)
			end
			for k,v in pairs(redis:smembers('Users')) do
				cli.forwardMessages(v, msg.chat_id_, {[0] = msg.reply_to_message_id_}, 1)
			end
		end
		if matches[1] == 'f2ausers' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('Users')) do
				cli.forwardMessages(v, msg.chat_id_, {[0] = msg.reply_to_message_id_}, 1)
			end
		end
		if matches[1] == 'f2agps' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('Groups!')) do
				cli.forwardMessages(v, msg.chat_id_, {[0] = msg.reply_to_message_id_}, 1)
			end
		end
	end
	function ApiRun(msg, matches)
		if matches[1] == 'bc' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('Groups!')) do
				api.sendMessage(_Config.TOKEN, v, txt, 'md', nil, 0, false)
				cli.sendText(v, 0, 0, 1, nil, txt, 1, 'MarkDown')
			end
			for k,v in pairs(redis:smembers('Users')) do
				api.sendMessage(_Config.TOKEN, v, txt, 'md', nil, 0, false)
			end
		end
		if matches[1] == 'f2a' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('Groups!')) do
				api.forwardMessage(_Config.TOKEN, msg.chat.id, v, msg.reply_to_message.message_id)
			end
			for k,v in pairs(redis:smembers('Users')) do
				api.forwardMessage(_Config.TOKEN, msg.chat.id, v, msg.reply_to_message.message_id)
			end
		end
		if matches[1] == 'f2ausers' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('USERSSS')) do
				api.forwardMessage(_Config.TOKEN, msg.chat.id, v, msg.reply_to_message.message_id)
			end
		end
		if matches[1] == 'f2agps' then
			txt = matches[2] 
			for k,v in pairs(redis:smembers('Groups!')) do
				api.forwardMessage(_Config.TOKEN, msg.chat.id, v, msg.reply_to_message.message_id)
			end
		end
	end
	return {
		HELP = {
			NAME = { 
				fa = 'پیام همگانی',
				en = 'Broad Cast',
				call = 'bc',
			},
			Dec = {
				fa = 'ارسال پیام به تمامی کاربران ربات',
				en = 'Broad Cast A Message To Users !',
			},
			Usage = {
				fa = '`f2a` : فوروارد پایم به گروه های ربات CLI\n'
				..'`bc (Message)` : ارسال Message به تمامی گروه های ربات CLI\n'
				..'*این پلاگین فقط برای مدیر کل ربات است !*',
				en = '`f2a` : Forward message to All of Cli Robot Groups\n'
				..'`bc (Message)` : Send Message to all of Cli Robot Groups\n'
				..'*This Plugin Can just use by SUDO !*',
			},
			rank = 'sudo',
		},
		cli = {
			_MSG = {
				'^(f2a)$',
				'^(f2agps)$',
				'^(f2ausers)$',

			},
	--		Pre = Pre,
			run = Run
		},
		api = {
			_MSG = {
				'^(bc) (.*)$',
				'^(f2a)$',
				'^(f2agps)$',
				'^(f2ausers)$',
			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}