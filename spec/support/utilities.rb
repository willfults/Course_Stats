# Sign in user to 
def sign_in_user(user)
  user.confirm!
  visit "/users/sign_in"

  fill_in "user_email",                 :with => user.email
  fill_in "Password",              :with => user.password
  
  click_button "Sign in"
end

def expect_email(email)
  delivered = ActionMailer::Base.deliveries.last
  expected =  email.deliver

  delivered.multipart?.should == expected.multipart?
  delivered.headers.except("Message-Id").should == expected.headers.except("Message-Id")
end