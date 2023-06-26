Rails.application.routes.draw do
  get 'minesweeper/create'

  resources :minesweeper, only: %i[create show] do
    member do
      put 'flag_cell'
      put 'undo_flag_cell'
      put 'select_cell'
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
