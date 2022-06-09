require "sequel"
require "telegram/bot"
require "telegram_bot"
require "gruff"
token = "5489884368:AAGB-s1HxA48Gui9OnW3CaF6N_nVJC7n1Ik"
#bot = TelegramBot.new(token: token)
DB = Sequel.sqlite("test.db")
#print conn
##DB = Sequel.sqlite("test.db")
print DB # memory database, requires sqlite3

unless DB.table_exists?(:dicks)
  DB.create_table :dicks do
    primary_key :id

    column :user_id, Integer
    column :amount, Integer
    column :username, String
    column :last_timestamp, Integer
  end
end

dicks = DB[:dicks]
# Create a dataset

# Populate the table
#items.insert(:user => "abc", :price => rand * 100)
#items.insert(:name => "def", :price => rand * 100)
#items.insert(:name => "ghi", :price => rand * 100)

# Print out the number of records
#puts "Item count: #{items.count}"

# Print out the average price
#puts "The average price is: #{items.avg(:price)}"
counter_greet = 0
delay = 5

def randomize
  value = rand(-5..10).to_i
  return value
end

%%

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
   
    command = message.get_command_for(bot)
    #name = bot.getChatMemberName(fro)
    message.reply do |reply|
      case command
      when /start/i
        bot.api.send_
      when /greet/i
        if counter_greet = 0
          counter_greet += 1
        else
          reply.text = "1"
          amount_to_add = rand(-5..10)
          if dicks.where(user_id: message.from.id) == 0
            dicks.insert(:user_id => message.from.id, :amount => amount_to_add)
            me = dicks.where(:user_id => message.from.id).get([:user_id, :amount])[1]
            
          else
            me = (dicks.where(:user_id => message.from.id).get([:user_id, :amount]))[1]
            me = amount_to_add + me
            dicks.update(user_id: message.from.id, amount: me)
          
            if amount_to_add >= 0
            % % ## reply.text = "#{message.from.first_name}, Your dick length is #{me} cm (+#{amount_to_add} from last time)"
  ## else
  ##  reply.text = "#{message.from.first_name}, Your dick length is #{me} cm (#{amount_to_add} from last time)"
  ##  end
  ##  puts "Your dick length is #{dicks.where(:user_id => message.from.id).get([:user_id, :amount])}"
  # reply.text = "#{message.from.user_id}, Your dick length is #{me}(#{amount_to_add} from last time)"
  %%   end
        end
      else% %
  ##  reply.text = "I have no idea what #{command.inspect} means."
  ##end
  ## puts "sending #{reply.text.inspect} to @#{message.from.user_id}"
  %%if reply.text != "1"
        reply.send_with(bot)
      end
    end
  end
end
% %
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    #  bot.api.send_message(chat_id: message.chat.id, text: "@#{message.from.username}: #{message.text}")
    case message
    when Telegram::Bot::Types::Message
      case message.text
      when "/start"
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      when "/dick"
        amount_to_add = rand(-5..10)
        print "messade id: #{message.from.id}"
        a = dicks.select(:user_id).where(user_id: message.from.id).to_hash_groups(:user_id).to_a[0]
        #print "#{a} before\n\n"
        ## print "#{dicks.select(:user_id).where(user_id: message.from.id).to_hash_groups(:user_id).to_a}\n\n"
        if a == nil
          amount_to_add += 10
          ##  print "#{a} after  exists"
          print "123\n\n"
          dicks.insert(:user_id => message.from.id, :amount => amount_to_add, :username => message.from.first_name, last_timestamp: Time.now.to_i)
          a = dicks.select(:user_id).where(user_id: message.from.id).to_hash_groups(:user_id).to_a
          print "#{a}after\n\n"
          #print "#{dicks.where(user_id: message.from.id).to_hash_groups(:user_id).to_a} \n\n"
          me = dicks.where(:user_id => message.from.id).get([:user_id, :amount])[1]
          #puts "#{me}"
          if amount_to_add >= 0
            bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, Your dick length is #{me} cm (+#{amount_to_add} from last time)", reply_to_message_id: message.message_id)
          else
            bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, Your dick length is #{me} cm (#{amount_to_add} from last time)", reply_to_message_id: message.message_id)
          end
        else
          time_difference = Time.now.to_i - dicks.where(:user_id => message.from.id).get([:last_timestamp])[0]
          time_to_elapse = (time_difference - (delay * 60 * 60)).abs
          hours = time_to_elapse / 60 / 60
          print "\n hours: #{hours}  time difference: #{time_difference} time to elapse #{time_to_elapse}   "
          minutes = time_to_elapse / 60
          print "minutes: #{minutes} \n\n"
          while minutes >= 60
            minutes -= 60
          end
          if time_difference < (delay * 60 * 60)

            if hours == 1
              bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, please wait #{hours} hour #{minutes} minutes", reply_to_message_id: message.message_id)
            else
              bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, please wait #{hours} hours #{minutes} minutes", reply_to_message_id: message.message_id)
            end
          else
            arrayy = (dicks.where(:user_id => message.from.id).get([:user_id, :amount]))
            # print "#{message.from.id} user prints /dick\n"
            # print "#{amount_to_add} is skolko dobavit\n"
            me = (dicks.where(:user_id => message.from.id).get([:user_id, :amount]))[1]
            # print "base: #{arrayy} - user_id / old_dick\n"
            me = amount_to_add + me
            #  print "#{me} dick after add\n"
            #bot.api.send_message(chat_id: message.chat.id, text: "#{arrayy}")
            sqlstring = "UPDATE dicks SET amount = #{me} WHERE user_id = #{message.from.id};"
            sqlstring_time = "UPDATE dicks SET last_timestamp = #{Time.now.to_i} WHERE user_id = #{message.from.id};"
            dicks.with_sql_all(sqlstring) ##where(:user_id => message.from.id).update(amount: me, last_timestamp: Time.now.to_i)
            dicks.with_sql_all(sqlstring_time)
            ##dicks.update(user_id: arrayy[0], amount: me, last_timestamp: Time.now.to_i)
            arrayy = (dicks.where(:user_id => message.from.id).get([:user_id, :amount]))
            #  print "after save #{arrayy}\n"

            if amount_to_add >= 0
              bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, Your dick length is #{me} cm (+#{amount_to_add} from last time)", reply_to_message_id: message.message_id)
            else
              bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, Your dick length is #{me} cm (#{amount_to_add} from last time)", reply_to_message_id: message.message_id)
            end
            # puts "Your dick length is #{dicks.where(:user_id => message.from.id).get([:user_id, :amount])}"
            # reply.text = "#{message.from.username}, Your dick length is #{me}(#{amount_to_add} from last time)"
          end
        end
        ##print "#{dicks.where(user_id: message.from.id)} after \n"
        a = dicks.where(user_id: message.from.id).to_hash_groups(:user_id)
        #print "#{a} after \n\n"
      when "/stats"
        #  bot.api.send_message(chat_id: message.chat.id, text: "fdsnkndns")
        ##stats_db = dicks.order(:amount).select(:username, :amount)

        stats_db = dicks.to_hash_groups(:username, :amount).to_a
        g = Gruff::Pie.new(800)
        g.title = "Dick gang"
        g.theme = Gruff::Themes::PASTEL
        stats_db.each do |data|
          g.data(data[0], data[1])
        end
        g.write("pie_grey.png")
        print "#{stats_db}\n\n" #bot.api.send_message(chat_id: message.chat.id, text: "#{stats_db}")

        topstats = "Top dicks:\n\n"

        array_topstats = Array.new(stats_db.length) { Array.new(2) }
        cnt = 0
        stats_db.each do |data|
          array_topstats[cnt][0] = data[0]
          array_topstats[cnt][1] = data[1].join.to_i
          cnt += 1
        end
        # print "#{array_topstats} before \n\n"
        #   print "#{array_topstats.sort!{|a,b| a[1] <=> b[1]}.reverse!}"
        array_topstats.sort! { |a, b| a[1] <=> b[1] }.reverse!
        # print "#{array_topstats} after \n\n"
        array_topstats.each do |data|
          topstats += "#{data[0]} - #{data[1].to_s}cm \n\n"
        end
        bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new("./pie_grey.png", "image/png"), caption: "#{topstats}")
        # bot.api.send_message(chat_id: message.chat.id, text: "#{topstats}")
      when "/printdb"
        if !(DB.table_exists?(:dicks))
          bot.api.send_message(chat_id: message.chat.id, text: "Your database is empty")
        else
          all_stats = dicks.select(:user_id, :username, :amount).select_all.to_hash_groups(:user_id).to_a
          print "#{all_stats}\n\n" ##bot.api.send_message(chat_id: message.chat.id, text: "#{all_stats}")
        end
      when "/stop"
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
      when "/cleartable"
        if message.from.id != 864415878
          bot.api.send_message(chat_id: message.chat.id, text: "You are not that guy, pal. Trust me, you are not that guy", reply_to_message_id: message.message_id)
        else
          sqlstring = "SELECT name FROM sqlite_schema WHERE type ='table' AND name NOT LIKE 'sqlite_%';"
          # print sqlstring.to_hash_groups(:user_id).to_a
          DB.drop_table?(:dicks)
          DB.create_table :dicks do
            primary_key :id

            column :user_id, Integer
            column :amount, Integer
            column :username, String
            column :last_timestamp, Integer
          end
          dicks = DB[:dicks]
          #  all_stats = dicks.select(:user_id, :username, :amount).select_all.to_hash_groups(:user_id).to_a
          #  bot.api.send_message(chat_id: message.chat.id, text: "#{all_stats}")
        end
      end
    end
  end
end
