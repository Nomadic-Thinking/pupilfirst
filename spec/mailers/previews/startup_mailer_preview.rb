class StartupMailerPreview < ActionMailer::Preview
  def startup_dropped_out
    startup = Startup.last
    StartupMailer.startup_dropped_out(startup)
  end

  def feedback_as_email
    startup_feedback = StartupFeedback.new(
      id: 1,
      feedback: "This is the feedback text.\nIt is multi-line.",
      timeline_event: TimelineEvent.new(
        id: 2,
        timeline_event_type: TimelineEventType.new(title: 'Timeline Event Type Title'),
        startup: Startup.new(id: 4, slug: 'test-startup')
        # target: Target.new
      ),
      faculty: Faculty.new(
        name: 'C V Raman'
      ),
      startup: Startup.new(
        id: 3,
        level: Level.new(number: 1)
      )
    )

    StartupMailer.feedback_as_email(startup_feedback)
  end

  def connect_request_confirmed
    connect_request = ConnectRequest.first

    StartupMailer.connect_request_confirmed(connect_request)
  end

  def payment_reminder
    payment = Payment.new(billing_end_at: 5.days.from_now, startup: Startup.last)
    StartupMailer.payment_reminder(payment)
  end

  def referral_reward
    startup = Startup.find_by(product_name: 'Super Product') # Paid.
    # startup = Startup.find_by(product_name: 'SuperHeroes') # Pending payment.

    payment = startup.payments.order(billing_end_at: :desc).first
    coupon = Coupon.new(referrer_startup: startup, referrer_extension_days: 10)
    StartupMailer.referral_reward(payment, coupon)
  end
end
