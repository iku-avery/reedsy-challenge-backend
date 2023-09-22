# app/services/result_handler.rb
module ResultHandler
    include HttpStatusCodes
    Result = Struct.new(:code, :body)
  
    def ok_result(result)
      Result.new(OK, result)
    end
  
    def invalid_request_result(error)
      Result.new(BAD_REQUEST, { error: error })
    end
  
    def not_found_result(error)
      Result.new(NOT_FOUND, { error: error })
    end
end
  