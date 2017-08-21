
http = require "socket.http"
ltn12 = require 'ltn12'
multipart = require 'multipart-post'


local function makeRequest(uRL, request_body)
  local response = {}
  local body, boundary = multipart.encode(request_body)

  local success, code, headers, status = https.request{
    url = uRL,
    method = 'POST',
    headers = {
      ['Content-Type'] =  'multipart/form-data; boundary=' .. boundary,
      ['Content-Length'] = string.len(body),
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response),
  }

  local respbody = table.concat(response or {"no response"})
  local jbody = json.decode(respbody)
  return jbody
end


	function ApiRun(msg, matches)
		AP_KEY = '34ba152fddf4ebc8358af60faaf0379d	'
		if matches[2] == 'SPR' then
		if matches[1] == '1' then
			SPRC = tonumber(matches[1])
			Coust = 50000
			if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
				TEXT = "شما در حال خرید ربات وی ای پی به مدت یک ماه هستید "
			else
				TEXT = 'Your Gonna to buy 1 Mounth VIP Group !'
			end
		elseif matches[1] == '2' then
			SPRC = tonumber(matches[1])
			Coust = 90000
			if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
				TEXT = "شما در حال خرید ربات وی ای پی به مدت دو ماه هستید "
			else
				TEXT = 'Your Gonna to buy 2 Mounth VIP Group !'
			end
		elseif matches[1] == '3' then
			Coust = 130000
			SPRC = tonumber(matches[1])
			if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
				TEXT = "شما در حال خرید ربات  وی ای پی به مدت سه ماه هستید "
			else
				TEXT = 'Your Gonna to buy 3 Mounth VIP Group !'
			end
		elseif matches[1] == '4' then
			SPRC = tonumber(matches[1])
			Coust = 170000
			if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
				TEXT = "شما در حال خرید ربات وی ای پی به مدت چهار ماه هستید "
			else
				TEXT = 'Your Gonna to buy 4 Mounth VIP Group !'
			end
		else
			TEXT = ':|'
		end
		redis:set('Count:'..msg.from.id, SPRC)
		url = 'https://pay.ir/payment/send'
		JDT = makeRequest(url, {
			amount = tostring(Coust),
			api = AP_KEY,
			redirect = 'http://pay.Tele-fake.ir',
			})
		keyboard = {
			inline_keyboard = {
				{ { text = 'بله ادامه', callback_data = 'PayMent '..JDT.transId } },
				{ { text = 'Back|بازگشت', callback_data = 'buy spr' } }
			}
		}
		api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
		end
		if matches[1] == 'PayMent' then
			URLTOPAY = 'https://pay.ir/payment/gateway/'.. matches[2]
			if (redis:get(msg.message.chat.id..'Lang') or 'fa') == 'fa' then
				TEXT = 'لینک پرداخت شما : [برای پرداخت کلیک کنید !]('..URLTOPAY .. ')\n'
				..'بعد از پرداخت بر روی دکمه ✅ کلیک کنید در غیر این صورت لغو را برنید !'
			else
				TEXT = 'Your Payment link : [Click To Pay]('.. URLTOPAY ..')'
				..'\nAfter pay use Buttens !'
			end
			keyboard = {
			inline_keyboard = {
					{ { text = '✅', callback_data = 'CheckPay '..matches[2] } },
					{ { text = 'Back|بازگشت', callback_data = 'buy spr' } }
				}
			}
			api.editMessageText(_Config.TOKEN, msg.message.chat.id, msg.message.message_id, TEXT, 'md', keyboard)
		end
		if matches[1] == 'CheckPay' then
			JDT = makeRequest('https://pay.ir/payment/verify', {
			transId = matches[2],
			api = AP_KEY,
			})
			if tostring(JDT.status) == tostring('1') then
				redis:set(msg.from.id..'GettingsGroup!', 'vip')
				redis:set(msg.from.id..'GettingsGroup!!', redis:get('Count:'..msg.from.id))

				if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
					TEXT = 'لینک خود را ارسال کنید!'
				else
					TEXT = 'Send Your link!'
				end
			else
				VarDump(JDT)
				if (redis:get(msg.from.id..'Lang') or 'fa') == 'fa' then
					TEXT = 'پرداخت تایید نشد !'
				else
					TEXT = 'unSuccess Payment !'
				end
			end
			keyboard = {
			inline_keyboard = {
					{ { text = 'Back|بازگشت', callback_data = 'buy spr' } }
				}
			}
			api.editMessageText(_Config.TOKEN, msg.from.id, msg.message.message_id, TEXT, 'md', keyboard)
		end

	end



	return {
		cli = {
			_MSG = {

			},
	--		Pre = Pre,
	--		run = Run
		},
		api = {
			_MSG = {
				'^!#MessageCall (PayMent) (.*)$',
				'^!#MessageCall (CheckPay) (.*)$',
				'^!#MessageCall (1) (SPR)$',
				'^!#MessageCall (2) (SPR)$',
				'^!#MessageCall (3) (SPR)$',
				'^!#MessageCall (4) (SPR)$',


			},
	--		Pre = ApiPre,
			run = ApiRun
		},
		CheckMethod = 'f80', -- Also Can use as 'TeleSeed' ! # If use TeleSeed Input Will be msg = { to = {}, from = {}} :))
	--	Cron = Cron
	}
