# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  price       :float(24)        not null
#  quantity    :float(24)        not null
#  measurement :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ActiveRecord::Base
  MEASUREMENT = %w(kg mg m cm box pack)

  with_options presence: true do |opt|
    opt.validates :name, allow_blank: false
    opt.validates :price, numericality: true
    opt.validates :quantity, numericality: true
  end
end
