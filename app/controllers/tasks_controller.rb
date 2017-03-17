class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, except: [:index, :create]
  before_action :authorize_task, except: [:index, :create]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = policy_scope(@project.tasks)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @project.tasks.build(task_params)
    authorize_task

    respond_to do |format|
      if @task.save
        format.html { redirect_to [@project, @task], notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: [@project, @task] }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to [@project, @task], notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: [@project, @task] }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_tasks_url(@project), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_task
      @task = params[:id] ? @project.tasks.find(params[:id]) : @project.tasks.build
    end
    
    def authorize_task
      authorize @task
    end
  
    def task_params
      params.require(:task).permit(:name, 
                                    :description,
                                    :resource_state,
                                    notes_attributes: [:text, :author, :_destroy])
    end

end
