class Book < ApplicationRecord

  self.table_name = "BOOK"

  def self.search(name, filters)
    flag = false
    if name.nil?
      sql = "SELECT * FROM BOOK"
    else
      sql = "SELECT * FROM BOOK WHERE lower(title) LIKE '%#{name.to_s.downcase}%'"
      flag = true
    end
    unless filters.nil?
      unless flag
        sql = sql + " WHERE "
      end
      sql = sql + " AND " + filters.join(" AND ")
    end
    Book.find_by_sql(sql)
  end

  def self.isbn_search(isbn)
    sql = "SELECT * FROM BOOK WHERE ISBN = \"#{isbn}\""
    Book.find_by_sql(sql)
  end
end
