class CommunitiesController < ApplicationController
  before_action :authenticate_user!
  layout 'student'

  # GET /communities/:id
  def show
    @community = authorize(Community.find(params[:id]))
    @search = params[:search]
    @questions = scoped_questions.live.includes(%i[creator answers])
      .order("last_activity_at DESC NULLs FIRST").page(page).per(10)
  end

  # GET /communities/:id/show_v2
  def show_v2
    @community = authorize(Community.find(params[:id]), 'show?')
    @search = params[:search]
    @topics = scoped_topics.live.includes([first_post: :creator])
      .order("last_activity_at DESC NULLs FIRST").page(page).per(10)

    # Pre-load the counts of replies on each post.
    ActiveRecord::Precounter.new(@topics).precount(:replies)
  end

  # GET /community/:community_id/questions/new
  def new_question
    @community = authorize(Community.find(params[:id]))
    target
  end

  private

  def page
    @page ||= begin
      page = params[:page].to_i
      page.zero? ? 1 : page
    end
  end

  def scoped_questions
    if params[:search].present?
      filtered_question.where('title ILIKE ?', "%#{@search}%")
    else
      filtered_question
    end
  end

  def filtered_question
    if target.present?
      target.questions.where(community: @community)
    else
      @community.questions
    end
  end

  def scoped_topics
    if params[:search].present?
      filtered_topics.where('title ILIKE ?', "%#{@search}%")
    else
      filtered_topics
    end
  end

  def filtered_topics
    if target.present?
      @community.topics.where(target_id: target.id)
    else
      @community.topics
    end
  end

  def target
    return unless @community.target_linkable?

    @target ||= if params[:target_id].present?
      t = Target.find_by(id: params[:target_id])

      # Only return the target if the target is in a course that is linked to this community.
      @community.courses.where(id: t&.course).exists? ? t : nil
    end
  end
end
