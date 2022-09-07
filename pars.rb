require 'nokogiri'
require 'httparty'
require 'byebug'
require 'json'

module WaterTemp

	def self.pars_page
		url = 'https://pogoda1.ru/mir/evropa/belarus/temperatura-vody/5-dney/#main'

		@unparsed_page = HTTParty.get(url)
		parsed_page = Nokogiri::HTML(@unparsed_page.body)
		@table = parsed_page.css("table.table.table-water-temp")
		@unparsed_days = @table.css("tr").first.children.children
	end	

	def self.data_days
		pars_page
		@days = []
		@unparsed_days.each do |day|	 
			@days << day.text		
		end
		return @days
	end

	def self.data	
		pars_page
		data = []
		@table.xpath( '//table/tr/td//text()' ).each_with_index do |td, index|		
			data << td.content
		end
		return data
	end

	def self.data_rivers
		data
		@rivers = []

		@temp = data.each_slice(6).to_a

		@temp.each do |arr|
			arr.each do |river|
				if river.include?('река')
					@rivers << river
				end
			end
		end
		return @rivers
	end

	def self.days_temp(river)
		data_days
		data_rivers		
		@temp.each do |arr|			
			arr.each do |t|				
				if t.include?(river)
					return "#{arr[0]}: 
					#{@days[0]}: #{arr[1]} 
					#{@days[1]}: #{arr[2]} 
					#{@days[2]}: #{arr[3]} 
					#{@days[3]}: #{arr[4]} 
					#{@days[4]}: #{arr[5]}"
				end	
			end
		end
	end

end
