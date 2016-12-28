class TodoController < ApplicationController
  def index
    td = Todoitem.all
    render json: {todo: td}
  end
  def create
    td = Todoitem.new(:text => params[:text], :completed => false)
    if td.save
      render json: {result: 'success', id: td.id}
    else
      render json: {result: 'error'}
    end
  end
  def update
    td = Todoitem.find(params[:id])
    td.text = params[:text]
    td.completed = params[:completed]
    if td.save
      render json: {result: 'success'}
    else
      render json: {result: 'error'}
    end
  end
end
