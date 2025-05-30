class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  def index
    @user = User.find(params[:user_id])
    @notes = @user.notes
  end

  def show
    @note = current_user.notes.find(params[:id])
  end

  def new
    @user = current_user
    @note = @user.notes.build
  end

  def create
    @note = current_user.notes.new(note_params)
    if @note.save
      redirect_to user_notes_path, notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
    @note = @user.notes.find(params[:id])
  end

  def update
      @user = current_user
    @note = @user.notes.find(params[:id])
    if @note.update(note_params)
      redirect_to user_note_path(@user, @note), notice: "Note updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to user_notes_path, notice: "Note was successfully deleted."
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end

  def record_not_found
    redirect_to user_notes_path(current_user), alert: "That record doesn't exist!"
  end
end