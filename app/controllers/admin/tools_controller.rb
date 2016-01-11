class Admin::ToolsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:index, :new, :edit, :create]
  before_action :set_tool, only: [:show, :edit, :update, :destroy]

  def index
    @project_tools = @project.project_tools
  end

  def new
    @project_tool = ProjectTool.new(project_id: @project.id)
  end

  def edit

  end

  def destroy
    @project_tool.destroy
    respond_to do |format|
      format.html { redirect_to admin_project_tools_url, notice: 'Tool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /tools
  # POST /tools.json
  def create
    # had to do it this way because the id being passed is actually a slug bc of friendly id :/
    @project_tool = ProjectTool.new(
        project_id: @project.id,
        name: tool_params[:name],
        attachment: tool_params[:attachment]
      )

    respond_to do |format|
      if @project_tool.save
        format.html { redirect_to admin_project_tools_url, notice: 'project tool was successfully created.' }
        format.json { render :show, status: :created, location: @project_tool }
      else
        format.html { render :new }
        format.json { render json: @project_tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tools/1
  # PATCH/PUT /tools/1.json
  def update
    respond_to do |format|
      if @project_tool.update(project_tool_params)
        format.html { redirect_to admin_project_tools_url, notice: 'project tool was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_tool }
      else
        format.html { render :edit }
        format.json { render json: @project_tool.errors, status: :unprocessable_entity }
      end
    end
  end


  private

  def set_project
    @project = Project.friendly.find_by(slug: params[:project_id])
  end

  def set_tool
    @project_tool = ProjectTool.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def tool_params
    params.require(:project_tool).permit(:name, :attachment, :project_id)
  end

end
