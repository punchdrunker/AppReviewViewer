# -*- encoding: utf-8 -*-
require 'cgi'

# TODO need refactor
class Reviews
  def after_create
    if ScriptConfig::NOTIFY_ROOMS[self.app_id]
      room = ScriptConfig::NOTIFY_ROOMS[self.app_id]
      message = "[Ver.#{self.version} ★#{self.star.to_s}] #{self.title} - #{self.body} (#{self.date} #{self.device})"
      message.gsub!('<br />', ' ')

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
