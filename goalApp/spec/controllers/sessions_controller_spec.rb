require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe "POST #create" do
    it "does not log in with bad creds and shows errors" do
      post :create, params: { user: {username: 'Alexina', password:'wrong_password'} }
      expect(response).to render_template('new')
      expect(flash[:errors]).to be_present
    end

    describe "logs in with the proper credentials" do
      it "redirects to user show page" do
        post :create, params: { user: {username: 'Alexina', password: 'secure_password'} }
        user = User.find_by_username('Alexina')

        expect(response).to redirect_to(user_url(user.id))
      end

      it "logs in the user" do
        post :create, params: { user: { username: 'Alexina', password: 'secure_password'} }
        user = User.find_by_username('Alexina')

        expect(session[:session_token]).to eq(user.session_token)
      end
    end
  end

  describe "DELETE #destroy" do
    it "logs out a user" do
      user = User.find_by_username('Alexina')
      delete :destroy
      expect(session[:session_token]).not_to eq(user.session_token)
    end
  end

end
