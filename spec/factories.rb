require 'faker'

Factory.define :user do |f|
  f.sequence(:id) {|n| n }
  f.sequence(:login) {|n| "User#{n}" }
  f.sequence(:name) {|n| "Имя#{n}" }
  f.sequence(:email) {|n| "user#{n}@example.com" }    
  # Password - monkey
  f.crypted_password "0da237a175b69218dd8e0362e9d81070dc1c0307"
  # Salt - SHA1('0') 
  f.salt "ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4"
end

Factory.define :town do |f|
  f.sequence(:name) {|n| "Город №#{n}" }
end

Factory.define :street do |f|
  f.sequence(:name) {|n| "Улица №#{n}" }
end

Factory.define :mail do |f|
  f.from { |from| from.association(:user) }
  f.to { |to| to.association(:user) }
  f.sequence(:title) {|n| "Название #{n}" }
  f.body { Faker::Lorem.sentences(10) }
  f.read { rand_true_false } 
end

Factory.define :org do |f|
  f.sequence(:name) {|n| "Организация №#{n}" }
  f.description { Faker::Lorem.sentences(10) }
  f.user { |user| user.association(:user) }
  f.town { |town| town.association(:town) }
  f.street { |street| street.association(:street) }
  f.house { rand(2) }
  f.sequence(:email) {|n| "company#{n}@example.com" } 
  f.sequence(:www) { |n| "http://example#{n}.com"}
end

Factory.define :category do |f|
  f.parent_id 2
  f.sequence(:name) {|n| "Категория №#{n}" }
end