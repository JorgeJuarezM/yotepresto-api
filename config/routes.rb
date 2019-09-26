Rails.application.routes.draw do
  get 'home/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api  do
    namespace :v1 do
      resources :user, only: [:index] do

        #member do
        #  put 'update' => 'user#update'
        #end

        collection do
          post 'new_admin' => 'user#new_admin'
          post 'new_holder' => 'user#new_holder'
          get 'all' => 'user#all'
        end
      end

      resources :transfers, only: [:index] do

        collection do
          post 'deposit' => 'transfers#deposit'
          post 'withdraw' => 'transfers#withdraw'
          post 'transfer' => 'transfers#transfer'
          get 'all' => 'transfers#all'
        end

      end

      resources :bank_account, only: [:index] do
         collection do
           get 'all' => 'bank_account#all'
           get 'my_balance' => 'bank_account#my_balance'
           post 'balance_by_code' => 'bank_account#balance_by_code'
         end
      end

      post 'account/login' => 'account#login'
    end
  end

  match "*path", to: "errors#err_404", via: :all
  root 'home#index'
end
