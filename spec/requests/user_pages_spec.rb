require 'spec_helper'

describe "User pages" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  subject { page }
  
  describe "signup page" do
    before { visit new_user_registration_path }

    it { should have_selector('h2',    text: 'Sign up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    
    before { 
      sign_in_user user
      visit user_path(user) 
    }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup" do

    before { visit new_user_registration_path }

    let(:submit) { "Sign up" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        
        let(:user) { User.find_by_email('user@example.com') }

        it {ActionMailer::Base.deliveries.last.to.should == ['user@example.com']}
        
        it {ActionMailer::Base.deliveries.last.subject.should == 'Confirmation instructions'}
        
        it {ActionMailer::Base.deliveries.last.body.should have_link('Confirm my account')}

        #todo
        #it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-notice', text: 'A message with a confirmation') }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in_user(user)
      visit edit_user_registration_path
    end

    describe "page" do
      it { should have_selector('h2',    text: "Edit User") }
    end

    describe "with invalid information" do
      before { click_button "Update" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Password confirmation", with: user.password
        fill_in "Current password", with: user.password
        click_button "Update"
      end

      it { should have_selector('h1', text: new_name) }
      it { should have_selector('div.alert.alert-notice') }
      
      it { should have_link('Sign out', href: destroy_user_session_path) }
      
      #todo
      #specify { user.reload.name.should  == new_name }
      #specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }

    before(:each) do
      sign_in_user(user)
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

   
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before {
      sign_in_user(user) 
      visit user_path(user) 
     }
  
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      
      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end    
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_other) { FactoryGirl.create(:user) }
    before { user.follow!(user_other) }

    describe "followed users" do
      before do
        sign_in_user(user)
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(user_other.name, href: user_path(user_other)) }
    end

    describe "followers" do
      before do
        sign_in_user user_other
        visit followers_user_path(user_other)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end

end