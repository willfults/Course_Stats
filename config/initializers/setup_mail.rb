ActionMailer::Base.smtp_settings = {  
      :address              => "smtp.gmail.com",  
      :port                 => 587,  
      :domain               => "gmail.com",  
      :user_name            => "socialuniversity1@gmail.com",  
      :password             => "c4llsource",  
      :authentication       => "plain",  
      :enable_starttls_auto => true  
    }  