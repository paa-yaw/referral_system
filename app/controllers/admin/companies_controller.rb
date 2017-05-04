class Admin::CompaniesController < Admin::ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_button, :contact_company,
   :deal_with_company]
  layout "admin"


  def index
  	@companies = Company.all.order(deal: :desc, contacted: :desc)
  end

  def show
    @tab = params[:tab]
  end

  def edit
  end
  
  def update
  	if @company.update(company_params)
  	  @company.update(update_button: false)	
  	  flash[:success] = "you successfully updated #{@company.company_name} details"
  	  redirect_to :back
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
  	  render :edit
  	end
  end

  def destroy
  	@company.destroy
  	flash[:success] = "succesfully deleted company"
  	redirect_to :back
  end

  def update_button
  	@company.update(update_button: true)
  	redirect_to :back
  end

  def contact_company
    if @company.contacted?
      if @company.deal?
        flash[:alert] = "not applicable. A deal has already been made with #{@company.company_name}"
      else
        @company.no_contact
      end 
    else
      @company.contact
      flash[:success] = "contacted #{@company.company_name}" 
    end
    redirect_to :back
  end

  def deal_with_company
    if @company.deal?
      @company.no_deal
      track_activity @company, "no deal", @company.user_id 
      update_jds_of_company_in_activity @company
      update_company_in_activity @company
      # sleep 5
      # delete_from_activity_on_deal_cancellation @company
    else
      if @company.contacted?
        @company.deal_true 
        track_activity @company, "deal", @company.user_id 
        permit_jds_of_company_in_activity @company
        flash[:success] = "you and #{@company.company_name} have a deal"
      else
        flash[:alert] = "not applicable. you haven't contacted #{@company.company_name} yet"
      end
    end
    redirect_to :back
  end
 


  private

  def set_company
  	@company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:company_name, :clientname, :email, :phonenumber, :role,
  	:url, :about, :contacted, :deal)
  end

  def permit_jds_of_company_in_activity(company)
    company.job_descriptions.each do |jd|
      track_activity jd, "create", jd.user_id
    end
  end

  def update_jds_of_company_in_activity(company)
    company.job_descriptions.each do |jd|
      if activity_exists? jd, "JobDescription", "create"
        activity = Activity.find_by trackable_id: jd.id, trackable_type: "JobDescription", action: "create"
         activity.update(action: "inactive") 
      end
    end  
  end

  def update_company_in_activity(company)
    if activity_exists? company, "Company", "deal"
      activity = Activity.find_by trackable_id: company.id, trackable_type: "Company", action: "deal"
      activity.update(action: "inactive")
    end
  end

  def delete_from_activity_on_deal_cancellation(company)
    trackable_id = company.id
    company_activity = Activity.find_by trackable_id: trackable_id, trackable_type: "Company"
    company_activity.delete

    company.applicants.each do |trackable_id|
      applicant_activity = Activity.find_by trackable_id: trackable_id, trackable_type: "Applicant"
      applicant_activity.delete 
    end  

    company.job_descriptions.each do |trackable_id|

    end
  end
end
