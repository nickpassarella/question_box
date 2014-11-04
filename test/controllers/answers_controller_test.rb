require 'test_helper'

class AnswersControllerTest < ActionController::TestCase

  def invalid_answer_data
    { text: "" }
  end

  def valid_answer_data
    { text: Faker::Hacker.say_something_smart }
  end

  context "POST answers#create" do
    context "when not logged in" do
      setup { post :create, question_id: questions(:one).id, answer: {} }

      should "redirect to login" do
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      context "with invalid data" do
        context "using HTML" do
          setup do
            post :create, { question_id: questions(:one).id, answer: invalid_answer_data }, logged_in_session
          end

          should render_template("questions/show")

          should "instantiate an invalid answer object" do
            assert_invalid_model(:answer)
          end
        end

        context "using JS" do
          setup do
            post :create, { question_id: questions(:one).id, answer: invalid_answer_data, format: "js" }, logged_in_session
          end

          should respond_with(:bad_request)
        end
      end

      context "with valid data" do
        context "using HTML" do
          setup do
            post :create, { question_id: questions(:one).id, answer: valid_answer_data }, logged_in_session
          end

          should "create an answer" do
            assert_saved_model(:answer)
          end

          should "redirect to question" do
            assert_redirected_to questions(:one)
          end
        end

        context "using JS" do
          setup do
            post :create, { question_id: questions(:one).id, answer: valid_answer_data, format: :js }, logged_in_session
          end

          should render_template("answers/create")
          should respond_with(:created)

          should "create an answer" do
            assert_saved_model(:answer)
          end
        end
      end
    end
  end

  context "POST answers#vote" do
    context "when not logged in" do
      setup { post :vote, id: answers(:one_for_question_one) }

      should "redirect to login" do
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      context "with invalid data" do
        context "using HTML" do
          setup do
            post :vote, { id: answers(:one_for_question_one), value: 0 }, logged_in_session
          end

          should "instantiate an invalid vote object" do
            assert_invalid_model(:vote)
          end

          should "redirect to question" do
            assert_redirected_to question_path(assigns[:voteable].question)
          end
        end

        context "using JS" do
          setup do
            post :vote, { id: answers(:one_for_question_one), value: 0, format: "js" }, logged_in_session
          end

          should respond_with(:accepted)
          should render_template("votes/create")
        end
      end

      context "with valid data" do
        context "using HTML" do
          setup do
            post :vote, { id: answers(:one_for_question_one), value: 1 }, logged_in_session
          end

          should "create a vote" do
            assert_saved_model(:vote)
          end

          should "redirect to question" do
            assert_redirected_to question_path(assigns[:voteable].question)
          end
        end

        context "using JS" do
          setup do
            post :vote, { id: answers(:one_for_question_one), value: 1, format: "js" }, logged_in_session
          end

          should respond_with(:created)
          should render_template("votes/create")
        end
      end
    end
  end
end
