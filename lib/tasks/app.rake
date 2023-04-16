desc "Run the app"
task run: :environment do
  App.call
end
