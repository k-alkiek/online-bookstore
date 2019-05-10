class ReportsController < ApplicationController
	authorize_resource :class => false

	# Sales for last month
  def sales
  	@sales = 0
  	sql = "SELECT SUM(price) as sales FROM PURCHASE
					WHERE YEAR(date_of_purchase) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
					AND MONTH(date_of_purchase) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);"
		result = ActiveRecord::Base.connection.execute(sql)
		@sales = result.first.first if result.first.first.present?
  end

  # The top 5 customers who purchased the most for the last three months
  def top_customers
  	sql = "SELECT User.id, first_name,last_name, SUM(price) as buyings FROM
	        PURCHASE inner join `User` on User.id = User_id
					WHERE YEAR(date_of_purchase) = YEAR(CURRENT_DATE - INTERVAL 3 MONTH)
					AND MONTH(date_of_purchase) = MONTH(CURRENT_DATE - INTERVAL 3 MONTH)
					GROUP BY User.id ORDER BY buyings DESC LIMIT 5;"
		@users = ActiveRecord::Base.connection.execute(sql)
  end

  # The top 10 selling books for the last three months
  def best_selling
  	sql = "SELECT ISBN, title, SUM(price) as sales FROM
	        PURCHASE inner join BOOK on ISBN = BOOK_ISBN
					WHERE YEAR(date_of_purchase) = YEAR(CURRENT_DATE - INTERVAL 3 MONTH)
					AND MONTH(date_of_purchase) = MONTH(CURRENT_DATE - INTERVAL 3 MONTH)
					GROUP BY BOOK_ISBN ORDER BY sales DESC LIMIT 10;"
		@books = ActiveRecord::Base.connection.execute(sql)
  end
end
