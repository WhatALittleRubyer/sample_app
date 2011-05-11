
# by using the symbol ':user', we get FG to simulate the User model.
Factory.define :user do |user|
  user.name                   "Stink Bungford"
  user.email                  "stink.bungford@foo.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

  
