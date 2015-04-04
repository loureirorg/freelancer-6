class GrievancesController < ApplicationController
  before_action :set_grievance, only: [:show, :edit, :update, :destroy, :approve, :disapprove]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_ownership, only: [:edit, :update, :destroy]
  before_action :check_admin, only: [:new_grievances, :changed_grievances, :approve, :disapprove]

  # GET /grievances
  # GET /grievances.json
  def index
    @title = "All Grievances"
    @grievances = Grievance.visible(current_user).order(date_incident: :desc).paginate(:page => params[:page], :per_page => 20)
  end

  def my_grievances
    @title = "My Grievances"
    @grievances = current_user.grievances.order(date_incident: :desc).paginate(:page => params[:page], :per_page => 20)
    render :index
  end

  def new_grievances
    @title = "New grievances waiting for approval"
    @grievances = Grievance.where(is_new: true).order(date_incident: :desc).paginate(:page => params[:page], :per_page => 20)
    render :index
  end

  def changed_grievances
    @title = "Changed grievances waiting for approval"
    @grievances = Grievance.where(is_revision: false).where.not(revision: nil).order(date_incident: :desc).paginate(:page => params[:page], :per_page => 20)
    render :index
  end

  def search
    @title = "Filtered Grievances"
    @cop = params[:cop].present? ? Cop.find_by(id: params[:cop]) : nil
    q = I18n.transliterate(params[:q]).upcase.gsub(/[^0-9A-Z ]/, "") if params[:q].present?
    @grievances = Grievance.visible(current_user)
    @grievances = @grievances.where(state_name: params[:state]) if params[:state].present?
    @grievances = @grievances.where(city_name: params[:city]) if params[:city].present?
    @grievances = @grievances.where(cop_id: params[:cop]) if params[:cop].present?
    @grievances = @grievances.where("text_search LIKE ?", "%#{q}%") if params[:q].present?
    @grievances = @grievances.order(date_incident: :desc).paginate(:page => params[:page], :per_page => 20)
    render :index
  end

  # GET /grievances/1
  # GET /grievances/1.json
  def show
  end

  # GET /grievances/new
  def new
    @grievance = Grievance.new
  end

  # GET /grievances/1/edit
  def edit
    if @grievance.revision.present?
      @original = @grievance 
      @grievance = @grievance.revision
    end
  end

  def approve
    if @grievance.is_new
      @grievance.update_attributes!(is_new: false, visible: true)
      redirect_to new_grievances_path, notice: "Grievance ##{@grievance.id} approved. Now it is visible."
    elsif @grievance.revision.present?
      @revision = @grievance.revision

      # erase actual grievance
      original_id = @grievance.id
      @grievance.connected_grievances.clear
      @grievance.delete

      # change revision id to the original id
      ConnectedGrievanceAssociation.where(grievance_id: @revision.id).each do |cg| 
        cg.update_attributes(grievance_id: original_id)
      end
      @revision.update_attributes(visible: true, is_new: false, is_revision: false, id: original_id)

      redirect_to changed_grievances_path, notice: "Changes to grievance ##{@grievance.id} approved."
    end
  end

  def disapprove
    if @grievance.revision.present?
      @grievance.revision.connected_grievances.clear
      @grievance.revision.delete
      redirect_to grievances_path, notice: "Changes to grievance ##{@grievance.id} disapproved."
    end
  end

  # POST /grievances
  # POST /grievances.json
  def create
    @grievance = Grievance.new(grievance_params, is_revision: false, visible: false, is_new: true)

    @grievance.connected_grievances.clear
    params[:grievance][:connected_grievances_ids].split(',').each do |id|
      grievance = Grievance.find_by(id: id)
      @grievance.connected_grievances << grievance if grievance.present?
    end

    respond_to do |format|
      if @grievance.save
        format.html { redirect_to grievances_path, notice: "Your grievance ##{@grievance.id} will be visible after approval." }
        format.json { render :show, status: :created, location: @grievance }
      else
        format.html { render :new }
        format.json { render json: @grievance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grievances/1
  # PATCH/PUT /grievances/1.json
  def update
    # check if we're editing a pending revision, delete current revision
    @grievance = Grievance.find_by(revision: @grievance) if @grievance.is_revision 
    @grievance.revision.delete if @grievance.revision.present? # overwrite pending revision

    # create a new revision and associates it to grievance
    @revision = Grievance.create(grievance_params.merge({ visible: false, is_revision: true, is_new: false }))
    @grievance.update_attributes(revision: @revision)

    # connected grievances
    @revision.connected_grievances.clear
    params[:grievance][:connected_grievances_ids].split(',').each do |id|
      grievance = Grievance.find_by(id: id)
      @revision.connected_grievances << grievance if grievance.present?
    end
    @revision.save

    # render
    respond_to do |format|
      if @grievance.errors.empty?
        format.html { redirect_to root_path, notice: "Your changes in grievance ##{@grievance.id} will be visible after approval." }
        format.json { render :show, status: :ok, location: @grievance }
      else
        format.html { render :edit }
        format.json { render json: @grievance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grievances/1
  # DELETE /grievances/1.json
  def destroy
    @grievance.destroy
    respond_to do |format|
      format.html { redirect_to grievances_url, notice: 'Grievance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_ownership
      if ! user_signed_in?
        redirect_to :root, alert: "You need to be logged to do that"
      elsif (@grievance.user != current_user) && ! current_user.is_admin
        redirect_to :root, alert: "You aren't the owner of this grievance"
      end
    end

    def check_admin
      unless user_signed_in? && current_user.is_admin
        redirect_to :root, alert: "Unauthorized access!"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_grievance
      @grievance = Grievance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grievance_params
      result = params.require(:grievance).permit(:cop_id, :date_incident, :description, :user_id, :publish_user_race, :publish_user_age, :cop_name, :cop_race, :cop_badge, :state_name, :city_name, :title, :connected_grievances_ids)
      result[:user] = current_user

      # "unpack" some params
      state = nil
      city = nil
      cop = nil

      state = State.find_by(name: params[:grievance][:state_name])
      if state.blank?
        if CS.states(:us).keys.include?(params[:grievance][:state_name].to_sym)
          state = State.create(name: params[:grievance][:state_name])
        else
          # isn't a real state
          if params[:grievance][:state_name].present?
            raise "Invalid State"
          end
        end
      end

      if state.present?
        city = City.find_by(state: state, name: params[:grievance][:city_name])
        if city.blank?
          if CS.cities(state.name, :us).include?(params[:grievance][:city_name])
            city = City.create(state: state, name: params[:grievance][:city_name])
          else
            # isn't a real city
            if params[:grievance][:city_name].present?
              raise "Invalid City"
            end
          end
        end
      end

      if state.present? && city.present?
        cop = Cop.find_by(id: params[:grievance][:cop_id])
        if cop.blank?
          # create new cop
          if params[:grievance][:cop_name].present?
            cop = Cop.create(state: state, city: city, name: params[:grievance][:cop_name], badge_number: params[:grievance][:cop_badge], race: params[:grievance][:cop_race])
          end
        end
      end

      result[:cop_id] = cop.try(:id)
      result[:city_id] = city.try(:id)
      result[:city_name] = city.try(:name)
      result[:state_id] = state.try(:id)
      result[:state_name] = state.try(:name)

      result
    end
end
