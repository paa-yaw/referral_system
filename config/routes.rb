Rails.application.routes.draw do

  get 'messages/index'

  get 'messages/show'

  namespace :admin do 
    get 'dashboard/dashboard', to: 'dashboard#dashboard', as: :dashboard
    # get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
    patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
    patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
    patch 'admin_users/:id/update_button', to: 'admin_users#update_button', as: :update_button_for_admin
    patch 'companies/:id/contact_company', to: 'companies#contact_company', as: :contact_company
    patch 'companies/:id/deal_with_company', to: 'companies#deal_with_company', as: :deal_with_company
    get 'activity_feed/index', to: 'activity_feed#index', as: :activity_feed
    get 'activity_feed/show', to: 'activity_feed#show', as: :show_activity
    patch 'messages/:id/send_message', to: 'messages#send_message', as: :send_message

    # resources :users, only: [] do 
    #   resources :companies
    # end
    resources :admin_users
    resources :users, only: [:index, :show]
    
    resources :companies do 
      resources :job_descriptions
    end

    resources :job_descriptions, only: [] do 
      resources :requirements, only: [:index, :show]
      resources :applicants
    end

    resources :messages
  end

  devise_for :users, controllers: { registrations: :registrations  }

  root to: 'dashboard#index'
  # get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
  
  patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
  patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
  patch 'applicants/:id/update_button', to: 'applicants#update_button', as: :update_button_for_applicants
  patch 'requirements/:id/update_button', to: 'requirements#update_button', as: :update_button_for_rq
  patch 'qualifications/:id/update_button', to: 'qualifications#update_button', as: :update_button_for_qualification
  patch 'required_experiences/:id/update_button', to: 'required_experiences#update_button', as: :update_button_for_exp
  patch 'job_descriptions/:id/complete_job_description', to: 'job_descriptions#complete_job_description', as: :complete_jd
  patch 'job_descriptions/:id/update_job_description', to: 'job_descriptions#update_job_description', as: :update_jd
  get 'activity_feed/index', to: 'activity_feed#index', as: :activity_feed
  get 'activity_feed/show', to: 'activity_feed#show', as: :show_activity


  resources :user, only: [] do 
    resources :companies 
  end

  resources :companies do 
    resources :job_descriptions
  end

  resources :job_descriptions, only: [] do 
    resources :requirements
    resources :applicants
    resources :qualifications
    resources :required_experiences
  end

  resources :messages, only: [:index, :show]
end
