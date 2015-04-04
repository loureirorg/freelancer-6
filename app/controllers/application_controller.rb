class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def cities
    render json: CS.cities(params[:state], :us).to_json
  end

  def cops
    cops = if params[:q].blank?
      Cop.order(:name)
    else
      q = I18n.transliterate(params[:q]).upcase.gsub(/[^0-9A-Z ]/, "")
      Cop.where("text_search LIKE ?", "%#{q}%").order(:name)
    end
    render json: cops.to_json
  end

  def cops_create
    
  end

  def connected_grievances
    grievances = if params[:q].blank?
      Grievance.all
    else
      q = I18n.transliterate(params[:q]).upcase.gsub(/[^0-9A-Z ]/, "")
      Grievance.where("text_search LIKE ?", "%#{q}%")
    end
    # render json: grievances.where(visible: true, is_revision: false).order(:title).pluck(:id, :title, :date_incident, :cop_name, :city_name, :state_name).to_json
    render json: grievances.order(date_incident: :desc), only: [:id, :title, :date_incident, :cop_name, :city_name, :state_name]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :age, :race, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :age, :race, :email, :password, :password_confirmation, :current_password) }
  end
end
