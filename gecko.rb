require "sinatra"
require "sinatra/json"
require "wuparty"
require "active_support/core_ext"

get '/' do
  wufoo = WuParty::Form.new(ENV['FORM'],:account => ENV['ACCOUNT'], :api_key => ENV['API_KEY'])
  current = Time.new

  #Current Year
  year = wufoo.count(:system => true,
                     :filters => [['DateCreated','Is_after', current.prev_year.end_of_year],
                                  ['CompleteSubmission','Is_equal_to',1]])
  #Current Month
  current_month = wufoo.count(:system => true,
                              :filters => [['DateCreated','Is_after',"#{current.prev_month.end_of_month.strftime("%Y-%m-%d 23:59:59")}"],
                                           ['CompleteSubmission','Is_equal_to',1]])
  #Previous Month
  prev_month = wufoo.count(:system => true,
                           :filters => [['DateCreated','Is_after',"#{current.prev_month.prev_month.end_of_month.strftime("%Y-%m-%d 23:59:59")}"], 
                                        ['DateCreated','Is_before',"#{current.beginning_of_month.strftime("%Y-%m-%d 00:00:01")}"],
                                        ['CompleteSubmission','Is_equal_to',1]])

  json :item => [{:value => "#{year}", :text => "Total for #{current.strftime("%Y")}"},
                 {:value => "#{current_month}", :text => "Total for #{current.strftime("%B %Y")}"},
                 {:value => "#{prev_month}", :text => "Total for #{current.prev_month.strftime("%B %Y")}"}]
end
