require "sinatra"
require "sinatra/json"
require "wuparty"
require "active_support/core_ext"

get '/' do
  wufoo = WuParty::Form.new(ENV['FORM'],:account => ENV['ACCOUNT'], :api_key => ENV['API_KEY'])
  current = Time.new

  year = wufoo.count(:filters => [['DateCreated','Is_after', current.prev_year.end_of_year]])
  current_month = wufoo.count(:filters => [['DateCreated','Is_after',current.prev_month.end_of_month]])
  prev_month = wufoo.count(:filters => [['DateCreated','Is_after',current.prev_month.prev_month.end_of_month], 
                                        ['DateCreated','Is_before',current.beginning_of_month]])

  json :item => [{:value => "#{year}", :text => "Total for #{current.strftime("%Y")}"},
                 {:value => "#{current_month}", :text => "Total for #{current.strftime("%B %Y")}"},
                 {:value => "#{prev_month}", :text => "Total for #{current.prev_month.strftime("%B %Y")}"}]
end
