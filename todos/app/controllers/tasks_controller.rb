class TasksController < ApplicationController
  respond_to :html

  def index
    respond_with(@tasks = Task.all)
  end

  def show
    redirect_to tasks_path
  end

  def create
    respond_with(@task = Task.create(params[:task]))
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    respond_with(@task)
  end

end
