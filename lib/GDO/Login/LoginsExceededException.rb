#
#
#
class GDO::Login::LoginsExceededException < GDO::Core::Exception
  def initialize(msg)
    super(msg)
    @code = 403
  end
end
