	

		function Run(msg, mathces)
			if mathces[1] == 'set' and isMod(msg.sender_user_id_, msg.chat_id_) then
				if mathces[2] == 'link' then
					redis:hset(msg.chat_id_, 'GroupLink', mathces[3])
					return 'New Group Link \n: '..MarkScape(mathces[3])..''
				end
				if mathces[2] == 'lang' then
					if mathces[3] == 'en' then
						redis:set(msg.chat_id_..'Lang', 'en')
						return 'Language Seted on English'
					else
						redis:set(msg.chat_id_..'Lang', 'fa')
						return 'Language Seted on Persian'
					end
				end
			end
			if mathces[1] == 'filter' and isMod(msg.sender_user_id_, msg.chat_id_) then
				redis:sadd('Filterlist'..msg.chat_id_, mathces[2])
				return MarkScape(mathces[2]) .. ' Filterd !'
			end
			if mathces[1] == 'unfilter' and isMod(msg.sender_user_id_, msg.chat_id_) then
				redis:srem('Filterlist'..msg.chat_id_, mathces[2])
				return MarkScape(mathces[2]) .. ' unFilterd !'
			end
			if mathces[1] == 'muteall' and isMod(msg.sender_user_id_, msg.chat_id_) then
				redis:hset(''..msg.chat_id_, 'MuteAll', true)
				return 'Group Muted ! !'
			end
			if mathces[1] == 'unmuteall' and isMod(msg.sender_user_id_, msg.chat_id_) then
				redis:hdel(''..msg.chat_id_, 'MuteAll')
				return ' Group unmuted !'
			end
		end

	return {
	HELP = {
			NAME = { 
				fa = 'تنظیم',
				en = 'Set Plugin !',
				call = 'set',
			},
			Dec = {
				fa = 'تنظیم تنظیمات',
				en = 'Set Settings ',
			},
			Usage = {
				fa = '`Set Link (GroupLink)` : تنظیم لینک گروه\n'
				..'`Set Lang (FA|EN)` : تنظیم زبان گروه\n'
				..'`[Un]Filter (Word)` : [حذف] فیلتر (Word)\n'
				..'`Filterlist Clean` : خذف فیلتر لیست\n'
				..'`[Un]Muteall` : سکوت/حذف سکوت گروه\n'
				..'',
				en = '`Set Link (GroupLink)` : تنظیم لینک گروه\n'
				..'`Set Lang (FA|EN)` : تنظیم زبان گروه\n'
				..'`[Un]Filter (Word)` : [حذف] فیلتر (Word)\n'
				..'`Filterlist Clean` : خذف فیلتر لیست\n'
				..'`[Un]Muteall` : سکوت/حذف سکوت گروه\n'
				..'',
			},
			rank = 'Mod',
		},
		cli = {
			_MSG = {
			'^([Ss]et) (link) (.*)$',
			'^([Ss]et) (lang) (.*)$',
			'^[/!#]([Ss]et) (link) (.*)$',
			'^[/!#]([Ss]et) (lang) (.*)$',

			'^([Ff]ilter) (.*)$',
			'^[/!#]([Ff]ilter) (.*)$',

			'^([Uu]n[Ff]ilter) (.*)$',
			'^[/!#]([Uu]n[Ff]ilter) (.*)$',

			'^([Uu]n[Mm]uteall)$',
			'^([Mm]uteall)$',
			'^[/!#]([Uu]n[Mm]uteall)$',
			'^[/!#]([Mm]uteall)$',

			},
	--		Pre = Pre,
			run = Run
		},
		api = {
			_MSG = {

			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'F80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}