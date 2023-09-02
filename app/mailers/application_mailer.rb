class ApplicationMailer < ActionMailer::Base
  default from: ENV["your_email"]
  layout "mailer"
end
