-- :|
	utf8 = require 'lua-utf8'
	function Run(msg, matches)
		if #matches > 0 then
		------------------------------------------------------------------
				if matches[1]:lower() == 'promote' and isOwner(msg.sender_user_id_, msg.chat_id_) then
					if msg.reply_to_message_id_ ~= 0 then
						cli.getMessage(
							msg.chat_id_,
							msg.reply_to_message_id_,
							function (extra, result)
								local user_id = result.sender_user_id_
								local chat_id = msg.chat_id_
								if isMod(user_id, chat_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " هم اکنون یک مدیر گروه است !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is already a Moderator !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:sadd('Mods'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " اکنون ارتقاغ یافت و یک مدیر گروه شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' promoted and now is a Moderator !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
							end,
							nil
						)
					end
					------------------
					if #matches > 1 then
						if #msg.content_.entities_ > 0 then
							if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
								X = tonumber(msg.content_.entities_[0].user_id_)
							else
								X = false
							end
						else
							if tonumber(matches[2]) ~= nil then
								X = tonumber(matches[2])
							else
								X = false
							end
						end
						-------------------------------------
						if X then
							cli.getUserFull(
								X,
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										user_id = result.user_.id_
										chat_id = msg.chat_id_
										if isMod(result.user_.id_, msg.chat_id_) then
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " هم اکنون یک مدیر گروه است !"
												cli.sendMention(chat_id, user_id, msg.id_, text, 8, utf8.len(user))
											else
												text = user .. ' is already a Moderator !'
												cli.sendMention(chat_id, user_id, msg.id_, text, 0, utf8.len(user))
											end 
										else
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
											redis:sadd('Mods'..chat_id, user_id)
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " اکنون ارتقاغ یافت و یک مدیر گروه شد!"
												cli.sendMention(chat_id, user_id, msg.id_, text, 8, utf8.len(user))
											else
												text = user .. ' promoted and now is a Moderator !'
												cli.sendMention(chat_id, user_id, msg.id_, text, 0, utf8.len(user))
											end 

										end
									end
								end,
								nil
							)
						else
							-------F This Shit :!
							cli.searchPublicChat(
								matches[2]:gsub('@', ''),
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										if result.type_.ID == 'PrivateChatInfo' then 
											user_id = result.id_ 
											chat_id = msg.chat_id_ 
											if isMod(result.id_, msg.chat_id_) then
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
												if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
													text = 'کاربر : ' .. user .. " هم اکنون یک مدیر گروه است !"
													cli.sendMention(chat_id, user_id, msg.id_, text, 8, utf8.len(user))
												else
													text = user .. ' is already a Moderator !'
													cli.sendMention(chat_id, user_id, msg.id_, text, 0, utf8.len(user))
												end 
											else
												user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
												redis:sadd('Mods'..chat_id, user_id)
												if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
													text = 'کاربر : ' .. user .. " اکنون ارتقاغ یافت و یک مدیر گروه شد!"
													cli.sendMention(chat_id, user_id, msg.id_, text, 8, utf8.len(user))
												else
													text = user .. ' promoted and now is a Moderator !'
													cli.sendMention(chat_id, user_id, msg.id_, text, 0, utf8.len(user))
												end 
											end
										else
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												return 'خطا \nیک کانال را نمیتوان ارتقاع داد '
											else
												return 'Error !\n Cant promote a Channel !'
											end
										end
									end
								end,
								nil
							)
						end
					end
				end
				-------------------------------------
				if matches[1]:lower() == 'demote' and isOwner(msg.sender_user_id_, msg.chat_id_) then
					if msg.reply_to_message_id_ ~= 0 then
						cli.getMessage(
							msg.chat_id_,
							msg.reply_to_message_id_,
							function (extra, result)
								local user_id = result.sender_user_id_
								local chat_id = msg.chat_id_
								if not isMod(user_id, chat_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " یک مدیر نبود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' was\'t a Moderator !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:srem('Mods'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " دیگر یک مدیر گروه نیست!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is nolonger a Moderator !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
							end,
							nil
						)
					end
					------------------
					if #matches > 1 then
						if #msg.content_.entities_ > 0 then
							if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
								X = tonumber(msg.content_.entities_[0].user_id_)
							else
								X = nil
							end
						else
							if tonumber(matches[2]) ~= nil then
								X = tonumber(matches[2])
							else
								X = nil
							end
						end
						-------------------------------------
						if type(X) == 'number' then
							cli.getUserFull(
								X,
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										user_id = result.user_.id_
										chat_id = msg.chat_id_
										if not isMod(user_id, chat_id) then
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " یک مدیر نبود !"
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
											else
												text = user .. ' was\'t a Moderator !'
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
											end 
										else
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
											redis:srem('Mods'..chat_id, user_id)
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " دیگر یک مدیر گروه نیست!"
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
											else
												text = user .. ' is nolonger a Moderator !'
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
											end 
										end
									end
								end,
								nil
							)
						else
							-------F This Shit :!
							cli.searchPublicChat(
								matches[2]:gsub('@', ''),
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										if result.type_.ID == 'PrivateChatInfo' then 
											user_id = result.id_ 
											chat_id = msg.chat_id_ 
											if not isMod(user_id, chat_id) then
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
												if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
													text = 'کاربر : ' .. user .. " یک مدیر نبود !"
													cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
												else
													text = user .. ' was\'t a Moderator !'
													cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
												end 
											else
												user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
												redis:srem('Mods'..chat_id, user_id)
												if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
													text = 'کاربر : ' .. user .. " دیگر یک مدیر گروه نیست!"
													cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
												else
													text = user .. ' is nolonger a Moderator !'
													cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
												end 
											end
										else
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												return 'خطا \nیک کانال را نمیتوان عزل مقام داد '
											else
												return 'Error !\n Cant demote a Channel !'
											end
										end
									end
								end,
								nil
							)
						end
					end
				end
				-----------------------------------------------------------

				if matches[1]:lower() == 'mods' then

					if matches[2] :lower() == 'clean' and isOwner(msg.sender_user_id_, msg.chat_id_)  then
						redis:del('Mods'..msg.chat_id_)
						if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
							return 'لیست مدیران خالی شد !'
						else
							return 'All of the Moderator demoted !'
						end
					elseif matches[2] :lower() == 'list' then
						if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
							if redis:scard('Mods'..msg.chat_id_) == 0 then
								return 'هیچ میدیری در این گروه موجود نیست !'
							else
								local Mods = 'لیست مدیران گروه : ' .. (redis:hget(msg.chat_id_, 'Title') or msg.chat_id_).. '\n'
								for k, v in pairs(redis:smembers('Mods'..msg.chat_id_)) do
									Mods = Mods.. k ..') '..getUserInfo(v) .. '\n'
								end
								return Mods
							end
						else
							if redis:scard('Mods'..msg.chat_id_) == 0 then
								return 'No Moderator !'
							else
								local Mods = 'List of group Moderator(s) for : ' .. (redis:hget(msg.chat_id_, 'Title') or msg.chat_id_).. '\n'
								for k, v in pairs(redis:smembers('Mods'..msg.chat_id_)) do
									Mods = Mods.. k ..') '..getUserInfo(v) .. '\n'
								end
								return Mods
							end
						end
					end
				end
				------------------------------------------
				if matches[1]:lower() == 'muteuser' and isMod(msg.sender_user_id_, msg.chat_id_) then
					if msg.reply_to_message_id_ ~= 0 then
						cli.getMessage(
							msg.chat_id_,
							msg.reply_to_message_id_,
							function (extra, result)
								local user_id = result.sender_user_id_
								local chat_id = msg.chat_id_
								if redis:sismember('Mutelist'..chat_id, user_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " از قبل در لیست سکوت بود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is already a Mute !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:sadd('Mutelist'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " وارد لیست سکوت شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Muted !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
							end,
							nil
						)
					end
					------------------
					if #matches > 1 then
						if #msg.content_.entities_ > 0 then
							if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
								X = tonumber(msg.content_.entities_[0].user_id_)
							else
								X = false
							end
						else
							if tonumber(matches[2]) ~= nil then
								X = tonumber(matches[2])
							else
								X = false
							end
						end
						-------------------------------------
						if X then
							cli.getUserFull(
								X,
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										user_id = result.user_.id_
										chat_id = msg.chat_id_
										if redis:sismember('Mutelist'..chat_id, user_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " از قبل در لیست سکوت بود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is already a Mute !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:sadd('Mutelist'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " وارد لیست سکوت شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Muted !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
									end
								end,
								nil
							)
						else
							-------F This Shit :!
							cli.searchPublicChat(
								matches[2]:gsub('@', ''),
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										if result.type_.ID == 'PrivateChatInfo' then 
											user_id = result.id_ 
											chat_id = msg.chat_id_ 
											if redis:sismember('Mutelist'..chat_id, user_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " از قبل در لیست سکوت بود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is already a Mute !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:sadd('Mutelist'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " وارد لیست سکوت شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Muted !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
										else
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												return 'خطا \nیک کانال نمیتواند وارد لیست سکوت شود ! '
											else
												return 'Error !\n Cant Mute a Channel !'
											end
										end
									end
								end,
								nil
							)
						end
					end
				end
				-------------------------------------
				if matches[1]:lower() == 'unmuteuser' and isMod(msg.sender_user_id_, msg.chat_id_) then
					if msg.reply_to_message_id_ ~= 0 then
						cli.getMessage(
							msg.chat_id_,
							msg.reply_to_message_id_,
							function (extra, result)
								local user_id = result.sender_user_id_
								local chat_id = msg.chat_id_
								if not redis:sismember('Mutelist'..chat_id, user_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " در لیست سکوت نبود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is not a Mute user !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:srem('Mutelist'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " از لیست سکوت خارج شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is nolonger Muted !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
							end,
							nil
						)
					end
					------------------
					if #matches > 1 then
						if #msg.content_.entities_ > 0 then
							if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
								X = tonumber(msg.content_.entities_[0].user_id_)
							else
								X = false
							end
						else
							if tonumber(matches[2]) ~= nil then
								X = tonumber(matches[2])
							else
								X = false
							end
						end
						-------------------------------------
						if X then
							cli.getUserFull(
								X,
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										user_id = result.user_.id_
										chat_id = msg.chat_id_
										if not redis:sismember('Mutelist'..chat_id, user_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " در لیست سکوت نبود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is not a Mute user !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:srem('Mutelist'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " از لیست سکوت خارج شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is nolonger Muted !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
									end
								end,
								nil
							)
						else
							-------F This Shit :!
							cli.searchPublicChat(
								matches[2]:gsub('@', ''),
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										if result.type_.ID == 'PrivateChatInfo' then 
											user_id = result.id_ 
											chat_id = msg.chat_id_ 
											if not redis:sismember('Mutelist'..chat_id, user_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " در لیست سکوت نبود !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is not a Mute user !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									redis:srem('Mutelist'..chat_id, user_id)
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " از لیست سکوت خارج شد!"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' is nolonger Muted !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
										else
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												return 'خطا \nیک کانال نمیتواند وارد لیست سکوت شود ! '
											else
												return 'Error !\n Cant Mute a Channel !'
											end
										end
									end
								end,
								nil
							)
						end
					end
				end
				-----------------------------------------------------------

				if matches[1]:lower() == 'mutes' then

					if matches[2] :lower() == 'clean' and isOwner(msg.sender_user_id_, msg.chat_id_)  then
						redis:del('Mutelist'..msg.chat_id_)
						if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
							return 'لیست سکوت خالی شد !'
						else
							return 'Mute list cleared!'
						end
					elseif matches[2] :lower() == 'list' then
						if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
							if redis:scard('Mutelist'..msg.chat_id_) == 0 then
								return 'هیچ کاربری در لیست سکوت نیسد !'
							else
								local Mutelist = 'لیست سکوت : ' .. (redis:hget(msg.chat_id_, 'Title') or msg.chat_id_).. '\n'
								for k, v in pairs(redis:smembers('Mutelist'..msg.chat_id_)) do
									Mutelist = Mutelist.. k ..') '..getUserInfo(v) .. '\n'
								end
								return Mutelist
							end
						else
							if redis:scard('Mutelist'..msg.chat_id_) == 0 then
								return 'No Muteduser !'
							else
								local Mutelist = 'List of group Mutedusers for : ' .. (redis:hget(msg.chat_id_, 'Title') or msg.chat_id_).. '\n'
								for k, v in pairs(redis:smembers('Mutelist'..msg.chat_id_)) do
									Mutelist = Mutelist.. k ..') '..getUserInfo(v) .. '\n'
								end
								return Mutelist
							end
						end
					end
				end
			-------------------------------------------------------------
				if matches[1]:lower() == 'kick' and isMod(msg.sender_user_id_, msg.chat_id_) then
					if msg.reply_to_message_id_ ~= 0 then
						cli.getMessage(
							msg.chat_id_,
							msg.reply_to_message_id_,
							function (extra, result)
								local user_id = result.sender_user_id_
								local chat_id = msg.chat_id_
								if isMod(user_id, chat_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " را نمیتوان اخراج کرد !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Can\'t be kick !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " اخراج شد !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Kicked !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
							end,
							nil
						)
					end
					------------------
					if #matches > 1 then
						if #msg.content_.entities_ > 0 then
							if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
								X = tonumber(msg.content_.entities_[0].user_id_)
							else
								X = false
							end
						else
							if tonumber(matches[2]) ~= nil then
								X = tonumber(matches[2])
							else
								X = false
							end
						end
						-------------------------------------
						if X then
							cli.getUserFull(
								X,
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										user_id = result.user_.id_
										chat_id = msg.chat_id_
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if isMod(user_id, chat_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " را نمیتوان اخراج کرد !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Can\'t be kick !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " اخراج شد !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Kicked !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
								end
								end,
								nil
							)
						else
							-------F This Shit :!
							cli.searchPublicChat(
								matches[2]:gsub('@', ''),
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										if result.type_.ID == 'PrivateChatInfo' then 
											user_id = result.id_ 
											chat_id = msg.chat_id_ 
											user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if isMod(user_id, chat_id) then
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " را نمیتوان اخراج کرد !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Can\'t be kick !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								else
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									cli.changeChatMemberStatus(chat_id, user_id, 'Kicked')
									if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
										text = 'کاربر : ' .. user .. " اخراج شد !"
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
									else
										text = user .. ' Kicked !'
										cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
									end 
								end
										else
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												return 'خطا \nنمیتوان یک کانال را کیک کرد |: ! '
											else
												return 'Error !\n Cant kick a Channel !'
											end
										end
									end
								end,
								nil
							)
						end
					end
				end
				--------------------------------------------------
				if matches[1]:lower() == 'invite' and isMod(msg.sender_user_id_, msg.chat_id_) then
					if msg.reply_to_message_id_ ~= 0 then
						cli.getMessage(
							msg.chat_id_,
							msg.reply_to_message_id_,
							function (extra, result)
								local user_id = result.sender_user_id_
								local chat_id = msg.chat_id_
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									cli.addChatMember(chat_id, user_id, 50, function (Arg, Data)
										if Data.ID == 'Ok' then
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " دعوت شد !"
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
											else
												text = user .. ' Invited !'
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
											end 
										elseif Data.ID == 'Error' then
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												cli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'نمیتوان کاربر را دعوت کرد !\nکد خطا : '..MarkScape(Data.message_), 1, 'MarkDown')
											else
												cli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'Can\'t invite user\n Error Result : '..MarkScape(Data.message_), 1, 'MarkDown')
											end
										end
										end, nil) 
							end,
							nil
						)
					end
					------------------
					if #matches > 1 then
						if #msg.content_.entities_ > 0 then
							if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
								X = tonumber(msg.content_.entities_[0].user_id_)
							else
								X = false
							end
						else
							if tonumber(matches[2]) ~= nil then
								X = tonumber(matches[2])
							else
								X = false
							end
						end
						-------------------------------------
						if X then
							cli.getUserFull(
								X,
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										user_id = result.user_.id_
										chat_id = msg.chat_id_
										user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									cli.addChatMember(chat_id, user_id, 50, function (Arg, Data)
										if Data.ID == 'Ok' then
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " دعوت شد !"
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
											else
												text = user .. ' Invited !'
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
											end 
										elseif Data.ID == 'Error' then
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												cli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'نمیتوان کاربر را دعوت کرد !\nکد خطا : '..MarkScape(Data.message_), 1, 'MarkDown')
											else
												cli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'Can\'t invite user\n Error Result : '..MarkScape(Data.message_), 1, 'MarkDown')
											end
										end
										end, nil)
									end
								end,
								nil
							)
						else
							-------F This Shit :!
							cli.searchPublicChat(
								matches[2]:gsub('@', ''),
								function (extra, result)
									if result.ID == 'Error' then
										if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
											return 'خطا !\n کد خطا : ' .. result.code_ .. '\n متن ارور : '.. result.message_
										else
											return 'Error !\n Error Code : ' .. result.code_ .. '\n Error Result : '.. result.message_
										end
									else
										if result.type_.ID == 'PrivateChatInfo' then 
											user_id = result.id_ 
											chat_id = msg.chat_id_ 
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									user = tostring(getUserInfo(user_id)):gsub('\\', ''):gsub('@','')
									cli.addChatMember(chat_id, user_id, 50, function (Arg, Data)
										if Data.ID == 'Ok' then
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												text = 'کاربر : ' .. user .. " دعوت شد !"
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 8, utf8.len(user))
											else
												text = user .. ' Invited !'
												cli.sendMention(chat_id, user_id, msg.reply_to_message_id_, text, 0, utf8.len(user))
											end 
										elseif Data.ID == 'Error' then
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												cli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'نمیتوان کاربر را دعوت کرد !\nکد خطا : '..MarkScape(Data.message_), 1, 'MarkDown')
											else
												cli.sendText(msg.chat_id_, msg.id_, 0, 1, nil, 'Can\'t invite user\n Error Result : '..MarkScape(Data.message_), 1, 'MarkDown')
											end
										else
											VarDump(Data)
										end
										end, nil)
										else
											if (redis:get(msg.chat_id_..'Lang') or 'fa') == 'fa' then
												return 'خطا \nنمیتوان یک کانال را دعوت کرد |: ! '
											else
												return 'Error !\n Cant invite a Channel !'
											end
										end
									end
								end,
								nil
							)
						end
					end
				end
			-------------------------------------------------------------
		end
	end

	return {
	HELP = {
			NAME = { 
				fa = 'مدیریت',
				en = 'Moderation !',
				call = 'moderation',
			},
			Dec = {
				fa = 'مدیریت اعضا !',
				en = 'Group Moderation !',
			},
			Usage = {
				fa = '`Promote (reply)` : ارتقاه فرد مورد نضر\n'
				..'`Promote (@Username)` : ارتقاه (@Username)\n'
				..'`Promote (Mention)` : ارتقاه (Mention)\n'
				..'`Promote (UserID)` : ارتقاه (UserID)\n'
				..'`Demote (reply)` : عزل مقام فرد مورد نضر\n'
				..'`Demote (@Username)` : عزل مقام (@Username)\n'
				..'`Demote (Mention)` : عزل مقام (Mention)\n'
				..'`Demote (UserID)` : عزل مقام (UserID)\n'
				..'`Mods Clean` : خذف مدیران\n'
				..'`Mods List` : لیست مدیران\n'
				..'`[Un]Muteuser (reply)` : [حذف] سکوت فرد مورد نظر\n'
				..'`[Un]Muteuser (@Username)` : [حذف] سکوت (@Username)\n'
				..'`[Un]Muteuser (Mention)` : [حذف] سکوت (Mention)\n'
				..'`[Un]Muteuser (UserID)` : [حذف] سکوت (UserID)\n'
				..'`Mutes Clean` : خذف لیست سکوت\n'
				..'`Mutes List` : لیست سکوت\n'
				..'`Invite (reply)` : دعوت فرد مورد نظر\n'
				..'`Invite (@Username)` : دعوت (@Username)\n'
				..'`Invite (Mention)` : دعوت (Mention)\n'
				..'`Invite (UserID)` : دعوت (UserID)\n'
				..'`Kick (reply)` : اخراج فرد مورد نضر\n'
				..'`Kick (@Username)` : اخراج (@Username)\n'
				..'`Kick (Mention)` : اخراج (Mention)\n'
				..'`Kick (UserID)` : اخراج (UserID)\n'
				..'*این پلاگین برای مدیران گروه است !*',
				en = '`Promote (reply)` : Promote Target\n'
				..'`Promote (@Username)` : Promote (@Username)\n'
				..'`Promote (Mention)` : Promote (Mention)\n'
				..'`Promote (UserID)` : Promote (UserID)\n'
				..'`Demote (reply)` : Demote Target\n'
				..'`Demote (@Username)` : Demote (@Username)\n'
				..'`Demote (Mention)` : Demote (Mention)\n'
				..'`Demote (UserID)` : Demote (UserID)\n'
				..'`Mods Clean` : Clean Moderator List\n'
				..'`Mods List` : Show Mods List\n'
				..'`[Un]Muteuser (reply)` : [Un]Muteuser Target\n'
				..'`[Un]Muteuser (@Username)` : [Un]Muteuser (@Username)\n'
				..'`[Un]Muteuser (Mention)` : [Un]Muteuser (Mention)\n'
				..'`[Un]Muteuser (UserID)` : [Un]Muteuser (UserID)\n'
				..'`Mutes Clean` : Clean Muted Users\n'
				..'`Mutes List` : Show Muted List\n'
				..'`Invite (reply)` : Invite Target\n'
				..'`Invite (@Username)` : Invite (@Username)\n'
				..'`Invite (Mention)` : Invite (Mention)\n'
				..'`Invite (UserID)` : Invite (UserID)\n'
				..'`Kick (reply)` : Kick Target\n'
				..'`Kick (@Username)` : Kick (@Username)\n'
				..'`Kick (Mention)` : Kick (Mention)\n'
				..'`Kick (UserID)` : Kick (UserID)\n'
				..'*This Plugin is Only usable by Moderators !*',
			},
			rank = 'Mod',
		},
		cli = {
			_MSG = {
				'^([Pp]romote) (.*)$',
				'^([Pp]romote)$',
				'^([Dd]emote)$',
				'^([Dd]emote) (.*)$',
				'^([Mm]ods) ([Cc]lean)$',
				'^([Mm]ods) ([Ll]ist)$',
				'^[/!#]([Pp]romote) (.*)$',
				'^[/!#]([Pp]romote)$',
				'^[/!#]([Dd]emote)$',
				'^[/!#]([Dd]emote) (.*)$',
				'^[/!#]([Mm]ods) ([Cc]lean)$',
				'^[/!#]([Mm]ods) ([Ll]ist)$',
				------------------------------
				'^([Mm]uteuser) (.*)$',
				'^([Mm]uteuser)$',
				'^([Uu]nmuteuser)$',
				'^([Uu]nmuteuser) (.*)$',
				'^([Mm]utes) ([Cc]lean)$',
				'^([Mm]utes) ([Ll]ist)$',
				'^[/!#]([Mm]uteuser) (.*)$',
				'^[/!#]([Mm]uteuser)$',
				'^[/!#]([Uu]nmuteuser)$',
				'^[/!#]([Uu]nmuteuser) (.*)$',
				'^[/!#]([Mm]utes) ([Cc]lean)$',
				'^[/!#]([Mm]utes) ([Ll]ist)$',
				--------------------------------
				'^([Ii]nvite) (.*)$',
				'^([Ii]nvite)$',
				'^([Kk]ick)$',
				'^([Kk]ick) (.*)$',

			},
	--		Pre = Pre,
			run = Run
		},
		api = {
			_MSG = {

			},
	--		Pre = ApiPre,
	--		run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}