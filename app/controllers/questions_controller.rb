class QuestionsController < ApplicationController
<<<<<<< HEAD
  def new
=======
  before_action :authenticate, only: [:new, :create, :vote]
  before_action :set_question, only: [:show, :vote]

  def home
    @question = Question.new
    @unanswered_questions = Question.unanswered.order(created_at: :desc).limit(5)
    @answered_questions = Question.recently_answered.limit(5)
  end

  def index
    @questions = Question.order(created_at: :desc).page params[:page]
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, success: "Your question has been created."
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.build
  end

  def vote
    @vote = @question.votes.build(user: current_user, value: params[:vote][:value])
    if @vote.save
      redirect_to @question, success: "Your vote was recorded."
    else
      redirect_to @question, error: "There was a problem saving your vote."
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text)
>>>>>>> bd87ac0c8e2139f88e1295e578e7e0b98c9e4838
  end
end
