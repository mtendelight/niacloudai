Rails.application.routes.draw do
  get "requirement/index"


  mount ActionCable.server => "/cable"

post "jmleads/:id/send_whatsapp",
     to: "jmleads#send_whatsapp",
     as: :send_whatsapp_jmlead
  # config/routes.rb

  get "bales_predictions/export",
    to: "bales_predictions#export",
    as: :export_bales_predictions

post "preview_offer_sms",
     to: "jmai#preview_offer_sms",
     as: :preview_offer_sms

     
resources :bales_predictions, only: [:index] do
  collection do
    post :refresh
    post :rebuild_now
  end
end


  post "send_bulk_sms", to: "jmai#send_bulk_sms", as: :send_bulk_sms

  # config/routes.rb
resources :daily_tasks do
member do
  get :move_up
  get :move_down
end
end
  # STK Push
match "mtendelightpayments/stkpush",
      to: "mtendelightpayments#stkpush",
      via: [:get, :post, :put],
      as: :stkpush_mtendelightpayments

# Safaricom Callback
match "mtendelightpayments/callback",
      to: "mtendelightpayments#callback",
      via: [:get, :post, :put, :patch],
      as: :callback_mtendelightpayments

# Standard CRUD
resources :mtendelightpayments


  resources :mtendelightvideos

resources :knowledge_feedbacks, only: [:index, :show]

resources :ailogs, only: [:index]
  get "aiproducts/index"


  resources :aiproducts do
  collection do
    post :import
  end
end

    get  "/webhook", to: "whatsapp#verify"
  post "/webhook", to: "whatsapp#receive"
  get "errors/not_found"
  get "jbi/index"
# config/routes.rb
get "sms_campaign", to: "jmai#sms_campaign"
post "send_custom_sms", to: "jmai#send_custom_sms"
post "send_single_sms", to: "jmai#send_single_sms"
  resources :mmfreport, only: [:index]
  get "mmfreport/index"
  resources :dispatchmmfs
get "dispatch_maturity", to: "mmfs#dispatch_maturity"
  
root to: 'home#index'
get '/home', to: 'home#index'
  resources :jfaqs

  get "jknows/index"
  get "jknow/index"
  resources :jknows
  resources :jmproducts
  get "jmproducts/index"
 
resources :openjobs do
  resources :job_applications, only: :create
end
 resources :janomaxleads do
  collection do
    post :import
    get :dashboard
  end
end




  resources :stock_movement_items
resources :stock_movement_batches do
  member do
    patch :confirm
  end
end
  resources :jpartialstocks
  get "mroadmap/index"

    get "niacomputerall/index"
resources :niaproductstocks, only: [:index, :update]

  resources :niaproducts

resource :niacheckout, only: [:new, :create]
 resource :niacart, only: [:show] do
  post :add
  post :increase
  post :decrease
  delete :remove
end
resources :niaorders do
  member do
    patch :update_status
  end
end
  resources :niacategories
  
# routes.rb
post "fetch_trends", to: "trends#fetch"
  resources :trends

  
# config/routes.rb
resources :contacts do
  collection do
    post :import
  end
end
  resources :noticeboards
 
  resources :conversations do
    resources :messages, only: [:create, :index, :destroy]
  end
  get "/logs", to: "logs#index"
resources :jmpayments, only: [:edit, :update]
get "talents/thank_you", to: "talents#thank_you"
resources :talents do
  collection do
    get :export_resumes
  end
end
# config/routes.rb
get "counsellors/thank_you", to: "counsellors#thank_you"
resources :counsellors do
  member do
    get :download_all
  end
end
  resources :mbookings do
    resources :msessions

    collection do
      get :thank_you
    end
  end

resources :contractors do
  resources :cinvoices do
    resources :cinvoice_items

    # ✅ PDF route for invoice (GET)
    get :pdf, on: :member
  end

  resources :cpayments
  resources :cstatements do
    # ✅ PDF route for statement (GET)
    get :pdf, on: :member
  end
end

  resources :jmcustomerpayments, only: [:index]
  get "jmcustomerpayments/index"
# config/routes.rb
get "jmpayments/search", to: "jmpayments#search", as: "search_jmpayments"
post '/jmpayments/import_pdf', to: 'jmpayments#import_pdf'
get  '/jmpayments/import', to: 'jmpayments#import'
get  '/jmpayments/import_results', to: 'jmpayments#import_results'
    resources :m_adventures
  resources :m_hotels

   resources :airbnbs do
    resources :m_customers, only: [:create, :destroy]
  end
  
  resources :m_customers
  resources :campaign_manifestos
  resources :brand_visibilities
resources :mentorships do
  resources :mattendances, only: [:create, :edit, :update]
  resources :partnerships
  collection do
    post :import_attendances
  end
end

resources :jnewsales do
    collection do
    match 'search', to: 'jnewsales#search', via: [:get, :post], as: :search
  end 
end

  get "jbaleai/index"
  
get "m_transactions/dashboard", to: "m_transactions#dashboard", as: :m_transactions_dashboard

  resources :m_time_offs
  resources :m_payrolls
  resources :m_employees
  resources :time_offs
  resources :payrolls
  resources :employees
  resources :m_transactions
  resources :m_accounts
  resources :transactions
  resources :accounts
  resources :businesses
  resources :blocks


  resources :jtasks do
  collection do
    delete :clear_done
  end
end



  resources :jnewstocks do
    collection do
    match 'search', to: 'jnewstocks#search', via: [:get, :post], as: :search
  end 
end
 get "jhh/index"
  get "jbgm/index"
  get "jkisii/index"

  resources :people

 get "jdailyreport/index"
  resources :jagencyperformances
# Branch index routes
get "jwarehouse/index"
get "jmeru/index"
get "jbusia/index"
get "jnakuru/index"
get "jmombasa/index"
get "jkisumu/index"
get "jeldoret/index"
get "jkitale/index"
get "jnairobi/index"

# Branch update_all routes (PATCH)
patch "jwarehouse/update_all", to: "jwarehouse#update_all", as: :update_all_jwarehouse
patch "jmeru/update_all",     to: "jmeru#update_all",     as: :update_all_jmeru
patch "jkisii/update_all",    to: "jkisii#update_all",    as: :update_all_jkisii
patch "jnakuru/update_all",   to: "jnakuru#update_all",   as: :update_all_jnakuru
patch "jmombasa/update_all",  to: "jmombasa#update_all",  as: :update_all_jmombasa
patch "jkisumu/update_all",   to: "jkisumu#update_all",   as: :update_all_jkisumu
patch "jeldoret/update_all",  to: "jeldoret#update_all",  as: :update_all_jeldoret
patch "jkitale/update_all",   to: "jkitale#update_all",   as: :update_all_jkitale
patch "jnairobi/update_all",  to: "jnairobi#update_all",  as: :update_all_jnairobi
patch "jbgm/update_all",  to: "jnairobi#update_all",  as: :update_all_jbgm
patch "jhh/update_all",  to: "jnairobi#update_all",  as: :update_all_jhh
patch "jmreports/update_all",  to: "jmreports#update_all",  as: :update_all_jmreport

  get "jmreports/index"

resources :m_adventures do
  resources :m_bookings
end
  
  resources :jmap_locations
# STK Push endpoint (can handle GET, POST, PUT)
match 'tumapayments/stkpush', to: 'tumapayments#stkpush', via: [:get, :post, :put], as: :stkpush_tumapayments
match 'tumapayments/callback', to: 'tumapayments#callback', via: [:patch, :get, :post, :put], as: :callback_tumapayments

resources :tumapayments



  # STK Push endpoint (can handle GET, POST, PUT)
match 'mmfs/stkpush', to: 'mmfs#stkpush', via: [:get, :post, :put], as: :stkpush_mmfs
match 'mmfs/callback', to: 'mmfs#callback', via: [:patch, :get, :post, :put], as: :callback_mmfs

  resources :mmfs  do
   collection do
      # ✅ Search (give priority)
      match 'search' => 'mmfs#search', via: [:get, :post], as: :search
      get :lookup_customer
 
    end
  end

  resources :jrewards, only: [:index] do
  post :redeem, on: :collection
end

get "orders/check_for_new_orders", to: "orders#check_for_new_orders"

    resources :m_subcontractors do
    resources :m_pos do
         member do
      get :export_excel
      get :export_pdf
       get :exportit_pdf
    end
      resources :m_po_items
      resources :m_invoices do
        resources :m_invoice_items
      end
    end
    resources :m_payments
    resources :m_statements
      member do
    get :export_pos
    get :export_invoices
    get :export_payments
  end
  end

resources :m_approvals do
  member do
    get :approve   # for testing only
    get :reject
    patch :approve
    patch :reject
  end
end

  resources :m_subcontractors do
  resources :m_pos
      member do
      get :export_excel
      get :export_pdf
    end
  resources :m_invoices
  resources :m_payments
  resources :m_statements
end

resources :m_po_items
resources :m_invoice_items
resources :m_approvals


resources :m_subcontractors do
    resources :m_pos     # nested POs
    resources :m_invoices
    resources :m_payments
    resources :m_statements
  end

  resources :m_approvals   # approvals can be top-level


  resources :bills
  get "niareport/index"
  get "niapos/index"
  

resources :utilizes do
  collection do
    post :import   # custom POST action for importing data
  end
end

resources :issues do
  collection do
    post :import   # custom POST action for importing data
  end
end

  get 'slam/index'
   get 'open/index'
  get 'fire/index'
    get 'status/index'
  get 'closed/index'
  get 'slap/index'
  get 'twelve/index'
  get 'six/index'
  get 'three/index'
    get 'two/index'
  get 'one/index'
  get 'four/index'
   get 'direct/index'

  get 'monthly/index'
  get 'weekly/index'
  get 'daily/index'
  get 'sla/index'
   resources :locs do
    collection do
      match 'search' => 'locs#search', via: [:get, :post], as: :search
      match 'query' => 'locs#query', via: [:get, :post], as: :query
    end
  end


  resources :osps do
    collection do
       match 'search' => 'osps#search', via: [:get, :post], as: :search
       match 'query' => 'osps#query', via: [:get, :post], as: :query
    end
  end

  get 'pending/index'
  get 'console/index'
  get 'utilization/index'
  get 'repo/index'
  resources :new_stocks
  get 'two2/index'
  get 'one1/index'
  resources :utilizes
  resources :materials
    resources :materials_imports, only: [:new, :create]
   resources :materials_imports, only: [:new, :create]
  resources :issues

  get 'materials/index'


# config/routes.rb

resources :tickets do
  collection do
    post :import           # custom POST action for bulk import          # custom GET action for tracking
  end
end

resources :locs do
  collection do
    post :import           # custom POST action for bulk import
  end
end

 resources :materials do
    collection do
      match 'search' => 'materials#search', via: [:get, :post], as: :search
    end
  end
  
  
    get 'sla/index'
  resources :reasons


  get 'tickets/:id/edit_f', to: 'tickets#edit_f', as: :edit_f_ticket
  #patch 'tickets/:id', to: 'tickets#update_f', as: :update_f_ticket

    get 'tickets/:id/edit_p', to: 'tickets#edit_p', as: :edit_p_ticket
  #patch 'tickets/:id', to: 'tickets#update_p', as: :update_p_ticket



get 'tickets/1/search', to: 'tickets#search', as: :search_ticket

  get 'tickets_imports/new'
    get 'tickets_imports/create'

    resources :tickets do
    collection do
      match 'search' => 'tickets#search', via: [:get, :post], as: :search
      match 'query' => 'tickets#query', via: [:get, :post], as: :query
       match 'look' => 'tickets#look', via: [:get, :post], as: :look
       match 'track' => 'tickets#track', via: [:get, :post], as: :track
   
      get 'search'

    end
  end
  
    get 'fiber/index'
  get 'lastosp/index'
  resources :pfs
  resources :ospslas
  get 'ospkpi/index'
  get 'allosp/index'
  
    get 'lospending/index'
  get 'losconsole/index'
  get 'los/index'
  get 'hr/index'
  resources :locs
  resources :purchases
  resources :fleets

  resources :surveys do
    resources :questions, except: [:index, :show]  # nested
  end

  resources :responses, only: [:create]

  resources :mcomments

  resources :comments
  resources :milestones
  resources :projects
  resources :real_estates
  resources :net_worth_items
 resources :events  
  resources :olts
 

  resources :ict_issuances do
    collection do
    match 'search', to: 'ict_issuances#search', via: [:get, :post], as: :search
  end 
end

    get "dsa_reports/monthly"
  resources :dsa_sales
  resources :dsas

    resources :jbudgets
    resources :mcontacts do
    collection do
    match 'search', to: 'mcontacts#search', via: [:get, :post], as: :search
  end 
end

  resources :jpermits do 
     collection do
      # ✅ Search (give priority)
      match 'search' => 'jpermits#search', via: [:get, :post], as: :search
 end
end


  resources :jtargets

   resources :joutputs


resources :jrevenues do
  member do
    patch :update_comment
  end
end

  resources :jrevenues

 get 'jimport/index'

  
  resources :janomaxes do
    collection do
      match 'search' => 'janomaxes#search', via: [:get, :post], as: :search
     
      match 'query' => 'janomaxes#query', via: [:get, :post], as: :query
  
    get 'search'
    end

  end


  resources :jstocks do
  collection do
    match 'search', to: 'jstocks#search', via: [:get, :post], as: :search
     match 'query', to: 'jstocks#query', via: [:get, :post], as: :query
    match 'nairobi', to: 'jstocks#nairobi', via: [:get, :post], as: :nairobi
    match 'mombasa', to: 'jstocks#mombasa', via: [:get, :post], as: :mombasa
    match 'kisumu', to: 'jstocks#kisumu', via: [:get, :post], as: :kisumu
    match 'eldoret', to: 'jstocks#eldoret', via: [:get, :post], as: :eldoret
    match 'kitale', to: 'jstocks#kitale', via: [:get, :post], as: :kitale
    match 'kisii', to: 'jstocks#kisii', via: [:get, :post], as: :kisii
    match 'nakuru', to: 'jstocks#nakuru', via: [:get, :post], as: :nakuru
     match 'hh', to: 'jstocks#hh', via: [:get, :post], as: :hh
      match 'bgm', to: 'jstocks#bgm', via: [:get, :post], as: :bgm

    match 'meru', to: 'jstocks#meru', via: [:get, :post], as: :meru
    match 'jmreport', to: 'jstocks#jmreport', via: [:get, :post], as: :jmreport
    match 'warehouse', to: 'jstocks#warehouse', via: [:get, :post], as: :warehouse
     patch :update_warehouse_comment   # ✅ ONLY warehouse comments
    patch :update_bale
    patch :update_all
    patch :update_others
    get :audits  # This will handle both HTML and XLSX formats
    get :jstockout
    post :import
    post :recalculate_amounts
  end
end

 resources :jmreports

patch "jstocks/update_others", to: "jstocks#update_others"

  resources :jstocks

resources :janomaxes do
  collection do
    post :import
    get :new
  end
end

post "jmai/send_offer_sms", to: "jmai#send_offer_sms", as: :send_offer_sms
  resources :janomaxes

  get "jmai/index"

   get "jrewards/index"
  resources :jrewards, only: [:index] do
  post :redeem, on: :collection
end

  get "mose/index"
  get "jano/index"
  get "j_referral_converted/index"
  get "j_referral_pending/index"
  resources :jreferrals

  resources :jbranchperformances

     resources :jsamples do
    # --- 🧠 COLLECTION ROUTES (apply to all customers) ---
    collection do
      # ✅ Search (give priority)
      match 'search' => 'jsamples#search', via: [:get, :post], as: :search
 
    end

  end

   resources :jfulfillments do
    # --- 🧠 COLLECTION ROUTES (apply to all customers) ---
    collection do
      # ✅ Search (give priority)
      match 'search' => 'jfulfillments#search', via: [:get, :post], as: :search
       get :pending
       get :dispatched
       patch :mark_all_delivered
       get :performance
       get :delivered
       get :refund_cancelled
       get :customer_care
       get :refunded
    end

  end

  get "jmbi/index"
  
resources :jmcustomers do
  resources :jmcallcomments, only: :create
  patch :update_callcomments, on: :member
  resources :jmpayments 
  collection do
    match 'search' => 'jmcustomers#search', via: [:get, :post], as: :search
    match 'query' => 'jmcustomers#query', via: [:get, :post], as: :query
    post :send_offer_sms_to_all
    get  :sms_balance
    post :import
  end

  member do
    post :send_offer_sms
  end
end


  get "convertedleads/index"
  get "openleads/index"
resources :jmleads do
collection do
      match 'search' => 'jmleads#search', via: [:get, :post], as: :search
    end

  member do
    patch :add_comment
    get :conversation
  end
end
  resources :jcustomers
  get 'jtpowerbi/index'
  get 'jothers/index'
  get 'jopen/index'
  get 'jtimport/index'




     resources :jtickets do
    collection do
      match 'search' => 'jtickets#search', via: [:get, :post], as: :search
     
      match 'query' => 'jtickets#query', via: [:get, :post], as: :query
  
    get 'search'
    end

  end

 

  get 'jtsignals/index'
  get 'jtprojects/index'
  get 'jtscheduled/index'
  resources :jtickets
  get 'jkitchen/index'
  get 'jpay/index'
  resources :jfeedbacks
  resources :joutputs
  get 'jhousehold/index'
  get 'jshoes/index'
  get 'jbags/index'
 

resources :jbudgets do
  resources :jbudget_expenses, only: [:new, :create, :edit, :update, :destroy]
end

  resources :jbudget_expenses

  

  resources :jevents
  resources :jcalendars
   get 'calendar', to: 'jevents#calendar_page'
  get 'calendar_events', to: 'jevents#calendar'  
  resources :mcalendars do
    resources :mevents
  end



post 'orders/create_from_qr', to: 'orders#create_from_qr'

resources :menu_items do
collection do
get :scan
post :import
end


member do
get :download_qr_code
get :download_audit_logs
post :add_stock
post :update_stock
end
end

   resources :menu_items do
collection do
      match 'search' => 'menu_items#search', via: [:get, :post], as: :search
    end
  end


    resources :menu_items do
    member do
      get :download_audit_logs  # This will define the route for downloading audit logs
    end
  end



       resources :tasks do
collection do
      match 'search' => 'tasks#search', via: [:get, :post], as: :search
    end
  end
    
  resources :tasks

  resources :equitypays

match 'push/stk', to: 'stks#stkpush', via: [:get, :post, :put]
match 'pos', to: 'stks#callback', via: [:patch, :get, :post, :put]
  resources :stks
  resources :mycustomers

  resources :payments do
    collection do
      get 'check_for_new_payment'  # This route will call the check_for_new_payment action
    end
  end
  get "print/index"
  get "pos/index"

   post 'payments/payment_confirmation', to: 'payments#payment_confirmation'

 # config/routes.rb
resources :payments do
  member do
    get 'download_receipt', defaults: { format: :pdf }
  end
end

match 'push/stkpush', to: 'stkpushes#stkpush', via: [:get, :post, :put]
match 'callback', to: 'stkpushes#callback', via: [:patch, :get, :post, :put]

resources :stkpushes



get "/home/index", to: redirect("/")
  get 'suggestions/index'
  get 'contactniapos/index'
   resources :orders do
    collection do
      match 'orders/:id' => 'orders#kitchen', via: [:get, :post], as: :kitchen
     
    end

  end

get 'check_for_new_data', to: 'payments#check_for_new_data', as: :check_for_new_data

  get 'kitchen/index'
  get 'orders/:id/', to: 'orders#edit_f', as: :edit_f 



  # config/routes.rb
resources :menu_items do
  member do
    post 'add_stock'
    patch 'update_stock'
  end
end



resources :customers do
    member do
      get :download_invoice
      post 'send_invoice'
    end
  end
  resources :customers
  resources :clients

  
resources :menu_items do
  collection do
    post :import
    get  :new
  end
end


  resources :opinions
   # MPesa-related routes
  get 'mpesa/index'
  
resources :payments
  resources :menu_items
  resources :inventory_items
  resources :order_items
  resources :orders do
    member do
      get :download_report
    end
  end
  resources :tables
  resources :animals do
    collection do
      match 'search' => 'animals#search', via: [:get, :post], as: :search
    end
  end
  resources :animals
  resources :expenditures
  get 'report/index'
  get 'import/index'

 

  post 'mpesa/timeout', to: 'mpesa#timeout'
  post 'mpesa/stk_push', to: 'mpesa#stk_push'
  post 'mpesa/callback', to: 'mpesa#callback'


  # Devise
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    delete '/users/sign_out', to: 'users/sessions#destroy'
  end

  # Admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :admin do
    get 'error/index', to: 'error#index'
  end

  # API
  namespace :api do
    namespace :v1 do
      post 'mpesa/result', to: 'mpesa#result'
      post 'mpesa/timeout', to: 'mpesa#timeout'
    end
  end

  # Mpesa
  match 'payment/validate', to: 'mpesa#validate_transaction', via: [:post]
  match 'payment/confirm', to: 'mpesa#confirm_transaction', via: [:post]
  match 'mpesa/register', to: 'mpesa#register', via: [:post]
  match 'pos', to: 'mpesa#pos', via: [:post]

  # Sidekiq
require "sidekiq/web"

mount Sidekiq::Web => "/sidekiq"

  # Catch-all (LAST)
# Catch-all (LAST)
# Catch-all (LAST)
match "*path", to: "errors#not_found", via: :all
end
