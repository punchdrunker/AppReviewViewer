class ScriptConfig
  USE_NOTIFY = false
  NOTIFY_HOST = 'localhost'
  NOTIFY_PORT = 8080
  NOTIFY_PATH_FORMAT = "/say?room=%s&message=%s"

  # app_id => room_name
  NOTIFY_ROOMS = {
    'com.exapmle'=>'test_room'
  }
end
