class GreetingService

  require "date"

  def greeting
  now = DateTime.now

    if now.between?(DateTime.parse("17:00"), DateTime.parse("23:59"))
      @greeting = "Good evening"
    elsif now.between?(DateTime.parse("00:00"), DateTime.parse("12:00"))
      @greeting = "Good morning"
    else now.between?(DateTime.parse("12:00"), DateTime.parse("17:00"))
      @greeting = "Good afternoon"
    end

    @greeting
  end

end
