namespace :order do
  desc "Destroy all orders without users"
  task clean_orphan_orders: :environment do
    orders = Order.all
    count = 0
    puts "🧑‍🔧 Starting order filtering and destruction"
    puts "."
    puts "."
    puts "."
    orders.each do |order|
      if order.user.nil?
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
end
