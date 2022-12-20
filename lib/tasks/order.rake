namespace :order do
  desc "Destroy all orders without users"
  task clean_unnamed: :environment do
    orders = Order.all
    count = 0
    puts "🧑‍🔧 Starting order filtering and destruction"
    puts "."
    puts "."
    puts "."
    orders.each do |order|
      if order.deceased_first_name.nil? && order.deceased_last_name.nil? && (((Time.now - order.updated_at) / 3600) > 24)
        count += 1
        order.destroy
      end
    end
    if count > 0
      puts "🙅 #{count} order#{count == 1 ? '' : 's'} have been destroyed"
    else
      puts "👌 All orders had users → no destruction"
    end
  end

  task clean_unpaid: :environment do
    orders = Order.all
    count = 0
    puts "🧑‍🔧 Starting order filtering and destruction"
    puts "."
    puts "."
    puts "."
    orders.each do |order|
      if !order.paid? && (((Time.now - order.updated_at) / 3600) > 24)
        count += 1
        order.destroy
      end
    end
    if count > 0
      puts "🙅 #{count} order#{count == 1 ? '' : 's'} have been destroyed"
    else
      puts "👌 All orders have been paid → no destruction"
    end
  end
end
