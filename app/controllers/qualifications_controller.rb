class QualificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_jd, except: [:update_button] 
  before_action :set_qualification, only: [:show, :edit, :update, :destroy]


  def index
  	@qualifications = @jd.qualifications.all
  end

  def show
  end

  def new
  	@qualification = @jd.qualifications.build
  end

  def create
  	@qualification = @jd.qualifications.build(qualification_params)

  	if @qualification.save 
  	  flash[:success] = "added qualification successfully"
  	  redirect_to [@jd.company, @jd]
  	else
      on_success "oops! something went wrong", :new
  	end
  end

  def edit
  end

  def update
  	if @qualification.update(qualification_params)
  	   @qualification.update(update_button: false)	
  	  flash[:success] = "successfully updated qualification"
  	  
  	  if request.referrer == company_job_description_url(@jd.company, @jd)
  	  	redirect_to :back
  	  else
  	    redirect_to job_description_qualifications_url(@jd)
  	  end
  	else 
      on_failure  "oops! something went wrong", :edit
  	end
  end

  def destroy
  	@qualification.destroy
    on_success "successfully deleted a qualification", :back
  end

  def update_button
  	@qualification = Qualification.find(params[:id])
  	@qualification.update(update_button: true)
  	redirect_to :back
  end

  
  private 

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_qualification
  	set_jd
  	@qualification = @jd.qualifications.find(params[:id])
  end

  def qualification_params
  	params.require(:qualification).permit(:certificate, :field_of_study,
  	 :update_button)
  end

  def copy_changes_to_existing_object
    @qualification = Qualification.find(params[:id])
      existing_attributes = @qualification.attributes 
      update_attributes = qualification_params 
      ["id", "job_description_id", "created_at", "updated_at", "copy", "copy_id", "update_button"].each do |key|
        existing_attributes.delete(key)
      end
      if change_in_data existing_attributes, update_attributes
        if find_qualification_copy = Qualification.find_by(copy: true, copy_id: @qualification.id)
          find_qualification_copy.delete
          @qualification_copy = Qualification.create qualification_params
          @qualification_copy.update(copy: true, copy_id: @qualification.id, job_description_id: @qualification.job_description_id)
        else
          @qualification_copy = Qualification.create qualification_params
          @qualification_copy.update(copy: true, copy_id: @qualification.id, job_description_id: @qualification.job_description_id)
        end
        @qualification.update(update_button: false)
        redirect_to company_job_description_url @qualification.job_description.company, @qualification.job_description
      else
        @qualification.update(update_button: false)
        flash[:alert] = "no changes detected"
        redirect_to company_job_description_url @qualification.job_description.company, @qualification.job_description
      end
  end
end
