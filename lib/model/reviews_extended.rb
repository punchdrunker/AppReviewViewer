require 'cgi'

# TODO need refactor
class Reviews
  def after_create
    if ScriptConfig::NOTIFY_ROOMS[self.app_id]
      room = ScriptConfig::NOTIFY_ROOMS[self.app_id]
      message = "[#{self.date}] #{self.title} - #{self.body} (Ver.#{self.version} #{self.device})"

      escaped_message = CGI.escape(message)
      begin
        Net::HTTP.get(ScriptConfig::NOTIFY_HOST,
                      sprintf(ScriptConfig::NOTIFY_PATH_FORMAT, room, escaped_message),
                      ScriptConfig::NOTIFY_PORT)
      rescue => e
        p e
      end
    end
  end
end
