require 'telegram/bot'
require_relative 'pars'
require 'dotenv/load'


TOKEN = ENV["MYTOKEN"]

Telegram::Bot::Client.run(TOKEN) do |bot|
	bot.listen do |message|
		case message 
		when Telegram::Bot::Types::Message
			bot.api.send_message(chat_id: message.from.id, text: "Температура водоёмов Беларуси на 5 дней #{p}")

			kb = WaterTemp.data_rivers.map {|river|			  
				Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{river}", callback_data: "#{river}")
			}			

			markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
			bot.api.send_message(chat_id: message.chat.id, text: "Все водоёмы:", reply_markup: markup)	

		when Telegram::Bot::Types::CallbackQuery			
			if WaterTemp.data_rivers.include?(message.data)
				bot.api.send_message(chat_id: message.from.id, text: "#{WaterTemp.days_temp(message.data)}")										
			end		
		end		
	end
end
