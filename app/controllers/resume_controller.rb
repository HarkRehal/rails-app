class ResumeController < ApplicationController
  before_action :set_resume
  before_action :require_login, except: [:index]

  def index
  end

  def edit
  end

  def update
    if @resume.update(resume_params)
      redirect_to root_path, notice: 'Resume was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_resume
    @resume = Resume.first_or_create(
      name: "Harki Rehal",
      title: "AI & Technology Professional",
      summary: "Technology leader and AI specialist with extensive experience in developing innovative solutions.",
      experience: "- Developed Harki's AI Clone\n- Created AI-powered video solutions\n- Published regular insights",
      projects: "AI Clone, AI Video Platform"
    )
  end

  def resume_params
    params.require(:resume).permit(:name, :title, :summary, :experience, :projects, :profile_image)
  end

  def require_login
    unless session[:user_id]
      flash[:alert] = "Please log in to edit the resume"
      redirect_to login_path
    end
  end
end