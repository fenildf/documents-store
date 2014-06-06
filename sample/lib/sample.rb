require "sinatra"
require "documents-store"
require "./config/env"

module DocumentsStore
  class Sample < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    set :views, ["templates"]
    set :root, File.expand_path("../../", __FILE__)
    set :method_override, true
    register Sinatra::AssetPack
    enable :sessions

    assets {
      serve '/js', :from => 'assets/javascripts'
      serve '/css', :from => 'assets/stylesheets'

      js :application, "/js/application.js", [
           '/js/jquery-1.11.0.min.js',
           '/js/**/*.js'
         ]

      css :application, "/css/application.css", [
            '/css/**/*.css'
          ]

      css_compression :yui
      js_compression  :uglify
    }

    helpers do
      def form(model)
        model_name = model.model_name.element
        base_url = "/#{model_name.pluralize}"

        action, method = case
                         when model.new_record?
                           ["#{base_url}", "post"]
                         when model.persisted?
                           ["#{base_url}/#{model.id}", "put"]
                         end

        haml :"_form",
             :layout => false,
             :locals => {
               :model      => model,
               :method     => method,
               :action     => action,
               :model_name => model_name
             }
      end

      def current_user
        session[:user]
      end

      def login(name)
        return redirect to("/documents") if current_user == name
        session[:user] = name
      end

      def auth!
        redirect to("/") if current_user.blank?
      end
    end

    before do
      auth! if request.path != "/"
    end

    get "/" do
      haml :login
    end

    post "/" do
      login(params[:name])
      redirect to("/documents")
    end

    get "/documents" do
      @documents = Document.all
      haml :"documents/index"
    end

    get "/documents/new" do
      @document = Document.new
      haml :"documents/new"
    end

    post "/documents" do
      document = Document.new params[:document]
      document.creator_id = current_user
      document.save
      redirect to("/documents/#{document.id}")
    end

    get "/documents/:id" do
      @document = Document.find(params[:id])
      haml :"documents/show"
    end

    get "/documents/:id/versions" do
      @document = Document.find(params[:id])
      haml :"documents/versions"
    end

    get "/documents/:id/versions/:version" do
      @version  = params[:version].to_i
      @document = Document.find(params[:id]).versions[@version - 1]
      haml :"documents/show"
    end

    get "/documents/:id/edit" do
      @document = Document.find(params[:id])
      haml :"documents/edit"
    end

    put "/documents/:id" do
      document = Document.find(params[:id])
      document.update_attributes params[:document]
      document.last_editor_id = current_user
      document.save
      redirect to("/documents/#{document.id}")
    end

    delete "/documents/:id" do
      document = Document.find(params[:id])
      document.destroy
      "/documents"
    end
  end
end
