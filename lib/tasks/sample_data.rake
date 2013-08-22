namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(email: example999@ads.pr.gov,
                          password: "foobar",
                          password_confirmation: "foobar",
                          admin: true)
                          
                          
  end
end